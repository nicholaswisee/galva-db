-- ============================================================
-- Galva ERP — Comprehensive Synthetic Seed Data
-- Run after schema.sql to populate all modules with demo data
-- ============================================================

USE ErpApMockup;
GO

-- Clear existing synthetic data (keep real prod extracts if any)
DELETE FROM SubBayar;
DELETE FROM Bayar;
DELETE FROM SubVoucherAP;
DELETE FROM VoucherAP;
DELETE FROM SubLPB;
DELETE FROM LPB;
DELETE FROM SubPO;
DELETE FROM PO;
DELETE FROM SubSPB;
DELETE FROM SPB;
DELETE FROM SaldoAP;
DELETE FROM APMuka;
DELETE FROM Barang;
DELETE FROM Gudang;
DELETE FROM Bank;
DELETE FROM Supplier;
DELETE FROM Dept;
DELETE FROM Category;
DELETE FROM Satuan;
DELETE FROM SupplierGroup;
GO

-- ============================================================
-- 1. MASTER DATA
-- ============================================================

INSERT INTO Dept (Kode, Nama) VALUES
('100', 'IT Department'),
('200', 'Operations'),
('300', 'Finance'),
('400', 'Procurement'),
('500', 'Warehouse'),
('600', 'Sales'),
('700', 'HRD');

SET IDENTITY_INSERT Supplier ON;
INSERT INTO Supplier (PKbas, Kode, Nama, Kode_Dept, Alamat1, Kota, NPWP, PKP, Syarat, MTU, Aktif, Status, SupGroupName, Email) VALUES
(1, 'TLA0030', 'PT ADAKOM INTERNATIONAL TECHNOLOGY', '400', 'PERKANTORAN CBD PLUIT BLOK S-8 LT 3', 'JAKARTA UTARA 14440', '027919315044000', 'PKP', 30, 'Rp.', 1, 'A', 'Electronics', 'adakom@example.com'),
(2, 'TLE0005', 'PT ELSISCOM PRIMA KARYA', '400', 'GALVA BUILDING 4TH FLOOR', 'JAKARTA', '01.402.120.8-073.000', 'PKP', 90, 'Rp.', 1, 'A', 'Services', 'elsiscom@example.com'),
(3, 'TLS0006', 'SL SOLUTION', '400', 'KAMAL RAYA CITY RESORT CENGKARENG', 'JAKARTA', '', 'Non-PKP', 7, 'Rp.', 1, 'A', 'Software', 'slsolution@example.com'),
(4, 'TLT0002', 'PT TOA GALVA PRIMA KARYA', '400', 'JL. HAYAM WURUK 26 JAKARTA PUSAT', 'JAKARTA', '02.491.716.3-074.000', 'PKP', 120, 'Rp.', 1, 'A', 'Audio', 'toagalva@example.com'),
(5, 'TLT0014', 'TOKOPEDIA', '400', 'JL. PROF. DR. SATRIO KAV. 11', 'JAKARTA', '', 'PKP', 0, 'Rp.', 1, 'A', 'Marketplace', 'tokopedia@example.com'),
(6, 'TLC0001', 'PT CANON INDONESIA', '400', 'JL. TOMANG RAYA NO. 39', 'JAKARTA', '01.234.567.8-123.000', 'PKP', 30, 'Rp.', 1, 'A', 'Electronics', 'canon@example.com'),
(7, 'TLH0001', 'PT HP INDONESIA', '400', 'JL. M.H. THAMRIN KAV. 10', 'JAKARTA', '02.345.678.9-234.000', 'PKP', 30, 'Rp.', 1, 'A', 'Electronics', 'hp@example.com'),
(8, 'TLS0001', 'PT SAMSUNG ELECTRONICS', '400', 'JL. JEND. SUDIRMAN KAV. 52-53', 'JAKARTA', '03.456.789.0-345.000', 'PKP', 30, 'Rp.', 1, 'A', 'Electronics', 'samsung@example.com'),
(9, 'TLP0001', 'PT PANASONIC GOBEL', '400', 'JL. MT. HARYONO KAV. 16', 'JAKARTA', '04.567.890.1-456.000', 'PKP', 45, 'Rp.', 1, 'A', 'Electronics', 'panasonic@example.com'),
(10, 'TLX0001', 'PT XEROX INDONESIA', '400', 'JL. GATOT SUBROTO KAV. 36-38', 'JAKARTA', '05.678.901.2-567.000', 'PKP', 30, 'Rp.', 1, 'A', 'Electronics', 'xerox@example.com');
SET IDENTITY_INSERT Supplier OFF;

