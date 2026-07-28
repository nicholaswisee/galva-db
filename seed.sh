#!/usr/bin/env bash
# Helper: keep a running galva-mssql container in sync with schema.sql.
#
# Background:
#   SQL Server's /docker-entrypoint-initdb.d only runs on a FRESH data volume.
#   Once a container has data, schema changes must be applied by resetting
#   the volume or by using your own ALTER scripts. This script resets the
#   DB from schema.sql and optionally re-seeds synthetic data.
#
# Usage:
#   ./seed.sh              # re-apply schema.sql + synthetic seed data
#   ./seed.sh --no-seed    # re-apply schema.sql only
#   ./seed.sh --reset      # DROP the DB, re-init from schema.sql, then seed

set -euo pipefail

cd "$(dirname "$0")"

# Read password from .env
PASSWORD=$(grep '^MSSQL_SA_PASSWORD=' .env | cut -d= -f2 | tr -d "'\"")
CONTAINER="${COMPOSE_PROJECT_NAME:-galva}-mssql"

RUN_SEED=1
DO_RESET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-seed) RUN_SEED=0; shift;;
    --reset)   DO_RESET=1; shift;;
    -h|--help)
      sed -n '2,12p' "$0"; exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

if [ "$DO_RESET" -eq 1 ]; then
  echo "Resetting ErpApMockup database on container '$CONTAINER'..."
  docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
    -Q "USE master; ALTER DATABASE ErpApMockup SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE ErpApMockup;" \
    2>/dev/null || true
  echo "Re-applying schema.sql..."
  docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
    -i /docker-entrypoint-initdb.d/01-schema.sql
fi

if [ "$RUN_SEED" -eq 1 ]; then
  echo
  echo "Applying seeds/seed-synthetic.sql..."
  tr -d '\r' < seeds/seed-synthetic.sql | docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$PASSWORD" -C -h -1 -W
fi

echo
echo "Verifying tables in ErpApMockup..."
docker exec "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
  -Q "USE ErpApMockup; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME;"
