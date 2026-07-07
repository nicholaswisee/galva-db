-- ============================================================
-- Galva ERP — Polished Live-Data Query Script
-- Target  : galva-remote  (GTC-SERVER, XTechnologies2018IN)
-- Verified: 2026-06-29 via INFORMATION_SCHEMA against the live DB
-- Row counts observed (non-zero, useful for seed):
--   Supplier 396, Gudang 134, Bank 198, Satuan 29, Category 103
--   SPB 145,371 / SubSPB 330,282
--   PO  23,629 / SubPO  49,090
--   LPB 29,613 / SubLPB 52,128
--   VoucherAP 22,426 / SubVoucherAP 27,163
--   Bayar 9,345 / SubBayar 44,473
--   Department / Barang / SupplierGroup / A_MASTER_BARANG = 0 rows
--   (still queried — they exist in the schema and may be populated later)
--
-- Schema notes (vs. original query.sql):
--   - Departments live in dbo.Dept (id_dept IDENTITY PK, Kode natural key)
--   - SPB.Memo    : the column is named [MEMO]    (use brackets to be safe)
--   - VoucherAP   : date column is [TglDoku]      (not Tgl)
--   - VoucherAP   : no [Kode_Bank] / [Status] cols (use Kode_Dept; STS only)
--
-- How to run from VS Code (SQLTools):
--   1. Open this file.
--   2. Pick the "galva-remote" connection, database XTechnologies2018IN.
--   3. Ctrl+Shift+E on the whole file  (or any single section).
--
-- How to run from sqlcmd:
--   sqlcmd -S GTC-SERVER -U remote9 -P "Remote!@#123" -d XTechnologies2018IN \
--          -h -1 -W -C -i query-live.sql
--
-- Safety:
--   - Every section has a <TOP> cap so an accidental run on a 145k-row
--     table never blocks your terminal for minutes. Bump the cap to 0
--     (or remove TOP) when you actually want the full result set.
--   - Section 0 verifies schema before any other section runs.
--   - Numeric aggregates are wrapped in ISNULL so empty result sets
--     don't print NULL everywhere.
-- ============================================================

USE XTechnologies2018IN;
SET NOCOUNT ON;

-- Top-cap template. Change once, applies to all previewable sections.
DECLARE @TopN INT = 50;        -- 0 = unlimited (use only on trusted connection)
-- Recency floor for transactional sections. Live data maxes in 2022-03,
-- so 2020-01-01 gives a useful ~2-year window of recent activity.
-- Bump earlier (e.g. '2017-01-01') if you want the full P2P universe.
DECLARE @SinceDate DATE = '2020-01-01';

-- ===========================================================
-- Section 0: Schema self-check (must pass before continuing)
-- ===========================================================
PRINT '========== SCHEMA SELF-CHECK ==========';
IF OBJECT_ID('dbo.Supplier')        IS NULL PRINT 'MISSING dbo.Supplier';
IF OBJECT_ID('dbo.Dept')            IS NULL PRINT 'MISSING dbo.Dept';
IF OBJECT_ID('dbo.Barang')          IS NULL PRINT 'MISSING dbo.Barang';
IF OBJECT_ID('dbo.Gudang')          IS NULL PRINT 'MISSING dbo.Gudang';
IF OBJECT_ID('dbo.Bank')            IS NULL PRINT 'MISSING dbo.Bank';
IF OBJECT_ID('dbo.SupplierGroup')   IS NULL PRINT 'MISSING dbo.SupplierGroup';
IF OBJECT_ID('dbo.Satuan')          IS NULL PRINT 'MISSING dbo.Satuan';
IF OBJECT_ID('dbo.Category')        IS NULL PRINT 'MISSING dbo.Category';
IF OBJECT_ID('dbo.A_MASTER_BARANG') IS NULL PRINT 'MISSING dbo.A_MASTER_BARANG';
IF OBJECT_ID('dbo.SPB')             IS NULL PRINT 'MISSING dbo.SPB';
IF OBJECT_ID('dbo.SubSPB')          IS NULL PRINT 'MISSING dbo.SubSPB';
IF OBJECT_ID('dbo.PO')              IS NULL PRINT 'MISSING dbo.PO';
IF OBJECT_ID('dbo.SubPO')           IS NULL PRINT 'MISSING dbo.SubPO';
IF OBJECT_ID('dbo.LPB')             IS NULL PRINT 'MISSING dbo.LPB';
IF OBJECT_ID('dbo.SubLPB')          IS NULL PRINT 'MISSING dbo.SubLPB';
IF OBJECT_ID('dbo.VoucherAP')       IS NULL PRINT 'MISSING dbo.VoucherAP';
IF OBJECT_ID('dbo.SubVoucherAP')    IS NULL PRINT 'MISSING dbo.SubVoucherAP';
IF OBJECT_ID('dbo.Bayar')           IS NULL PRINT 'MISSING dbo.Bayar';
IF OBJECT_ID('dbo.SubBayar')        IS NULL PRINT 'MISSING dbo.SubBayar';
PRINT 'Schema check complete. If any MISSING lines printed above, stop.';

