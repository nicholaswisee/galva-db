# Galva Database — Agentic Knowledge Bank

> **For autonomous agents.** Read this before touching any schema, query, or
> data-extraction task in `galva-db`. This document is the primary source of
> truth for structure, naming conventions, non-obvious facts, and gotchas.

---

## 1. Module purpose

`galva-db` is a Dockerized **SQL Server 2022 (Developer)** instance hosting the
**`ErpApMockup`** database — a cut-down local mirror of the production
`XTechnologies2018IN` ERP database (on `GTC-SERVER`). It covers the
**Purchase-to-Pay (P2P)** process end-to-end, plus purchase returns, AR receipt
notes, and inventory/stock modules.

**Source of truth for schema:** `schema.sql`. No migration system exists.
Any schema change = edit `schema.sql` + container reset.

---

## 2. Canonical P2P Data Flow

```
Purchase Requisition
    SPB / SubSPB
        │
        ▼
Purchase Order   ← "POSem" in production naming (sementara = preliminary/draft)
    POSem / SubPOSem
        │
        ▼
PO Confirmation  ← "PO" in production naming (the finalized purchase order)
    PO / SubPO
        │
        ▼
Goods Receipt
    LPB / SubLPB
        │
        ▼
AP Invoice
    VoucherAP / SubVoucherAP
        │
        ▼
Payment
    Hiapt06 / Hiapt02
        │
        ▼
Purchase Return (optional branch off GR/Payment)
    ReturBeli / SubReturBeli

Final acknowledgement (AR-side receipts):
    TandaTerimaAr / SubTandaTerimaAr
```

### ⚠️ CRITICAL NAMING GOTCHA — PO vs. POSem

The production ERP uses **inverted terminology** from what you might expect:

| ERP Table Name | What the Business Calls It | Stage |
|---|---|---|
| `POSem` / `SubPOSem` | **Purchase Order** (initial, draft) | Issued to supplier |
| `PO` / `SubPO` | **PO Confirmation** (finalized) | Confirmed by supplier |

- **`POSem`** = *sementara* (Indonesian: "temporary/preliminary"). This is the **initial Purchase Order** sent to the supplier and is present in the local `ErpApMockup` schema.
- **`PO`** = the **PO Confirmation** — the supplier-confirmed, finalized purchase order. This **is** present locally and is the table used for downstream GR/AP flows.

The `PO` header has `[Doku_POSem]` which stores the document number of the
originating `POSem` (the draft PO). `SubPO` lines also carry `[Doku_POSem]`
for the same purpose.

---

## 3. Header / Detail Pattern

Every transaction follows the same header → detail shape:

| Business Name | Header Table | Detail Table | Header PK | Detail PK |
|---|---|---|---|---|
| Purchase Requisition | `SPB` | `SubSPB` | `id_spb` | `id_sub_spb` |
| Purchase Order (draft) | `POSem` | `SubPOSem` | `id_posem` | `id_sub_posem` |
| PO Confirmation | `PO` | `SubPO` | `id_po` | `id_sub_po` |
| Goods Receipt | `LPB` | `SubLPB` | `id_lpb` | `id_sub_lpb` |
| AP Invoice | `VoucherAP` | `SubVoucherAP` | `PKbas` | `PKbas` |
| Payment | `Hiapt06` | `Hiapt02` | `PKindex` | `PKbas` |
| Purchase Return | `ReturBeli` | `SubReturBeli` | `PKbas` | `PKbas` |
| AR Receipt Note | `TandaTerimaAr` | `SubTandaTerimaAr` | `PKbas` | `PKbas` |

**Document number column:** always `[Doku]` on both header and detail.
Cross-references between tables use `[Doku_<SourceTable>]` columns
(e.g., `LPB.[Doku_PO]` → the PO Confirmation doc number).

---

## 4. Complete Table Catalog

### 4a. Master / Reference Tables