SET IDENTITY_INSERT Bank ON;
INSERT INTO Bank (PKindex, Kode, Nama, Kode_Valas, AC, AN, Alamat1, Kota) VALUES
(1, 'BCA', 'Bank Central Asia', 'IDR', '1234567890', 'PT GALVA PRIMA KARYA', 'JL. SUDIRMAN', 'JAKARTA'),
(2, 'MANDIRI', 'Bank Mandiri', 'IDR', '0987654321', 'PT GALVA PRIMA KARYA', 'JL. THAMRIN', 'JAKARTA'),
(3, 'BNI', 'Bank Negara Indonesia', 'IDR', '1122334455', 'PT GALVA PRIMA KARYA', 'JL. GATOT SUBROTO', 'JAKARTA'),
(4, 'BRI', 'Bank Rakyat Indonesia', 'IDR', '5566778899', 'PT GALVA PRIMA KARYA', 'JL. MH THAMRIN', 'JAKARTA');
SET IDENTITY_INSERT Bank OFF;

SET IDENTITY_INSERT Gudang ON;
INSERT INTO Gudang (id_gudang, Kode, Nama, Aktif, Alamat1, Kota, Email, PIC) VALUES
(1, 'WH-JKT', 'Warehouse Jakarta', 1, 'JL. DAAN MOGOT KM 19', 'JAKARTA', 'wh.jkt@galva.com', 'Budi'),
(2, 'WH-BDG', 'Warehouse Bandung', 1, 'JL. MOH TOHA KM 5', 'BANDUNG', 'wh.bdg@galva.com', 'Andi'),
(3, 'WH-SBY', 'Warehouse Surabaya', 1, 'JL. RUNGKUT INDUSTRI', 'SURABAYA', 'wh.sby@galva.com', 'Citra'),
(4, 'WH-DPK', 'Warehouse Depok', 1, 'JL. ARIF RAHMAN HAKIM', 'DEPOK', 'wh.dpk@galva.com', 'Dedi');
SET IDENTITY_INSERT Gudang OFF;

INSERT INTO Barang (Kode, Nama) VALUES
('LAPTOP-HP-01', 'HP EliteBook 840 G8 Laptop'),
('LAPTOP-DL-01', 'Dell Latitude 5520 Laptop'),
('MONITOR-LG-24', 'LG 24MK600M 24-inch Monitor'),
('MONITOR-SM-27', 'Samsung 27-inch Curved Monitor'),
('PRINTER-CAN-01', 'Canon PIXMA G3020 Printer'),
('PRINTER-HP-01', 'HP LaserJet Pro M404dn'),
('TONER-HP-05A', 'HP 05A Black Toner Cartridge'),
('TONER-CAN-045', 'Canon 045 Toner Cartridge Set'),
('KEYBOARD-LOG-01', 'Logitech MK270 Wireless Keyboard Mouse'),
('MOUSE-LOG-01', 'Logitech M331 Silent Plus Mouse'),
('WEBCAM-LOG-01', 'Logitech C920 HD Pro Webcam'),
('HEADSET-JBL-01', 'JBL Quantum 100 Gaming Headset'),
('ROUTER-TP-01', 'TP-Link Archer C6 AC1200 Router'),
('SWITCH-TP-01', 'TP-Link TL-SG108 8-Port Gigabit Switch'),
('CABLE-HDMI-03', 'HDMI Cable 3 Meter High Speed'),
('CABLE-LAN-05', 'Cat 6 LAN Cable 5 Meter'),
('DESK-OF-01', 'Office Desk 120x60 cm'),
('CHAIR-OF-01', 'Ergonomic Office Chair'),
('FILING-CAB-01', 'Metal Filing Cabinet 4 Drawer'),
('WHITEBOARD-01', 'Magnetic Whiteboard 90x120 cm'),
('PROJECTOR-EP-01', 'Epson EB-E01 Projector'),
('SCREEN-PR-01', 'Projector Screen 100-inch'),
('UPS-APC-01', 'APC Back-UPS 650VA'),
('STABILIZER-01', 'Stabilizer 2000VA'),
('AIRCON-PAN-01', 'Panasonic 1PK Split AC');