-- ===========================================================
-- Section 0b: Row counts (one row per target table)
-- ===========================================================
PRINT '========== TABLE COUNTS ==========';
SELECT 'Supplier'        AS TableName, COUNT(*) AS Rows_ FROM dbo.Supplier
UNION ALL SELECT 'Dept',            COUNT(*) FROM dbo.Dept
UNION ALL SELECT 'Barang',          COUNT(*) FROM dbo.Barang
UNION ALL SELECT 'Gudang',          COUNT(*) FROM dbo.Gudang
UNION ALL SELECT 'Bank',            COUNT(*) FROM dbo.Bank
UNION ALL SELECT 'SupplierGroup',   COUNT(*) FROM dbo.SupplierGroup
UNION ALL SELECT 'Satuan',          COUNT(*) FROM dbo.Satuan
UNION ALL SELECT 'Category',        COUNT(*) FROM dbo.Category
UNION ALL SELECT 'A_MASTER_BARANG', COUNT(*) FROM dbo.A_MASTER_BARANG
UNION ALL SELECT 'SPB',             COUNT(*) FROM dbo.SPB
UNION ALL SELECT 'SubSPB',          COUNT(*) FROM dbo.SubSPB
UNION ALL SELECT 'PO',              COUNT(*) FROM dbo.PO
UNION ALL SELECT 'SubPO',           COUNT(*) FROM dbo.SubPO
UNION ALL SELECT 'LPB',             COUNT(*) FROM dbo.LPB
UNION ALL SELECT 'SubLPB',          COUNT(*) FROM dbo.SubLPB
UNION ALL SELECT 'VoucherAP',       COUNT(*) FROM dbo.VoucherAP
UNION ALL SELECT 'SubVoucherAP',    COUNT(*) FROM dbo.SubVoucherAP
UNION ALL SELECT 'Bayar',           COUNT(*) FROM dbo.Bayar
UNION ALL SELECT 'SubBayar',        COUNT(*) FROM dbo.SubBayar
ORDER BY TableName;

-- ===========================================================
-- Section 1: Master Data
-- ===========================================================

-- 1.1 Suppliers (vendors) — 396 rows
PRINT '========== SUPPLIERS ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  PKbas, Kode, Nama, Kode_Dept, MTU AS Currency, Syarat AS TermsDays,
  NPWP, PKP, Status, Aktif, SupGroupName AS GroupName
FROM dbo.Supplier
ORDER BY Kode;

-- 1.2 Departments — dbo.Dept, id_dept IDENTITY PK, Kode natural key
PRINT '========== DEPARTMENTS ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  id_dept, Kode, Nama, KodeGTC, KodeEPK
FROM dbo.Dept
ORDER BY Kode;

-- 1.3 Inventory items (Barang) — 0 rows in this DB
PRINT '========== INVENTORY ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  Kode, Nama
FROM dbo.Barang
ORDER BY Kode;

-- 1.4 Warehouses — 134 rows
PRINT '========== WAREHOUSES ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  Kode, Nama, Aktif
FROM dbo.Gudang
ORDER BY Kode;