| Table | Prod Origin | Primary Key | Key Columns | Notes |
|---|---|---|---|---|
| `Dept` | `dbo.Dept` | `id_dept` (IDENTITY) | `Kode`, `Nama` | Departments/divisions. Trimmed: print-layout + approver signature columns retained (Nama10..Nama52, Jabatan10..52, SignPO, PossPO, etc.). |
| `Supplier` | `dbo.Supplier` | `id_supplier` (IDENTITY) | `Kode`, `Nama`, `KodeGTC`, `KodeEPK` | Vendors. Local `RowVersion` added. Has dual-company codes (`KodeGTC`/`KodeEPK`). |
| `Barang` | `dbo.Barang` | *(none — no PK)* | `Kode`, `Nama` | Items/SKUs. **No PK in prod.** Local additions: `Merk`, `Satuan`, `Harga`. |
| `Gudang` | `dbo.Gudang` | `id_gudang` (IDENTITY) | `Kode`, `Nama` | Warehouses. |
| `Bank` | `dbo.Bank` | `PKindex` (IDENTITY) | `Kode`, `Nama` | Banks used in payments. |
| `Category` | `dbo.Category` | `id_category` (IDENTITY) | `Kode`, `Nama` | Item categories. |
| `Satuan` | `dbo.Satuan` | `id_satuan` (IDENTITY) | `Kode`, `Nama` | Units of measure. |
| `Area` | `dbo.Area` | `id_area` (IDENTITY) | `Kode`, `Nama` | Geographic areas (referenced by Supplier/Gudang/Bank). |
| `Sales` | `dbo.Sales` | `id_sales` (IDENTITY) | `Kode`, `Nama` | Sales persons. |
| `VALAS2` | `dbo.VALAS2` | *(none — loose)* | `Kode`, `Tanggal`, `Rate` | Currency rate history. No PK in prod. |
| `JenisTransferBarang` | `dbo.JenisTransferBarang` | `IdJenisTransferBarang` (IDENTITY) | `Kode`, `Nama` | Item transfer type (48 rows in prod). Used by stock/TTP. |
| `SupplierGroup` | `dbo.SupplierGroup` | — | `Kode`, `Nama` | Supplier groupings. |

### 4b. P2P Transaction Tables

| Table | Prod Origin | Primary Key | Notes |
|---|---|---|---|
| `SPB` | `dbo.SPB` | `id_spb` | Purchase Requisition header. Heavily wide: 80+ columns include customer refs, project codes, shipping details. `RowVersion` added locally. |
| `SubSPB` | `dbo.SubSPB` | `id_sub_spb` | PR line items. `Jumhar` is a **computed column**: `AS ([jumlah]*[Harga])`. Cannot specify NULL on it. |
| `POSem` | `dbo.POSem` | `id_posem` | Draft Purchase Order header. Copied locally from the confirmed PO shape without `Doku_POSem`; `RowVersion` added locally. |
| `SubPOSem` | `dbo.SubPOSem` | `id_sub_posem` | Draft Purchase Order lines. Copied locally from the confirmed PO shape without `Doku_POSem`. |
| `PO` | `dbo.PO` | `id_po` | **PO Confirmation** in business terms (see §2 naming gotcha). Has `Doku_POSem` reference to draft PO. `RowVersion` added locally. Indexed on `Doku` and `Kode_Supplier`. |
| `SubPO` | `dbo.SubPO` | `id_sub_po` | PO Confirmation line items. Local additions: `Merk`, `Satuan`, `DiscPct`. Has `Doku_POSem` tracking back to draft. `JumlahKonfirm` tracks supplier-confirmed qty. |
| `LPB` | `dbo.LPB` | `id_lpb` | **Goods Receipt** header. `RowVersion` added locally. Wide: 50+ columns covering freight cost sub-documents (Asuransi, Interest, LC, Bea, Angkut, Exp1, Exp2, Lain). |
| `SubLPB` | `dbo.SubLPB` | `id_sub_lpb` | GR line items. |
| `VoucherAP` | `dbo.VoucherAP` | `PKbas` | AP Invoice header. Local additions: `NOPEN`, `TglNopen`, `AWB_BL`, `SourceType`, `RowVersion`. Has `CHECK` constraint: `TipeBiaya IN ('LPB', 'PO')`. |
| `SubVoucherAP` | `dbo.SubVoucherAP` | `PKbas` | AP Invoice lines. Local additions: `APRef`, `InvoiceNo`, `TglInvoice`, `Doku_FP`, `Tgl_FP`, `SourceType`. Same `TipeBiaya` check constraint. |
| `Hiapt06` | `dbo.Hiapt06` | `PKindex` | **Payment** header. `RowVersion` added locally. |
| `Hiapt02` | `dbo.Hiapt02` | `PKbas` | Payment lines allocated to vouchers. References `Doku_Faktur` (voucher doc) and `Doku_LPB`. |

