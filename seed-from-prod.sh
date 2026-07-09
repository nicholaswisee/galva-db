#!/usr/bin/env bash
# ============================================================================
# galva-db/seed-from-prod.sh
# End-to-end pipeline:
#   1. Extract a clean, P2P-coherent sample from the live XTechnologies2018IN
#      database on GTC-SERVER.
#   2. Transform it to match the local ErpApMockup schema.
#   3. Write galva-db/seed-from-prod.sql with static INSERTs.
#   4. Apply it to the running galva-mssql Docker container.
#
# Requirements:
#   - Python 3.10+ with pymssql
#   - docker (the galva-mssql container must be running)
#   - .env with MSSQL_SA_PASSWORD
#
# Usage:
#   ./seed-from-prod.sh                 # default: 30 POs, 60-month window
#   ./seed-from-prod.sh --n-pos 50      # more POs
#   ./seed-from-prod.sh --dry-run       # extract only, don't apply
#   ./seed-from-prod.sh --reset         # nuke the DB and re-init from schema first
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")"

# ---- args ----
N_POS=30
RECENCY_MONTHS=60
DRY_RUN=0
DO_RESET=0
PYTHON_BIN="${PYTHON_BIN:-python3}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --n-pos)           N_POS="$2"; shift 2;;
    --recency-months)  RECENCY_MONTHS="$2"; shift 2;;
    --dry-run)         DRY_RUN=1; shift;;
    --reset)           DO_RESET=1; shift;;
    --python)          PYTHON_BIN="$2"; shift 2;;
    -h|--help)
      sed -n '2,21p' "$0"; exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

PASSWORD=$(grep '^MSSQL_SA_PASSWORD=' .env | cut -d= -f2 | tr -d "'\"")
CONTAINER="galva-mssql"
SEED_SQL="seed-from-prod.sql"

# ---- 1. Extract ----
echo "============================================================"
echo "Step 1/3: Extract from prod (GTC-SERVER / XTechnologies2018IN)"
echo "         N=$N_POS POs, last $RECENCY_MONTHS months"
echo "============================================================"
"$PYTHON_BIN" scripts/extract-from-prod.py \
  --n-pos "$N_POS" \
  --recency-months "$RECENCY_MONTHS" \
  --output "$SEED_SQL"

if [[ ! -s "$SEED_SQL" ]]; then
  echo "ERROR: extractor produced empty $SEED_SQL" >&2
  exit 1
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo
  echo "Dry run complete. $SEED_SQL written, not applied to container."
  exit 0
fi

# ---- 2. (Optional) Reset DB ----
if [[ $DO_RESET -eq 1 ]]; then
  echo
  echo "============================================================"
  echo "Step 2/4: Reset ErpApMockup database"
  echo "============================================================"
  docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
    -Q "
USE master;
IF DB_ID('ErpApMockup') IS NOT NULL
BEGIN
  ALTER DATABASE ErpApMockup SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE ErpApMockup;
END;
CREATE DATABASE ErpApMockup;
"
  echo "Re-creating from schema.sql..."
  docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
    -Q "$(cat schema.sql | tr -d '\r')"
fi

# ---- 3. Apply pending migrations ----
# Existing containers may have been initialized before schema.sql added
# columns such as LPB.Doku_PCF. Migrations bring those online idempotently.
echo
echo "============================================================"
echo "Step 3/4: Apply pending migrations"
echo "============================================================"
./migrate.sh

# ---- 4. Apply seed SQL ----
echo
echo "============================================================"
echo "Step 4/4: Apply $SEED_SQL to container '$CONTAINER'"
echo "============================================================"
# Strip CRLF and pipe to sqlcmd
docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
  -Q "$(tr -d '\r' < "$SEED_SQL")"

# ---- Verify ----
echo
echo "============================================================"
echo "Verifying row counts in ErpApMockup"
echo "============================================================"
docker exec "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "$PASSWORD" -C -h -1 -W \
  -Q "
USE ErpApMockup;
SELECT 'Dept'         AS TableName, COUNT(*) AS n FROM dbo.Dept
UNION ALL SELECT 'Supplier',   COUNT(*) FROM dbo.Supplier
UNION ALL SELECT 'Barang',     COUNT(*) FROM dbo.Barang
UNION ALL SELECT 'Gudang',     COUNT(*) FROM dbo.Gudang
UNION ALL SELECT 'Bank',       COUNT(*) FROM dbo.Bank
UNION ALL SELECT 'Category',   COUNT(*) FROM dbo.Category
UNION ALL SELECT 'Satuan',     COUNT(*) FROM dbo.Satuan
UNION ALL SELECT 'PO',         COUNT(*) FROM dbo.PO
UNION ALL SELECT 'SubPO',      COUNT(*) FROM dbo.SubPO
UNION ALL SELECT 'LPB',        COUNT(*) FROM dbo.LPB
UNION ALL SELECT 'SubLPB',     COUNT(*) FROM dbo.SubLPB
UNION ALL SELECT 'VoucherAP',  COUNT(*) FROM dbo.VoucherAP
UNION ALL SELECT 'SubVoucherAP', COUNT(*) FROM dbo.SubVoucherAP
ORDER BY TableName;
"

echo
echo "Done. $SEED_SQL is the artifact; re-run this script to regenerate."