INSERT INTO Category (Kode, Nama) VALUES
('CAT01', 'Computer & Laptop'),
('CAT02', 'Printer & Supplies'),
('CAT03', 'Network Equipment'),
('CAT04', 'Office Furniture'),
('CAT05', 'Electronics'),
('CAT06', 'Accessories');

INSERT INTO Satuan (Kode, Nama) VALUES
('PC', 'Pcs'),
('ST', 'Set'),
('BX', 'Box'),
('RL', 'Roll'),
('UN', 'Unit'),
('PK', 'Pack');

INSERT INTO SupplierGroup (Kode, Nama) VALUES
('ELEC', 'Electronics'),
('SERV', 'Services'),
('SOFT', 'Software'),
('AUDI', 'Audio'),
('MKT', 'Marketplace');

GO

-- ============================================================
-- 2. PURCHASE REQUISITIONS (SPB)
-- ============================================================

SET IDENTITY_INSERT SPB ON;
INSERT INTO SPB (id_spb, Doku, Tgl, Kode_Dept, Kode_Sales, Total, Nilai, PPn, Diskon, Sts, Status, Memo, GROSS, GRANDTOTAL, DPP) VALUES
(1, '2018000001', '2024-01-15', '100', 'S001', 15000000, 15000000, 1500000, 0, '1', 'Approved', 'PR for Q1 IT equipment refresh', 15000000, 16500000, 15000000),
(2, '2018000002', '2024-01-20', '200', 'S002', 8500000, 8500000, 850000, 0, '1', 'Approved', 'Office supplies for Operations', 8500000, 9350000, 8500000),
(3, '2018000003', '2024-02-05', '100', 'S001', 25000000, 25000000, 2500000, 0, '0', 'Pending', 'Server upgrade request', 25000000, 27500000, 25000000),
(4, '2018000004', '2024-02-10', '400', 'S003', 5000000, 5000000, 500000, 0, '1', 'Approved', 'Printer toner stock refill', 5000000, 5500000, 5000000),
(5, '2018000005', '2024-02-15', '500', 'S004', 12000000, 12000000, 1200000, 0, '1', 'Approved', 'Warehouse shelving units', 12000000, 13200000, 12000000),
(6, '2018000006', '2024-03-01', '100', 'S001', 18000000, 18000000, 1800000, 0, '0', 'Pending', 'Network infrastructure upgrade', 18000000, 19800000, 18000000),
(7, '2018000007', '2024-03-10', '600', 'S005', 7500000, 7500000, 750000, 0, '1', 'Approved', 'Sales demo equipment', 7500000, 8250000, 7500000),
(8, '2018000008', '2024-03-15', '200', 'S002', 3000000, 3000000, 300000, 0, '1', 'Approved', 'Stationery bulk order', 3000000, 3300000, 3000000),
(9, '2018000009', '2024-04-01', '400', 'S003', 22000000, 22000000, 2200000, 0, '1', 'Approved', 'AC units for new office wing', 22000000, 24200000, 22000000),
(10, '2018000010', '2024-04-10', '100', 'S001', 9500000, 9500000, 950000, 0, '0', 'Pending', 'Backup UPS units', 9500000, 10450000, 9500000);
SET IDENTITY_INSERT SPB OFF;