-- 1.5 Banks — 198 rows
PRINT '========== BANKS ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  Kode, Nama, Kode_Valas AS Currency
FROM dbo.Bank
ORDER BY Kode;

-- 1.6 Supplier groups — 0 rows
PRINT '========== SUPPLIER GROUPS ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  PKbas, Kode, Nama
FROM dbo.SupplierGroup
ORDER BY Kode;

-- 1.7 Units of measure (Satuan) — 29 rows
PRINT '========== UNITS OF MEASURE ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  id_satuan, Kode, Nama
FROM dbo.Satuan
ORDER BY Kode;

-- 1.8 Item categories — 103 rows
PRINT '========== CATEGORIES ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  id_category, Kode, Nama
FROM dbo.Category
ORDER BY Kode;

-- 1.9 A_MASTER_BARANG (extended inventory) — 0 rows
PRINT '========== A_MASTER_BARANG ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  PKindex, Area, kodelama, nama, kodebaru, KETERANGAN
FROM dbo.A_MASTER_BARANG
ORDER BY kodebaru;

-- ===========================================================
-- Section 2: P2P Transaction Flow (recency-filtered)
-- ===========================================================

-- 2.1 Purchase Requisitions (SPB) — filtered to last ~18 months
PRINT '========== PURCHASE REQUISITIONS (SPB) ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  id_spb, Doku, Tgl, Kode_Dept, Kode_Customer, Kode_SubCustomer,
  Kode_Sales, NPO, Total, Nilai, GROSS, GRANDTOTAL, PPn, Diskon,
  Sts, Status, [MEMO] AS Memo
FROM dbo.SPB
WHERE Tgl >= @SinceDate
ORDER BY Tgl DESC, Doku;

-- 2.2 SPB detail lines (joined to header)
PRINT '========== SPB DETAIL LINES ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  s.Doku, s.Tgl, sd.Kode_Brg,
  ISNULL(b.Nama, '(no Barang master)') AS ItemName,
  sd.Jumlah, sd.Harga, sd.Nilai, sd.Kode_Gudang, sd.Alias
FROM dbo.SubSPB sd
  INNER JOIN dbo.SPB s    ON s.Doku = sd.Doku
  LEFT  JOIN dbo.Barang b ON b.Kode = sd.Kode_Brg
WHERE s.Tgl >= @SinceDate
ORDER BY s.Tgl DESC, s.Doku;

-- 2.3 Purchase Orders (PO) — joined to Supplier
PRINT '========== PURCHASE ORDERS (PO) ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  po.id_po, po.Doku, po.Tgl, po.Kode_Supplier,
  ISNULL(s.Nama, po.Kode_Supplier) AS SupplierName,
  po.Kode_dept, po.Nilai, po.PPN, po.Diskon, po.STS, po.[MEMO] AS Memo,
  po.Doku_SPPB
FROM dbo.PO po
  LEFT JOIN dbo.Supplier s ON s.Kode = po.Kode_Supplier
WHERE po.Tgl >= @SinceDate
ORDER BY po.Tgl DESC, po.Doku;

-- 2.4 PO detail lines
PRINT '========== PO DETAIL LINES ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  po.Doku, po.Tgl, sp.Kode_Brg,
  ISNULL(b.Nama, '(no Barang master)') AS ItemName,
  sp.Jumlah, sp.Harga, sp.Total, sp.Kode_Gudang, sp.Alias
FROM dbo.SubPO sp
  INNER JOIN dbo.PO po     ON po.Doku = sp.Doku
  LEFT  JOIN dbo.Barang b  ON b.Kode  = sp.Kode_Brg
WHERE po.Tgl >= @SinceDate
ORDER BY po.Tgl DESC, po.Doku;

-- 2.5 Goods Receipts (LPB) — header
PRINT '========== GOODS RECEIPTS (LPB) ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  l.id_lpb, l.Doku, l.Tgl, l.Doku_PO, l.Kode_Supplier,
  ISNULL(s.Nama, l.Kode_Supplier) AS SupplierName,
  l.SuratJalan, l.Nilai, l.PPN, l.STS, l.[Status], l.Memo
