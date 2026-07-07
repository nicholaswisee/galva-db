-- ============================================================
-- Galva ERP — Example Data Query Script
-- Compatible with both the Docker (galva-mssql) and the galva-remote
-- production SQL Server instance (database: XTechnologies2018IN).
--
-- Usage option A — Docker container:
--   docker exec galva-mssql /opt/mssql-tools18/bin/sqlcmd \
--     -S localhost -U sa -P "GalvaDev2026_StrongPwd" -C \
--     -h -1 -W -i /path/to/query.sql
--
-- Usage option B — galva-remote (your real SQL Server, e.g. GTC-SERVER
-- with the XTechnologies2018IN database restored as-is):
--   Open the file in VS Code, pick the "galva-remote" connection in
--   SQLTools, select database XTechnologies2018IN, and execute the whole file
--   (or pick a single section and run with Ctrl+Shift+E).
--
-- The query uses only the most fundamental columns (Doku, Kode, Nama,
-- Doku_SPPB, Doku_LPB, Nilai) common to both the local Docker mockup
-- and the prod XTechnologies2018IN schema. VoucherAP uses TglDoku
-- (prod-faithful) and STS, no Kode_Bank/Status (neither exists in prod).
-- ============================================================

USE XTechnologies2018IN;

-- ----------------------------------------------------
-- Section 0: Database overview — confirm tables and row counts
-- ----------------------------------------------------
PRINT '========== TABLE COUNTS ==========';
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = 'XTechnologies2018IN'
ORDER BY TABLE_NAME;

-- ----------------------------------------------------
-- Section 1: Master Data
-- ----------------------------------------------------

-- 1.1 Suppliers (vendors)
PRINT '========== SUPPLIERS ==========';
SELECT PKbas, Kode, Nama, Kode_Dept, MTU AS Currency, Syarat AS TermsDays,
  NPWP, PKP, Status, Aktif
FROM Supplier
ORDER BY Kode;

-- 1.2 Departments (prod: dbo.Dept, id_dept IDENTITY PK, Kode natural key)
PRINT '========== DEPARTMENTS ==========';
SELECT id_dept, Kode, Nama, KodeGTC, KodeEPK
FROM Dept
ORDER BY Kode;

-- 1.3 Inventory items
PRINT '========== INVENTORY ==========';
SELECT Kode, Nama
FROM Barang
ORDER BY Kode;

-- 1.4 Warehouses
PRINT '========== WAREHOUSES ==========';
SELECT Kode, Nama, Aktif
FROM Gudang
ORDER BY Kode;

-- 1.5 Banks
PRINT '========== BANKS ==========';
SELECT Kode, Nama, Kode_Valas AS Currency
FROM Bank
ORDER BY Kode;

-- 1.6 Supplier groups
PRINT '========== SUPPLIER GROUPS ==========';
SELECT PKbas, Kode, Nama
FROM SupplierGroup
ORDER BY Kode;

-- 1.7 Unit of measure (Satuan)
PRINT '========== UNITS OF MEASURE ==========';
SELECT id_satuan, Kode, Nama
FROM Satuan
ORDER BY Kode;

-- 1.8 Item categories
PRINT '========== CATEGORIES ==========';
SELECT id_category, Kode, Nama
FROM Category
ORDER BY Kode;

-- 1.9 A_MASTER_BARANG (extended inventory)
PRINT '========== A_MASTER_BARANG ==========';
SELECT PKindex, Area, kodelama, nama, kodebaru, KETERANGAN
FROM A_MASTER_BARANG
ORDER BY kodebaru;

-- ----------------------------------------------------
-- Section 2: P2P Transaction Flow — all documents
-- ----------------------------------------------------

-- 2.1 Purchase Requisitions (SPB)
PRINT '========== PURCHASE REQUISITIONS (SPB) ==========';
SELECT id_spb, Doku, Tgl, Kode_Dept, Kode_Customer, Kode_SubCustomer,
  Kode_Sales, NPO, Total, Nilai, GROSS, GRANDTOTAL, PPn, Diskon,
  Sts, Status, Memo
FROM SPB
ORDER BY Tgl DESC, Doku;

-- 2.2 SPB detail lines
PRINT '========== SPB DETAIL LINES ==========';
SELECT s.Doku, s.Tgl, sd.Kode_Brg, b.Nama AS ItemName,
  sd.Jumlah, sd.Harga, sd.Nilai, sd.Kode_Gudang, sd.Alias
