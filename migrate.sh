#!/usr/bin/env bash
# Apply incremental migrations in galva-db/migrations/ to the running
# galva-mssql container. Migrations are sorted by filename and applied
# idempotently (each script is expected to check IF NOT EXISTS before
# making schema changes).
#
# Usage:
#   ./migrate.sh            # apply all pending migrations
#   ./migrate.sh --dry-run  # list migrations that would be applied

set -euo pipefail

cd "$(dirname "$0")"

PASSWORD=$(grep '^MSSQL_SA_PASSWORD=' .env | cut -d= -f2 | tr -d "'\"")
CONTAINER="${COMPOSE_PROJECT_NAME:-galva}-mssql"
MIGRATIONS_DIR="./migrations"
DRY_RUN=0

if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=1
fi

if [ ! -d "$MIGRATIONS_DIR" ]; then
  echo "No migrations directory found at $MIGRATIONS_DIR" >&2
  exit 1
fi

# Gather migration files sorted by name.
mapfile -t MIGRATION_FILES < <(ls -1 "$MIGRATIONS_DIR"/*.sql 2>/dev/null | sort)

if [ ${#MIGRATION_FILES[@]} -eq 0 ]; then
  echo "No migration files found in $MIGRATIONS_DIR"
  exit 0
fi

echo "Applying ${#MIGRATION_FILES[@]} migration(s) to container '$CONTAINER'..."

for file in "${MIGRATION_FILES[@]}"; do
  name=$(basename "$file")
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] $name"
    continue
  fi

  echo "  → $name"
  docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
    -i "/migrations/$name"
done

echo
echo "Verifying LPB/SubLPB Doku_PCF columns exist..."
docker exec "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
  -Q "USE ErpApMockup; SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME IN ('LPB','SubLPB') AND COLUMN_NAME = 'Doku_PCF' ORDER BY TABLE_NAME;"

echo
echo "Migrations complete."
