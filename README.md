# galva-db

SQL Server 2022 (Developer Edition) running in Docker for local development.
Hosts the **Galva ERP AP mockup schema** (`schema.sql`) — a P2P data model
mirrored from the production `XTechnologies2018IN` database.

## Quick start

```bash
# 1. Start the container (schema.sql auto-runs on first init)
docker compose up -d

# 2. Wait for healthy status
docker compose ps
docker compose logs -f mssql

# 3. Reset + seed with synthetic data (use after schema changes)
./seed.sh --reset
```

## Connection

| Field      | Value                                  |
| ---------- | -------------------------------------- |
| Server     | `localhost,1433`                       |
| Auth type  | SQL Login                              |
| User       | `sa`                                   |
| Password   | `GalvaDev2026_StrongPwd` (from `.env`) |
| Database   | `ErpApMockup`                          |
| Trust cert | True (self-signed)                     |

Read-only prod profile: server `GTC-SERVER`, database `XTechnologies2018IN`,
user `remote9`. Credentials are not checked in.

## P2P Data Flow

```
Purchase Requisition  →  SPB / SubSPB
       │
       ▼
Purchase Order        →  POSem / SubPOSem
       │                 referenced via Doku_POSem columns in PO / SubPO
       ▼
PO Confirmation       →  PO / SubPO
       │
       ▼
Goods Receipt         →  LPB / SubLPB
       │
       ▼
AP Invoice            →  VoucherAP / SubVoucherAP
       │
       ▼
Payment               →  Hiapt06 / Hiapt02
       │
       ▼
Purchase Return       →  ReturBeli / SubReturBeli  (optional)

AR Receipt Notes      →  TandaTerimaAr / SubTandaTerimaAr
```

> **ERP naming convention:** In the production system `POSem` is what the
> business calls a **Purchase Order** (draft), and `PO` is what the business
> calls a **PO Confirmation** (finalized). Both table pairs are in the local
> schema; `PO` and `SubPO` retain `Doku_POSem` references to their drafts.

## Layout

| Path                    | Purpose                                                   |
| ----------------------- | --------------------------------------------------------- |
| `schema.sql`            | Full T-SQL schema for `ErpApMockup`. Source of truth.     |
| `seeds/`                | Synthetic seed data (`seed-synthetic.sql`).               |
| `docs/AGENTIC_CONTEXT.md` | Agentic knowledge bank — schema facts, gotchas, join map. |
| `validate-schema.sh`    | Lightweight static naming validation; no Docker required.  |
| `docker-compose.yml`    | SQL Server 2022 service definition.                       |
| `seed.sh`               | Reset or seed the running container.                      |
| `.env` / `.env.example` | Local credentials (gitignored) / template.                |

## Keeping schema.sql in sync with prod

`schema.sql` is the local source of truth for the relevant P2P subset (masters,
PR, draft PO, PO confirmation, GR, AP invoice, payment, returns, and receipts).
Production extraction scripts are not present in this repository.

Run the non-Docker naming check after any edit:

```bash
bash ./validate-schema.sh
```

Then, when Docker is available, validate a clean database initialization:

```bash
docker compose down -v
docker compose up -d
# wait for healthy
./seed.sh --reset
```

## Known gotchas

- **Init runs once.** `/docker-entrypoint-initdb.d/*.sql` only executes on a
  fresh data volume. Edit `schema.sql`, then `docker compose down -v && up -d`
  or `./seed.sh --reset` to reapply.
- **No FK constraints.** Referential integrity is enforced by the API.
- **RowVersion columns.** Added locally to transaction tables for optimistic
  concurrency. Never specify in INSERT/UPDATE — SQL Server manages them.
- **Computed columns.** `SubSPB.Jumhar` is `AS ([jumlah]*[Harga])`.
- **`POSem` ≠ `PO`.** `POSem`/`SubPOSem` (local + prod) = Purchase Orders.
  `PO`/`SubPO` (local + prod) = PO Confirmations. See `docs/AGENTIC_CONTEXT.md`.
- **Soft deletes.** All transaction tables use `Hapus IS NULL` for active
  records. Never hard-delete ERP rows.

## Full documentation

See [`docs/AGENTIC_CONTEXT.md`](docs/AGENTIC_CONTEXT.md) for the complete
agentic knowledge bank: schema definitions, cross-table join map, primary key
reference, naming conventions, and a full list of non-obvious gotchas.