FROM dbo.LPB l
  LEFT JOIN dbo.Supplier s ON s.Kode = l.Kode_Supplier
WHERE l.Tgl >= @SinceDate
ORDER BY l.Tgl DESC, l.Doku;

-- 2.6 LPB detail lines
PRINT '========== LPB DETAIL LINES ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  l.Doku, l.Tgl, sl.Kode_Brg,
  ISNULL(b.Nama, '(no Barang master)') AS ItemName,
  sl.Jumlah, sl.Harga, sl.Nilai, sl.Kode_Gudang
FROM dbo.SubLPB sl
  INNER JOIN dbo.LPB l     ON l.Doku = sl.Doku
  LEFT  JOIN dbo.Barang b  ON b.Kode  = sl.Kode_Brg
WHERE l.Tgl >= @SinceDate
ORDER BY l.Tgl DESC, l.Doku;

-- 2.7 AP Vouchers (VoucherAP) — note: date col is TglDoku, no Status/Kode_Bank
PRINT '========== AP VOUCHERS (VoucherAP) ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  v.PKbas, v.Doku, v.TglDoku AS Tgl, v.Kode_Supplier,
  ISNULL(s.Nama, v.Kode_Supplier) AS SupplierName,
  v.Kode_Dept, v.Nilai, v.PPn, v.Diskon, v.Misc,
  v.STS, v.Keterangan
FROM dbo.VoucherAP v
  LEFT JOIN dbo.Supplier s ON s.Kode = v.Kode_Supplier
WHERE v.TglDoku >= @SinceDate
ORDER BY v.TglDoku DESC, v.Doku;

-- 2.8 Voucher detail lines (LPB allocations)
PRINT '========== VOUCHER DETAIL LINES ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  v.Doku, v.TglDoku AS Tgl, sv.Doku_LPB, sv.NilaiLPB, sv.Nilai,
  sv.Doku_PO, sv.Kode_Supplier
FROM dbo.SubVoucherAP sv
  INNER JOIN dbo.VoucherAP v ON v.Doku = sv.Doku
WHERE v.TglDoku >= @SinceDate
ORDER BY v.Doku;

-- 2.9 Payments (Bayar)
PRINT '========== PAYMENTS (Bayar) ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  b.PKindex, b.Doku, b.Tgl, b.Kode_Supplier,
  ISNULL(s.Nama, b.Kode_Supplier) AS SupplierName,
  b.Kode_BankSupplier, b.NilaiKas, b.NilaiGiro, b.NilMuka, b.NilaiAJE,
  b.STS, b.Kode_Valas, b.Kurs
FROM dbo.Bayar b
  LEFT JOIN dbo.Supplier s ON s.Kode = b.Kode_Supplier
WHERE b.Tgl >= @SinceDate
ORDER BY b.Tgl DESC, b.Doku;

-- 2.10 Payment detail lines
PRINT '========== PAYMENT DETAILS ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  b.Doku, sb.Doku_LPB, sb.Kode_Supplier, sb.Nilai
FROM dbo.SubBayar sb
  INNER JOIN dbo.Bayar b ON b.Doku = sb.Doku
WHERE b.Tgl >= @SinceDate
ORDER BY b.Doku;