FROM SubSPB sd
  INNER JOIN SPB s ON s.Doku = sd.Doku
  LEFT JOIN Barang b ON b.Kode = sd.Kode_Brg
ORDER BY s.Tgl DESC, s.Doku;

-- 2.3 Purchase Orders (PO)
PRINT '========== PURCHASE ORDERS (PO) ==========';
SELECT po.id_po, po.Doku, po.Tgl, po.Kode_Supplier, s.Nama AS SupplierName,
  po.Kode_dept, po.Nilai, po.PPN, po.Diskon, po.STS, po.Memo
FROM PO po
  LEFT JOIN Supplier s ON s.Kode = po.Kode_Supplier
ORDER BY po.Tgl DESC, po.Doku;

-- 2.4 PO detail lines
PRINT '========== PO DETAIL LINES ==========';
SELECT po.Doku, po.Tgl, sp.Kode_Brg, b.Nama AS ItemName,
  sp.Jumlah, sp.Harga, sp.Total, sp.Kode_Gudang, sp.Alias
FROM SubPO sp
  INNER JOIN PO po ON po.Doku = sp.Doku
  LEFT JOIN Barang b ON b.Kode = sp.Kode_Brg
ORDER BY po.Tgl DESC, po.Doku;

-- 2.5 Goods Receipts (LPB)
PRINT '========== GOODS RECEIPTS (LPB) ==========';
SELECT l.id_lpb, l.Doku, l.Tgl, l.Doku_PO, l.Kode_Supplier,
  s.Nama AS SupplierName, l.SuratJalan, l.Nilai,
  l.PPN, l.STS, l.Status, l.Memo
FROM LPB l
  LEFT JOIN Supplier s ON s.Kode = l.Kode_Supplier
ORDER BY l.Tgl DESC, l.Doku;

-- 2.6 LPB detail lines
PRINT '========== LPB DETAIL LINES ==========';
SELECT l.Doku, l.Tgl, sl.Kode_Brg, b.Nama AS ItemName,
  sl.Jumlah, sl.Harga, sl.Nilai, sl.Kode_Gudang
FROM SubLPB sl
  INNER JOIN LPB l ON l.Doku = sl.Doku
  LEFT JOIN Barang b ON b.Kode = sl.Kode_Brg
ORDER BY l.Tgl DESC, l.Doku;

-- 2.7 AP Vouchers (VoucherAP)
PRINT '========== AP VOUCHERS (VoucherAP) ==========';
SELECT v.PKbas, v.Doku, v.TglDoku AS Tgl, v.Kode_Supplier, s.Nama AS SupplierName,
  v.Kode_Dept, v.Nilai, v.PPn, v.Diskon, v.Misc,
  v.STS, v.Keterangan
FROM VoucherAP v
  LEFT JOIN Supplier s ON s.Kode = v.Kode_Supplier
ORDER BY v.TglDoku DESC, v.Doku;

-- 2.8 AP Voucher detail lines
PRINT '========== VOUCHER DETAIL LINES ==========';
SELECT v.Doku, v.TglDoku AS Tgl, sv.Doku_LPB, sv.NilaiLPB, sv.Nilai
FROM SubVoucherAP sv
  INNER JOIN VoucherAP v ON v.Doku = sv.Doku
ORDER BY v.Doku;

-- 2.9 Payments (Bayar)
PRINT '========== PAYMENTS (Bayar) ==========';
SELECT b.PKindex, b.Doku, b.Tgl, b.Kode_Supplier, s.Nama AS SupplierName,
  b.Kode_BankSupplier, b.NilaiKas, b.NilaiGiro, b.NilMuka, b.NilaiAJE,
  b.STS, b.Kode_Valas, b.Kurs
FROM Bayar b
  LEFT JOIN Supplier s ON s.Kode = b.Kode_Supplier
ORDER BY b.Tgl DESC, b.Doku;

-- 2.10 Payment detail lines
PRINT '========== PAYMENT DETAILS ==========';
SELECT b.Doku, sb.Doku_LPB, sb.Kode_Supplier,
  sb.Nilai
FROM SubBayar sb
  INNER JOIN Bayar b ON b.Doku = sb.Doku
ORDER BY b.Doku;

-- ----------------------------------------------------
-- Section 3: Complete P2P Flow — one document per stage
-- ----------------------------------------------------