### 4c. Returns and Receipts

| Table | Prod Origin | Primary Key | Notes |
|---|---|---|---|
| `ReturBeli` | `dbo.ReturBeli` | `PKbas` | Purchase Return header. Local `RowVersion` added. |
| `SubReturBeli` | `dbo.SubReturBeli` | `PKbas` | Return line items. References `Doku_LPB`. Local `RowVersion` added. |
| `TandaTerimaAr` | `dbo.TandaTerimaAr` | `PKbas` | AR Receipt Note header. Local `RowVersion` added. |
| `SubTandaTerimaAr` | `dbo.SubTandaTerimaAr` | `PKbas` | AR Receipt Note lines. |

### 4d. Inventory / Stock

| Table | Prod Origin | Primary Key | Notes |
|---|---|---|---|
| `SKU_Stok` | `dbo.SKU_Stok` | *(none — loose)* | Current stock balance per item/warehouse/dept. All columns `varchar(50)` including `Qty`. |
| `HistStokMon` | `dbo.HistStokMon` | Composite: `(ItemCode, Kode_Dept, Period, Kode_Area)` | Monthly stock/saldo history. Dense data, joins on `ItemCode` and `Kode_Dept`. |
| `TRStokOpname` | `dbo.TRStokOpname` | `Doku` (natural) | Stock count (opname) header. 0 rows in prod; schema only for completeness. |
| `TRStokOpnameSub` | `dbo.TRStokOpnameSub` | Composite: `(Doku, Kode)` | Stock count lines. References `TRStokOpname.Doku`. |

### 4e. Local-Only / Non-Flow Tables

Tables that exist only in the local mockup and are **not** part of the canonical
P2P or production flow:

| Table | Purpose |
|---|---|
| `Master_Users` | Application user store for the mockup API. |
| `Tx_IdempotencyRecord` | API-layer idempotency key store. |
| `Tx_PushSubscription` | Web-push notification subscriptions. |
| `A_MASTER_BARANG` | Legacy item master mapping (old code → new code). |

### 4f. Legacy / Archive Tables (local only)

These are carried over from early mockup builds and are **not actively used**:

`TTP` / `subTTP` / `TTPRetur` / `subTTPRetur` / `Faktur` / `SUBFAKTUR` /
`FakturPajak` / `APMuka` / `AwalBank` / `SaldoAP`

---

## 5. Key Column Conventions

### Document Number Columns

| Pattern | Meaning |
|---|---|
| `[Doku]` | The document number of **this** record (header or detail) |
| `[Doku_PO]` | Reference to a **PO** (`PO.Doku`) document |
| `[Doku_POSem]` | Reference to a **POSem** (draft PO) document |
| `[Doku_LPB]` | Reference to a **LPB** (GR) document |
| `[Doku_Faktur]` | Reference to a **VoucherAP** document |
| `[Doku_SPPB]` | Reference to a shipping/packing document |
| `[Doku_SO]` | Reference to a sales order document |

### Status Columns

| Column | Table(s) | Values / Meaning |
|---|---|---|
| `STS` | `PO`, `LPB` | Short status code (1-3 chars). Not enum-constrained by DB. |
| `Sts` | `SPB`, `Hiapt06`, `APMuka` | Variant spelling (mixed case); same pattern. |
| `Status` | `LPB`, `SubSPB` | Extended status string. |
| `StsVerify` | `SPB`, `PO` | `bit` — verified flag. |
| `TglVerify` | `SPB`, `PO` | Date of verification. |
| `StatusGL` | `Hiapt06`, `LPB` | GL posting status string. |
| `Hapus` | Most tables | Soft-delete: `NULL` = active, non-null = deleted (stores user/timestamp). **Never hard-delete.** |