INSERT INTO SubSPB (Doku, Tgl, Kode_Brg, Kode_Gudang, Alias, Jumlah, Harga, Nilai, Diskon, PPn, Kode_Valas, Kurs, NoUrut, Kode_Dept, Sts, Gross, Dpp, SubTotal) VALUES
('2018000001', '2024-01-15', 'LAPTOP-HP-01', 'WH-JKT', 'HP EliteBook 840', 5, 1500000, 7500000, 0, 750000, 'Rp.', 1, 1, '100', '1', 7500000, 7500000, 8250000),
('2018000001', '2024-01-15', 'MONITOR-LG-24', 'WH-JKT', 'LG 24-inch Monitor', 5, 1500000, 7500000, 0, 750000, 'Rp.', 1, 2, '100', '1', 7500000, 7500000, 8250000),
('2018000002', '2024-01-20', 'DESK-OF-01', 'WH-JKT', 'Office Desk', 10, 500000, 5000000, 0, 500000, 'Rp.', 1, 1, '200', '1', 5000000, 5000000, 5500000),
('2018000002', '2024-01-20', 'CHAIR-OF-01', 'WH-JKT', 'Ergonomic Chair', 10, 350000, 3500000, 0, 350000, 'Rp.', 1, 2, '200', '1', 3500000, 3500000, 3850000),
('2018000003', '2024-02-05', 'SERVER-DL-01', 'WH-JKT', 'Dell PowerEdge Server', 2, 12500000, 25000000, 0, 2500000, 'Rp.', 1, 1, '100', '0', 25000000, 25000000, 27500000),
('2018000004', '2024-02-10', 'TONER-HP-05A', 'WH-JKT', 'HP 05A Toner', 20, 250000, 5000000, 0, 500000, 'Rp.', 1, 1, '400', '1', 5000000, 5000000, 5500000),
('2018000005', '2024-02-15', 'SHELF-IND-01', 'WH-BDG', 'Industrial Shelving', 15, 800000, 12000000, 0, 1200000, 'Rp.', 1, 1, '500', '1', 12000000, 12000000, 13200000),
('2018000006', '2024-03-01', 'ROUTER-TP-01', 'WH-JKT', 'TP-Link Router', 10, 800000, 8000000, 0, 800000, 'Rp.', 1, 1, '100', '0', 8000000, 8000000, 8800000),
('2018000006', '2024-03-01', 'SWITCH-TP-01', 'WH-JKT', 'TP-Link Switch', 10, 1000000, 10000000, 0, 1000000, 'Rp.', 1, 2, '100', '0', 10000000, 10000000, 11000000),
('2018000007', '2024-03-10', 'PROJECTOR-EP-01', 'WH-JKT', 'Epson Projector', 3, 2500000, 7500000, 0, 750000, 'Rp.', 1, 1, '600', '1', 7500000, 7500000, 8250000),
('2018000008', '2024-03-15', 'STATIONERY-01', 'WH-JKT', 'Stationery Set', 50, 60000, 3000000, 0, 300000, 'Rp.', 1, 1, '200', '1', 3000000, 3000000, 3300000),
('2018000009', '2024-04-01', 'AIRCON-PAN-01', 'WH-JKT', 'Panasonic 1PK AC', 10, 2200000, 22000000, 0, 2200000, 'Rp.', 1, 1, '400', '1', 22000000, 22000000, 24200000),
('2018000010', '2024-04-10', 'UPS-APC-01', 'WH-JKT', 'APC UPS 650VA', 10, 950000, 9500000, 0, 950000, 'Rp.', 1, 1, '100', '0', 9500000, 9500000, 10450000);

GO

-- ============================================================
-- 3. PURCHASE ORDERS (PO)
-- ============================================================

