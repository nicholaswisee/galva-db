# Galva Database — Agentic Context

This document gives an autonomous agent everything it needs to work on the
`galva-db` module without re-deriving the basics.

## 1. Module purpose

`galva-db` is a Dockerized SQL Server 2022 instance that hosts the
**ErpApMockup** database. It is a cut-down, local mirror of the production
`XTechnologies2018IN` ERP database, focused on the **Purchase-to-Pay (P2P)**
flow and related return / receipt features.

The single source of truth for schema is `schema.sql`. Migrations are no
longer used.

## 2. High-level data flow

```
Purchase Requisition (SPB / SubSPB)
    │
    ▼
Purchase Order (PO / SubPO)
    │
    ▼
PO Confirmation (POConfirmation / SubPOConfirmation)   ← local-only tables
    │
    ▼
Goods Receipt (LPB / SubLPB)
    │
    ▼
AP Invoice (VoucherAP / SubVoucherAP)
    │
    ▼
Payment (Bayar / SubBayar)
    │
    ▼
Purchase Return (ReturBeli / SubReturBeli)

Final receipts / acknowledgement:
  TandaTerimaAr / SubTandaTerimaAr   (AR receipt notes, mirrored from prod)
```

## 3. Header / detail pattern

Almost every transaction follows the same shape:

| Header table | Detail table | What the header carries | What the detail carries |
| ------------ | ------------ | ---------------------- | ------------------------ |
| `SPB` | `SubSPB` | Document number, department, request date, status | Individual item lines: item code, quantity, notes |
| `PO` | `SubPO` | Supplier, PO date, terms, totals | Ordered item lines: item, quantity, price, discount |
| `POConfirmation` | `SubPOConfirmation` | Confirmation document, PO reference | Confirmed quantities per PO line |
| `LPB` | `SubLPB` | Receipt document, PCF reference | Received item lines linked to `id_sub_po_confirmation` |
| `VoucherAP` | `SubVoucherAP` | Invoice header, supplier, invoice totals | Invoice lines referencing LPB/PO lines |
| `Bayar` | `SubBayar` | Payment header, bank, total paid | Payment lines allocated to vouchers |
| `ReturBeli` | `SubReturBeli` | Return document, supplier, date | Returned item lines |
| `TandaTerimaAr` | `SubTandaTerimaAr` | Receipt note header | Receipt lines |

**Rule of thumb:** the header table contains the metadata for the document;
the matching `Sub*` table contains the line items that belong to that
document.

## 4. Table catalog

### Masters

| Table | Origin | Notes |
| ----- | ------ | ----- |
| `Dept` | prod | Departments / divisions. |
| `Supplier` | prod | Vendors. Has local `RowVersion`. |
| `Barang` | prod | Items / SKUs. Local additions: `Merk`, `Satuan`, `Harga`. |
| `Gudang` | prod | Warehouses. |
| `Bank` | prod | Banks. |
| `Category` | prod | Item categories. |
| `Satuan` | prod | Units of measure. |

### P2P transactions

| Table | Origin | Notes |
| ----- | ------ | ----- |
| `SPB` / `SubSPB` | prod | Purchase requisition. `SubSPB.Jumhar` is computed `([jumlah]*[Harga])`. |
| `PO` / `SubPO` | prod | Purchase order. `SubPO` has local `Merk`, `Satuan`, `DiscPct`. |
| `POConfirmation` / `SubPOConfirmation` | **local only** | Not present in prod. Confirms PO quantities before GR. |
| `LPB` / `SubLPB` | prod | Goods receipt. Local additions: `Doku_PCF` (header & detail), `id_sub_po_confirmation` (detail). |
| `VoucherAP` / `SubVoucherAP` | prod | AP invoice / voucher. Local additions: `Doku_PCF`, `NOPEN`, `TglNopen`, `AWB_BL`, `SourceType`, `RowVersion` (header), plus detail import fields. |
| `Bayar` / `SubBayar` | prod | Payment. |

### Returns and receipts

| Table | Origin | Notes |
| ----- | ------ | ----- |
| `ReturBeli` / `SubReturBeli` | prod | Purchase returns. Local `RowVersion` added. |
| `TandaTerimaAr` / `SubTandaTerimaAr` | prod | Receipt acknowledgement (AR-side). Local `RowVersion` added. |

### Other local tables