### Financial Columns

| Column Pattern | Type | Meaning |
|---|---|---|
| `Nilai` | `float(53)` | Document value/amount |
| `Harga` | `float(53)` | Unit price |
| `Jumlah` | `float(53)` | Quantity |
| `Diskon` | `float(53)` | Discount (flat amount) |
| `DiscPct` | `float` | Discount percentage (local addition to `SubPO`) |
| `DiskonTunai` | `float(53)` | Cash discount |
| `PPN` / `PPn` | `float(53)` | VAT amount (spelling varies by table) |
| `PPnBm` | `float(53)` | Luxury goods tax |
| `PPH22` | `float(53)` | Article 22 income tax withholding |
| `Kode_Valas` | `nvarchar` | Currency code (e.g., `'USD'`, `'IDR'`) |
| `Kurs` | `float(53)` | Exchange rate |
| `NilaiLPB` | `float(53)` | GR-sourced value (on VoucherAP) |

### Audit Columns

| Column | Type | Purpose |
|---|---|---|
| `UserID` | `nvarchar(100)` | User who created/last modified the record |
| `EntryDate` | `smalldatetime` | Creation/modification timestamp |
| `RowVersion` | `timestamp` (= `rowversion`) | Optimistic concurrency — auto-updated by SQL Server on every write. **Do not insert/update this column.** |

---

## 6. Local Additions vs. Production

When rebuilding `schema.sql` from prod, these **local-only columns must be
preserved** (not overwritten by prod extracts):

### Transaction-level local additions

| Table | Local Columns | Purpose |
|---|---|---|
| `SPB` | `RowVersion` | Optimistic concurrency |
| `POSem` | `RowVersion` | Optimistic concurrency |
| `PO` | `RowVersion` | Optimistic concurrency |
| `LPB` | `RowVersion` | Optimistic concurrency |
| `VoucherAP` | `NOPEN`, `TglNopen`, `AWB_BL`, `SourceType`, `RowVersion` | Invoice import fields |
| `SubVoucherAP` | `APRef`, `InvoiceNo`, `TglInvoice`, `Doku_FP`, `Tgl_FP`, `SourceType` | Invoice import fields |
| `SubPO` | `Merk`, `Satuan`, `DiscPct` | Brand, unit, pct discount |
| `Barang` | `Merk`, `Satuan`, `Harga` | Brand, unit, price |
| `Hiapt06` | `RowVersion` | Optimistic concurrency |
| `Faktur` | `RowVersion` | Optimistic concurrency |
| `Supplier` | `RowVersion` | Optimistic concurrency |
| `SubReturBeli` | `RowVersion` | Optimistic concurrency |

---

## 7. Non-Obvious Facts & Gotchas

### Schema and Container

1. **Init runs exactly once.** Docker only executes `schema.sql` on a fresh
   data volume. Any schema edit requires:
   ```bash
   docker compose down -v && docker compose up -d
   # or
   ./seed.sh --reset
   ```
   Failing to do this silently leaves the old schema in place.

2. **No foreign keys.** None of the ERP tables have FK constraints. Referential
   integrity is 100% enforced at the API layer. Do not assume cascades or
   constraint errors on bad joins.

3. **`RowVersion` is SQL Server `timestamp`.** Despite the name, it is a
   binary auto-increment token (8 bytes), not a datetime. It increments
   database-wide. Never try to parse it as a time. Never specify it in
   `INSERT`/`UPDATE` — SQL Server sets it automatically.

4. **Computed column syntax.** `SubSPB.Jumhar` is defined as:
   ```sql
   [Jumhar] AS (([jumlah]*[Harga]))
   ```
   You cannot add `NULL` after a computed column definition. It will fail.
   Don't add `PERSISTED` unless you also test that the formula works with
   `float` nullability.

