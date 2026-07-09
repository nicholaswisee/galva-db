-- Migration 001: Add Doku_PCF linkage to Goods Receipt tables.
--
-- Background:
--   schema.sql already declares Doku_PCF on LPB (header) and SubLPB (line),
--   but SQL Server's /docker-entrypoint-initdb.d runs only on a fresh data
--   volume. Existing developer containers were initialized before this column
--   existed, so the live tables are missing it. This migration adds the
--   columns idempotently to those existing databases.
--
-- Apply with: ./migrate.sh   (or let ./seed.sh / ./seed-from-prod.sh run it)

USE ErpApMockup;
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'LPB'
      AND COLUMN_NAME = 'Doku_PCF'
)
BEGIN
    ALTER TABLE dbo.LPB ADD Doku_PCF NVARCHAR(50) NULL;
    PRINT 'Added LPB.Doku_PCF';
END
ELSE
BEGIN
    PRINT 'LPB.Doku_PCF already exists - skipped';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'SubLPB'
      AND COLUMN_NAME = 'Doku_PCF'
)
BEGIN
    ALTER TABLE dbo.SubLPB ADD Doku_PCF NVARCHAR(50) NULL;
    PRINT 'Added SubLPB.Doku_PCF';
END
ELSE
BEGIN
    PRINT 'SubLPB.Doku_PCF already exists - skipped';
END
GO
