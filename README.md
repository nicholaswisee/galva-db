# galva-db

SQL Server 2022 (developer edition) running in Docker for local dev.
Hosts the **Galva ERP AP mockup schema** (`schema.sql`) — a faithful
replica of the production `XTechnologies2018IN` P2P data model
(PR → PO → GR → Invoice → Payment).

Three workflows live here:

1. **Bring up the local DB** — `docker compose up`, with `schema.sql`
   auto-applied on first boot.
2. **Query live prod** — `query.sql` / `query-live.sql` are T-SQL scripts
   designed to be run against either the local Docker container or the
   `galva-remote` production server (GTC-SERVER / XTechnologies2018IN).
3. **Seed from prod** — `seed-from-prod.sh` extracts a clean,
   P2P-coherent slice of production data and applies it to the local
   container, giving the mockup realistic data to develop against.

## Quick start

```bash
# 1. Bring it up (auto-runs schema.sql on first init)
docker compose up -d

# 2. Wait until healthy
docker compose ps      # STATUS should show "healthy" after ~20-40s
docker compose logs -f mssql   # tail startup; look for "Recovery is complete"

# 3. Connect from VS Code
#    Install extension: "MSSQL" by Microsoft (ms-mssql.mssql)
#    Add connection:
#      Server:   localhost,1433
#      Auth:     SQL Login
#      User:     sa
#      Password: GalvaDev2026_StrongPwd
#      Encrypt:  Optional (or Mandatory with Trust Server Certificate)
#    Database: ErpApMockup
```

## Common commands

```bash
# Tail logs
docker compose logs -f

# Open a sqlcmd shell inside the container
docker compose exec mssql /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$(grep MSSQL_SA_PASSWORD .env | cut -d= -f2)" -C

# Re-apply schema (use after editing schema.sql, or if init didn't run)
./seed.sh

# Stop (keeps data)
docker compose down

# Nuke data + re-seed schema (DESTRUCTIVE)
docker compose down -v
docker compose up -d
```

## Querying prod

Two read-only scripts are checked in. They use only the most fundamental
columns (Doku, Kode, Nama, Doku_SPPB, Doku_LPB, Nilai) so they work
across schema versions.

| Script           | Target                       | Use case                                                                                                                        |
| ---------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `query.sql`      | Either DB                    | Section-by-section reports — run individual sections in VS Code, or the whole file via sqlcmd.                                  |
| `query-live.sql` | `XTechnologies2018IN` (prod) | Polished version of `query.sql` with the live-schema corrections, safety caps, and an additional **seed-ready P2P chain** view. |

Run from VS Code (SQLTools → galva-remote profile → Ctrl+Shift+E) or:

```bash
sqlcmd -S GTC-SERVER -U remote9 -P "Remote!@#123" -d XTechnologies2018IN \
       -h -1 -W -C -i query-live.sql
```

Both scripts are **byte-deterministic** — running the same script twice
against the same prod snapshot returns the same output (results are
ordered; `TOP` clauses use `Doku` as a tie-breaker where applicable).

## Seeding from prod

The local schema is empty after `schema.sql` runs (modulo a placeholder
row per master table). To populate it with realistic prod data:

```bash
# Wipe + re-init from schema, then extract 30 recent POs from prod
# and apply them to the running container.
./seed-from-prod.sh --n-pos 30 --recency-months 60 --reset

# Smaller sample, dry-run (extract only, don't apply)
./seed-from-prod.sh --n-pos 10 --dry-run

# Re-apply the existing seed-from-prod.sql without re-extracting
docker exec -i galva-mssql /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$(grep MSSQL_SA_PASSWORD .env | cut -d= -f2)" -C -h -1 -W \
  -Q "$(tr -d '\r' < seed-from-prod.sql)"
```

The pipeline is:

```
GTC-SERVER (prod)                galva-mssql (local)
  XTechnologies2018IN            ErpApMockup
  ┌──────────────────┐           ┌──────────────────┐
  │  Supplier, PO,   │           │  schema.sql      │
  │  LPB, VoucherAP  │  extract  │  (empty)         │
  │  Sub* tables     │ ────────► │  + seed-from-    │
  │  Dept (161 rows) │  scripts/ │    prod.sql      │
  │  Barang (0%)     │  extract- │  (279 rows)      │
  └──────────────────┘  from-    └──────────────────┘
                       prod.py
                            │
                            ▼
                  seed-from-prod.sql
                  (auto-generated, ~64KB,
                   byte-deterministic)
```