5. **`Barang` has no primary key.** It is joined on `Kode` (a natural key),
   but no `CONSTRAINT PRIMARY KEY` exists. This matches prod. Do not add one
   without coordinating with the API.

6. **`SKU_Stok` stores `Qty` as `varchar(50)`.** It mirrors prod exactly.
   Cast to `float` when doing arithmetic: `CAST([Qty] AS float)`.

7. **`VALAS2` has no PK and no unique index.** To get the current rate for a
   currency on a given day, always `TOP 1 ... ORDER BY Tanggal DESC`.

8. **Inline defaults instead of `ALTER TABLE ADD DEFAULT`.** `ALTER TABLE ADD
   DEFAULT` statements cause duplicate-constraint errors if the schema is
   re-applied. Do not introduce them.

9. **`<Name of Missing Index, sysname,>` index names.** Some indexes in the
   schema have placeholder names from SSMS's missing-index hints:
   `CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]`. These are
   prod-faithful and safe to leave as-is.

10. **`Doku_POSem` in `PO` and `SubPO`.** This column stores the document number
    of the originating local `POSem` draft PO.

11. **`APMuka.Doku_Bayar` and `APMuka.TglDokuBayar` remain unchanged.** These
    existing columns are retained to avoid a backend refactor.

### Data Modelling

12. **`PO.TipeBiaya` and `VoucherAP.TipeBiaya` CHECK constraint.**
    Both are constrained to `NULL OR IN ('LPB', 'PO')`. This controls which
    upstream document an AP invoice draws from — either a Goods Receipt (`LPB`)
    or directly from a PO Confirmation (`PO`). Always set this correctly when
    creating AP records.

13. **`Hiapt02.Doku_Faktur` → `VoucherAP.Doku`.** Payment lines reference the
    AP invoice by its document number, not its PK. Join on `Doku_Faktur = VoucherAP.Doku`.

14. **`LPB.Doku_PO` and `SubLPB.Doku_PO`.** Both store the PO Confirmation doc
    number (`PO.Doku`). The GR header references the PO at the document level,
    not by `id_po`.

15. **Soft deletes are universal.** All prod-mirrored transaction tables have a
    `[Hapus]` column. A non-null value means the record is logically deleted.
    All queries that list active records must filter `WHERE Hapus IS NULL`.

16. **`SubSPB.Jenis` and `SubSPB.KirimKd` have `DEFAULT ('')`** — non-null
    with empty string default, not NULL. Always include them in inserts or
    rely on the default.

17. **`Dept` carries signature-block columns** (`Nama10..52`, `Jabatan10..52`,
    `SignPO`, `PossPO`, `SignFaktur`, etc.). These are used in PDF report
    rendering for approval signatures. Do not strip them.

18. **`SPB` is a sales-side table in prod**, but is used in this mockup as a
    generic requisition (the AP side). The `Kode_Customer` column in `SPB`
    refers to the requesting entity/department — not a customer in the AP sense.

20. **`HistStokMon` composite PK** is `(ItemCode, Kode_Dept, Period, Kode_Area)`.
    Period is `datetime`. Always join/query using all four key parts to avoid
    expensive full-table scans.

### Seeding and Data

21. **Seed data is in `seeds/seed-synthetic.sql`.** It is hand-tuned for the
    current schema. If you add or remove columns in a table, update the seed
    INSERT column lists accordingly.

22. **The `./seed.sh --reset` flag drops and recreates the database**, then
    re-runs `schema.sql` + `seeds/seed-synthetic.sql`. It is the canonical
    "start fresh" operation.

23. **Production extraction scripts are unavailable.** Do not depend on `/tmp`
    scripts or attempt production access; update the local source of truth and
    synthetic seed together instead.

---

## 8. Cross-Table Document Number Join Map

This is the authoritative join map for the P2P flow using document numbers
(the primary way tables are linked in this schema — no FKs):

