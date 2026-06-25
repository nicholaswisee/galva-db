#!/usr/bin/env bash
# Helper: apply schema.sql into the running galva-mssql container.
# Use when /docker-entrypoint-initdb.d/ didn't run (volume wasn't fresh)
# or after manually editing schema.sql.
set -euo pipefail

cd "$(dirname "$0")"

# Read password from .env
PASSWORD=$(grep '^MSSQL_SA_PASSWORD=' .env | cut -d= -f2 | tr -d "'\"")
CONTAINER="${COMPOSE_PROJECT_NAME:-galva}_mssql"

echo "Applying schema.sql to container '$CONTAINER'..."
docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
  -i /docker-entrypoint-initdb.d/01-schema.sql

echo
echo "Verifying tables in ErpApMockup..."
docker exec "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
  -Q "USE ErpApMockup; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME;"
