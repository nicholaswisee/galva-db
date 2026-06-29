"""Extract a clean, P2P-coherent sample from the live XTechnologies2018IN
database on GTC-SERVER, transform it to match the local ErpApMockup schema
in galva-db/schema.sql, and emit a SQL file that can be loaded into the
local Docker container.

Why a Python script (not pure T-SQL)?
- Cross-database SELECT FROM OPENDATASOURCE is brittle and needs linked-server
  config on the target side.  Easier: pull rows from prod, write a portable
  seed-from-prod.sql with static INSERTs, drop the file into the initdb
  volume OR run via sqlcmd.

Usage:
    python3 extract-from-prod.py [--n-pos 30] [--output seed-from-prod.sql]

Environment / connection details live at the top of the file.
"""

from __future__ import annotations

import argparse
import datetime as dt
import re
import sys
from pathlib import Path
from typing import Any, Iterable

import pymssql


# --- Connection config (matches .env / GTC-SERVER profile in VS Code) ---
PROD = dict(
    server="GTC-SERVER",
    user="remote9",
    password="Remote!@#123",
    database="XTechnologies2018IN",
    login_timeout=10,
    timeout=60,
    tds_version="7.4",
)

# --- Sample size (tweak on the CLI) ---
DEFAULTS = dict(
    n_pos=30,            # Purchase Orders to seed
    recency_months=60,   # Only consider transactions in the last N months
    since_date=None,     # explicit date override; default = recency_months ago
)


# ---------------------------------------------------------------------------
# Schema maps: source table -> list of (source_col, target_col)
# Only columns that exist in BOTH schemas are listed.
# The order here is the column order used in the generated INSERT.
# ---------------------------------------------------------------------------

# Note: source DB has some column-name mismatches vs. local DB (e.g.
# Department[code,description] -> Department[Kode,Nama]) and missing
# columns (e.g. VoucherAP has no Memo, only Keterangan).  We map them here.

# A special "identity" entry per table tells the emitter to:
#   1. Pull the source IDENTITY column into the SELECT (so we can preserve it)
#   2. Include it in the INSERT column list (required by IDENTITY_INSERT=ON)
# Source tables that don't have IDENTITY columns simply omit this entry.