Tables in `schema.sql` that are **not** mirrored from prod and exist only for
the mockup include `A_MASTER_BARANG`, `Master_Users`, `Tx_IdempotencyRecord`,
`Tx_PushSubscription`, and the legacy `TTP` / `subTTP` / `TTPRetur` /
`subTTPRetur` / `Faktur` / `SUBFAKTUR` blocks.

## 5. Local additions vs production

When rebuilding `schema.sql` from prod, the following local columns must be
preserved:

- `RowVersion [timestamp] NOT NULL` — optimistic concurrency on transaction
  headers and some details.
- `Doku_PCF [nvarchar](50) NULL` — links GR and AP invoice back to PO
  Confirmation.
- `id_sub_po_confirmation [bigint] NULL` — line-level GR → PO Confirmation link.
- `SubPO`: `Merk`, `Satuan`, `DiscPct`.
- `Barang`: `Merk`, `Satuan`, `Harga`.
- `VoucherAP` / `SubVoucherAP`: import columns (`NOPEN`, `AWB_BL`,
  `TglNopen`, `InvoiceNo`, `TglInvoice`, `Doku_FP`, `Tgl_FP`, `SourceType`,
  `APRef`).

These are merged into the production CREATE TABLE blocks by
`/tmp/update_schema_final.py`.

## 6. Credentials and connection

### Local container

- Server: `localhost,1433`
- Database: `ErpApMockup`
- Auth: SQL Login
- User: `sa`
- Password: `GalvaDev2026_StrongPwd` (read from `.env`)

### Production read-only source

- Server: `GTC-SERVER`
- Database: `XTechnologies2018IN`
- Auth: SQL Login
- User: `remote9`
- Password: `Remote!@#123`

**Never commit production credentials.** The extraction scripts in `/tmp`
are not part of the repo.

## 7. File layout

```
galva-db/
├── schema.sql              ← source of truth
├── docker-compose.yml      ← SQL Server 2022 service
├── seed.sh                 ← reset / seed the container
├── seeds/
│   └── seed-synthetic.sql  ← mock data
├── docs/
│   └── AGENTIC_CONTEXT.md  ← this file
├── .env                    ← local credentials (gitignored)
└── .env.example            ← template
```

## 8. Common tasks

### Validate a schema change

```bash
cd galva-db
docker compose down -v
docker compose up -d
# wait for healthy
./seed.sh --reset
```

A clean run prints `Changed database context to 'ErpApMockup'.` and nothing
else. Any `Msg` lines are errors.

### Re-extract production schemas

Run the temporary (non-committed) scripts in `/tmp`:

```bash
/tmp/galva-db-venv/bin/python /tmp/extract_prod_schemas.py   # writes /tmp/prod_schemas.sql
/tmp/galva-db-venv/bin/python /tmp/update_schema_final.py    # merges into galva-db/schema.sql
```

Then validate as above.

### Add a new prod-mirrored table

1. Add the table name to the `TABLES` list in both
   `/tmp/extract_prod_schemas.py` and `/tmp/update_schema_final.py`.
2. If the table is new to the local schema, add an `INSERT_AFTER` anchor in
   `/tmp/update_schema_final.py`.
3. Add any local columns to `LOCAL_ADDITIONS`.
4. Re-extract and validate.

## 9. Constraints and conventions

- **No foreign keys** in the ERP tables. The API enforces referential
  integrity.
- **Primary keys** use `PKindex` or `PKbas` IDENTITY columns, or natural keys
  like `id_po`.
- **Document numbers** are in `Doku` columns (header) and `Doku_*` columns
  (detail references).
- **Dates** use `smalldatetime` or `datetime`.
- **Money/quantity** columns use `float` or `money`.
- **Computed columns** (e.g., `SubSPB.Jumhar`) must be written as
  `[col] AS (expression)` without a trailing `NULL` keyword.
- **Inline defaults** from prod replace explicit `ALTER TABLE ADD DEFAULT`
  statements to avoid duplicate-constraint errors.

## 10. What not to do

- Do not run `ALTER TABLE` migrations for schema-wide changes. Update
  `schema.sql` and reset the container.
- Do not add new dependencies to `galva-db` unless absolutely necessary.
- Do not commit production credentials, `.venv/`, or `__pycache__/`.
- Do not manually edit `seeds/seed-synthetic.sql` for structural changes;
  update `schema.sql` first, then adjust the seed data if column lists change.
