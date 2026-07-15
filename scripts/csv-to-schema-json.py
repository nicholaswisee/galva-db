"""Convert a CSV dump of INFORMATION_SCHEMA.COLUMNS into the JSON format
expected by introspect-prod-schema.py --prod-schema-json.

Use this when production is not reachable from the development environment.
Export the CSV from a machine with access to GTC-SERVER:

    sqlcmd -S GTC-SERVER -U remote9 -P 'Remote!@#123' -d XTechnologies2018IN \
           -h -1 -W -Q "
    SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
           NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION, IS_NULLABLE,
           ORDINAL_POSITION
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME IN ('VoucherAP','SubVoucherAP')
    ORDER BY TABLE_NAME, ORDINAL_POSITION
    " -o prod-schema.csv -s ','

Then run:

    python3 scripts/csv-to-schema-json.py prod-schema.csv prod-schema.json
    python3 scripts/introspect-prod-schema.py --prod-schema-json prod-schema.json
"""

from __future__ import annotations

import argparse
import csv
import json
import sys
from pathlib import Path
from typing import Any


def parse_int(value: str) -> int | None:
    value = value.strip()
    if value == "" or value.lower() == "null":
        return None
    try:
        return int(value)
    except ValueError:
        return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("csv", type=Path)
    ap.add_argument("output", type=Path)
    args = ap.parse_args()

    tables: dict[str, list[dict[str, Any]]] = {}
    with args.csv.open(encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            table = row["TABLE_NAME"].strip()
            tables.setdefault(table, []).append(
                {
                    "table_name": table,
                    "column_name": row["COLUMN_NAME"].strip(),
                    "data_type": row["DATA_TYPE"].strip().lower(),
                    "max_length": parse_int(row.get("CHARACTER_MAXIMUM_LENGTH", "")) or 0,
                    "numeric_precision": parse_int(row.get("NUMERIC_PRECISION", "")),
                    "numeric_scale": parse_int(row.get("NUMERIC_SCALE", "")),
                    "datetime_precision": parse_int(row.get("DATETIME_PRECISION", "")),
                    "is_nullable": row.get("IS_NULLABLE", "YES").strip(),
                    "ordinal_position": parse_int(row.get("ORDINAL_POSITION", "0")) or 0,
                }
            )

    for cols in tables.values():
        cols.sort(key=lambda c: c["ordinal_position"])

    args.output.write_text(json.dumps(tables, indent=2), encoding="utf-8")
    print(f"Wrote {args.output} with tables: {', '.join(tables)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