SCHEMA: dict[str, list[tuple[str, str]]] = {
    "Department": [
        ("code", "Kode"),
        ("description", "Nama"),
    ],
    "Supplier": [
        # local PK is IDENTITY(1,1) -> PKbas. Source also has PKbas.
        ("PKbas", "PKbas"),
        ("Kode", "Kode"),
        ("Nama", "Nama"),
        ("Kode_Dept", "Kode_Dept"),
        ("Alamat1", "Alamat1"),
        ("Kota", "Kota"),
        ("NPWP", "NPWP"),
        ("PKP", "PKP"),
        ("Syarat", "Syarat"),
        ("MTU", "MTU"),
        ("Aktif", "Aktif"),
        ("Status", "Status"),
        ("SupGroupName", "SupGroupName"),
    ],
    "Barang": [
        ("Kode", "Kode"),
        ("Nama", "Nama"),
    ],
    "Gudang": [
        # local PK is IDENTITY -> id_gudang. Source has id_gudang too.
        ("id_gudang", "id_gudang"),
        ("Kode", "Kode"),
        ("Nama", "Nama"),
        ("Aktif", "Aktif"),
    ],
    "Bank": [
        # local PK is IDENTITY -> PKindex. Source has PKindex.
        ("PKindex", "PKindex"),
        ("Kode", "Kode"),
        ("Nama", "Nama"),
        ("Kode_Valas", "Kode_Valas"),
    ],
    "Category": [
        # local PK is IDENTITY -> id_category. Source has id_category.
        ("id_category", "id_category"),
        ("Kode", "Kode"),
        ("Nama", "Nama"),
    ],
    "Satuan": [
        # local PK is IDENTITY -> id_satuan. Source has id_satuan.
        ("id_satuan", "id_satuan"),
        ("Kode", "Kode"),
        ("Nama", "Nama"),
    ],
    "PO": [
        # local PK is IDENTITY -> id_po. Source has id_po.
        ("id_po", "id_po"),
        ("Doku", "Doku"),
        ("Tgl", "Tgl"),
        ("Kode_Supplier", "Kode_Supplier"),
        ("Kode_dept", "Kode_dept"),
        ("Doku_SPPB", "Doku_SPPB"),
        ("Nilai", "Nilai"),
        ("PPN", "PPN"),
        ("Diskon", "Diskon"),
        ("STS", "STS"),
        ("Kode_Valas", "Kode_Valas"),
        ("Kurs", "Kurs"),
        ("Syarat", "Syarat"),
        # PO.Memo in both DBs is `text`; we pull as-is
        ("Memo", "Memo"),
        ("Tipe", "Tipe"),
    ],
    "SubPO": [
        ("Doku", "Doku"),
        ("Tgl", "Tgl"),
        ("Kode_Brg", "Kode_Brg"),
        ("Kode_Gudang", "Kode_Gudang"),
        ("Alias", "Alias"),
        ("Jumlah", "Jumlah"),
        ("Harga", "Harga"),
        ("Total", "Total"),
        ("PPN", "PPN"),
        ("Diskon", "Diskon"),
        ("Kode_Dept", "Kode_Dept"),
        ("Doku_SPPB", "Doku_SPPB"),
        ("NoUrutSPPB", "NoUrutSPPB"),
        ("Kode_Valas", "Kode_Valas"),
        # NOTE: prod SubPO has no Kurs column. We omit it from the seed
        # and let the local default NULL apply.
    ],
    "LPB": [
        # local PK is IDENTITY -> id_lpb. Source has id_lpb.
        ("id_lpb", "id_lpb"),
        ("Doku", "Doku"),
        ("Tgl", "Tgl"),
        ("Kode_Supplier", "Kode_Supplier"),
        ("Kode_Dept", "Kode_Dept"),
        ("Doku_PO", "Doku_PO"),
        ("SuratJalan", "SuratJalan"),
        ("Nilai", "Nilai"),
        ("PPN", "PPN"),
        ("Diskon", "Diskon"),
        ("Kode_Valas", "Kode_Valas"),
        ("Kurs", "Kurs"),
        ("STS", "STS"),
        ("Status", "Status"),
        ("Memo", "Memo"),
    ],
    "SubLPB": [
        ("Doku", "Doku"),
        ("Tgl", "Tgl"),
        ("Doku_PO", "Doku_PO"),
        ("Doku_SPPB", "Doku_SPPB"),
        ("Kode_Brg", "Kode_Brg"),
        ("Kode_Gudang", "Kode_Gudang"),
        ("Jumlah", "Jumlah"),
        ("Harga", "Harga"),
        ("Nilai", "Nilai"),
        ("PPN", "PPN"),
        ("Diskon", "Diskon"),
        ("Kode_Valas", "Kode_Valas"),
        ("Kurs", "Kurs"),
    ],
    "VoucherAP": [
        # local PK is IDENTITY -> PKbas. Source has PKbas too.
        # Local schema has [Tgl]; remote uses [TglDoku] -- alias it.
        # NOTE: prod VoucherAP also has Doku_LPB / Doku_PO but the local
        # VoucherAP does NOT -- those refs live in SubVoucherAP only.
        ("PKbas", "PKbas"),
        ("Doku", "Doku"),
        ("TglDoku", "Tgl"),
        ("Kode_Supplier", "Kode_Supplier"),
        ("Kode_Dept", "Kode_Dept"),
        ("Nilai", "Nilai"),
        ("PPn", "PPn"),
        ("Diskon", "Diskon"),
        ("Misc", "Misc"),
        ("STS", "STS"),
        ("Keterangan", "Keterangan"),
        ("Kode_Valas", "Kode_Valas"),
        ("Kurs", "Kurs"),
    ],
    "SubVoucherAP": [
        ("Doku", "Doku"),
        ("Tgl", "Tgl"),
        ("Doku_LPB", "Doku_LPB"),
        ("Doku_PO", "Doku_PO"),
        ("NilaiLPB", "NilaiLPB"),
        ("Nilai", "Nilai"),
        ("PPn", "PPn"),
        ("Diskon", "Diskon"),
        ("Misc", "Misc"),
        ("Kode_Supplier", "Kode_Supplier"),
        ("Kode_Valas", "Kode_Valas"),
        ("Kurs", "Kurs"),
    ],
}