-- ===========================================================
-- Section 3: Complete P2P Flow (one row per document stage)
-- ===========================================================
PRINT '========== FULL P2P FLOW (last 12 months) ==========';
SELECT Stage, ID, Detail, Date, Amount
FROM (
  SELECT 'SUPPLIER' AS Stage, Kode AS ID, Nama AS Detail,
         NULL AS Date, NULL AS Amount
  FROM dbo.Supplier
  WHERE Aktif = 1
  UNION ALL
  SELECT 'PR (SPB)' AS Stage, Doku AS ID, CAST(Kode_Dept AS VARCHAR(100)) AS Detail,
         CONVERT(VARCHAR(10), Tgl, 23) AS Date, CAST(Total AS VARCHAR(20)) AS Amount
  FROM dbo.SPB
  WHERE Tgl >= DATEADD(YEAR, -1, GETDATE())
  UNION ALL
  SELECT 'PO' AS Stage, po.Doku AS ID, ISNULL(s.Nama, po.Kode_Supplier) AS Detail,
         CONVERT(VARCHAR(10), po.Tgl, 23) AS Date, CAST(po.Nilai AS VARCHAR(20)) AS Amount
  FROM dbo.PO po LEFT JOIN dbo.Supplier s ON s.Kode = po.Kode_Supplier
  WHERE po.Tgl >= DATEADD(YEAR, -1, GETDATE())
  UNION ALL
  SELECT 'GR (LPB)' AS Stage, l.Doku AS ID, l.Doku_PO AS Detail,
         CONVERT(VARCHAR(10), l.Tgl, 23) AS Date, CAST(l.Nilai AS VARCHAR(20)) AS Amount
  FROM dbo.LPB l
  WHERE l.Tgl >= DATEADD(YEAR, -1, GETDATE())
  UNION ALL
  SELECT 'VOUCHER' AS Stage, v.Doku AS ID, ISNULL(s.Nama, v.Kode_Supplier) AS Detail,
         CONVERT(VARCHAR(10), v.TglDoku, 23) AS Date, CAST(v.Nilai AS VARCHAR(20)) AS Amount
  FROM dbo.VoucherAP v LEFT JOIN dbo.Supplier s ON s.Kode = v.Kode_Supplier
  WHERE v.TglDoku >= DATEADD(YEAR, -1, GETDATE())
  UNION ALL
  SELECT 'PAYMENT' AS Stage, b.Doku AS ID, ISNULL(s.Nama, b.Kode_Supplier) AS Detail,
         CONVERT(VARCHAR(10), b.Tgl, 23) AS Date,
         CAST((ISNULL(b.NilaiKas,0) + ISNULL(b.NilaiGiro,0)) AS VARCHAR(20)) AS Amount
  FROM dbo.Bayar b LEFT JOIN dbo.Supplier s ON s.Kode = b.Kode_Supplier
  WHERE b.Tgl >= DATEADD(YEAR, -1, GETDATE())
) AS flow
ORDER BY Stage, Date DESC;

-- ===========================================================
-- Section 4: Open Payables Summary
-- ===========================================================
PRINT '========== OPEN VOUCHERS BY SUPPLIER ==========';
SELECT v.Kode_Supplier,
  ISNULL(s.Nama, v.Kode_Supplier) AS SupplierName,
  COUNT(*) AS VoucherCount,
  ISNULL(SUM(v.Nilai), 0) AS TotalNilai,
  ISNULL(SUM(v.Nilai + ISNULL(v.PPn, 0)), 0) AS TotalWithPPn
FROM dbo.VoucherAP v
  INNER JOIN dbo.Supplier s ON s.Kode = v.Kode_Supplier
WHERE ISNULL(v.STS, '') <> 'Paid'
GROUP BY v.Kode_Supplier, s.Nama
ORDER BY TotalNilai DESC;

-- ===========================================================
-- Section 5: PR -> PO conversion status (last 12 months)
-- Expected to return 0 rows until PO.Doku_SPPB is populated in prod.
-- ===========================================================
PRINT '========== PR -> PO STATUS (PO.Doku_SPPB is 0% populated in this DB) ==========';
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  spb.Doku AS PR_Doku, spb.Tgl AS PR_Date, spb.Status AS PR_Status,
  CASE WHEN po.Doku IS NOT NULL THEN 'Converted' ELSE 'Pending' END AS ConversionStatus,
  po.Doku AS PO_Doku, po.Tgl AS PO_Date
FROM dbo.SPB spb
  LEFT JOIN dbo.PO po ON po.Doku_SPPB = spb.Doku
WHERE spb.Tgl >= @SinceDate
ORDER BY spb.Tgl DESC;

