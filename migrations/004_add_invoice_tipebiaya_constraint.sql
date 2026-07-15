-- Migration 004: Enforce TipeBiaya discriminator on AP invoice tables.
--
-- Background:
--   VoucherAP / SubVoucherAP store both GR-based (LPB) and PO-based (PO)
--   invoices. Production XTechnologies2018IN differentiates them via
--   TipeBiaya = 'LPB' or 'PO'. This migration enforces that rule locally
--   and aligns SubVoucherAP.TipeBiaya width with production (nvarchar(10)).
--
-- Apply with: ./migrate.sh   (or let ./seed.sh / ./seed-from-prod.sh run it)

USE ErpApMockup;
GO

-- Align SubVoucherAP.TipeBiaya width with production (10 chars is enough
-- for 'LPB' / 'PO' and matches VoucherAP.TipeBiaya).
IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'SubVoucherAP'
      AND COLUMN_NAME = 'TipeBiaya'
      AND CHARACTER_MAXIMUM_LENGTH > 10
)
BEGIN
    ALTER TABLE dbo.[SubVoucherAP] ALTER COLUMN [TipeBiaya] NVARCHAR(10) NULL;
    PRINT 'Narrowed SubVoucherAP.TipeBiaya to NVARCHAR(10)';
END
ELSE
BEGIN
    PRINT 'SubVoucherAP.TipeBiaya width already <= 10 - skipped';
END
GO

-- Restrict VoucherAP.TipeBiaya to the two known invoice sources.
-- NULL is allowed for legacy rows until they are backfilled or re-created.
IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'VoucherAP'
      AND CONSTRAINT_NAME = 'CK_VoucherAP_TipeBiaya'
)
BEGIN
    ALTER TABLE dbo.[VoucherAP]
        ADD CONSTRAINT [CK_VoucherAP_TipeBiaya]
        CHECK ([TipeBiaya] IS NULL OR [TipeBiaya] IN ('LPB', 'PO'));
    PRINT 'Added CK_VoucherAP_TipeBiaya';
END
ELSE
BEGIN
    PRINT 'CK_VoucherAP_TipeBiaya already exists - skipped';
END
GO

-- Restrict SubVoucherAP.TipeBiaya to the two known invoice sources.
IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'SubVoucherAP'
      AND CONSTRAINT_NAME = 'CK_SubVoucherAP_TipeBiaya'
)
BEGIN
    ALTER TABLE dbo.[SubVoucherAP]
        ADD CONSTRAINT [CK_SubVoucherAP_TipeBiaya]
        CHECK ([TipeBiaya] IS NULL OR [TipeBiaya] IN ('LPB', 'PO'));
    PRINT 'Added CK_SubVoucherAP_TipeBiaya';
END
ELSE
BEGIN
    PRINT 'CK_SubVoucherAP_TipeBiaya already exists - skipped';
END
GO

-- Index to speed up list queries filtered by invoice source.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.VoucherAP')
      AND name = N'IX_VoucherAP_TipeBiaya_Doku'
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_VoucherAP_TipeBiaya_Doku]
        ON dbo.[VoucherAP] ([TipeBiaya], [Doku]);
    PRINT 'Added IX_VoucherAP_TipeBiaya_Doku';
END
ELSE
BEGIN
    PRINT 'IX_VoucherAP_TipeBiaya_Doku already exists - skipped';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.SubVoucherAP')
      AND name = N'IX_SubVoucherAP_TipeBiaya_Doku'
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_SubVoucherAP_TipeBiaya_Doku]
        ON dbo.[SubVoucherAP] ([TipeBiaya], [Doku]);
    PRINT 'Added IX_SubVoucherAP_TipeBiaya_Doku';
END
ELSE
BEGIN
    PRINT 'IX_SubVoucherAP_TipeBiaya_Doku already exists - skipped';
END
GO