# Tables that get only top-N by activity, capped to avoid bloating the seed
MASTER_CAPS = {
    "Supplier": 25,    # only suppliers appearing in our selected POs
    "Barang": 40,      # only items appearing in our selected SubPOs
    "Gudang": 10,      # only warehouses used in our selected LPBs/POs
    "Department": 10,
    "Bank": 8,
    "Category": 8,
    "Satuan": 8,
}


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def quote_sql(value: Any) -> str:
    """Format a Python value as a SQL literal for static INSERT VALUES."""
    if value is None:
        return "NULL"
    if isinstance(value, bool):
        return "1" if value else "0"
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, (dt.datetime, dt.date)):
        # SQL Server accepts 'YYYY-MM-DD HH:MM:SS.sss' for datetime
        if isinstance(value, dt.datetime):
            return f"'{value.strftime('%Y-%m-%d %H:%M:%S')}'"
        return f"'{value.strftime('%Y-%m-%d')}'"
    if isinstance(value, bytes):
        # Image / varbinary -- represent as 0x... for safety
        return "0x" + value.hex()
    s = str(value)
    # Escape single quotes by doubling
    s = s.replace("'", "''")
    # Truncate ridiculously long values to avoid blowing up the SQL file
    if len(s) > 4000:
        s = s[:4000]
    return f"'{s}'"


def fetch_dict(cur, sql: str, params: Iterable = ()) -> list[dict]:
    cur.execute(sql, tuple(params))
    cols = [c[0] for c in cur.description]
    return [dict(zip(cols, row)) for row in cur.fetchall()]


def dedupe_by(rows: list[dict], key: str) -> dict:
    out = {}
    for r in rows:
        k = r.get(key)
        if k and k not in out:
            out[k] = r
    return out


# ---------------------------------------------------------------------------
# Extract + transform
# ---------------------------------------------------------------------------

