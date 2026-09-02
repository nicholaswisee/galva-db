#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
schema="$root/schema.sql"
seed="$root/seeds/seed-synthetic.sql"
readme="$root/README.md"
context="$root/docs/AGENTIC_CONTEXT.md"
failures=0

require() {
    local file=$1 text=$2
    if ! grep -Fq -- "$text" "$file"; then
        printf 'Missing %s in %s\n' "$text" "$file" >&2
        failures=$((failures + 1))
    fi
}

forbid() {
    local file=$1 pattern=$2
    if grep -Eq -- "$pattern" "$file"; then
        printf 'Forbidden %s in %s\n' "$pattern" "$file" >&2
        failures=$((failures + 1))
    fi
}

table_excludes() {
    local table=$1 column=$2 line found=0
    while IFS= read -r line; do
        if [[ $line == "CREATE TABLE [dbo].[$table](" ]]; then
            found=1
        fi
        if (( found )) && [[ $line == *"$column"* ]]; then
            printf 'Forbidden %s in %s table\n' "$column" "$table" >&2
            failures=$((failures + 1))
            return
        fi
        if (( found )) && [[ $line == ') ON [PRIMARY]' ]]; then
            return
        fi
    done < "$schema"
    printf 'Missing %s table\n' "$table" >&2
    failures=$((failures + 1))
}

require "$schema" 'CREATE TABLE [dbo].[POSem]('
require "$schema" 'CREATE TABLE [dbo].[SubPOSem]('
require "$schema" '[id_posem] [bigint] IDENTITY(1,1) NOT NULL,'
require "$schema" '[id_sub_posem] [bigint] IDENTITY(1,1) NOT NULL,'
require "$schema" 'CONSTRAINT [PK_POSem] PRIMARY KEY CLUSTERED ([id_posem]) ON [PRIMARY]'
require "$schema" 'CONSTRAINT [PK_SubPOSem] PRIMARY KEY CLUSTERED ([id_sub_posem]) ON [PRIMARY]'
require "$schema" 'CREATE TABLE [dbo].[Hiapt06]('
require "$schema" 'CREATE TABLE [dbo].[Hiapt02]('
require "$schema" 'ALTER TABLE [dbo].[Hiapt06] ADD [RowVersion] ROWVERSION NOT NULL;'
require "$schema" '[Doku_Bayar] [nvarchar](20) NULL,'
require "$schema" '[TglDokuBayar] [smalldatetime] NULL,'
require "$seed" 'INSERT INTO POSem'
require "$seed" 'INSERT INTO SubPOSem'
require "$seed" 'INSERT INTO Hiapt06'
require "$seed" 'INSERT INTO Hiapt02'
require "$seed" 'INSERT INTO Supplier (id_supplier,'
require "$seed" 'INSERT INTO Hiapt02 (Doku, Tgl, Kode_Supplier, Doku_Faktur,'
require "$readme" 'POSem / SubPOSem'
require "$readme" 'Hiapt06 / Hiapt02'
require "$context" 'POSem / SubPOSem'
require "$context" 'Hiapt06 / Hiapt02'

table_excludes POSem '[Doku_POSem]'
table_excludes SubPOSem '[Doku_POSem]'

for file in "$schema" "$seed" "$readme" "$context"; do
    forbid "$file" '\b(POConfirmation|SubPOConfirmation|Doku_PCF|id_sub_po_confirmation|Bayar|SubBayar)\b'
done

if (( failures )); then
    exit 1
fi

printf 'Schema naming checks passed.\n'
