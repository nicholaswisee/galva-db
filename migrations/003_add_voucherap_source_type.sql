-- Migration 003: Add SourceType discriminator to VoucherAP tables.
--
-- Background:
--   GR-based and PO-Confirm-based AP invoices currently share the same
--   VoucherAP / SubVoucherAP tables with no explicit source discriminator.
--   This migration adds a SourceType column so the two invoice kinds can be
--   queried and validated separately.
--
-- Apply with: ./migrate.sh   (or let ./seed.sh / ./seed-from-prod.sh run it)

USE ErpApMockup;
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'VoucherAP'
      AND COLUMN_NAME = 'SourceType'
)
BEGIN
    ALTER TABLE dbo.[VoucherAP] ADD [SourceType] NVARCHAR(20) NULL;
    PRINT 'Added VoucherAP.SourceType';
END
ELSE
BEGIN
    PRINT 'VoucherAP.SourceType already exists - skipped';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'SubVoucherAP'
      AND COLUMN_NAME = 'SourceType'
)
BEGIN
    ALTER TABLE dbo.[SubVoucherAP] ADD [SourceType] NVARCHAR(20) NULL;
    PRINT 'Added SubVoucherAP.SourceType';
END
ELSE
BEGIN
    PRINT 'SubVoucherAP.SourceType already exists - skipped';
END
GO