def extract(conn, n_pos: int, since_date: dt.date) -> dict[str, list[dict]]:
    cur = conn.cursor()

    # 1. Pick the most recent N POs as the seed "spine".
    # ORDER BY uses Tgl DESC then Doku ASC as a tie-breaker so the same
    # N rows are selected on every run -- otherwise POs sharing a Tgl
    # could rotate in/out of the TOP (N) between runs and break
    # byte-deterministic regeneration of seed-from-prod.sql.
    pos = fetch_dict(cur, """
        SELECT TOP ({n}) id_po, Doku, Tgl, Kode_Supplier, Kode_dept, Doku_SPPB,
               Nilai, PPN, Diskon, STS, Kode_Valas, Kurs, Syarat,
               CAST(Memo AS VARCHAR(4000)) AS Memo, Tipe
        FROM dbo.PO WITH (NOLOCK)
        WHERE Tgl >= %s
          AND Kode_Supplier IS NOT NULL AND LTRIM(RTRIM(Kode_Supplier)) <> ''
          AND ISNULL(STS,'') <> '0'
        ORDER BY Tgl DESC, Doku ASC
    """.format(n=n_pos), (since_date,))
    po_dokus = [p["Doku"] for p in pos]
    print(f"[1] Selected {len(po_dokus)} POs from {since_date}")

    if not po_dokus:
        raise RuntimeError("No POs found in the recency window. "
                           "Bump --recency-months or check connection.")

    # 2. Pull all LPBs that link to our POs
    in_clause = ",".join(["%s"] * len(po_dokus))
    lpbs = fetch_dict(cur, f"""
        SELECT id_lpb, Doku, Tgl, Kode_Supplier, Kode_Dept, Doku_PO, SuratJalan,
               Nilai, PPN, Diskon, Kode_Valas, Kurs, STS, Status,
               CAST(Memo AS VARCHAR(4000)) AS [Memo]
        FROM dbo.LPB WITH (NOLOCK)
        WHERE Doku_PO IN ({in_clause})
    """, po_dokus)
    lpb_dokus = [l["Doku"] for l in lpbs]
    print(f"[2] Matched {len(lpb_dokus)} LPBs to selected POs")

    # 3. Pull all VoucherAPs that link to our LPBs
    if lpb_dokus:
        in_clause = ",".join(["%s"] * len(lpb_dokus))
        vchs = fetch_dict(cur, f"""
            SELECT PKbas, Doku, TglDoku AS [Tgl], Kode_Supplier, Kode_Dept,
                   Nilai, PPn, Diskon, Misc, STS, Keterangan,
                   Kode_Valas, Kurs
            FROM dbo.VoucherAP WITH (NOLOCK)
            WHERE Doku_LPB IN ({in_clause})
        """, lpb_dokus)
    else:
        vchs = []
    vch_dokus = [v["Doku"] for v in vchs]
    print(f"[3] Matched {len(vch_dokus)} VoucherAPs to selected LPBs")

    # 4. Pull line items (Sub* tables)
    sub_pos = fetch_dict(cur, f"""
        SELECT Doku, Tgl, Kode_Brg, Kode_Gudang, Alias, Jumlah, Harga, Total,
               PPN, Diskon, Kode_Dept, Doku_SPPB, NoUrutSPPB, Kode_Valas
        FROM dbo.SubPO WITH (NOLOCK)
        WHERE Doku IN ({",".join(["%s"]*len(po_dokus))})
    """, po_dokus) if po_dokus else []
    print(f"[4a] SubPO lines: {len(sub_pos)}")

    sub_lpbs = fetch_dict(cur, f"""
        SELECT Doku, Tgl, Doku_PO, Doku_SPPB, Kode_Brg, Kode_Gudang, Jumlah,
               Harga, Nilai, PPN, Diskon, Kode_Valas, Kurs
        FROM dbo.SubLPB WITH (NOLOCK)
        WHERE Doku IN ({",".join(["%s"]*len(lpb_dokus))})
    """, lpb_dokus) if lpb_dokus else []
    print(f"[4b] SubLPB lines: {len(sub_lpbs)}")

    sub_vchs = fetch_dict(cur, f"""
        SELECT Doku, Tgl, Doku_LPB, Doku_PO, NilaiLPB, Nilai, PPn, Diskon,
               Misc, Kode_Supplier, Kode_Valas, Kurs
        FROM dbo.SubVoucherAP WITH (NOLOCK)
        WHERE Doku IN ({",".join(["%s"]*len(vch_dokus))})
    """, vch_dokus) if vch_dokus else []
    print(f"[4c] SubVoucherAP lines: {len(sub_vchs)}")

    # 5. Determine the FK set we need to back-fill from masters
    supplier_kodes = {p["Kode_Supplier"] for p in pos if p.get("Kode_Supplier")}
    barang_kodes = {s["Kode_Brg"] for s in sub_pos if s.get("Kode_Brg")}
    gudang_kodes = {s["Kode_Gudang"] for s in sub_pos if s.get("Kode_Gudang")}
    gudang_kodes = {g for g in gudang_kodes if g}  # remove empty
    dept_kodes = (
        {p["Kode_dept"] for p in pos if p.get("Kode_dept")}
        | {l["Kode_Dept"] for l in lpbs if l.get("Kode_Dept")}
    )
    print(f"[5] FK sets: suppliers={len(supplier_kodes)} barang={len(barang_kodes)} "
          f"gudang={len(gudang_kodes)} dept={len(dept_kodes)}")

    # 6. Back-fill masters
    suppliers = []
    if supplier_kodes:
        in_clause = ",".join(["%s"] * len(supplier_kodes))
        suppliers = fetch_dict(cur, f"""
            SELECT PKbas, Kode, Nama, Kode_Dept, Alamat1, Kota, NPWP, PKP, Syarat,
                   MTU, Aktif, Status, SupGroupName
            FROM dbo.Supplier WITH (NOLOCK)
            WHERE Kode IN ({in_clause})
              AND Kode NOT LIKE '*MISC%'
        """, list(supplier_kodes))
    print(f"[6a] Supplier master rows: {len(suppliers)}")

    barangs = []
    if barang_kodes:
        in_clause = ",".join(["%s"] * len(barang_kodes))
        barangs = fetch_dict(cur, f"""
            SELECT Kode, Nama
            FROM dbo.Barang WITH (NOLOCK)
            WHERE Kode IN ({in_clause})
        """, list(barang_kodes))
    # Synthesize stub items for any Kode_Brg values referenced by SubPO
    # lines that don't exist in the (possibly empty) prod Barang master.
    missing_brg = barang_kodes - {b["Kode"] for b in barangs}
    for k in sorted(missing_brg):
        barangs.append({"Kode": k, "Nama": f"ITEM {k} (synthetic)"})
    print(f"[6b] Barang master rows: {len(barangs)} (synthesized {len(missing_brg)})")

    gudangs = []
    if gudang_kodes:
        in_clause = ",".join(["%s"] * len(gudang_kodes))
        gudangs = fetch_dict(cur, f"""
            SELECT id_gudang, Kode, Nama, Aktif
            FROM dbo.Gudang WITH (NOLOCK)
            WHERE Kode IN ({in_clause})
        """, list(gudang_kodes))
    print(f"[6c] Gudang master rows: {len(gudangs)}")

    departments = []
    if dept_kodes:
        in_clause = ",".join(["%s"] * len(dept_kodes))
        departments = fetch_dict(cur, f"""
            SELECT code AS Kode, description AS Nama
            FROM dbo.Department WITH (NOLOCK)
            WHERE code IN ({in_clause})
        """, list(dept_kodes))
    # Synthesize stub departments for any Kode_Dept values referenced by
    # transactions that don't exist in the (possibly empty) prod master.
    missing_dept = dept_kodes - {d["Kode"] for d in departments}
    for k in sorted(missing_dept):
        departments.append({"Kode": k, "Nama": f"DEPT {k} (synthetic)"})
    print(f"[6d] Department master rows: {len(departments)} (synthesized {len(missing_dept)})")

    # Static-ish masters: take a small set of real rows for the app to work
    banks = fetch_dict(cur, """
        SELECT TOP 8 PKindex, Kode, Nama, Kode_Valas
        FROM dbo.Bank WITH (NOLOCK)
        WHERE Kode IS NOT NULL
        ORDER BY Kode
    """)
    categories = fetch_dict(cur, """
        SELECT TOP 8 id_category, Kode, Nama
        FROM dbo.Category WITH (NOLOCK)
        WHERE Kode IS NOT NULL
        ORDER BY Kode
    """)
    satuans = fetch_dict(cur, """
        SELECT TOP 8 id_satuan, Kode, Nama
        FROM dbo.Satuan WITH (NOLOCK)
        WHERE Kode IS NOT NULL
        ORDER BY Kode
    """)
    print(f"[6e] Static masters: banks={len(banks)} categories={len(categories)} "
          f"satuans={len(satuans)}")

    # Sort every result by its PK column so the emitted INSERT order is
    # byte-deterministic. The PK is the first column in each table's
    # SCHEMA entry; fall back to "Doku" / "Kode" for tables whose first
    # schema column isn't a PK (e.g. detail tables that don't have an
    # IDENTITY column in scope).
    out = {
        "Department": departments,
        "Supplier": suppliers,
        "Barang": barangs,
        "Gudang": gudangs,
        "Bank": banks,
        "Category": categories,
        "Satuan": satuans,
        "PO": pos,
        "SubPO": sub_pos,
        "LPB": lpbs,
        "SubLPB": sub_lpbs,
        "VoucherAP": vchs,
        "SubVoucherAP": sub_vchs,
    }
    pk_col = {
        "Department": "Kode", "Supplier": "Kode", "Barang": "Kode",
        "Gudang": "Kode", "Bank": "Kode", "Category": "Kode",
        "Satuan": "Kode", "PO": "Doku", "SubPO": "Doku",
        "LPB": "Doku", "SubLPB": "Doku", "VoucherAP": "Doku",
        "SubVoucherAP": "Doku",
    }
    for t, rows in out.items():
        col = pk_col.get(t)
        if col:
            rows.sort(key=lambda r, c=col: (r.get(c) is None, r.get(c) or ""))
    return out


