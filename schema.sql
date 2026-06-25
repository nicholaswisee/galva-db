CREATE DATABASE ErpApMockup
GO
USE ErpApMockup
GO
-- ==============================================================================
-- ERP MIGRATION SCHEMA - ACCOUNT PAYABLE FLOW (SQL SERVER)
-- Based on Legacy UI Analysis
-- Flow: PR -> PO -> GR -> Invoice -> Payment
-- ==============================================================================

-- =========================================
-- 1. MASTER DATA TABLES
-- =========================================

-- Based on "Browse Inventory" screen
CREATE TABLE Master_Inventory
(
  StockCode VARCHAR(50) PRIMARY KEY,
  Description NVARCHAR(255) NOT NULL,
  Model VARCHAR(100),
  Unit VARCHAR(20),
  Class VARCHAR(50),
  SubClass VARCHAR(50),
  DefaultPrice DECIMAL(18, 2) DEFAULT 0.00,
  -- Note: Available, SuitableStock, OnOrder are usually calculated dynamically 
  -- from transaction history or kept in a separate InventoryBalance table.
  IsActive BIT DEFAULT 1
);

CREATE TABLE Master_Vendor
(
  VendorCode VARCHAR(50) PRIMARY KEY,
  VendorName NVARCHAR(150) NOT NULL,
  TOPDays INT DEFAULT 0,
  -- Terms of Payment (Days)
  Currency VARCHAR(10) DEFAULT 'IDR'
);

CREATE TABLE Master_Department
(
  DeptCode VARCHAR(20) PRIMARY KEY,
  DeptName NVARCHAR(100) NOT NULL
);

CREATE TABLE Master_Warehouse
(
  WHCode VARCHAR(20) PRIMARY KEY,
  WHName NVARCHAR(100) NOT NULL
);

CREATE TABLE Master_Bank
(
  BankCode VARCHAR(20) PRIMARY KEY,
  BankName NVARCHAR(100) NOT NULL
);

-- =========================================
-- 2. TRANSACTION DATA: PURCHASE REQUISITION
-- =========================================