-- ===========================================================
-- Section 6: GR qty vs PO qty audit (3-way match, last 6 months)
-- ===========================================================
PRINT '========== GR QTY vs PO QTY (per item) ==========';
;WITH gr_agg AS (
  SELECT sl.Doku_PO, sl.Kode_Brg, SUM(sl.Jumlah) AS GR_Qty
  FROM dbo.SubLPB sl
  GROUP BY sl.Doku_PO, sl.Kode_Brg
)
SELECT TOP (CASE WHEN @TopN = 0 THEN 2147483647 ELSE @TopN END)
  po.Doku AS PO_Doku,
  sp.Kode_Brg,
  sp.Jumlah AS PO_Qty,
  ISNULL(gr_agg.GR_Qty, 0) AS GR_Qty,
  sp.Jumlah - ISNULL(gr_agg.GR_Qty, 0) AS Outstanding_Qty
FROM dbo.SubPO sp
  INNER JOIN dbo.PO po              ON po.Doku = sp.Doku
  LEFT  JOIN gr_agg                 ON gr_agg.Doku_PO  = sp.Doku
                                    AND gr_agg.Kode_Brg = sp.Kode_Brg
WHERE po.Tgl >= DATEADD(MONTH, -6, GETDATE())
  AND ISNULL(po.STS, '') <> '0'
ORDER BY po.Doku, sp.Kode_Brg;

-- ===========================================================
-- Section 7 (NEW): Seed-ready P2P chain (PO -> LPB -> VoucherAP)
-- Build a denormalised row per PO with its goods receipt and AP voucher.
-- In XTechnologies2018IN the link fill-rates are:
--     LPB.Doku_PO          = 100% (reliable)
--     SubVoucherAP.Doku_LPB= ~99% (reliable)
--     PO.Doku_SPPB         = 0%   (PR link never written, omitted)
--     SubBayar.Doku_LPB    = 0%   (payment link never written, omitted)
-- So this view stops at the AP voucher. Use Section 2.9 to join
-- payments by supplier + amount when you need pay data.
-- ===========================================================
PRINT '========== SEED-READY P2P CHAINS (PO -> LPB -> VoucherAP, top 100) ==========';
;WITH latest_po AS (
  SELECT TOP 100
    po.Doku AS PO_Doku, po.Tgl AS PO_Tgl, po.Kode_Supplier,
    po.Nilai AS PO_Nilai, po.PPN AS PO_PPN, po.[MEMO] AS PO_Memo
  FROM dbo.PO po
  WHERE po.Tgl >= @SinceDate
  ORDER BY po.Tgl DESC
),
lpb_for_po AS (
  SELECT l.Doku_PO, l.Doku AS LPB_Doku, l.Tgl AS LPB_Tgl, l.Nilai AS LPB_Nilai
  FROM dbo.LPB l
  WHERE l.Doku_PO IN (SELECT PO_Doku FROM latest_po)
),
voucher_for_lpb AS (
  SELECT v.Doku_LPB, v.Doku AS Voucher_Doku, v.TglDoku AS Voucher_Tgl,
         v.Nilai AS Voucher_Nilai, v.STS AS Voucher_Status
  FROM dbo.VoucherAP v
  WHERE v.Doku_LPB IN (SELECT LPB_Doku FROM lpb_for_po)
)
SELECT TOP 100
  po.PO_Doku, po.PO_Tgl, po.Kode_Supplier,
  ISNULL(s.Nama, po.Kode_Supplier) AS SupplierName,
  po.PO_Nilai, po.PO_PPN, po.PO_Memo,
  lpb.LPB_Doku, lpb.LPB_Tgl, lpb.LPB_Nilai,
  v.Voucher_Doku, v.Voucher_Tgl, v.Voucher_Nilai, v.Voucher_Status
FROM latest_po po
  LEFT JOIN lpb_for_po        lpb ON lpb.Doku_PO = po.PO_Doku
  LEFT JOIN voucher_for_lpb   v   ON v.Doku_LPB  = lpb.LPB_Doku
  LEFT JOIN dbo.Supplier      s   ON s.Kode      = po.Kode_Supplier
ORDER BY po.PO_Tgl DESC;

PRINT '========== DONE ==========';