SET IDENTITY_INSERT PO ON;
INSERT INTO PO (id_po, Doku, Tgl, Kode_Supplier, Kode_dept, Nilai, PPN, Diskon, STS, Memo, Kode_Valas, Kurs, Syarat, DPPNilaiLain) VALUES
(1, '2201JKT999/E/0100', '2024-01-18', 'TLA0030', '100', 15000000, 1500000, 0, '1', 'PO for IT equipment refresh Q1', 'Rp.', 1, 30, 15000000),
(2, '2201JKT999/E/0101', '2024-01-22', 'TLT0014', '200', 8500000, 850000, 0, '1', 'Office supplies procurement', 'Rp.', 1, 0, 8500000),
(3, '2202JKT999/E/0102', '2024-02-12', 'TLE0005', '400', 5000000, 500000, 0, '1', 'Printer toner stock order', 'Rp.', 1, 90, 5000000),
(4, '2202JKT999/E/0103', '2024-02-18', 'TLS0006', '500', 12000000, 1200000, 0, '1', 'Warehouse shelving PO', 'Rp.', 1, 7, 12000000),
(5, '2203JKT999/E/0104', '2024-03-12', 'TLT0002', '600', 7500000, 750000, 0, '1', 'Sales demo equipment PO', 'Rp.', 1, 120, 7500000),
(6, '2203JKT999/E/0105', '2024-03-18', 'TLT0014', '200', 3000000, 300000, 0, '1', 'Stationery bulk order', 'Rp.', 1, 0, 3000000),
(7, '2203JKT999/E/0106', '2024-04-02', 'TLC0001', '400', 22000000, 2200000, 0, '1', 'AC units for new wing', 'Rp.', 1, 30, 22000000),
(8, '2204JKT999/E/0107', '2024-04-15', 'TLH0001', '100', 9500000, 950000, 0, '0', 'Backup UPS units PO', 'Rp.', 1, 30, 9500000);
SET IDENTITY_INSERT PO OFF;

INSERT INTO SubPO (Doku, Tgl, Kode_Brg, Kode_Dept, Kode_Gudang, Alias, Jumlah, Harga, Total, Diskon, PPN, Kode_Valas) VALUES
('2201JKT999/E/0100', '2024-01-18', 'LAPTOP-HP-01', '100', 'WH-JKT', 'HP EliteBook 840', 5, 1500000, 7500000, 0, 750000, 'Rp.'),
('2201JKT999/E/0100', '2024-01-18', 'MONITOR-LG-24', '100', 'WH-JKT', 'LG 24-inch Monitor', 5, 1500000, 7500000, 0, 750000, 'Rp.'),
('2201JKT999/E/0101', '2024-01-22', 'DESK-OF-01', '200', 'WH-JKT', 'Office Desk', 10, 500000, 5000000, 0, 500000, 'Rp.'),
('2201JKT999/E/0101', '2024-01-22', 'CHAIR-OF-01', '200', 'WH-JKT', 'Ergonomic Chair', 10, 350000, 3500000, 0, 350000, 'Rp.'),
('2202JKT999/E/0102', '2024-02-12', 'TONER-HP-05A', '400', 'WH-JKT', 'HP 05A Toner', 20, 250000, 5000000, 0, 500000, 'Rp.'),
('2202JKT999/E/0103', '2024-02-18', 'SHELF-IND-01', '500', 'WH-BDG', 'Industrial Shelving', 15, 800000, 12000000, 0, 1200000, 'Rp.'),
('2203JKT999/E/0104', '2024-03-12', 'PROJECTOR-EP-01', '600', 'WH-JKT', 'Epson Projector', 3, 2500000, 7500000, 0, 750000, 'Rp.'),
('2203JKT999/E/0105', '2024-03-18', 'STATIONERY-01', '200', 'WH-JKT', 'Stationery Set', 50, 60000, 3000000, 0, 300000, 'Rp.'),
('2203JKT999/E/0106', '2024-04-02', 'AIRCON-PAN-01', '400', 'WH-JKT', 'Panasonic 1PK AC', 10, 2200000, 22000000, 0, 2200000, 'Rp.'),
('2204JKT999/E/0107', '2024-04-15', 'UPS-APC-01', '100', 'WH-JKT', 'APC UPS 650VA', 10, 950000, 9500000, 0, 950000, 'Rp.');

GO

-- ============================================================
-- 4. GOODS RECEIPTS (LPB)
-- ============================================================

