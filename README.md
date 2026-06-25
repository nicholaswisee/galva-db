# GALVA-DB

SQL Server 2022 (developer edition) running in Docker for local dev. Schema (`schema.sql`) seeds automatically on first boot.

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

# Manually re-apply schema (use after editing schema.sql, or if init didn't run)
./seed.sh

# Stop (keeps data)
docker compose down

# Nuke data + re-seed schema (DESTRUCTIVE)
docker compose down -v
docker compose up -d
```

## Files

- `docker-compose.yml` — service definition
- `schema.sql` — auto-seeded on first run (ERP AP mockup, PR→PO→GR→Invoice→Payment)
- `seed.sh` — manually re-apply schema.sql
- `.env` — local credentials (gitignored)
- `.env.example` — template

## VS Code connection cheat-sheet

| Field        | Value                                |
|--------------|--------------------------------------|
| Server       | `localhost,1433`                     |
| Auth type    | SQL Login                            |
| User         | `sa`                                 |
| Password     | `GalvaDev2026_StrongPwd` (from `.env`) |
| Database     | `ErpApMockup`                        |
| Trust cert   | True (self-signed)                   |

## Known gotchas

- **Init runs ONCE.** `/docker-entrypoint-initdb.d/*.sql` only executes on a fresh
  data volume. Editing `schema.sql` after first start won't auto-reapply — use
  `./seed.sh`. For a clean slate: `docker compose down -v && docker compose up -d`.
- **`GO` must be on its own line.** sqlcmd 18+ on Linux does not recognize
  inline `; GO` as a batch separator. The schema is already formatted correctly.
- **Avoid `!` in `MSSQL_SA_PASSWORD`.** Bash history expansion can mangle it
  before the file is written, leaving an invalid password that fails SQL Server's
  complexity check.