CREATE TABLE Tx_PurchaseRequisition
(
  PRNumber VARCHAR(50) PRIMARY KEY,
  PRDate DATE NOT NULL,
  DeptCode VARCHAR(20) FOREIGN KEY REFERENCES Master_Department(DeptCode),
  SalesmanName NVARCHAR(100),
  HeaderDescription NVARCHAR(MAX),
  IsApproved BIT DEFAULT 0,
  CreatedBy NVARCHAR(50),
  CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Tx_PurchaseRequisitionDetail
(
  PRDetailID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  PRNumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_PurchaseRequisition(PRNumber),
  StockCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Inventory(StockCode),
  Qty DECIMAL(18, 4) NOT NULL,
  Unit VARCHAR(20),
  Memo NVARCHAR(255),
  Description NVARCHAR(255)
);

-- =========================================
-- 3. TRANSACTION DATA: PURCHASE ORDER
-- =========================================

CREATE TABLE Tx_PurchaseOrder
(
  PONumber VARCHAR(50) PRIMARY KEY,
  PODate DATE NOT NULL,
  VendorCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Vendor(VendorCode),
  TOPDays INT,
  DeptCode VARCHAR(20) FOREIGN KEY REFERENCES Master_Department(DeptCode),
  Currency VARCHAR(10),
  ExchangeRate DECIMAL(18, 4) DEFAULT 1.00,
  HeaderNote NVARCHAR(MAX),
  -- Totals
  GrossAmount DECIMAL(18, 2) DEFAULT 0,
  DiscPercent DECIMAL(5, 2) DEFAULT 0,
  DiscAmount DECIMAL(18, 2) DEFAULT 0,
  NetAmount DECIMAL(18, 2) DEFAULT 0,
  VATPercent DECIMAL(5, 2) DEFAULT 0,
  VATAmount DECIMAL(18, 2) DEFAULT 0,
  GrandTotal DECIMAL(18, 2) DEFAULT 0,
  Status VARCHAR(20) DEFAULT 'Pending'
  -- Pending, Confirmed, Cancelled
);

CREATE TABLE Tx_PurchaseOrderDetail
(
  PODetailID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  PONumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_PurchaseOrder(PONumber),
  StockCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Inventory(StockCode),
  PRNumber VARCHAR(50) NULL,
  -- Link back to PR
  Brand VARCHAR(50),
  Model VARCHAR(100),
  Qty DECIMAL(18, 4) NOT NULL,
  Unit VARCHAR(20),
  UnitPrice DECIMAL(18, 2) NOT NULL,
  DiscPercent DECIMAL(5, 2) DEFAULT 0,
  DiscAmount DECIMAL(18, 2) DEFAULT 0,
  LineTotal DECIMAL(18, 2) NOT NULL,
  WHCode VARCHAR(20) FOREIGN KEY REFERENCES Master_Warehouse(WHCode),
  ScheduleDate DATE,
  Note NVARCHAR(255)
);

-- =========================================
-- 4. TRANSACTION DATA: GOODS RECEIPT
-- =========================================

CREATE TABLE Tx_GoodsReceipt
(
  GRNumber VARCHAR(50) PRIMARY KEY,
  GRDate DATE NOT NULL,
  PONumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_PurchaseOrder(PONumber),
  -- Link to PO
  DOVendor VARCHAR(100),
  -- Delivery Order Vendor Ref
  Nopen VARCHAR(100),
  PaymentDate DATE,
  VendorCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Vendor(VendorCode),
  ExchangeRate DECIMAL(18, 4) DEFAULT 1.00,
  AWB_BL VARCHAR(100),
  -- Airway Bill / Bill of Lading
  Note NVARCHAR(MAX),
  ForwardAgent NVARCHAR(100),
  -- Totals
  GrossAmount DECIMAL(18, 2) DEFAULT 0,
  DiscAmount DECIMAL(18, 2) DEFAULT 0,
  NetAmount DECIMAL(18, 2) DEFAULT 0,
  VATPercent DECIMAL(5, 2) DEFAULT 0,
  PurchaseAmount DECIMAL(18, 2) DEFAULT 0
);

CREATE TABLE Tx_GoodsReceiptDetail
(
  GRDetailID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  GRNumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_GoodsReceipt(GRNumber),
  StockCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Inventory(StockCode),
  Model VARCHAR(100),
  Qty DECIMAL(18, 4) NOT NULL,
  SerialNo VARCHAR(100),
  UnitPrice DECIMAL(18, 2) NOT NULL,
  DiscPercent DECIMAL(5, 2) DEFAULT 0,
  LineTotal DECIMAL(18, 2) NOT NULL,
  WHCode VARCHAR(20) FOREIGN KEY REFERENCES Master_Warehouse(WHCode),
  Description NVARCHAR(255),
  Information NVARCHAR(255)
);

-- =========================================
-- 5. TRANSACTION DATA: AP INVOICE
-- =========================================

CREATE TABLE Tx_APInvoice
(
  InvoiceNumber VARCHAR(50) PRIMARY KEY,
  InvoiceDate DATE NOT NULL,
  VendorCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Vendor(VendorCode),
  DueDate DATE NOT NULL,
  Currency VARCHAR(10),
  ExchangeRate DECIMAL(18, 4) DEFAULT 1.00,
  FPNumber VARCHAR(100),
  -- Faktur Pajak
  -- Totals
  Amount DECIMAL(18, 2) DEFAULT 0,
  DiscPercent DECIMAL(5, 2) DEFAULT 0,
  DiscAmount DECIMAL(18, 2) DEFAULT 0,
  NetAmount DECIMAL(18, 2) DEFAULT 0,
  VATPercent DECIMAL(5, 2) DEFAULT 0,
  VATAmount DECIMAL(18, 2) DEFAULT 0,
  InvoiceAmount DECIMAL(18, 2) DEFAULT 0,
  Status VARCHAR(20) DEFAULT 'Open'
  -- Open, Partially Paid, Paid
);

-- An Invoice can be based on multiple Goods Receipts
CREATE TABLE Tx_APInvoiceGR_Link
(
  LinkID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  InvoiceNumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_APInvoice(InvoiceNumber),
  GRNumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_GoodsReceipt(GRNumber),
  GRTotal DECIMAL(18, 2) NOT NULL
);

-- =========================================
-- 6. TRANSACTION DATA: AP PAYMENT
-- =========================================

CREATE TABLE Tx_APPayment
(
  DocumentNumber VARCHAR(50) PRIMARY KEY,
  PaymentDate DATE NOT NULL,
  VendorCode VARCHAR(50) FOREIGN KEY REFERENCES Master_Vendor(VendorCode),
  Description NVARCHAR(255),
  BankCode VARCHAR(20) FOREIGN KEY REFERENCES Master_Bank(BankCode),
  ChequeNo VARCHAR(50),
  TotalPaidAmount DECIMAL(18, 2) NOT NULL
);

CREATE TABLE Tx_APPaymentDetail
(
  PaymentDetailID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  DocumentNumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_APPayment(DocumentNumber),
  InvoiceNumber VARCHAR(50) FOREIGN KEY REFERENCES Tx_APInvoice(InvoiceNumber),
  PaymentType VARCHAR(50),
  -- e.g., Tunai, ADJ-PPH
  OriginalAmount DECIMAL(18, 2),
  Currency VARCHAR(10),
  ExchangeRate DECIMAL(18, 4) DEFAULT 1.00,
  ApplyAmount DECIMAL(18, 2) NOT NULL,
  DeptCode VARCHAR(20) FOREIGN KEY REFERENCES Master_Department(DeptCode)
);