SET IDENTITY_INSERT LPB ON;
INSERT INTO LPB (id_lpb, Doku, Tgl, Doku_PO, Kode_Supplier, Kode_Dept, SuratJalan, Nilai, PPN, Diskon, STS, Status, Memo, Kode_Valas, Kurs, Term, DPPNilaiLain) VALUES
(1, '2201JKT999/L/0200', '2024-01-25', '2201JKT999/E/0100', 'TLA0030', '100', 'SJ-2024-001', 15000000, 1500000, 0, '1', 'Rcv', 'Full receipt of IT equipment', 'Rp.', 1, 30, 15000000),
(2, '2201JKT999/L/0201', '2024-01-28', '2201JKT999/E/0101', 'TLT0014', '200', 'SJ-2024-002', 8500000, 850000, 0, '1', 'Rcv', 'Office supplies received', 'Rp.', 1, 0, 8500000),
(3, '2202JKT999/L/0202', '2024-02-15', '2202JKT999/E/0102', 'TLE0005', '400', 'SJ-2024-003', 5000000, 500000, 0, '1', 'Rcv', 'Toner stock received', 'Rp.', 1, 90, 5000000),
(4, '2202JKT999/L/0203', '2024-02-22', '2202JKT999/E/0103', 'TLS0006', '500', 'SJ-2024-004', 12000000, 1200000, 0, '1', 'Part', 'Shelving partial delivery', 'Rp.', 1, 7, 12000000),
(5, '2203JKT999/L/0204', '2024-03-15', '2203JKT999/E/0104', 'TLT0002', '600', 'SJ-2024-005', 7500000, 750000, 0, '1', 'Rcv', 'Demo equipment received', 'Rp.', 1, 120, 7500000),
(6, '2203JKT999/L/0205', '2024-03-20', '2203JKT999/E/0105', 'TLT0014', '200', 'SJ-2024-006', 3000000, 300000, 0, '1', 'Rcv', 'Stationery received', 'Rp.', 1, 0, 3000000),
(7, '2203JKT999/L/0206', '2024-04-05', '2203JKT999/E/0106', 'TLC0001', '400', 'SJ-2024-007', 22000000, 2200000, 0, '1', 'Rcv', 'AC units installed', 'Rp.', 1, 30, 22000000);
SET IDENTITY_INSERT LPB OFF;

INSERT INTO SubLPB (Doku, Tgl, Doku_PO, Kode_Brg, Kode_Gudang, Jumlah, Harga, Nilai, Diskon, PPN, Kode_Valas, Kurs) VALUES
('2201JKT999/L/0200', '2024-01-25', '2201JKT999/E/0100', 'LAPTOP-HP-01', 'WH-JKT', 5, 1500000, 7500000, 0, 750000, 'Rp.', 1),
('2201JKT999/L/0200', '2024-01-25', '2201JKT999/E/0100', 'MONITOR-LG-24', 'WH-JKT', 5, 1500000, 7500000, 0, 750000, 'Rp.', 1),
('2201JKT999/L/0201', '2024-01-28', '2201JKT999/E/0101', 'DESK-OF-01', 'WH-JKT', 10, 500000, 5000000, 0, 500000, 'Rp.', 1),
('2201JKT999/L/0201', '2024-01-28', '2201JKT999/E/0101', 'CHAIR-OF-01', 'WH-JKT', 10, 350000, 3500000, 0, 350000, 'Rp.', 1),
('2202JKT999/L/0202', '2024-02-15', '2202JKT999/E/0102', 'TONER-HP-05A', 'WH-JKT', 20, 250000, 5000000, 0, 500000, 'Rp.', 1),
('2202JKT999/L/0203', '2024-02-22', '2202JKT999/E/0103', 'SHELF-IND-01', 'WH-BDG', 10, 800000, 8000000, 0, 800000, 'Rp.', 1),
('2203JKT999/L/0204', '2024-03-15', '2203JKT999/E/0104', 'PROJECTOR-EP-01', 'WH-JKT', 3, 2500000, 7500000, 0, 750000, 'Rp.', 1),
('2203JKT999/L/0205', '2024-03-20', '2203JKT999/E/0105', 'STATIONERY-01', 'WH-JKT', 50, 60000, 3000000, 0, 300000, 'Rp.', 1),
('2203JKT999/L/0206', '2024-04-05', '2203JKT999/E/0106', 'AIRCON-PAN-01', 'WH-JKT', 10, 2200000, 22000000, 0, 2200000, 'Rp.', 1);

GO

-- ============================================================
-- 5. AP INVOICES (VoucherAP)
-- ============================================================