# ---------------------------------------------------------------------------
# SQL emission
# ---------------------------------------------------------------------------

HEADER = """\
-- ============================================================
-- Galva ERP — Seed data extracted from prod (XTechnologies2018IN)
-- Generator : galva-db/scripts/extract-from-prod.py
-- Signature : {n_pos} POs since {since}
-- DO NOT EDIT BY HAND -- regenerate from prod via seed-from-prod.sh
-- This file is byte-deterministic: same args + same prod snapshot
-- produce an identical file.  Diff the git history to see what prod
-- data changed; diff this file's "Signature" line to see what
-- arguments changed.
-- ============================================================

USE ErpApMockup;

"""


FOOTER = """
PRINT 'Seed from prod applied successfully.';
"""


# Tables whose PK is IDENTITY in the local schema -- we wrap each table's
# INSERTs with SET IDENTITY_INSERT ON/OFF so the source PKs are preserved.
# (SQL Server allows IDENTITY_INSERT=ON on only one table per session.)
IDENTITY_TABLES = {
    "Supplier", "Gudang", "Bank", "Category", "Satuan",
    "PO", "LPB", "VoucherAP",
}


def emit_inserts(table: str, rows: list[dict]) -> str:
    """Render INSERT ... VALUES (...) batches for a single table.

    `rows` are dicts keyed by the TARGET column name (so a synthesized
    row uses the same key shape as a row pulled from prod, after
    fetch_dict's column aliasing).  When a source row used a different
    name (e.g. Department[code] -> Department[Kode]), the SELECT in
    extract() aliases it; the synthesizer uses target names directly.

    Tables whose PK is an IDENTITY column are wrapped in
    SET IDENTITY_INSERT ON/OFF so the source PKs round-trip.
    """
    if not rows:
        return f"-- (no rows for {table})\n"
    cols = [tgt for (_src, tgt) in SCHEMA[table]]
    col_list = ", ".join(f"[{c}]" for c in cols)
    out = [f"-- {table}: {len(rows)} rows"]
    if table in IDENTITY_TABLES:
        out.append(f"SET IDENTITY_INSERT dbo.[{table}] ON;")
    for r in rows:
        values = ", ".join(
            quote_sql(r.get(tgt)) for (_src, tgt) in SCHEMA[table]
        )
        out.append(f"INSERT INTO dbo.[{table}] ({col_list}) VALUES ({values});")
    if table in IDENTITY_TABLES:
        out.append(f"SET IDENTITY_INSERT dbo.[{table}] OFF;")
    return "\n".join(out) + "\n\n"