**Generated artifact:** `seed-from-prod.sql` is regenerated on every
run. The header carries a `Signature:` line showing the parameters
(`N POs since YYYY-MM-DD`); a diff in git between two runs reveals
exactly what changed in prod data.

**Scope decisions** (worth knowing before you scale up):

- `Bayar` / `SubBayar` are not seeded — prod's `SubBayar.Doku_LPB` is
  0% populated, so there's no reliable Voucher→Payment chain.
- `SPB` / `SubSPB` (PRs) are not seeded — `PO.Doku_SPPB` is 0%
  populated in prod, so the PR→PO link can't be walked.
- Stub rows are synthesized for any `Kode_Brg` value referenced by the
  selected transactions but missing from prod's Barang master (that
  master is 0% populated in XTechnologies2018IN). `Kode_Dept` values
  resolve against prod's `dbo.Dept` (161 rows).

## File index

| File                           | Type   | Notes                                                                                              |
| ------------------------------ | ------ | -------------------------------------------------------------------------------------------------- |
| `docker-compose.yml`           | Config | Service definition; `schema.sql` is bind-mounted into the initdb dir.                              |
| `schema.sql`                   | T-SQL  | Full schema for `ErpApMockup`. Auto-runs on first container boot.                                  |
| `seed.sh`                      | Bash   | Re-apply `schema.sql` to a running container (use after editing the schema or if init didn't run). |
| `seed-from-prod.sh`            | Bash   | Orchestrator: extract from prod, write `seed-from-prod.sql`, optionally reset and apply.           |
| `seed-from-prod.sql`           | T-SQL  | **Auto-generated** seed data. Don't edit; regenerate via the script.                               |
| `scripts/extract-from-prod.py` | Python | The extractor. Schema-aware, transforms source columns to match local schema, synthesizes stubs.   |
| `query.sql`                    | T-SQL  | Section-by-section reports. Schema-agnostic.                                                       |
| `query-live.sql`               | T-SQL  | Polished version of `query.sql` for the live prod DB.                                              |
| `test.sql`                     | T-SQL  | Ad-hoc test queries (kept for reference).                                                          |
| `.env` / `.env.example`        | Config | Local credentials (gitignored) / template.                                                         |
| `.gitignore`                   | Config | Excludes `.env`, `__pycache__/`, `*.pyc`, `data/`, `*.log`.                                        |

## VS Code connection cheat-sheet

| Field      | Value                                  |
| ---------- | -------------------------------------- |
| Server     | `localhost,1433`                       |
| Auth type  | SQL Login                              |
| User       | `sa`                                   |
| Password   | `GalvaDev2026_StrongPwd` (from `.env`) |
| Database   | `ErpApMockup`                          |
| Trust cert | True (self-signed)                     |

For the prod read-only profile (`galva-remote`), see the corresponding
VS Code connection profile — server `GTC-SERVER`, database
`XTechnologies2018IN`, user `remote9`. The credentials are not
checked in.

## Known gotchas

- **Init runs ONCE.** `/docker-entrypoint-initdb.d/*.sql` only executes
  on a fresh data volume. Editing `schema.sql` after first start won't
  auto-reapply — use `./seed.sh`. For a clean slate:
  `docker compose down -v && docker compose up -d`.
- **`GO` must be on its own line.** sqlcmd 18+ on Linux does not
  recognize inline `; GO` as a batch separator. The schema is already
  formatted correctly.
- **Avoid `!` in `MSSQL_SA_PASSWORD`.** Bash history expansion can
  mangle it before the file is written, leaving an invalid password
  that fails SQL Server's complexity check.
- **No FK constraints in the ERP tables.** `schema.sql` declares
  primary keys and IDENTITY columns but not foreign keys — referential
  integrity is the app's responsibility. The seed pipeline doesn't
  enforce FKs, so a master row can be missing without breaking the
  apply.
- **`RowVersion` columns.** `schema.sql` adds `RowVersion` (a.k.a.
  `timestamp`) to most tables for optimistic concurrency. These
  columns auto-populate on INSERT — the seed SQL doesn't include them
  in the column list, so the DB fills them in.
- **`SubPO.Kurs` does not exist in prod.** The local `SubPO` table
  has a `Kurs` column but the prod `SubPO` does not. The extractor
  omits it from the seed; the local column stays `NULL` for seeded
  rows. This is documented in `scripts/extract-from-prod.py`.