SET IDENTITY_INSERT VoucherAP ON;
INSERT INTO VoucherAP (PKbas, Doku, TglDoku, Kode_Supplier, Kode_Dept, Nilai, PPn, Diskon, Misc, STS, Keterangan, Kode_Valas, Kurs) VALUES
(1, '2201JKT999/E/0250', '2024-01-30', 'TLA0030', '100', 15000000, 1500000, 0, 0, '1', 'AP Invoice for IT equipment PO 2201JKT999/E/0100', 'Rp.', 1),
(2, '2201JKT999/E/0251', '2024-02-01', 'TLT0014', '200', 8500000, 850000, 0, 0, '1', 'AP Invoice for office supplies PO 2201JKT999/E/0101', 'Rp.', 1),
(3, '2202JKT999/E/0252', '2024-02-18', 'TLE0005', '400', 5000000, 500000, 0, 0, '1', 'AP Invoice for toner stock PO 2202JKT999/E/0102', 'Rp.', 1),
(4, '2202JKT999/E/0253', '2024-02-25', 'TLS0006', '500', 12000000, 1200000, 0, 0, '1', 'AP Invoice for shelving PO 2202JKT999/E/0103', 'Rp.', 1),
(5, '2203JKT999/E/0254', '2024-03-18', 'TLT0002', '600', 7500000, 750000, 0, 0, '1', 'AP Invoice for demo equipment PO 2203JKT999/E/0104', 'Rp.', 1),
(6, '2203JKT999/E/0255', '2024-03-22', 'TLT0014', '200', 3000000, 300000, 0, 0, '1', 'AP Invoice for stationery PO 2203JKT999/E/0105', 'Rp.', 1),
(7, '2203JKT999/E/0256', '2024-04-08', 'TLC0001', '400', 22000000, 2200000, 0, 0, '1', 'AP Invoice for AC units PO 2203JKT999/E/0106', 'Rp.', 1),
(8, '2203JKT999/E/0257', '2024-04-20', 'TLH0001', '100', 9500000, 950000, 0, 0, '0', 'AP Invoice for UPS units PO 2204JKT999/E/0107', 'Rp.', 1);
SET IDENTITY_INSERT VoucherAP OFF;

INSERT INTO SubVoucherAP (Doku, Tgl, Doku_LPB, Doku_PO, NilaiLPB, Nilai, Diskon, PPn, Kode_Valas, Kurs, NoUrut, Kode_Supplier) VALUES
('2201JKT999/E/0250', '2024-01-30', '2201JKT999/L/0200', '2201JKT999/E/0100', 15000000, 15000000, 0, 1500000, 'Rp.', 1, 1, 'TLA0030'),
('2201JKT999/E/0251', '2024-02-01', '2201JKT999/L/0201', '2201JKT999/E/0101', 8500000, 8500000, 0, 850000, 'Rp.', 1, 1, 'TLT0014'),
('2202JKT999/E/0252', '2024-02-18', '2202JKT999/L/0202', '2202JKT999/E/0102', 5000000, 5000000, 0, 500000, 'Rp.', 1, 1, 'TLE0005'),
('2202JKT999/E/0253', '2024-02-25', '2202JKT999/L/0203', '2202JKT999/E/0103', 12000000, 12000000, 0, 1200000, 'Rp.', 1, 1, 'TLS0006'),
('2203JKT999/E/0254', '2024-03-18', '2203JKT999/L/0204', '2203JKT999/E/0104', 7500000, 7500000, 0, 750000, 'Rp.', 1, 1, 'TLT0002'),
('2203JKT999/E/0255', '2024-03-22', '2203JKT999/L/0205', '2203JKT999/E/0105', 3000000, 3000000, 0, 300000, 'Rp.', 1, 1, 'TLT0014'),
('2203JKT999/E/0256', '2024-04-08', '2203JKT999/L/0206', '2203JKT999/E/0106', 22000000, 22000000, 0, 2200000, 'Rp.', 1, 1, 'TLC0001'),
('2203JKT999/E/0257', '2024-04-20', NULL, '2204JKT999/E/0107', 0, 9500000, 0, 950000, 'Rp.', 1, 1, 'TLH0001');

GO

-- ============================================================
-- 6. PAYMENTS (Bayar)
-- ============================================================