# Order matters: masters first, then headers, then detail lines.
# Note: IDENTITY_INSERT lets us preserve the source PKs.
EMIT_ORDER = [
    "Department", "Supplier", "Barang", "Gudang", "Bank", "Category", "Satuan",
    "PO", "SubPO", "LPB", "SubLPB", "VoucherAP", "SubVoucherAP",
]


def render(data: dict[str, list[dict]], since: dt.date, n_pos: int) -> str:
    chunks = [HEADER.format(
        n_pos=n_pos,
        since=since.isoformat(),
    )]
    for t in EMIT_ORDER:
        chunks.append(emit_inserts(t, data.get(t, [])))
    chunks.append(FOOTER)
    return "".join(chunks)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--n-pos", type=int, default=DEFAULTS["n_pos"],
                    help="How many recent POs to include (default 30)")
    ap.add_argument("--recency-months", type=int,
                    default=DEFAULTS["recency_months"],
                    help="Only POs newer than N months (default 18)")
    ap.add_argument("--since", type=str, default=None,
                    help="Explicit YYYY-MM-DD lower bound; overrides --recency-months")
    ap.add_argument("--output", type=Path,
                    default=Path("galva-db/seed-from-prod.sql"),
                    help="Output SQL file path")
    args = ap.parse_args()

    if args.since:
        since_date = dt.date.fromisoformat(args.since)
    else:
        since_date = dt.date.today() - dt.timedelta(days=30 * args.recency_months)

    print(f"Connecting to {PROD['server']}.{PROD['database']} ...")
    with pymssql.connect(**PROD) as conn:
        data = extract(conn, args.n_pos, since_date)

    sql = render(data, since_date, args.n_pos)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(sql)

    total_rows = sum(len(v) for v in data.values())
    print(f"\nWrote {args.output}  ({len(sql):,} bytes, {total_rows} rows total)")
    print("\nRow counts by table:")
    for t in EMIT_ORDER:
        print(f"  {t:15s} {len(data.get(t, []))}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
