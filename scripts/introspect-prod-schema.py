"""Compare local ErpApMockup schema against production XTechnologies2018IN.

Outputs:
  - galva-db/prod-schema-diff.json: columns present in prod but missing locally.
  - galva-db/migrations/002_extend_voucherap_from_prod.sql: idempotent ALTER
    script to add the missing columns (or spec-derived columns if prod is
    unreachable and --use-spec-defaults is passed).
  - galva-db/scripts/extract-schema-snippet.txt: suggested SCHEMA map additions
    for extract-from-prod.py.

Modes:
  1. Online (default): connects to GTC-SERVER and reads INFORMATION_SCHEMA.
  2. Offline: pass --prod-schema-json <file> with a previously exported prod
     schema dump.
  3. Spec fallback: if prod is unreachable and --use-spec-defaults is passed,
     the script emits a migration derived from the import-invoice spec rather
     than production columns.

Usage:
    python3 scripts/introspect-prod-schema.py
    python3 scripts/introspect-prod-schema.py --prod-schema-json prod-schema.json
    python3 scripts/introspect-prod-schema.py --use-spec-defaults

The script is read-only on both sides. No DDL is executed.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

try:
    import pymssql
except ModuleNotFoundError:
    pymssql = None  # type: ignore[assignment]

# Same production connection used by extract-from-prod.py
PROD = dict(
    server="GTC-SERVER",
    user="remote9",
    password="Remote!@#123",
    database="XTechnologies2018IN",
    login_timeout=10,
    timeout=60,
    tds_version="7.4",
)

LOCAL_SCHEMA_FILE = Path("galva-db/schema.sql")
TABLES = ["VoucherAP", "SubVoucherAP"]

# Columns derived from the import-invoice spec (Use Case 1) when prod is
# unreachable. These are added to VoucherAP/SubVoucherAP as a minimal,
# spec-aligned fallback. If production is reachable, the real prod columns
# take precedence.
SPEC_HEADER_COLUMNS: list[dict[str, Any]] = [
    {"column_name": "NOPEN", "data_type": "nvarchar", "max_length": 50},
    {"column_name": "TglNopen", "data_type": "smalldatetime", "max_length": 0},
    {"column_name": "AWB_BL", "data_type": "nvarchar", "max_length": 50},
    {"column_name": "Doku_PCF", "data_type": "nvarchar", "max_length": 50},
]

SPEC_COST_COLUMNS: list[dict[str, Any]] = [
    # Reusable cost-line fields stored on SubVoucherAP for the spec fallback.
    {"column_name": "APRef", "data_type": "nvarchar", "max_length": 50},
    {"column_name": "InvoiceNo", "data_type": "nvarchar", "max_length": 50},
    {"column_name": "TglInvoice", "data_type": "smalldatetime", "max_length": 0},
    {"column_name": "Doku_FP", "data_type": "nvarchar", "max_length": 50},
    {"column_name": "Tgl_FP", "data_type": "smalldatetime", "max_length": 0},
]

# Columns whose width/type needs to change to support the import-invoice spec.
SPEC_ALTER_COLUMNS: list[dict[str, Any]] = [
    # SubVoucherAP.TipeBiaya is currently NVARCHAR(10); cost types like
    # 'ImportHandling' (15 chars) do not fit. Widen to NVARCHAR(20).
    {"table_name": "SubVoucherAP", "column_name": "TipeBiaya", "data_type": "nvarchar", "max_length": 20},
]


def fetch_prod_columns(tables: list[str]) -> dict[str, list[dict[str, Any]]]:
    if pymssql is None:
        raise RuntimeError("pymssql is not installed. Install it or use --prod-schema-json.")

    with pymssql.connect(**PROD) as conn:
        cur = conn.cursor(as_dict=True)
        rows: list[dict[str, Any]] = []
        for table in tables:
            cur.execute(
                """
                SELECT
                    TABLE_NAME AS table_name,
                    COLUMN_NAME AS column_name,
                    DATA_TYPE AS data_type,
                    COALESCE(CHARACTER_MAXIMUM_LENGTH, 0) AS max_length,
                    NUMERIC_PRECISION AS numeric_precision,
                    NUMERIC_SCALE AS numeric_scale,
                    DATETIME_PRECISION AS datetime_precision,
                    IS_NULLABLE AS is_nullable,
                    ORDINAL_POSITION AS ordinal_position
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = %s
                ORDER BY ORDINAL_POSITION
                """,
                (table,),
            )
            rows.extend(cur.fetchall())

    out: dict[str, list[dict[str, Any]]] = {t: [] for t in tables}
    for r in rows:
        out[r["table_name"]].append(r)
    return out


def load_prod_schema_from_json(path: Path) -> dict[str, list[dict[str, Any]]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if "VoucherAP" not in data:
        raise ValueError(f"{path} must contain a top-level 'VoucherAP' key.")
    return {t: data.get(t, []) for t in TABLES}


def parse_local_create_table(sql: str, table_name: str) -> dict[str, str]:
    """Parse column definitions from a CREATE TABLE block in schema.sql."""
    pattern = rf"CREATE TABLE \[dbo\]\.\[{re.escape(table_name)}\]\((.*?)\)\s+ON \[PRIMARY\]"
    match = re.search(pattern, sql, re.DOTALL | re.IGNORECASE)
    if not match:
        return {}

    body = match.group(1)
    columns: dict[str, str] = {}

    depth = 0
    current = ""
    for char in body:
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            _maybe_add_column(current, columns)
            current = ""
            continue
        current += char
    _maybe_add_column(current, columns)

    return columns


def _maybe_add_column(fragment: str, columns: dict[str, str]) -> None:
    fragment = fragment.strip()
    if not fragment:
        return
    if re.match(r"^CONSTRAINT\b|^PRIMARY\b|^\)", fragment, re.IGNORECASE):
        return
    m = re.match(r"\[(\w+)\]\s+(.+)", fragment, re.DOTALL)
    if m:
        columns[m.group(1)] = m.group(2).strip()


def sql_type_for_alter(col: dict[str, Any]) -> str:
    """Render a SQL Server column type from INFORMATION_SCHEMA metadata."""
    t = col["data_type"].upper()
    if t in ("NVARCHAR", "VARCHAR", "NCHAR", "CHAR"):
        length = col["max_length"]
        if length == -1:
            return f"{t}(MAX)"
        return f"{t}({length})"
    if t == "TEXT":
        return t
    if t in ("DECIMAL", "NUMERIC"):
        return f"{t}({col['numeric_precision']},{col['numeric_scale']})"
    if t in ("FLOAT", "REAL", "INT", "BIGINT", "SMALLINT", "TINYINT", "BIT", "MONEY", "SMALLMONEY"):
        return t
    if t in ("DATETIME", "DATETIME2", "SMALLDATETIME", "DATE", "TIME"):
        if t == "DATETIME2" and col.get("datetime_precision"):
            return f"{t}({col['datetime_precision']})"
        return t
    if t in ("IMAGE", "VARBINARY", "BINARY"):
        length = col["max_length"]
        if length == -1:
            return f"{t}(MAX)"
        return f"{t}({length})"
    return t


def build_diff(
    prod_columns: dict[str, list[dict[str, Any]]],
    local_columns: dict[str, dict[str, str]],
) -> dict[str, list[dict[str, Any]]]:
    diff: dict[str, list[dict[str, Any]]] = {}
    for table in TABLES:
        prod_names = {c["column_name"] for c in prod_columns[table]}
        local_names = set(local_columns[table].keys())
        missing = prod_names - local_names
        diff[table] = [c for c in prod_columns[table] if c["column_name"] in missing]
    return diff


def emit_alter_script(
    diff: dict[str, list[dict[str, Any]]],
    alter_columns: list[dict[str, Any]] | None = None,
) -> str:
    lines = [
        "USE ErpApMockup;",
        "GO",
        "-- Idempotent migration generated by introspect-prod-schema.py",
        "-- Adds columns present in production XTechnologies2018IN but missing locally.",
        "",
    ]
    any_col = False
    for table, cols in diff.items():
        for col in cols:
            any_col = True
            lines.append(
                f"IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS "
                f"WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = '{table}' AND COLUMN_NAME = '{col['column_name']}')"
            )
            lines.append("BEGIN")
            lines.append(
                f"    ALTER TABLE dbo.[{table}] ADD [{col['column_name']}] [{sql_type_for_alter(col)}] NULL;"
            )
            lines.append(f"    PRINT 'Added {table}.{col['column_name']}';")
            lines.append("END")
            lines.append("GO")
            lines.append("")

    for col in alter_columns or []:
        any_col = True
        table = col["table_name"]
        name = col["column_name"]
        lines.append(
            f"IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS "
            f"WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = '{table}' AND COLUMN_NAME = '{name}' "
            f"AND CHARACTER_MAXIMUM_LENGTH < {col['max_length']})"
        )
        lines.append("BEGIN")
        lines.append(
            f"    ALTER TABLE dbo.[{table}] ALTER COLUMN [{name}] [{sql_type_for_alter(col)}] NULL;"
        )
        lines.append(f"    PRINT 'Widened {table}.{name}';")
        lines.append("END")
        lines.append("GO")
        lines.append("")

    if not any_col:
        lines.append("-- No missing columns detected. Nothing to add.")
        lines.append("")
    return "\n".join(lines)


def emit_schema_map_snippet(diff: dict[str, list[dict[str, Any]]]) -> str:
    lines = ["# Suggested additions to extract-from-prod.py SCHEMA map:", ""]
    for table, cols in diff.items():
        if not cols:
            continue
        lines.append(f'    "{table}": [')
        for col in cols:
            lines.append(f'        ("{col["column_name"]}", "{col["column_name"]}"),')
        lines.append("    ],")
    if len(lines) == 2:
        lines.append("# No missing columns to add.")
    return "\n".join(lines)


def print_offline_instructions() -> None:
    print("""