SET IDENTITY_INSERT Bayar ON;
INSERT INTO Bayar (PKindex, Doku, Tgl, Kode_Supplier, Keterangan, NilaiKas, NilaiGiro, STS, Kode_Valas, Kurs, Cara) VALUES
(1, 'PV-2024-0001', '2024-03-25', 'TLT0014', 'Payment for stationery invoice', 3300000, 0, '1', 'Rp.', 1, 'Transfer'),
(2, 'PV-2024-0002', '2024-04-10', 'TLE0005', 'Partial payment for toner invoice', 2750000, 0, '1', 'Rp.', 1, 'Transfer'),
(3, 'PV-2024-0003', '2024-04-15', 'TLA0030', 'Payment for IT equipment invoice', 16500000, 0, '1', 'Rp.', 1, 'Transfer'),
(4, 'PV-2024-0004', '2024-04-20', 'TLT0002', 'Payment for demo equipment', 8250000, 0, '1', 'Rp.', 1, 'Giro'),
(5, 'PV-2024-0005', '2024-04-25', 'TLS0006', 'Payment for shelving invoice', 13200000, 0, '1', 'Rp.', 1, 'Transfer');
SET IDENTITY_INSERT Bayar OFF;

INSERT INTO SubBayar (Doku, Tgl, Kode_Supplier, Doku_LPB, Giro, Nilai, TotalNilai, Kode_Valas, Kurs, NoUrut, Keterangan, Kode_Bank) VALUES
('PV-2024-0001', '2024-03-25', 'TLT0014', '2203JKT999/L/0205', NULL, 3000000, 3300000, 'Rp.', 1, 1, 'Stationery payment', 'MANDIRI'),
('PV-2024-0002', '2024-04-10', 'TLE0005', '2202JKT999/L/0202', NULL, 2500000, 2750000, 'Rp.', 1, 1, 'Toner partial payment', 'BCA'),
('PV-2024-0003', '2024-04-15', 'TLA0030', '2201JKT999/L/0200', NULL, 15000000, 16500000, 'Rp.', 1, 1, 'IT equipment full payment', 'BCA'),
('PV-2024-0004', '2024-04-20', 'TLT0002', '2203JKT999/L/0204', NULL, 7500000, 8250000, 'Rp.', 1, 1, 'Demo equipment payment', 'BRI'),
('PV-2024-0005', '2024-04-25', 'TLS0006', '2202JKT999/L/0203', NULL, 12000000, 13200000, 'Rp.', 1, 1, 'Shelving full payment', 'BNI');

GO

-- ============================================================
-- 7. ADDITIONAL MASTER DATA FOR AR / SALES MODULES
-- ============================================================

-- SaldoAP
SET IDENTITY_INSERT SaldoAP ON;
INSERT INTO SaldoAP (PKbas, Kode_Supplier, Awal) VALUES
(1, 'TLA0030', 0),
(2, 'TLE0005', 2500000),
(3, 'TLS0006', 0),
(4, 'TLT0002', 0),
(5, 'TLT0014', 0),
(6, 'TLC0001', 22000000),
(7, 'TLH0001', 9500000);
SET IDENTITY_INSERT SaldoAP OFF;

-- APMuka (Down payment / advance)
SET IDENTITY_INSERT APMuka ON;
INSERT INTO APMuka (PKindex, Doku, TglDoku, Doku_PO, Kode_Supplier, NilaiBruto, NilaiKas, NilaiGiro, PPn, Sts, Kode_Valas, Kurs, Memo, Tipe) VALUES
(1, 'DP-2024-0001', '2024-01-10', '2201JKT999/E/0100', 'TLA0030', 5000000, 5000000, 0, 500000, '1', 'Rp.', 1, 'Down payment for IT equipment', 'DP'),
(2, 'DP-2024-0002', '2024-02-05', '2202JKT999/E/0103', 'TLS0006', 3000000, 3000000, 0, 300000, '1', 'Rp.', 1, 'Down payment for shelving', 'DP');
SET IDENTITY_INSERT APMuka OFF;

GO

PRINT 'Seed completed successfully.';
GO