```
SPB.Doku
  → SubSPB.Doku                        (PR header → PR lines)
  → SubSPB.Doku_PO                     (PR line → PO Confirmation Doku)

POSem.Doku                             (Purchase Order draft)
  → SubPOSem.Doku                      (draft header → lines)
  → PO.Doku_POSem                      (PO Confirmation → draft)
  → SubPO.Doku_POSem                   (PO Confirmation line → draft)

PO.Doku                                (PO Confirmation)
  → SubPO.Doku                         (PO Confirmation header → lines)
  → LPB.Doku_PO                        (GR header → PO Confirmation)
  → SubLPB.Doku_PO                     (GR line → PO Confirmation)
  → VoucherAP.Doku_PO                  (AP invoice → PO Confirmation)
  → SubVoucherAP.Doku_PO               (AP invoice line → PO Confirmation)

LPB.Doku                               (Goods Receipt)
  → SubLPB.Doku                        (GR header → GR lines)
  → VoucherAP.Doku_LPB                 (AP invoice → GR)
  → SubVoucherAP.Doku_LPB              (AP invoice line → GR)
  → Hiapt02.Doku_LPB                   (Payment line → GR)
  → SubReturBeli.Doku_LPB              (Return line → GR)

VoucherAP.Doku                         (AP Invoice)
  → SubVoucherAP.Doku                  (AP invoice header → lines)
  → Hiapt02.Doku_Faktur                (Payment line → AP invoice)

Hiapt06.Doku                           (Payment)
  → Hiapt02.Doku                       (Payment header → lines)
```

---

## 9. Primary Key Reference

| Table | PK Column | Type |
|---|---|---|
| `SPB` | `id_spb` | `bigint IDENTITY` |
| `SubSPB` | `id_sub_spb` | `bigint IDENTITY` |
| `POSem` | `id_posem` | `bigint IDENTITY` |
| `SubPOSem` | `id_sub_posem` | `bigint IDENTITY` |
| `PO` | `id_po` | `bigint IDENTITY` |
| `SubPO` | `id_sub_po` | `bigint IDENTITY` |
| `LPB` | `id_lpb` | `bigint IDENTITY` |
| `SubLPB` | `id_sub_lpb` | `bigint IDENTITY` |
| `VoucherAP` | `PKbas` | `bigint IDENTITY` |
| `SubVoucherAP` | `PKbas` | `bigint IDENTITY` |
| `Hiapt06` | `PKindex` | `bigint IDENTITY` |
| `Hiapt02` | `PKbas` | `bigint IDENTITY` |
| `ReturBeli` | `PKbas` | `bigint IDENTITY` |
| `SubReturBeli` | `PKbas` | `bigint IDENTITY` |
| `TandaTerimaAr` | `PKbas` | `bigint IDENTITY` |
| `SubTandaTerimaAr` | `PKbas` | `bigint IDENTITY` |
| `Supplier` | `id_supplier` | `bigint IDENTITY` |
| `Dept` | `id_dept` | `bigint IDENTITY` |
| `Gudang` | `id_gudang` | `bigint IDENTITY` |
| `Bank` | `PKindex` | `bigint IDENTITY` |
| `Category` | `id_category` | `bigint IDENTITY` |
| `Satuan` | `id_satuan` | `bigint IDENTITY` |
| `Area` | `id_area` | `bigint IDENTITY` |
| `Sales` | `id_sales` | `bigint IDENTITY` |
| `JenisTransferBarang` | `IdJenisTransferBarang` | `bigint IDENTITY` |
| `HistStokMon` | Composite `(ItemCode, Kode_Dept, Period, Kode_Area)` | — |
| `TRStokOpname` | `Doku` | `nvarchar(50)` natural |
| `TRStokOpnameSub` | Composite `(Doku, Kode)` | — |
| `Master_Users` | — | — |
| `Tx_IdempotencyRecord` | — | — |
| `Tx_PushSubscription` | — | — |
| `Barang` | *(none)* | — |
| `SKU_Stok` | *(none)* | — |
| `VALAS2` | *(none)* | — |

---

## 10. Credentials and Connection

### Local container

| Field | Value |
|---|---|
| Server | `localhost,1433` |
| Database | `ErpApMockup` |
| Auth | SQL Login |
| User | `sa` |
| Password | `GalvaDev2026_StrongPwd` (from `.env`) |
| Trust cert | Yes (self-signed) |