Production is not reachable from this environment. To get the real prod schema:

  1. From a machine with access to GTC-SERVER, run:

       sqlcmd -S GTC-SERVER -U remote9 -P 'Remote!@#123' -d XTechnologies2018IN \
              -h -1 -W -Q "
       SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
              NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION, IS_NULLABLE,
              ORDINAL_POSITION
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME IN ('VoucherAP','SubVoucherAP')
       ORDER BY TABLE_NAME, ORDINAL_POSITION
       " -o prod-schema.csv -s ','

  2. Convert the CSV to JSON keyed by table, then run:

       python3 scripts/introspect-prod-schema.py --prod-schema-json prod-schema.json

Or pass --use-spec-defaults to generate a spec-based migration without prod access.
""")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--output-dir", type=Path, default=Path("galva-db"))
    ap.add_argument("--prod-schema-json", type=Path, default=None)
    ap.add_argument(
        "--use-spec-defaults",
        action="store_true",
        help="If prod is unreachable, emit a migration based on the import-invoice spec.",
    )
    args = ap.parse_args()

    output_dir = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    if not LOCAL_SCHEMA_FILE.exists():
        print(f"ERROR: {LOCAL_SCHEMA_FILE} not found. Run from repo root.", file=sys.stderr)
        return 1

    local_sql = LOCAL_SCHEMA_FILE.read_text(encoding="utf-8")
    local_columns: dict[str, dict[str, str]] = {
        t: parse_local_create_table(local_sql, t) for t in TABLES
    }

    prod_columns: dict[str, list[dict[str, Any]]] | None = None

    if args.prod_schema_json:
        print(f"Loading production schema from {args.prod_schema_json} ...")
        prod_columns = load_prod_schema_from_json(args.prod_schema_json)
    else:
        print(f"Connecting to {PROD['server']}.{PROD['database']} ...")
        try:
            prod_columns = fetch_prod_columns(TABLES)
        except Exception as exc:
            print(f"WARNING: could not connect to production: {exc}", file=sys.stderr)
            print_offline_instructions()
            if args.use_spec_defaults:
                print("Falling back to spec-derived columns.")
                prod_columns = {
                    "VoucherAP": SPEC_HEADER_COLUMNS,
                    "SubVoucherAP": SPEC_COST_COLUMNS,
                }
            else:
                print(
                    "No migration written. Re-run with --use-spec-defaults or provide --prod-schema-json.",
                    file=sys.stderr,
                )
                return 1

    assert prod_columns is not None
    diff = build_diff(prod_columns, local_columns)

    for table in TABLES:
        print(
            f"{table}: {len(prod_columns[table])} cols in source, "
            f"{len(local_columns[table])} parsed locally, {len(diff[table])} missing"
        )

    report_path = output_dir / "prod-schema-diff.json"
    report_path.write_text(json.dumps(diff, indent=2, default=str), encoding="utf-8")
    print(f"Wrote {report_path}")

    alter_columns = SPEC_ALTER_COLUMNS if args.use_spec_defaults else None
    alter_path = output_dir / "migrations" / "002_extend_voucherap_from_prod.sql"
    alter_path.parent.mkdir(parents=True, exist_ok=True)
    alter_path.write_text(emit_alter_script(diff, alter_columns), encoding="utf-8")
    print(f"Wrote {alter_path}")

    snippet_path = output_dir / "scripts" / "extract-schema-snippet.txt"
    snippet_path.write_text(emit_schema_map_snippet(diff), encoding="utf-8")
    print(f"Wrote {snippet_path}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