PRINT '========== FULL P2P FLOW ==========';
  SELECT 'SUPPLIER' AS Stage, Kode AS ID, Nama AS Detail,
    NULL AS Date, NULL AS Amount
  FROM Supplier
  WHERE Aktif = 1
UNION ALL
  SELECT 'PR (SPB)' AS Stage, Doku AS ID, CAST(Kode_Dept AS VARCHAR(100)) AS Detail,
    CONVERT(VARCHAR, Tgl, 23) AS Date, CAST(Total AS VARCHAR(20)) AS Amount
  FROM SPB
UNION ALL
  SELECT 'PO' AS Stage, po.Doku AS ID, ISNULL(s.Nama, po.Kode_Supplier) AS Detail,
    CONVERT(VARCHAR, po.Tgl, 23) AS Date, CAST(po.Nilai AS VARCHAR(20)) AS Amount
  FROM PO po LEFT JOIN Supplier s ON s.Kode = po.Kode_Supplier
UNION ALL
  SELECT 'GR (LPB)' AS Stage, l.Doku AS ID, l.Doku_PO AS Detail,
    CONVERT(VARCHAR, l.Tgl, 23) AS Date, CAST(l.Nilai AS VARCHAR(20)) AS Amount
  FROM LPB l
UNION ALL
  SELECT 'VOUCHER' AS Stage, v.Doku AS ID, ISNULL(s.Nama, v.Kode_Supplier) AS Detail,
    NULL AS Date, CAST(v.Nilai AS VARCHAR(20)) AS Amount
  FROM VoucherAP v LEFT JOIN Supplier s ON s.Kode = v.Kode_Supplier
UNION ALL
  SELECT 'PAYMENT' AS Stage, b.Doku AS ID, ISNULL(s.Nama, b.Kode_Supplier) AS Detail,
    NULL AS Date, CAST((b.NilaiKas + b.NilaiGiro) AS VARCHAR(20)) AS Amount
  FROM Bayar b LEFT JOIN Supplier s ON s.Kode = b.Kode_Supplier
ORDER BY Stage, Date;

-- ----------------------------------------------------
-- Section 4: Open Payables Summary
-- ----------------------------------------------------

PRINT '========== OPEN VOUCHERS BY SUPPLIER ==========';
SELECT v.Kode_Supplier, s.Nama AS SupplierName,
  COUNT(*) AS VoucherCount,
  SUM(v.Nilai) AS TotalNilai,
  SUM(v.Nilai + ISNULL(v.PPn, 0)) AS TotalWithPPn
FROM VoucherAP v
  INNER JOIN Supplier s ON s.Kode = v.Kode_Supplier
WHERE v.STS <> 'Paid'
GROUP BY v.Kode_Supplier, s.Nama
ORDER BY TotalNilai DESC;

-- ----------------------------------------------------
-- Section 5: PR -> PO conversion status
-- ----------------------------------------------------

PRINT '========== PR -> PO STATUS ==========';
SELECT spb.Doku AS PR_Doku, spb.Tgl AS PR_Date, spb.Status AS PR_Status,
  CASE WHEN po.Doku IS NOT NULL THEN 'Converted' ELSE 'Pending' END AS ConversionStatus,
  po.Doku AS PO_Doku, po.Tgl AS PO_Date
FROM SPB spb
  LEFT JOIN PO po ON po.Doku_SPPB = spb.Doku
ORDER BY spb.Tgl DESC;

-- ----------------------------------------------------
-- Section 6: GR qty vs PO qty audit (3-way match)
-- ----------------------------------------------------

PRINT '========== GR QTY vs PO QTY (per item) ==========';
SELECT po.Doku AS PO_Doku,
  sp.Kode_Brg,
  sp.Jumlah AS PO_Qty,
  ISNULL(gr_agg.GR_Qty, 0) AS GR_Qty,
  sp.Jumlah - ISNULL(gr_agg.GR_Qty, 0) AS Outstanding_Qty
FROM SubPO sp
  INNER JOIN PO po ON po.Doku = sp.Doku
  LEFT JOIN (
    SELECT sl.Doku_PO, sl.Kode_Brg, SUM(sl.Jumlah) AS GR_Qty
  FROM SubLPB sl
  GROUP BY sl.Doku_PO, sl.Kode_Brg
) gr_agg ON gr_agg.Doku_PO = sp.Doku AND gr_agg.Kode_Brg = sp.Kode_Brg
WHERE po.STS <> '0'
ORDER BY po.Doku, sp.Kode_Brg;