### Production read-only source

| Field | Value |
|---|---|
| Server | `GTC-SERVER` |
| Database | `XTechnologies2018IN` |
| User | `remote9` |
| Password | `Remote!@#123` |

> **Never commit production credentials or connect to production.** Extraction
> scripts are unavailable in this repository.

---

## 11. File Layout

```
galva-db/
├── schema.sql                  ← single source of truth for all DDL
├── validate-schema.sh           ← non-Docker static naming validation
├── docker-compose.yml          ← SQL Server 2022 service definition
├── seed.sh                     ← reset and/or seed the container
├── seeds/
│   └── seed-synthetic.sql      ← hand-tuned synthetic INSERT data
├── docs/
│   ├── AGENTIC_CONTEXT.md      ← this file (agentic knowledge bank)
│   └── SCHEMA_REFERENCE.md     ← per-table column reference (optional, see docs/)
├── .env                        ← local credentials (gitignored)
└── .env.example                ← template for .env
```

---

## 12. Common Operational Tasks

### Validate a schema change

```bash
cd galva-db
bash ./validate-schema.sh
```

When Docker is available, also validate a fresh database initialization:

```bash
docker compose down -v
docker compose up -d
# wait ~30s for healthy
./seed.sh --reset
```

A clean run prints `Changed database context to 'ErpApMockup'.` with no `Msg`
lines. Any `Msg` line = error.

### Apply schema change without full reset (dev shortcut)

```bash
PASSWORD=$(grep '^MSSQL_SA_PASSWORD=' .env | cut -d= -f2 | tr -d "'\"")
cat your_change.sql | docker exec -i galva-mssql \
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$PASSWORD" -C -d ErpApMockup
```

**Warning:** This approach does not test the full `schema.sql` cleanly. Always
do a full reset before committing schema changes.

### Production re-extraction

Production extraction scripts are unavailable. Do not fabricate replacement
scripts or connect to production; coordinate a separately approved extraction
workflow before refreshing production-derived tables or seed data.

---

## 13. Constraints and Conventions

- **No foreign keys** on ERP tables. The API enforces referential integrity.
- **Primary keys** use IDENTITY columns (`id_*`, `PKindex`, `PKbas`) or natural
  string keys (`TRStokOpname.Doku`).
- **Document numbers** in `[Doku]` columns are always `nvarchar` (or `varchar`)
  and are the primary join keys across tables (no FKs).
- **Dates** use `smalldatetime` (most common) or `datetime`/`datetime2`.
- **Money/quantity** use `float(53)` (standard) or `money` (rare). Be aware of
  float precision issues in financial reporting.
- **Computed columns** (e.g., `SubSPB.Jumhar`) are defined as
  `[col] AS (expression)` — no `NULL` keyword after, no `PERSISTED` unless
  explicitly needed.
- **Inline defaults** replace `ALTER TABLE ADD DEFAULT` to prevent duplicate
  constraint errors on schema re-application.
- **`SET ANSI_NULLS ON` / `SET QUOTED_IDENTIFIER ON`** appear before every
  `CREATE TABLE` block — SQL Server boilerplate, required for prod-faithful
  compatibility.

---

## 14. What NOT to Do

- **Do not run `ALTER TABLE` migrations** for schema-wide changes. Update
  `schema.sql` and reset the container.
- **Do not add FK constraints** to ERP tables without explicit instruction.
- **Do not add new dependencies** to `galva-db` unless absolutely necessary.
- **Do not commit** production credentials, `.venv/`, or `__pycache__/`.
- **Do not manually edit** `seeds/seed-synthetic.sql` for structural changes;
  update `schema.sql` first, then adjust seed data if column lists change.
- **Do not hard-delete** rows from any ERP table. Use the `Hapus` soft-delete
  pattern instead.
- **Do not insert or update `RowVersion`** columns — SQL Server manages them.
- **Do not add `NULL` after a computed column definition** — it will fail at DDL
  parse time.
