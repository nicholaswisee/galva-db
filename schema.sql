CREATE DATABASE ErpApMockup
GO
USE ErpApMockup
GO
/****** Object:  Table [dbo].[A_MASTER_BARANG]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[A_MASTER_BARANG](
	[Area] [nvarchar](255) NULL,
	[kodelama] [nvarchar](255) NULL,
	[nama] [nvarchar](255) NULL,
	[kodebaru] [nvarchar](255) NULL,
	[KETERANGAN] [nvarchar](50) NULL,
	[PKindex] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_A_MASTER_BARANG] PRIMARY KEY CLUSTERED 
(
	[PKindex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[APMuka]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APMuka](
	[Doku] [nvarchar](20) NULL,
	[TglDoku] [smalldatetime] NULL,
	[Doku_PO] [nvarchar](50) NULL,
	[Doku_Bayar] [nvarchar](20) NULL,
	[TglDokuBayar] [smalldatetime] NULL,
	[Kode_Supplier] [nvarchar](20) NULL,
	[Kode_Bank] [nvarchar](20) NULL,
	[Giro] [nvarchar](25) NULL,
	[PPn] [float] NULL,
	[NilaiBruto] [float] NULL,
	[NilaiKas] [float] NULL,
	[NilaiKasTerpakai] [float] NULL,
	[TglGiro] [smalldatetime] NULL,
	[TglCair] [smalldatetime] NULL,
	[Sts] [nvarchar](5) NULL,
	[Kompensasi] [float] NULL,
	[Kirim] [smalldatetime] NULL,
	[Kode_Valas] [nvarchar](12) NULL,
	[Kurs] [float] NULL,
	[Memo] [nvarchar](255) NULL,
	[Tipe] [nvarchar](20) NULL,
	[NoSeri] [nvarchar](20) NULL,
	[UserID] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[NilaiGiro] [float] NULL,
	[NilaiGiroTerpakai] [float] NULL,
	[NamaUser] [nvarchar](20) NULL,
	[Jenis] [nvarchar](5) NULL,
	[PKindex] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_APMuka] PRIMARY KEY CLUSTERED 
(
	[PKindex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AwalBank]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AwalBank](
	[Kode] [float] NULL,
	[AC] [nvarchar](255) NULL,
	[Nama] [nvarchar](255) NULL,
	[Kode_Valas] [nvarchar](255) NULL,
	[PKindex] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_AwalBank] PRIMARY KEY CLUSTERED 
(
	[PKindex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank](
    [Kode] [nvarchar](20) NULL,
    [KodeLama] [nvarchar](50) NULL,
    [Nama] [nvarchar](100) NULL,
    [LookupBank] [bit] NULL,
    [Major] [nvarchar](12) NULL,
    [Kode_JenisBayar] [nvarchar](20) NULL,
    [Reference] [nvarchar](200) NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Alamat1] [nvarchar](50) NULL,
    [Alamat2] [nvarchar](50) NULL,
    [Kota] [nvarchar](35) NULL,
    [KodePos] [nvarchar](20) NULL,
    [Telepon] [nvarchar](20) NULL,
    [Fax] [nvarchar](20) NULL,
    [AC] [nvarchar](35) NULL,
    [AN] [nvarchar](50) NULL,
    [Awal] [float](53) NULL,
    [Masuk] [float](53) NULL,
    [Keluar] [float](53) NULL,
    [Kode_Area] [nvarchar](20) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [PKindex] [bigint] IDENTITY(1,1) NOT NULL,
    [MajorPajak] [nvarchar](50) NULL,
    [BpPPn] [int] NULL,
    [PPh23List] [varchar](2) NULL,
    [Diskontinu] [int] NULL,
    [TglDiskontinu] [smalldatetime] NULL,
    CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED ([PKindex]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Barang]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Barang](
    [Kode] [nvarchar](50) NULL,
    [Nama] [nvarchar](255) NULL,
    [Merk] [nvarchar](100) NULL,
    [Satuan] [nvarchar](10) NULL,
    [Harga] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hiapt06]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hiapt06](
    [Doku] [varchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](50) NULL,
    [Kode_BankSupplier] [nvarchar](50) NULL,
    [Keterangan] [nvarchar](350) NULL,
    [NilaiKas] [float](53) NULL,
    [NilaiGiro] [float](53) NULL,
    [NilaiAJE] [float](53) NULL,
    [NilMuka] [float](53) NULL,
    [STS] [nvarchar](1) NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Kurs] [float](53) NULL,
    [Selisih_Bayar] [float](53) NULL,
    [Cara] [nvarchar](20) NULL,
    [Jenis] [nvarchar](10) NULL,
    [Hapus] [nvarchar](100) NULL,
    [UserID] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [StatusGL] [nvarchar](12) NULL,
    [PKindex] [bigint] IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_Hiapt06] PRIMARY KEY CLUSTERED ([PKindex]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
    [Kode] [nvarchar](50) NULL,
    [Nama] [nvarchar](255) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [id_category] [bigint] IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([id_category]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faktur]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Faktur](
	[Doku] [nvarchar](50) NULL,
	[Tgl] [smalldatetime] NULL,
	[Doku_SJ] [nvarchar](50) NULL,
	[Doku_SPB] [nvarchar](50) NULL,
	[Kode_Customer] [nvarchar](20) NULL,
	[Kode_SubCustomer] [nvarchar](20) NULL,
	[Kode_Dept] [nvarchar](20) NULL,
	[Kode_Gudang] [nvarchar](20) NULL,
	[Destination] [nvarchar](255) NULL,
	[Tgl_ETD] [smalldatetime] NULL,
	[TGL_ETA] [smalldatetime] NULL,
	[TGL_PACKING] [smalldatetime] NULL,
	[TGL_SPB] [smalldatetime] NULL,
	[ETD] [nvarchar](20) NULL,
	[ETA] [nvarchar](20) NULL,
	[LOADING] [nvarchar](30) NULL,
	[VESSEL1] [nvarchar](35) NULL,
	[VESSEL2] [nvarchar](35) NULL,
	[MOS] [nvarchar](35) NULL,
	[HUBUNGI] [nvarchar](40) NULL,
	[NPO] [nvarchar](50) NULL,
	[PPn] [float] NULL,
	[PPnTunai] [float] NULL,
	[PPnBm] [float] NULL,
	[PPnBmTunai] [float] NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[TOTAL] [float] NULL,
	[KODE_VALAS] [nvarchar](10) NULL,
	[Kurs] [float] NULL,
	[KursPajak] [float] NULL,
	[SHIP] [nvarchar](50) NULL,
	[PAYMENT] [nvarchar](50) NULL,
	[NAMAUSER] [nvarchar](50) NULL,
	[JMPRN] [float] NULL,
	[STS] [nvarchar](2) NULL,
	[Status] [nvarchar](20) NULL,
	[WAKTU] [smalldatetime] NULL,
	[LIHAT] [nvarchar](1) NULL,
	[MATERAI] [float] NULL,
	[NILAI] [float] NULL,
	[NILAI_MUKA] [float] NULL,
	[Kode_Sales] [nvarchar](10) NULL,
	[SYARAT] [float] NULL,
	[NamaKirim] [nvarchar](100) NULL,
	[AlmKirim] [nvarchar](255) NULL,
	[NOSERI] [nvarchar](100) NULL,
	[PHD] [nvarchar](1) NULL,
	[Case1] [nvarchar](255) NULL,
	[Case2] [nvarchar](255) NULL,
	[Case3] [nvarchar](255) NULL,
	[Case4] [nvarchar](255) NULL,
	[Case5] [nvarchar](255) NULL,
	[Shiping] [nvarchar](6) NULL,
	[MAWB] [nvarchar](25) NULL,
	[HAWB] [nvarchar](25) NULL,
	[NAMASIGN1] [nvarchar](25) NULL,
	[NAMASIGN2] [nvarchar](25) NULL,
	[NAMASIGN3] [nvarchar](25) NULL,
	[JABATANSIGN1] [nvarchar](25) NULL,
	[JABATANSIGN2] [nvarchar](25) NULL,
	[JABATANSIGN3] [nvarchar](25) NULL,
	[REV] [nvarchar](2) NULL,
	[DIVISION] [nvarchar](10) NULL,
	[NO_PEB] [nvarchar](10) NULL,
	[TGL_PEB] [smalldatetime] NULL,
	[Vessel3] [nvarchar](50) NULL,
	[Vessel4] [nvarchar](50) NULL,
	[REALISASI] [nvarchar](5) NULL,
	[TGL_REALISASI] [smalldatetime] NULL,
	[TYPE] [nvarchar](50) NULL,
	[Keterangan] [nvarchar](255) NULL,
	[UserID] [nvarchar](100) NULL,
	[HAPUS] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[StatusGL] [nvarchar](10) NULL,
	[Kode_CustomerGanti] [nvarchar](50) NULL,
	[Hadiah] [bit] NULL,
	[DOKU_KONTRAK] [nvarchar](100) NULL,
	[TipePRoject] [nvarchar](50) NULL,
	[GROSS] [float] NULL,
	[grandTotal] [float] NULL,
	[DOKU_PD] [nvarchar](100) NULL,
	[JmlKirim] [float] NULL,
	[PPhJasa] [float] NULL,
	[DPP] [float] NULL,
	[pphjasaTunai] [float] NULL,
	[Memo] [nvarchar](255) NULL,
	[Terbilang] [nvarchar](300) NULL,
	[TerbilangEnglish] [nvarchar](300) NULL,
	[Doku_paket] [nvarchar](100) NULL,
	[tGLKirim] [smalldatetime] NULL,
	[tGLNPO] [smalldatetime] NULL,
	[tGLVerify] [smalldatetime] NULL,
	[tGL_PD] [smalldatetime] NULL,
	[tGL_Kontrak] [smalldatetime] NULL,
	[nAMApROYEK] [nvarchar](100) NULL,
	[Pelunasan] [float] NULL,
	[Kode_PIC] [nvarchar](50) NULL,
	[DOKU_PROYEK] [nvarchar](100) NULL,
	[PPNNET] [float] NULL,
	[NewEPK] [nvarchar](50) NULL,
	[SalesLama] [nvarchar](20) NULL,
	[KodePajak] [nvarchar](50) NULL,
	[PKBAS] [bigint] IDENTITY(1,1) NOT NULL,
	[TglSewa1] [smalldatetime] NULL,
	[TglSewa2] [smalldatetime] NULL,
	[PeriodSewa] [int] NULL,
	[Nilai_DPAR] [float] NULL,
	[Doku_FP] [nvarchar](50) NULL,
	[ProyekKe] [nvarchar](5) NULL,
	[DiskonOth] [float] NULL,
	[UserEdit] [nvarchar](50) NULL,
	[Kode_IDN] [nvarchar](50) NULL,
	[Rebet] [float] NULL,
	[Doku_Gabungan] [nvarchar](50) NULL,
	[Tgl_Gabungan] [datetime] NULL,
	[EclipseID] [nvarchar](20) NULL,
	[ReportBenq] [nvarchar](50) NULL,
	[ModulSource] [nvarchar](50) NULL,
	[NPWPSub] [nvarchar](50) NULL,
	[CDOut] [float] NULL,
	[CDOutTunai] [float] NULL,
	[CekPreviewInvoice] [int] NULL,
	[TglPreview] [smalldatetime] NULL,
	[Retensi] [float] NOT NULL,
	[Retensip] [int] NOT NULL,
	[CDOutExpired] [smalldatetime] NULL,
	[imgTTD] [image] NULL,
	[NamaTTD] [nvarchar](50) NULL,
	[Validasi] [bit] NULL,
	[ValidasiTime] [smalldatetime] NULL,
	[emailsent] [int] NULL,
	[emaillastsent] [datetime] NULL,
	[NoMaterai] [varchar](20) NULL,
	[Kode_Meterai] [nvarchar](50) NULL,
	[Nilai_Meterai] [float] NULL,
	[JenisPajak] [nvarchar](20) NULL,
	[DokuBC40] [nvarchar](50) NULL,
	[Order_Class] [nvarchar](50) NULL,
	[Order_Type] [nvarchar](50) NULL,
	[Kode_Area] [nvarchar](50) NULL,
 CONSTRAINT [PK_Faktur] PRIMARY KEY CLUSTERED 
(
	[PKBAS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FakturPajak]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FakturPajak](
	[TGrossAmount] [float] NULL,
	[TDiskon] [float] NULL,
	[TNetAmount] [float] NULL,
	[TVAT] [float] NULL,
	[TVATRoundUp] [float] NULL,
	[TGrandTotal] [float] NULL,
	[TGrossAmountRP] [float] NULL,
	[TDiskonRP] [float] NULL,
	[TNetAmountRP] [float] NULL,
	[TVATRP] [float] NULL,
	[TVATRoundUpRP] [float] NULL,
	[TGrandTotalRP] [float] NULL,
	[Terbilang] [nvarchar](300) NULL,
	[TerbilangEnglish] [nvarchar](300) NULL,
	[Doku] [nvarchar](50) NULL,
	[Tgl] [smalldatetime] NULL,
	[Doku_faktur] [nvarchar](50) NULL,
	[Tgl_faktur] [smalldatetime] NULL,
	[Kode_CustomerGabung] [nvarchar](50) NULL,
	[Nama_CustomerGabung] [nvarchar](255) NULL,
	[NPWP_Gabung] [nvarchar](50) NULL,
	[PKP_Gabung] [nvarchar](50) NULL,
	[Alamat_Gabung] [nvarchar](300) NULL,
	[Memo_Gabung] [nvarchar](300) NULL,
	[KodeRnd] [nvarchar](100) NULL,
	[UserID] [nvarchar](50) NULL,
	[EntryDate] [smalldatetime] NULL,
	[TipeFaktur] [nvarchar](100) NULL,
	[kode_valas] [nvarchar](50) NULL,
	[kurs] [float] NULL,
	[TDP] [float] NULL,
	[MARKING] [nvarchar](1) NULL,
	[ODec] [nvarchar](10) NULL,
	[OMrk] [nvarchar](10) NULL,
	[OGrp] [nvarchar](10) NULL,
	[OPrc] [nvarchar](10) NULL,
	[Memo] [nvarchar](255) NULL,
	[Kode_Customer] [nvarchar](50) NULL,
	[kode_CustomerGANTi] [nvarchar](50) NULL,
	[TTD] [nvarchar](50) NULL,
	[PKBAS] [bigint] IDENTITY(1,1) NOT NULL,
	[EFaktur] [nvarchar](255) NULL,
	[Kode_IDN] [nvarchar](50) NULL,
	[Proyekkd] [nvarchar](20) NULL,
	[csvI] [nvarchar](50) NULL,
	[DokuBC40] [nvarchar](50) NULL,
 CONSTRAINT [PK_FakturPajak] PRIMARY KEY CLUSTERED 
(
	[PKBAS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Gudang]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gudang](
    [Kode] [nvarchar](12) NULL,
    [KodeLama] [nvarchar](12) NULL,
    [Nama] [nvarchar](50) NULL,
    [Aktif] [bit] NULL,
    [NoCounter1] [nvarchar](20) NULL,
    [NoCounter2] [nvarchar](20) NULL,
    [NoCounter3] [nvarchar](20) NULL,
    [TipeIC] [bit] NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Kode_Area] [nvarchar](20) NULL,
    [KodeNum] [smallint] NULL,
    [Alamat1] [nvarchar](50) NULL,
    [Alamat2] [nvarchar](50) NULL,
    [Kota] [nvarchar](30) NULL,
    [FreeSN] [bit] NULL,
    [TipeSRV] [bit] NULL,
    [TipeTTP] [bit] NULL,
    [NewEPK] [nvarchar](50) NULL,
    [id_gudang] [bigint] IDENTITY(1,1) NOT NULL,
    [Email] [nvarchar](255) NULL,
    [PIC] [nvarchar](50) NULL,
    [ByPasSN] [bit] NULL,
    [KodeLokasi] [nvarchar](50) NULL,
    [KodeOpname] [nvarchar](50) NULL,
    [Kode_GudangOpname] [nvarchar](50) NULL,
    [SyncToCMG] [bit] NULL,
    [GudangSync] [nvarchar](25) NULL,
    [Ecom] [bit] NULL,
    [HideReport] [bit] NULL,
    [lat] [varchar](50) NULL,
    [long] [varchar](50) NULL,
    [Kode_Group] [nvarchar](50) NULL,
    [WHBlocked] [bit] NULL,
    [Kode_AreaOld] [nvarchar](50) NULL,
    CONSTRAINT [PK_Gudang] PRIMARY KEY CLUSTERED ([id_gudang]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Gudang] ON [dbo].[Gudang] ([Kode])
GO
/****** Object:  Table [dbo].[LPB]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LPB](
    [Doku] [nvarchar](50) NULL,
    [Tgl] [datetime] NULL,
    [Tgl_Ganti] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](20) NULL,
    [Kode_Dept] [nvarchar](20) NULL,
    [Doku_PO] [nvarchar](50) NULL,
    [SuratJalan] [nvarchar](20) NULL,
    [TglSuratJalan] [smalldatetime] NULL,
    [TglCreate] [smalldatetime] NULL,
    [Tgl_Pembayaran] [smalldatetime] NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPN] [float](53) NULL,
    [PPnTunai] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [Kode_Valas] [nvarchar](20) NULL,
    [Kurs] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [ForwardAgent] [nvarchar](100) NULL,
    [Memo] [nvarchar](78) NULL,
    [STP] [nvarchar](1) NULL,
    [JMRLPB] [smallint] NULL,
    [MOBIL] [nvarchar](10) NULL,
    [STS] [nvarchar](3) NULL,
    [Ext_Doku_PO] [nvarchar](50) NULL,
    [Status] [nvarchar](5) NULL,
    [Status_Edit] [bit] NULL,
    [rptUserId] [nvarchar](100) NULL,
    [StatusGL] [nvarchar](12) NULL,
    [Kode_Sup_Biaya_Asuransi] [nvarchar](50) NULL,
    [Kode_Valas_Asuransi] [nvarchar](10) NULL,
    [KursAsuransi] [float](53) NULL,
    [Biaya_Asuransi] [float](53) NULL,
    [Kode_Sup_Biaya_Interest] [nvarchar](50) NULL,
    [Kode_Valas_Interest] [nvarchar](10) NULL,
    [KursInterest] [float](53) NULL,
    [Biaya_Interest] [float](53) NULL,
    [Kode_Sup_Biaya_Exp1] [nvarchar](50) NULL,
    [Kode_Valas_Exp1] [nvarchar](10) NULL,
    [KursExp1] [float](53) NULL,
    [Biaya_Exp1] [float](53) NULL,
    [Kode_Sup_Biaya_Exp2] [nvarchar](50) NULL,
    [Kode_Valas_Exp2] [nvarchar](10) NULL,
    [KursExp2] [float](53) NULL,
    [Biaya_Exp2] [float](53) NULL,
    [Kode_Sup_Biaya_Angkut] [nvarchar](50) NULL,
    [Kode_Valas_Angkut] [nvarchar](10) NULL,
    [KursAngkut] [float](53) NULL,
    [Biaya_Angkut] [float](53) NULL,
    [Kode_Sup_Biaya_LC] [nvarchar](50) NULL,
    [Kode_Valas_LC] [nvarchar](10) NULL,
    [KursLC] [float](53) NULL,
    [Biaya_LC] [float](53) NULL,
    [Kode_Sup_Biaya_Bea] [nvarchar](50) NULL,
    [Kode_Valas_Bea] [nvarchar](10) NULL,
    [KursBea] [float](53) NULL,
    [Biaya_Bea] [float](53) NULL,
    [Kode_Sup_Biaya_Lain] [nvarchar](50) NULL,
    [Kode_Valas_Lain] [nvarchar](10) NULL,
    [KursLain] [float](53) NULL,
    [Biaya_Lain] [float](53) NULL,
    [STS_Biaya] [nvarchar](3) NULL,
    [Term] [smallint] NULL,
    [Syarat] [smallint] NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Validasi] [bit] NULL,
    [Kode_buyer] [nvarchar](100) NULL,
    [BiayaMasuk] [float](53) NULL,
    [BiayaMasukP] [float](53) NULL,
    [id_lpb] [bigint] IDENTITY(1,1) NOT NULL,
    [Kode_IDN] [nvarchar](50) NULL,
    [ModulSource] [nvarchar](50) NULL,
    [SyncToCMG] [bit] NULL,
    [AWBBL] [nvarchar](100) NULL,
    [Nopen] [nvarchar](50) NULL,
    [Tapen] [smalldatetime] NULL,
    [CreatedInWMS] [bit] NULL,
    [CreatedByInWMS] [nvarchar](50) NULL,
    [CreatedDateInWMS] [datetime] NULL,
    [DPPNilaiLain] [float](53) NULL,
    CONSTRAINT [PK_LPB] PRIMARY KEY CLUSTERED ([id_lpb]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[LPB] ([Tgl]) INCLUDE ([Doku], [Kode_Supplier])
GO
CREATE NONCLUSTERED INDEX [idx_Tgl] ON [dbo].[LPB] ([Tgl])
GO
/****** Object:  Table [dbo].[POSem]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSem](
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](12) NULL,
    [DokuVendor] [nvarchar](100) NULL,
    [TglDokuVendor] [smalldatetime] NULL,
    [BLAWB] [nvarchar](50) NULL,
    [Carrier] [nvarchar](100) NULL,
    [Vessel] [nvarchar](100) NULL,
    [Arrival] [nvarchar](100) NULL,
    [PIUD] [nvarchar](100) NULL,
    [TglPIUD] [smalldatetime] NULL,
    [Ship] [nvarchar](100) NULL,
    [TglShip] [smalldatetime] NULL,
    [TglDeparture] [smalldatetime] NULL,
    [Discharge] [nvarchar](100) NULL,
    [Loading] [nvarchar](100) NULL,
    [CountryOrigin] [nvarchar](100) NULL,
    [TglCountryOrigin] [smalldatetime] NULL,
    [Weight] [float](53) NULL,
    [Memo] [text] NULL,
    [ContactPr] [nvarchar](40) NULL,
    [Syarat] [smallint] NULL,
    [Revisi] [nvarchar](10) NULL,
    [Terms] [nvarchar](50) NULL,
    [PPH22] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPN] [float](53) NULL,
    [PPnBM] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Kode_dept] [nvarchar](12) NULL,
    [LC] [char](2) NULL,
    [Tgl_Pengiriman] [smalldatetime] NULL,
    [Tgl_Pembayaran] [smalldatetime] NULL,
    [Pembayaran] [nvarchar](255) NULL,
    [Penyelesaian] [nvarchar](255) NULL,
    [ADDITIONAL] [nvarchar](20) NULL,
    [PEMBUATAN] [nvarchar](30) NULL,
    [Doku_SPPB] [nvarchar](20) NULL,
    [Jml_Print] [smallint] NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Kurs] [float](53) NULL,
    [Wkt] [smalldatetime] NULL,
    [DokuExt] [nvarchar](20) NULL,
    [STS] [nvarchar](3) NULL,
    [MOS] [nvarchar](100) NULL,
    [Packing] [nvarchar](100) NULL,
    [Sign] [nvarchar](10) NULL,
    [Tipe] [nvarchar](10) NULL,
    [STSPrint] [nvarchar](1) NULL,
    [StsVerify] [bit] NULL,
    [TglVerify] [smalldatetime] NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Kode_buyer] [nvarchar](100) NULL,
    [BiayaMasuk] [float](53) NULL,
    [BiayaMasukP] [float](53) NULL,
    [id_posem] [bigint] IDENTITY(1,1) NOT NULL,
    [Kode_IDN] [nvarchar](50) NULL,
    [ModulSource] [nvarchar](50) NULL,
    [CreatedInWMS] [bit] NULL,
    [CreatedByInWMS] [nvarchar](50) NULL,
    [CreatedDateInWMS] [datetime] NULL,
    [DPPNilaiLain] [float](53) NULL,
    [PPnTunai] [float](53) NULL,
    CONSTRAINT [PK_POSem] PRIMARY KEY CLUSTERED ([id_posem]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_POSem_Doku] ON [dbo].[POSem] ([Doku])
GO
CREATE NONCLUSTERED INDEX [IX_POSem_Kode_Supplier] ON [dbo].[POSem] ([Kode_Supplier]) INCLUDE ([Doku])
GO
/****** Object:  Table [dbo].[PO]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PO](
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](12) NULL,
    [Doku_POSem] [nvarchar](50) NULL,
    [DokuVendor] [nvarchar](100) NULL,
    [TglDokuVendor] [smalldatetime] NULL,
    [BLAWB] [nvarchar](50) NULL,
    [Carrier] [nvarchar](100) NULL,
    [Vessel] [nvarchar](100) NULL,
    [Arrival] [nvarchar](100) NULL,
    [PIUD] [nvarchar](100) NULL,
    [TglPIUD] [smalldatetime] NULL,
    [Ship] [nvarchar](100) NULL,
    [TglShip] [smalldatetime] NULL,
    [TglDeparture] [smalldatetime] NULL,
    [Discharge] [nvarchar](100) NULL,
    [Loading] [nvarchar](100) NULL,
    [CountryOrigin] [nvarchar](100) NULL,
    [TglCountryOrigin] [smalldatetime] NULL,
    [Weight] [float](53) NULL,
    [Memo] [text] NULL,
    [ContactPr] [nvarchar](40) NULL,
    [Syarat] [smallint] NULL,
    [Revisi] [nvarchar](10) NULL,
    [Terms] [nvarchar](50) NULL,
    [PPH22] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPN] [float](53) NULL,
    [PPnBM] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Kode_dept] [nvarchar](12) NULL,
    [LC] [char](2) NULL,
    [Tgl_Pengiriman] [smalldatetime] NULL,
    [Tgl_Pembayaran] [smalldatetime] NULL,
    [Pembayaran] [nvarchar](255) NULL,
    [Penyelesaian] [nvarchar](255) NULL,
    [ADDITIONAL] [nvarchar](20) NULL,
    [PEMBUATAN] [nvarchar](30) NULL,
    [Doku_SPPB] [nvarchar](20) NULL,
    [Jml_Print] [smallint] NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Kurs] [float](53) NULL,
    [Wkt] [smalldatetime] NULL,
    [DokuExt] [nvarchar](20) NULL,
    [STS] [nvarchar](3) NULL,
    [MOS] [nvarchar](100) NULL,
    [Packing] [nvarchar](100) NULL,
    [Sign] [nvarchar](10) NULL,
    [Tipe] [nvarchar](10) NULL,
    [STSPrint] [nvarchar](1) NULL,
    [StsVerify] [bit] NULL,
    [TglVerify] [smalldatetime] NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Kode_buyer] [nvarchar](100) NULL,
    [BiayaMasuk] [float](53) NULL,
    [BiayaMasukP] [float](53) NULL,
    [id_po] [bigint] IDENTITY(1,1) NOT NULL,
    [Kode_IDN] [nvarchar](50) NULL,
    [ModulSource] [nvarchar](50) NULL,
    [CreatedInWMS] [bit] NULL,
    [CreatedByInWMS] [nvarchar](50) NULL,
    [CreatedDateInWMS] [datetime] NULL,
    [DPPNilaiLain] [float](53) NULL,
    [PPnTunai] [float](53) NULL,
    CONSTRAINT [PK_PO] PRIMARY KEY CLUSTERED ([id_po]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<idxGITI>] ON [dbo].[PO] ([Doku])
GO
CREATE NONCLUSTERED INDEX [giti_po_kodeSupplier] ON [dbo].[PO] ([Kode_Supplier]) INCLUDE ([Doku])
GO
/****** Object:  Table [dbo].[SaldoAP]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaldoAP](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
	[Kode_Supplier] [nvarchar](255) NULL,
	[Awal] [float] NULL,
 CONSTRAINT [PK_SaldoAP] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Satuan]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Satuan](
    [id_satuan] [bigint] IDENTITY(1,1) NOT NULL,
    [Kode] [nvarchar](2) NULL,
    [Nama] [nvarchar](10) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    CONSTRAINT [PK_Satuan] PRIMARY KEY CLUSTERED ([id_satuan]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SPB]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SPB](
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [TglVerify] [smalldatetime] NULL,
    [Kode_Customer] [nvarchar](20) NULL,
    [Kode_SubCustomer] [nvarchar](20) NULL,
    [NPO] [nvarchar](150) NULL,
    [TglNPO] [smalldatetime] NULL,
    [Hubungi] [nvarchar](75) NULL,
    [JmlKirim] [float](53) NULL,
    [TglKirim] [smalldatetime] NULL,
    [NamaKirim] [nvarchar](255) NULL,
    [AlmKirim] [nvarchar](255) NULL,
    [PPn] [float](53) NULL,
    [PPnTunai] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [PPnBmTunai] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [Total] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Kurs] [float](53) NULL,
    [Sts] [nvarchar](2) NULL,
    [Status] [nvarchar](20) NULL,
    [Waktu] [smalldatetime] NULL,
    [Ship] [nvarchar](10) NULL,
    [Pay] [nvarchar](10) NULL,
    [Lihat] [nvarchar](1) NULL,
    [Kode_Sales] [nvarchar](12) NULL,
    [JMPRN] [float](53) NULL,
    [Syarat] [float](53) NULL,
    [Kode_Dept] [nvarchar](12) NULL,
    [StsVerify] [bit] NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Kode_CustomerGanti] [nvarchar](50) NULL,
    [NamaProyek] [nvarchar](255) NULL,
    [Doku_PD] [nvarchar](50) NULL,
    [tgl_DokuPD] [smalldatetime] NULL,
    [Doku_Kontrak] [nvarchar](100) NULL,
    [tgl_Kontrak] [smalldatetime] NULL,
    [TipePRoject] [nvarchar](50) NULL,
    [Terbilang] [nvarchar](300) NULL,
    [TerbilangEnglish] [nvarchar](300) NULL,
    [kurspajak] [float](53) NULL,
    [tgl_PD] [smalldatetime] NULL,
    [PPHJasa] [float](53) NULL,
    [GROSS] [float](53) NULL,
    [GRANDTOTAL] [float](53) NULL,
    [DPP] [float](53) NULL,
    [PPHJasaTunai] [float](53) NULL,
    [MEMO] [nvarchar](255) NULL,
    [Hadiah] [bit] NULL,
    [NAMA_PD] [nvarchar](100) NULL,
    [DPP_PD] [float](53) NULL,
    [Kode_PIC] [nvarchar](50) NULL,
    [ProInv] [bit] NULL,
    [NewEPK] [nvarchar](50) NULL,
    [SalesLama] [nvarchar](20) NULL,
    [id_spb] [bigint] IDENTITY(1,1) NOT NULL,
    [HangusSO] [float](53) NULL,
    [NoteHangusSO] [nvarchar](50) NULL,
    [TglSewa1] [smalldatetime] NULL,
    [TglSewa2] [smalldatetime] NULL,
    [PeriodSewa] [int] NULL,
    [DokuSFA] [nvarchar](50) NULL,
    [TglDokuSFA] [smalldatetime] NULL,
    [Titip] [nvarchar](10) NULL,
    [DiskonOth] [float](53) NULL,
    [CDLangsung] [float](53) NULL,
    [Jenis] [nvarchar](30) DEFAULT ('') NOT NULL,
    [KirimKd] [nvarchar](30) DEFAULT ('') NOT NULL,
    [Kode_IDN] [nvarchar](50) NULL,
    [Doku_Sewa] [nvarchar](50) NULL,
    [Rebet] [float](53) NULL,
    [lokasi] [nvarchar](5) NULL,
    [EclipseID] [nvarchar](20) NULL,
    [MCCode] [nvarchar](20) NULL,
    [Kode_MarketSegment] [nvarchar](20) NULL,
    [NIK] [nvarchar](20) NULL,
    [ModulSource] [nvarchar](50) NULL,
    [ClaimCode] [nvarchar](50) NULL,
    [CDLangsungPersen] [float](53) NULL,
    [Kode_MarketSegmentGrup] [nvarchar](20) NULL,
    [Doku_LPB] [nvarchar](50) NULL,
    [NPWPSub] [nvarchar](50) NULL,
    [KursJual] [float](53) NULL,
    [CDOut] [float](53) NULL,
    [CDOutPersen] [float](53) NULL,
    [CDOutTunai] [float](53) NULL,
    [CDOutHari] [int] NULL,
    [CDOutTglAwal] [smalldatetime] NULL,
    [CDOutTglAkhir] [smalldatetime] NULL,
    [CDOutBasicCal] [nvarchar](20) NULL,
    [CDOutDayCal] [nvarchar](20) NULL,
    [NamaPenerima] [nvarchar](50) NULL,
    [Kode_MarketSegmentGrupOld] [nvarchar](10) DEFAULT ('') NOT NULL,
    [BusinessModel] [nvarchar](50) NULL,
    [id_proyek] [bigint] NULL,
    [id_dept] [bigint] NULL,
    [id_sales] [bigint] NULL,
    [id_customer] [bigint] NULL,
    [id_subcustomer] [bigint] NULL,
    [id_pic] [bigint] NULL,
    [Doku_PO] [nvarchar](100) NULL,
    [StsKomisi] [bit] NULL,
    [DPPNilaiLain] [float](53) NULL,
    [Order_Class] [nvarchar](50) NULL,
    [Order_Type] [nvarchar](50) NULL,
    [Kode_Area] [nvarchar](50) NULL,
    [Order_Tupe] [nvarchar](50) NULL,
    CONSTRAINT [PK_SPB] PRIMARY KEY CLUSTERED ([id_spb]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[SPB] ([EntryDate]) INCLUDE ([Doku], [Tgl], [Kode_Customer], [NamaProyek])
GO
CREATE NONCLUSTERED INDEX [1] ON [dbo].[SPB] ([Kode_Dept]) INCLUDE ([Doku], [Tgl], [Kode_Customer], [NPO], [TglKirim], [AlmKirim], [PPnTunai], [DiskonTunai], [Kode_Sales], [NamaProyek], [Doku_PD], [Doku_Kontrak], [GROSS], [GRANDTOTAL], [DPP], [Kode_PIC])
GO
CREATE NONCLUSTERED INDEX [IX_SPB_Doku] ON [dbo].[SPB] ([Doku])
GO
CREATE NONCLUSTERED INDEX [SPB Kode_Customer inc Doku] ON [dbo].[SPB] ([Kode_Customer]) INCLUDE ([Doku])
GO
CREATE NONCLUSTERED INDEX [SPB_Kode_Dept] ON [dbo].[SPB] ([Kode_Dept]) INCLUDE ([Doku], [Tgl], [Kode_Customer], [NamaProyek])
GO
/****** Object:  Table [dbo].[SUBFAKTUR]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUBFAKTUR](
	[kode_BRGganti] [nvarchar](50) NULL,
	[Doku] [nvarchar](50) NULL,
	[Tgl] [smalldatetime] NULL,
	[Kode_Customer] [nvarchar](20) NULL,
	[Kode_Gudang] [nvarchar](20) NULL,
	[Doku_SJ] [nvarchar](50) NULL,
	[Doku_SPB] [nvarchar](50) NULL,
	[NPO] [nvarchar](50) NULL,
	[Kode_Dept] [nvarchar](20) NULL,
	[Kode_Brg] [nvarchar](50) NULL,
	[Alias] [nvarchar](255) NULL,
	[Spec] [nvarchar](10) NULL,
	[Jumlah] [float] NULL,
	[JumlahTemp] [float] NULL,
	[JumlahRetur] [float] NULL,
	[JumlahReturTemp] [float] NULL,
	[Harga] [float] NULL,
	[Hpp] [float] NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[PPN] [float] NULL,
	[PPnBm] [float] NULL,
	[Nilai] [float] NULL,
	[Kode_Valas] [nvarchar](10) NULL,
	[Kurs] [float] NULL,
	[Comercial] [tinyint] NULL,
	[NoUrut] [smallint] NULL,
	[Hapus] [nvarchar](100) NULL,
	[KodeRnd] [nvarchar](100) NULL,
	[UserID] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[JML_Retur_Temp] [float] NULL,
	[Kode_CustomerGanti] [nvarchar](50) NULL,
	[HARGAPAKET] [float] NULL,
	[TipePRoject] [nvarchar](50) NULL,
	[JmlKirim] [float] NULL,
	[JmlKirimTemp] [float] NULL,
	[JumlahVerify] [float] NULL,
	[SisaOrder] [float] NULL,
	[PPnNet] [float] NULL,
	[HargaNet] [float] NULL,
	[HargaPPnNet] [float] NULL,
	[DiskonNet] [float] NULL,
	[Realisasi] [float] NULL,
	[PPhJasa] [float] NULL,
	[KursPajak] [float] NULL,
	[SubTotal] [float] NULL,
	[MajorPSD] [nvarchar](100) NULL,
	[MajorAR] [nvarchar](100) NULL,
	[MajorHPP] [nvarchar](100) NULL,
	[MajorCustomer] [nvarchar](100) NULL,
	[referencecustomer] [nvarchar](100) NULL,
	[MajorPPn] [nvarchar](100) NULL,
	[MajordISKON] [nvarchar](100) NULL,
	[Kode_tujuan] [nvarchar](100) NULL,
	[Doku_paket] [nvarchar](100) NULL,
	[Kode_paket] [nvarchar](100) NULL,
	[Nama_paket] [nvarchar](100) NULL,
	[AlmKirim] [nvarchar](300) NULL,
	[TglKirim] [smalldatetime] NULL,
	[tgl_paket] [smalldatetime] NULL,
	[sts] [nvarchar](100) NULL,
	[Kode_Sales] [nvarchar](100) NULL,
	[HPPGLOBAL] [float] NULL,
	[MODEL] [nvarchar](50) NULL,
	[MAJORPPHJASA] [nvarchar](50) NULL,
	[MAJORPPNBM] [nvarchar](50) NULL,
	[MAJORRETUR] [nvarchar](50) NULL,
	[Memo] [nvarchar](200) NULL,
	[gross] [float] NULL,
	[tgl_kirim] [smalldatetime] NULL,
	[MajorPPbBm] [nvarchar](50) NULL,
	[MajorPPbnBm] [nvarchar](50) NULL,
	[NewEPK] [nvarchar](50) NULL,
	[SalesLama] [nvarchar](20) NULL,
	[PKindex] [bigint] IDENTITY(1,1) NOT NULL,
	[JumlahMin] [float] NULL,
	[ProyekKe] [nvarchar](5) NOT NULL,
	[Proyekkd] [nvarchar](20) NULL,
	[InfoCM] [nvarchar](50) NULL,
	[AliasCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_SUBFAKTUR] PRIMARY KEY CLUSTERED 
(
	[PKindex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubLPB]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubLPB](
    [id_sub_lpb] [bigint] IDENTITY(1,1) NOT NULL,
    [kode_BRGganti] [nvarchar](50) NULL,
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Doku_PO] [nvarchar](50) NULL,
    [Doku_SPPB] [nvarchar](50) NULL,
    [NoUrutSPPB] [smallint] NULL,
    [Kode_Brg] [nvarchar](50) NULL,
    [Kode_Gudang] [nvarchar](10) NULL,
    [Jumlah] [float](53) NULL,
    [JML_LPB_Temp] [float](53) NULL,
    [JML_Retur] [float](53) NULL,
    [JML_Retur_Temp] [float](53) NULL,
    [JumlahKeluar] [float](53) NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Harga] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPN] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [NilaiDistribusi] [float](53) NULL,
    [JML_BYR] [float](53) NULL,
    [TERM_BYR] [smallint] NULL,
    [TglCreate] [smalldatetime] NULL,
    [TGL_BAYAR] [smalldatetime] NULL,
    [MEMO1] [nvarchar](255) NULL,
    [STP] [nvarchar](1) NULL,
    [JMRLPB] [smallint] NULL,
    [NAMAUSER] [nvarchar](20) NULL,
    [Kurs] [float](53) NULL,
    [Kode_Dept_PO] [nvarchar](12) NULL,
    [Ext_Doku_PO] [nvarchar](50) NULL,
    [Keterangan] [nvarchar](50) NULL,
    [SuratJalan] [nvarchar](50) NULL,
    [Tgl_PO] [smalldatetime] NULL,
    [TempNama] [nvarchar](70) NULL,
    [TempOrder] [float](53) NULL,
    [Estimated] [nvarchar](50) NULL,
    [Urut] [float](53) NULL,
    [KodeRnd] [nvarchar](100) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Model] [nvarchar](255) NULL,
    CONSTRAINT [PK_SubLPB] PRIMARY KEY CLUSTERED ([id_sub_lpb]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[SubLPB] ([Tgl]) INCLUDE ([Doku], [Doku_PO], [Kode_Brg], [Jumlah], [KodeRnd])
GO
CREATE NONCLUSTERED INDEX [giti] ON [dbo].[SubLPB] ([Doku_PO], [Tgl]) INCLUDE ([Doku], [Kode_Brg], [Jumlah], [KodeRnd])
GO
CREATE NONCLUSTERED INDEX [SubLPB-Kode_Brg] ON [dbo].[SubLPB] ([Kode_Brg])
GO
CREATE NONCLUSTERED INDEX [Tgl_Index] ON [dbo].[SubLPB] ([Tgl])
GO
/****** Object:  Table [dbo].[SubPOSem]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubPOSem](
    [kode_BRGganti] [nvarchar](50) NULL,
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Doku_SPPB] [nvarchar](20) NULL,
    [NoUrutSPPB] [smallint] NULL,
    [Kode_Brg] [nvarchar](50) NULL,
    [Kode_Dept] [nvarchar](12) NULL,
    [Kode_Gudang] [nvarchar](10) NULL,
    [Alias] [nvarchar](20) NULL,
    [HargaJasa] [float](53) NULL,
    [HargaMaterial] [float](53) NULL,
    [Harga] [float](53) NULL,
    [Total] [float](53) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [Jumlah] [float](53) NULL,
    [JumlahTemp] [float](53) NULL,
    [JumlahKirim] [float](53) NULL,
    [JmlKirimTemp] [float](53) NULL,
    [JumlahVerify] [float](53) NULL,
    [JumlahVerifyTemp] [float](53) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [PPN] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [PPH22] [float](53) NULL,
    [RTPO] [float](53) NULL,
    [REALISASI] [float](53) NULL,
    [TGL_LPB] [smalldatetime] NULL,
    [KETNPSD] [nvarchar](50) NULL,
    [NilValas] [float](53) NULL,
    [Doku_LPB] [nvarchar](12) NULL,
    [ExtDokuPO] [nvarchar](20) NULL,
    [SISA_ORDER_TEMP] [float](53) NULL,
    [REALISASI_TEMP] [float](53) NULL,
    [TempNama] [nvarchar](70) NULL,
    [TglKirim] [smalldatetime] NULL,
    [Major] [nvarchar](20) NULL,
    [Ref] [nvarchar](20) NULL,
    [KodeRnd] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Urut] [float](53) NULL,
    [UserID] [nvarchar](100) NULL,
    [JumlahKonfirm] [float](53) NULL,
    [Doku_SO] [nvarchar](255) NULL,
    [KodeRnd_SO] [nvarchar](255) NULL,
    [id_sub_posem] [bigint] IDENTITY(1,1) NOT NULL,
    [Model] [nvarchar](255) NULL,
    [Merk] [nvarchar](100) NULL,
    [Satuan] [nvarchar](10) NULL,
    [DiscPct] [float] NULL,
    CONSTRAINT [PK_SubPOSem] PRIMARY KEY CLUSTERED ([id_sub_posem]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SubPOSem_Kode_Brg] ON [dbo].[SubPOSem] ([Kode_Brg])
GO
CREATE NONCLUSTERED INDEX [IX_SubPOSem_Doku] ON [dbo].[SubPOSem] ([Doku]) INCLUDE ([Kode_Brg], [KodeRnd])
GO
/****** Object:  Table [dbo].[SubPO]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubPO](
    [kode_BRGganti] [nvarchar](50) NULL,
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Doku_POSem] [nvarchar](50) NULL,
    [Doku_SPPB] [nvarchar](20) NULL,
    [NoUrutSPPB] [smallint] NULL,
    [Kode_Brg] [nvarchar](50) NULL,
    [Kode_Dept] [nvarchar](12) NULL,
    [Kode_Gudang] [nvarchar](10) NULL,
    [Alias] [nvarchar](20) NULL,
    [HargaJasa] [float](53) NULL,
    [HargaMaterial] [float](53) NULL,
    [Harga] [float](53) NULL,
    [Total] [float](53) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [Jumlah] [float](53) NULL,
    [JumlahTemp] [float](53) NULL,
    [JumlahKirim] [float](53) NULL,
    [JmlKirimTemp] [float](53) NULL,
    [JumlahVerify] [float](53) NULL,
    [JumlahVerifyTemp] [float](53) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [PPN] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [PPH22] [float](53) NULL,
    [RTPO] [float](53) NULL,
    [REALISASI] [float](53) NULL,
    [TGL_LPB] [smalldatetime] NULL,
    [KETNPSD] [nvarchar](50) NULL,
    [NilValas] [float](53) NULL,
    [Doku_LPB] [nvarchar](12) NULL,
    [ExtDokuPO] [nvarchar](20) NULL,
    [SISA_ORDER_TEMP] [float](53) NULL,
    [REALISASI_TEMP] [float](53) NULL,
    [TempNama] [nvarchar](70) NULL,
    [TglKirim] [smalldatetime] NULL,
    [Major] [nvarchar](20) NULL,
    [Ref] [nvarchar](20) NULL,
    [KodeRnd] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Urut] [float](53) NULL,
    [UserID] [nvarchar](100) NULL,
    [JumlahKonfirm] [float](53) NULL,
    [Doku_SO] [nvarchar](255) NULL,
    [KodeRnd_SO] [nvarchar](255) NULL,
    [id_sub_po] [bigint] IDENTITY(1,1) NOT NULL,
    [Model] [nvarchar](255) NULL,
    [Merk] [nvarchar](100) NULL,
    [Satuan] [nvarchar](10) NULL,
    [DiscPct] [float] NULL,
    CONSTRAINT [PK_SubPO] PRIMARY KEY CLUSTERED ([id_sub_po]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[SubPO] ([Kode_Brg])
GO
CREATE NONCLUSTERED INDEX [GITI] ON [dbo].[SubPO] ([Doku]) INCLUDE ([Kode_Brg], [KodeRnd])
GO
/****** Object:  Table [dbo].[SubSPB]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubSPB](
    [kode_brgGanti] [nvarchar](50) NULL,
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Kode_Brg] [nvarchar](50) NULL,
    [Kode_Tujuan] [nvarchar](50) NULL,
    [Kode_Gudang] [nvarchar](20) NULL,
    [Alias] [nvarchar](255) NULL,
    [Spec] [nvarchar](10) NULL,
    [Harga] [float](53) NULL,
    [Jumlah] [float](53) NULL,
    [JumlahTemp] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Realisasi] [float](53) NULL,
    [JmlKirim] [float](53) NULL,
    [JmlKirimTemp] [float](53) NULL,
    [JmlKirimSem] [float](53) NULL,
    [JumlahVerify] [float](53) NULL,
    [JumlahVerifyTemp] [float](53) NULL,
    [SisaOrder] [float](53) NULL,
    [TglKirim] [smalldatetime] NULL,
    [AlmKirim] [nvarchar](255) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPn] [float](53) NULL,
    [PPnBm] [nvarchar](50) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Kurs] [float](53) NULL,
    [NoUrut] [smallint] NULL,
    [Kode_Sales] [nvarchar](12) NULL,
    [Sts] [nvarchar](1) NULL,
    [Kode_Dept] [nvarchar](20) NULL,
    [KodeRnd] [nvarchar](255) NULL,
    [UserID] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Hapus] [nvarchar](100) NULL,
    [kursPajak] [float](53) NULL,
    [Doku_Paket] [nvarchar](100) NULL,
    [kode_Paket] [nvarchar](100) NULL,
    [Nama_Paket] [nvarchar](100) NULL,
    [tgl_Paket] [smalldatetime] NULL,
    [PPhJasa] [float](53) NULL,
    [Gross] [float](53) NULL,
    [Dpp] [float](53) NULL,
    [SubTotal] [float](53) NULL,
    [MajorPSD] [nvarchar](50) NULL,
    [MajorAR] [nvarchar](50) NULL,
    [MajorHPP] [nvarchar](50) NULL,
    [MajorCustomer] [nvarchar](50) NULL,
    [ReferenceCustomer] [nvarchar](50) NULL,
    [MajorPPn] [nvarchar](50) NULL,
    [MajorDiskon] [nvarchar](50) NULL,
    [MajorPPnBM] [nvarchar](50) NULL,
    [MajorPPhJasa] [nvarchar](50) NULL,
    [HargaNet] [float](53) NULL,
    [HargaPPnNet] [float](53) NULL,
    [PPnNet] [float](53) NULL,
    [DiskonNet] [float](53) NULL,
    [SN] [int] NULL,
    [TIPEPROJECT] [nvarchar](50) NULL,
    [HPPGLOBAL] [float](53) NULL,
    [HargaPaket] [float](53) NULL,
    [Memo] [nvarchar](255) NULL,
    [NewEPK] [nvarchar](50) NULL,
    [SalesLama] [nvarchar](20) NULL,
    [id_sub_spb] [bigint] IDENTITY(1,1) NOT NULL,
    [JumlahMin] [float](53) NULL,
    [DokuSFA] [nvarchar](50) NULL,
    [Jenis] [nvarchar](30) DEFAULT ('') NOT NULL,
    [KirimKd] [nvarchar](30) DEFAULT ('') NOT NULL,
    [Status] [nvarchar](30) DEFAULT ('') NOT NULL,
    [Jumhar] AS (([jumlah]*[Harga])),
    [Proyekkd] [nvarchar](30) NULL,
    [CustKd] [nvarchar](30) NULL,
    [SerialNumber] [nvarchar](150) NULL,
    [Nm_Brg] [nvarchar](200) NULL,
    [InfoCM] [nvarchar](50) NULL,
    [AliasCode] [nvarchar](50) NULL,
    [id_ktr_psd] [bigint] NULL,
    [id_gudang] [bigint] NULL,
    [id_spb] [bigint] NULL,
    [Doku_PO] [nvarchar](100) NULL,
    CONSTRAINT [PK_SubSPB] PRIMARY KEY CLUSTERED ([id_sub_spb]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[SubSPB] ([Kode_Gudang]) INCLUDE ([Kode_Brg], [Jumlah], [JmlKirim])
GO
CREATE NONCLUSTERED INDEX [IX_SubSPB_Doku] ON [dbo].[SubSPB] ([Doku])
GO
CREATE NONCLUSTERED INDEX [IX_SubSPB_KodeBrg] ON [dbo].[SubSPB] ([Kode_Brg])
GO
CREATE NONCLUSTERED INDEX [IX_SubSPB_KodeRnd] ON [dbo].[SubSPB] ([KodeRnd])
GO
/****** Object:  Table [dbo].[SubTandaTerimaAr]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubTandaTerimaAr](
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [Doku] [nvarchar](75) NULL,
    [Tgl] [datetime] NULL,
    [Kode_Customer] [nvarchar](50) NULL,
    [Doku_Faktur] [nvarchar](50) NULL,
    [Doku_LPB] [nvarchar](50) NULL,
    [SuratJalan] [nvarchar](50) NULL,
    [Giro] [nvarchar](50) NULL,
    [TglGiro] [datetime] NULL,
    [Nilai] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [TotalNilai] [float](53) NULL,
    [STS] [nvarchar](5) NULL,
    [Doku_Muka] [nvarchar](20) NULL,
    [NoUrut] [smallint] NULL,
    [Cara] [nvarchar](100) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Kode_ValasBayar] [nvarchar](10) NULL,
    [NilaiLocal] [float](53) NULL,
    [NilaiForeign] [float](53) NULL,
    [Kurs] [float](53) NULL,
    [KursBayar] [float](53) NULL,
    [KursLocal] [float](53) NULL,
    [KursKonversi] [float](53) NULL,
    [Kode_Bank] [nvarchar](100) NULL,
    [SelisihTagih] [float](53) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [Status] [nvarchar](5) NULL,
    [UserID] [nvarchar](20) NULL,
    [Hapus] [nvarchar](25) NULL,
    [EntryDate] [datetime] NULL,
    [MajorRef] [nvarchar](20) DEFAULT ('') NOT NULL,
    [Reference] [nvarchar](50) NULL,
    [DokuKwitansiAR] [nvarchar](50) NULL,
    [RowVersion] [timestamp] NOT NULL,
    CONSTRAINT [PK_SubTandaTerimaAr] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subTTP]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subTTP](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
	[kode_BRGganti] [nvarchar](50) NULL,
	[Doku] [nvarchar](100) NULL,
	[Tgl] [smalldatetime] NULL,
	[Doku_TTP] [nvarchar](100) NULL,
	[Kode_Customer] [nvarchar](50) NULL,
	[Kode_Brg] [nvarchar](50) NULL,
	[Kode_brgLama] [nvarchar](50) NULL,
	[NAma_brg] [nvarchar](50) NULL,
	[Unit] [nvarchar](50) NULL,
	[Kode_Gudang] [nvarchar](50) NULL,
	[Kode_GudangPinjaman] [nvarchar](50) NULL,
	[Kode_gudangLama] [nvarchar](50) NULL,
	[Kode_Dept] [nvarchar](50) NULL,
	[Kode_deptLama] [nvarchar](50) NULL,
	[Alias] [nvarchar](50) NULL,
	[JumlahAwal] [nvarchar](50) NULL,
	[Jumlah] [float] NULL,
	[JumlahTemp] [float] NULL,
	[JumlahRetur] [float] NULL,
	[JumlahReturTemp] [float] NULL,
	[JumlahReturSem] [float] NULL,
	[JumlahReturSakti] [float] NULL,
	[JumlahSisa] [float] NULL,
	[Harga] [float] NULL,
	[HPP] [float] NULL,
	[Total] [float] NULL,
	[Ket] [nvarchar](255) NULL,
	[NoUrut] [smallint] NULL,
	[KodeRnd] [nvarchar](100) NULL,
	[UserID] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[KODE_CUSTOMERGANTI] [nvarchar](50) NULL,
 CONSTRAINT [PK_subTTP] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[subTTPRetur]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subTTPRetur](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
	[Doku] [nvarchar](25) NULL,
	[Tgl] [smalldatetime] NULL,
	[Doku_TTP] [nvarchar](25) NULL,
	[Kode_Customer] [nvarchar](25) NULL,
	[Kode_Brg] [nvarchar](50) NULL,
	[Kode_BrggANTI] [nvarchar](50) NULL,
	[Kode_Gudang] [nvarchar](25) NULL,
	[Kode_GudangPinjaman] [nvarchar](50) NULL,
	[Kode_Dept] [nvarchar](25) NULL,
	[Alias] [nvarchar](25) NULL,
	[Jumlah] [float] NULL,
	[Harga] [float] NULL,
	[HPP] [float] NULL,
	[Total] [float] NULL,
	[Ket] [nvarchar](255) NULL,
	[NoUrut] [smallint] NULL,
	[KodeRnd] [nvarchar](100) NULL,
	[UserID] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[KODE_CUSTOMERGANTI] [nvarchar](50) NULL,
	[HAPUS] [nvarchar](100) NULL,
 CONSTRAINT [PK_subTTPRetur] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubVoucherAP]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubVoucherAP](
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Doku_LPB] [nvarchar](50) NULL,
    [Doku_PO] [nvarchar](50) NULL,
    [TipeBiaya] [nvarchar](10) NULL,
    [TglDokuLPB] [smalldatetime] NULL,
    [TglDokuPO] [smalldatetime] NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Kurs] [float](53) NULL,
    [KursPajak] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPn] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [Misc] [float](53) NULL,
    [NilaiLPB] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [NoUrut] [smallint] NULL,
    [EntryDate] [smalldatetime] NULL,
    [UserID] [nvarchar](100) NULL,
    [Kode_Supplier] [nvarchar](50) NULL,
    [APRef] [nvarchar](50) NULL,
    [InvoiceNo] [nvarchar](50) NULL,
    [TglInvoice] [smalldatetime] NULL,
    [Doku_FP] [nvarchar](50) NULL,
    [Tgl_FP] [smalldatetime] NULL,
    [SourceType] [nvarchar](20) NULL,
    CONSTRAINT [PK_SubVoucherAP] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[SubVoucherAP] ([Doku])
GO

ALTER TABLE [dbo].[SubVoucherAP]
    ADD CONSTRAINT [CK_SubVoucherAP_TipeBiaya]
    CHECK ([TipeBiaya] IS NULL OR [TipeBiaya] IN ('LPB', 'PO'));
GO

CREATE NONCLUSTERED INDEX [IX_SubVoucherAP_TipeBiaya_Doku]
    ON [dbo].[SubVoucherAP] ([TipeBiaya], [Doku]);
GO

/****** Object:  Table [dbo].[Supplier]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
    [id_supplier] [bigint] IDENTITY(1,1) NOT NULL,
    [KodeEPK] [nvarchar](20) NULL,
    [KodeGTC] [nvarchar](20) NULL,
    [TglMasuk] [smalldatetime] NULL,
    [Kode] [nvarchar](50) NULL,
    [Nama] [nvarchar](255) NULL,
    [KodeLama] [nvarchar](50) NULL,
    [Kode_Dept] [nvarchar](50) NULL,
    [Kode_Area] [nvarchar](50) NULL,
    [NPWP] [nvarchar](50) NULL,
    [PKP] [nvarchar](50) NULL,
    [BankLC] [bit] NULL,
    [Contact1] [nvarchar](255) NULL,
    [Contact2] [nvarchar](255) NULL,
    [Contact3] [nvarchar](255) NULL,
    [Contact4] [nvarchar](255) NULL,
    [Kode_Usaha] [nvarchar](50) NULL,
    [Kode_Sales] [nvarchar](50) NULL,
    [MOS] [nvarchar](50) NULL,
    [Syarat] [smallint] NULL,
    [Limit] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [PHD] [nvarchar](50) NULL,
    [PPN] [float](53) NULL,
    [Major] [nvarchar](50) NULL,
    [Reference] [nvarchar](50) NULL,
    [Alamat1] [nvarchar](255) NULL,
    [Alamat2] [nvarchar](255) NULL,
    [Kota] [nvarchar](255) NULL,
    [Negara] [nvarchar](50) NULL,
    [KodePos] [nvarchar](50) NULL,
    [Telepon] [nvarchar](50) NULL,
    [Fax] [nvarchar](50) NULL,
    [Benua] [nvarchar](50) NULL,
    [Alamat1Pabrik] [nvarchar](255) NULL,
    [Alamat2Pabrik] [nvarchar](255) NULL,
    [KotaPabrik] [nvarchar](255) NULL,
    [NegaraPabrik] [nvarchar](50) NULL,
    [KodePosPabrik] [nvarchar](50) NULL,
    [TeleponPabrik] [nvarchar](50) NULL,
    [FaxPabrik] [nvarchar](50) NULL,
    [BenuaPabrik] [nvarchar](50) NULL,
    [Status] [nvarchar](2) NULL,
    [TipeHarga] [nvarchar](1) NULL,
    [Muka] [float](53) NULL,
    [Giro] [float](53) NULL,
    [Awal] [float](53) NULL,
    [D1] [float](53) NULL,
    [D2] [float](53) NULL,
    [D3] [float](53) NULL,
    [D4] [float](53) NULL,
    [D5] [float](53) NULL,
    [D6] [float](53) NULL,
    [D7] [float](53) NULL,
    [D8] [float](53) NULL,
    [D9] [float](53) NULL,
    [D10] [float](53) NULL,
    [D11] [float](53) NULL,
    [D12] [float](53) NULL,
    [K1] [float](53) NULL,
    [K2] [float](53) NULL,
    [K3] [float](53) NULL,
    [K4] [float](53) NULL,
    [K5] [float](53) NULL,
    [K6] [float](53) NULL,
    [K7] [float](53) NULL,
    [K8] [float](53) NULL,
    [K9] [float](53) NULL,
    [K10] [float](53) NULL,
    [K11] [float](53) NULL,
    [K12] [float](53) NULL,
    [R1] [float](53) NULL,
    [R2] [float](53) NULL,
    [R3] [float](53) NULL,
    [R4] [float](53) NULL,
    [R5] [float](53) NULL,
    [R6] [float](53) NULL,
    [R7] [float](53) NULL,
    [R8] [float](53) NULL,
    [R9] [float](53) NULL,
    [R10] [float](53) NULL,
    [R11] [float](53) NULL,
    [R12] [float](53) NULL,
    [MTU] [nvarchar](12) NULL,
    [VMuka] [float](53) NULL,
    [VGiro] [float](53) NULL,
    [VAwal] [float](53) NULL,
    [VD1] [float](53) NULL,
    [VD2] [float](53) NULL,
    [VD3] [float](53) NULL,
    [VD4] [float](53) NULL,
    [VD5] [float](53) NULL,
    [VD6] [float](53) NULL,
    [VD7] [float](53) NULL,
    [VD8] [float](53) NULL,
    [VD9] [float](53) NULL,
    [VD10] [float](53) NULL,
    [VD11] [float](53) NULL,
    [VD12] [float](53) NULL,
    [VK1] [float](53) NULL,
    [VK2] [float](53) NULL,
    [VK3] [float](53) NULL,
    [VK4] [float](53) NULL,
    [VK5] [float](53) NULL,
    [VK6] [float](53) NULL,
    [VK7] [float](53) NULL,
    [VK8] [float](53) NULL,
    [VK9] [float](53) NULL,
    [VK10] [float](53) NULL,
    [VK11] [float](53) NULL,
    [VK12] [float](53) NULL,
    [VR1] [float](53) NULL,
    [VR2] [float](53) NULL,
    [VR3] [float](53) NULL,
    [VR4] [float](53) NULL,
    [VR5] [float](53) NULL,
    [VR6] [float](53) NULL,
    [VR7] [float](53) NULL,
    [VR8] [float](53) NULL,
    [VR9] [float](53) NULL,
    [VR10] [float](53) NULL,
    [VR11] [float](53) NULL,
    [VR12] [float](53) NULL,
    [TipeHutang] [nvarchar](10) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [ServerFrom] [nvarchar](100) NULL,
    [Alamat1Pajak] [nvarchar](255) NULL,
    [Alamat2Pajak] [nvarchar](255) NULL,
    [Jenis] [nvarchar](50) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [KodePosPajak] [nvarchar](50) NULL,
    [KodeTrim] [nvarchar](50) NULL,
    [KotaPajak] [nvarchar](50) NULL,
    [LOGID] [nvarchar](100) NULL,
    [NamaPajak] [nvarchar](100) NULL,
    [NamaTrim] [nvarchar](100) NULL,
    [NegaraPajak] [nvarchar](50) NULL,
    [PPNGST] [float](53) NULL,
    [Propinsi] [nvarchar](50) NULL,
    [TipeDiskon] [nvarchar](1) NULL,
    [TransferTime] [nvarchar](50) NULL,
    [SupGroup] [nvarchar](100) NULL,
    [Kode_buyer] [nvarchar](100) NULL,
    [SupGroupName] [nvarchar](100) NULL,
    [bPPN] [bit] NULL,
    [VoucherSistem] [bit] NULL,
    [Aktif] [bit] NULL,
    [Email] [nvarchar](150) NULL,
    [Password] [nvarchar](50) NULL,
    [Kode_Customer] [nvarchar](20) NULL,
    [Afiliasi] [bit] NULL,
    CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([id_supplier]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupplierGroup]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupplierGroup](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
	[Kode] [nvarchar](100) NULL,
	[Nama] [nvarchar](100) NULL,
 CONSTRAINT [PK_SupplierGroup] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TandaTerimaAr]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TandaTerimaAr](
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [Doku] [nvarchar](75) NULL,
    [Tgl] [datetime] NULL,
    [Kode_Customer] [nvarchar](20) NULL,
    [Kode_BankCustomer] [nvarchar](20) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [NilKas] [float](53) DEFAULT (((0))) NOT NULL,
    [NilGiro] [float](53) DEFAULT (((0))) NOT NULL,
    [NilAJE] [float](53) DEFAULT (((0))) NOT NULL,
    [NilMuka] [float](53) DEFAULT (((0))) NOT NULL,
    [STS] [nvarchar](1) NULL,
    [Kode_Valas] [nvarchar](20) NULL,
    [Kurs] [float](53) DEFAULT (((0))) NOT NULL,
    [Selisih_Bayar] [float](53) DEFAULT (((0))) NOT NULL,
    [Cara] [nvarchar](20) NULL,
    [Jenis] [nvarchar](20) NULL,
    [Hapus] [nvarchar](50) NULL,
    [UserID] [nvarchar](30) NULL,
    [EntryDate] [nvarchar](30) NULL,
    [StatusGL] [nvarchar](10) NULL,
    [StsTipe] [nvarchar](5) NULL,
    [Selisih_Tagih] [float](53) DEFAULT (((0))) NOT NULL,
    [Nilai] [float](53) DEFAULT (((0))) NOT NULL,
    [InUse] [nvarchar](50) NULL,
    [UserArea] [nvarchar](50) NULL,
    [RowVersion] [timestamp] NOT NULL,
    CONSTRAINT [PK_TandaTerimaAr] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TTP]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TTP](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
	[Doku] [nvarchar](100) NULL,
	[TGL] [smalldatetime] NULL,
	[kode_area] [nvarchar](50) NULL,
	[Kode_Customer] [nvarchar](100) NULL,
	[kode_customerLama] [nvarchar](50) NULL,
	[Nama_customer] [nvarchar](50) NULL,
	[Kode_SubCustomer] [nvarchar](50) NULL,
	[Kode_Dept] [nvarchar](50) NULL,
	[kode_deptlama] [nvarchar](50) NULL,
	[Kode_Gudang] [nvarchar](50) NULL,
	[Kode_gudanglama] [nvarchar](50) NULL,
	[Kode_Sales] [nvarchar](50) NULL,
	[Nama_sales] [nvarchar](50) NULL,
	[Destination] [nvarchar](255) NULL,
	[NamaKirim] [nvarchar](100) NULL,
	[AlmKirim] [nvarchar](200) NULL,
	[Sts] [nvarchar](2) NULL,
	[Sts_Temp] [nvarchar](1) NULL,
	[UserID] [nvarchar](100) NULL,
	[UserUpdate] [nvarchar](100) NULL,
	[Hapus] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[EntryUpdate] [smalldatetime] NULL,
	[Jumlah] [float] NULL,
	[JumlahRetur] [float] NULL,
	[JumlahSisa] [float] NULL,
	[Kode_CustomerGanti] [nvarchar](50) NULL,
	[Validasi] [bit] NULL,
	[DOKU_SJ] [nvarchar](50) NULL,
 CONSTRAINT [PK_TTP] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TTPRetur]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TTPRetur](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
	[Doku] [nvarchar](20) NULL,
	[TGL] [smalldatetime] NULL,
	[Tgl_Ganti] [smalldatetime] NULL,
	[Doku_TTP] [nvarchar](20) NULL,
	[Kode_Customer] [nvarchar](12) NULL,
	[Kode_SubCustomer] [nvarchar](20) NULL,
	[Kode_Dept] [nvarchar](12) NULL,
	[Kode_Gudang] [nvarchar](10) NULL,
	[Total] [float] NULL,
	[Kode_Sales] [nvarchar](12) NULL,
	[Destination] [nvarchar](255) NULL,
	[NamaKirim] [nvarchar](100) NULL,
	[AlmKirim] [nvarchar](200) NULL,
	[Sts] [nvarchar](2) NULL,
	[Sts_Temp] [nvarchar](1) NULL,
	[UserID] [nvarchar](100) NULL,
	[UserCreate] [nvarchar](100) NULL,
	[Hapus] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[Kode_CustomerGanti] [nvarchar](50) NULL,
	[Validasi] [bit] NULL,
	[usernd] [nvarchar](100) NULL,
	[DOKU_SJ] [nvarchar](50) NULL,
 CONSTRAINT [PK_TTPRetur] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Faktur] ADD  CONSTRAINT [DF_Faktur_ProyekKe]  DEFAULT ('') FOR [ProyekKe]
GO
ALTER TABLE [dbo].[Faktur] ADD  CONSTRAINT [Faktur_Retensi]  DEFAULT ((0)) FOR [Retensi]
GO
ALTER TABLE [dbo].[Faktur] ADD  CONSTRAINT [Faktur_Retensip]  DEFAULT ((0)) FOR [Retensip]
GO
ALTER TABLE [dbo].[SUBFAKTUR] ADD  CONSTRAINT [DF_SUBFAKTUR_ProyekKe]  DEFAULT ('') FOR [ProyekKe]
GO

-- =========================================
-- EXTENSIONS: Auth, Idempotency, Push, Concurrency, Missing Tables
-- =========================================

-- Auth: Users table (JWT + Refresh Tokens)
CREATE TABLE [dbo].[Master_Users](
    [UserId] INT IDENTITY(1, 1) PRIMARY KEY,
    [Username] NVARCHAR(100) NOT NULL UNIQUE,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [Role] NVARCHAR(50) NOT NULL DEFAULT 'User',
    [RefreshTokenHash] NVARCHAR(255) NULL,
    [RefreshTokenExpiry] DATETIME2 NULL,
    [RowVersion] ROWVERSION NOT NULL
);
GO

-- Idempotency: Request Dedup
CREATE TABLE [dbo].[Tx_IdempotencyRecord](
    [IdempotencyKey] NVARCHAR(100) PRIMARY KEY,
    [RequestHash] NVARCHAR(64) NOT NULL,
    [ResponseStatusCode] INT NOT NULL,
    [ResponseBody] NVARCHAR(MAX) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    [ExpiresAt] DATETIME2 NOT NULL
);
GO

-- Push: Web Push Subscription Store
CREATE TABLE [dbo].[Tx_PushSubscription](
    [SubscriptionId] INT IDENTITY(1, 1) PRIMARY KEY,
    [UserId] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Master_Users](UserId),
    [Endpoint] NVARCHAR(500) NOT NULL,
    [P256dh] NVARCHAR(255) NOT NULL,
    [AuthKey] NVARCHAR(255) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- VoucherAP (prod-faithful column names: TglDoku, no Kode_Bank, no Status)
-- ponytail: trimmed ~120 paired cost-*/FP columns from prod's 140-col VoucherAP;
--           re-add from fetched_ddl.sql if AP cost-distribution rows are needed.
/****** Object:  Table [dbo].[VoucherAP]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoucherAP](
    [Doku] [nvarchar](50) NULL,
    [TglDoku] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](20) NULL,
    [Kode_Dept] [nvarchar](20) NULL,
    [Doku_LPB] [nvarchar](50) NULL,
    [Doku_PO] [nvarchar](50) NULL,
    [TipeBiaya] [nvarchar](10) NULL,
    [TglDokuLPB] [smalldatetime] NULL,
    [TglDokuPO] [smalldatetime] NULL,
    [Syarat] [smallint] NULL,
    [TglJatuhTempo] [smalldatetime] NULL,
    [Kode_Valas] [nvarchar](12) NULL,
    [Kurs] [float](53) NULL,
    [KursPajak] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPn] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [Misc] [float](53) NULL,
    [NilaiLPB] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Keterangan] [nvarchar](255) NULL,
    [STS] [nvarchar](2) NULL,
    [Tipe] [nvarchar](10) NULL,
    [Doku_Asuransi] [nvarchar](30) NULL,
    [TglAsuransi] [smalldatetime] NULL,
    [SyaratAsuransi] [smallint] NULL,
    [Kode_Sup_Biaya_Asuransi] [nvarchar](20) NULL,
    [PPnAsuransi] [float](53) NULL,
    [Kode_Valas_Asuransi] [nvarchar](20) NULL,
    [KursAsuransi] [float](53) NULL,
    [Biaya_Asuransi] [float](53) NULL,
    [Doku_Interest] [nvarchar](30) NULL,
    [TglInterest] [smalldatetime] NULL,
    [SyaratInterest] [smallint] NULL,
    [Kode_Sup_Biaya_Interest] [nvarchar](20) NULL,
    [PPnInterest] [float](53) NULL,
    [Kode_Valas_Interest] [nvarchar](20) NULL,
    [KursInterest] [float](53) NULL,
    [Biaya_Interest] [float](53) NULL,
    [Doku_Exp1] [nvarchar](30) NULL,
    [TglExp1] [smalldatetime] NULL,
    [SyaratExp1] [smallint] NULL,
    [Kode_Sup_Biaya_Exp1] [nvarchar](20) NULL,
    [PPnExp1] [float](53) NULL,
    [Kode_Valas_Exp1] [nvarchar](20) NULL,
    [KursExp1] [float](53) NULL,
    [Biaya_Exp1] [float](53) NULL,
    [Doku_Exp2] [nvarchar](30) NULL,
    [TglExp2] [smalldatetime] NULL,
    [SyaratExp2] [smallint] NULL,
    [Kode_Sup_Biaya_Exp2] [nvarchar](20) NULL,
    [PPnExp2] [float](53) NULL,
    [Kode_Valas_Exp2] [nvarchar](20) NULL,
    [KursExp2] [float](53) NULL,
    [Biaya_Exp2] [float](53) NULL,
    [Doku_Angkut] [nvarchar](30) NULL,
    [TglAngkut] [smalldatetime] NULL,
    [SyaratAngkut] [smallint] NULL,
    [Kode_Sup_Biaya_Angkut] [nvarchar](20) NULL,
    [PPnAngkut] [float](53) NULL,
    [Kode_Valas_Angkut] [nvarchar](20) NULL,
    [KursAngkut] [float](53) NULL,
    [Biaya_Angkut] [float](53) NULL,
    [Doku_LC] [nvarchar](30) NULL,
    [TglLC] [smalldatetime] NULL,
    [SyaratLC] [smallint] NULL,
    [Kode_Sup_Biaya_LC] [nvarchar](20) NULL,
    [PPnLC] [float](53) NULL,
    [Kode_Valas_LC] [nvarchar](20) NULL,
    [KursLC] [float](53) NULL,
    [Biaya_LC] [float](53) NULL,
    [Doku_Bea] [nvarchar](30) NULL,
    [TglBea] [smalldatetime] NULL,
    [SyaratBea] [smallint] NULL,
    [Kode_Sup_Biaya_Bea] [nvarchar](20) NULL,
    [PPnBea] [float](53) NULL,
    [Kode_Valas_Bea] [nvarchar](20) NULL,
    [KursBea] [float](53) NULL,
    [Biaya_Bea] [float](53) NULL,
    [Doku_Lain] [nvarchar](30) NULL,
    [TglLain] [smalldatetime] NULL,
    [SyaratLain] [smallint] NULL,
    [Kode_Sup_Biaya_Lain] [nvarchar](20) NULL,
    [PPnLain] [float](53) NULL,
    [Kode_Valas_Lain] [nvarchar](20) NULL,
    [KursLain] [float](53) NULL,
    [Biaya_Lain] [float](53) NULL,
    [Doku_Rev] [nvarchar](30) NULL,
    [TglRev] [smalldatetime] NULL,
    [Kode_Sup_Biaya_Rev] [nvarchar](20) NULL,
    [Kode_Valas_Rev] [nvarchar](20) NULL,
    [KursRev] [float](53) NULL,
    [Biaya_Rev] [float](53) NULL,
    [Recalculate] [nvarchar](15) NULL,
    [NoUrut] [smallint] NULL,
    [EntryDate] [smalldatetime] NULL,
    [UserID] [nvarchar](100) NULL,
    [Doku_LC2] [nvarchar](30) NULL,
    [TGLLC2] [smalldatetime] NULL,
    [SYARATLC2] [smallint] NULL,
    [Kode_Sup_Biaya_Lc2] [nvarchar](20) NULL,
    [Kode_valas_LC2] [nvarchar](20) NULL,
    [KursLC2] [float](53) NULL,
    [Biaya_LC2] [float](53) NULL,
    [Doku_LC3] [nvarchar](30) NULL,
    [TGLLC3] [smalldatetime] NULL,
    [SYARATLC3] [smallint] NULL,
    [Kode_Sup_Biaya_Lc3] [nvarchar](20) NULL,
    [Kode_valas_LC3] [nvarchar](20) NULL,
    [KursLC3] [float](53) NULL,
    [Biaya_LC3] [float](53) NULL,
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [Doku_AsuransiFP] [nvarchar](50) NULL,
    [Doku_InterestFP] [nvarchar](50) NULL,
    [Doku_Exp1FP] [nvarchar](50) NULL,
    [Doku_Exp2FP] [nvarchar](50) NULL,
    [Doku_AngkutFP] [nvarchar](50) NULL,
    [Doku_LCFP] [nvarchar](50) NULL,
    [Doku_BeaFP] [nvarchar](50) NULL,
    [TglAsuransiFP] [smalldatetime] NULL,
    [TglInterestFP] [smalldatetime] NULL,
    [TglExp1FP] [smalldatetime] NULL,
    [TglExp2FP] [smalldatetime] NULL,
    [TglAngkutFP] [smalldatetime] NULL,
    [TglLCFP] [smalldatetime] NULL,
    [TglBeaFP] [smalldatetime] NULL,
    [Doku_FP] [nvarchar](50) NULL,
    [Tgl_FP] [smalldatetime] NULL,
    [EFaktur] [nvarchar](255) NULL,
    [Doku_LC2FP] [nvarchar](50) NULL,
    [Doku_LC3FP] [nvarchar](50) NULL,
    [TglLC2FP] [smalldatetime] NULL,
    [TglLC3FP] [smalldatetime] NULL,
    [DokuPIB] [nvarchar](50) NULL,
    [TglPIB] [smalldatetime] NULL,
    [PPnTunai] [float](53) NULL,
    [PPnAsuransiTunai] [float](53) NULL,
    [PPnInterestTunai] [float](53) NULL,
    [PPnExp1Tunai] [float](53) NULL,
    [PPnExp2Tunai] [float](53) NULL,
    [PPnLCTunai] [float](53) NULL,
    [PPnLC2Tunai] [float](53) NULL,
    [PPnLC3Tunai] [float](53) NULL,
    [PPnAngkutTunai] [float](53) NULL,
    [PPnLainTunai] [float](53) NULL,
    [Doku_LainFP] [nvarchar](50) NULL,
    [TglLainFP] [smalldatetime] NULL,
    [TglFP] [smalldatetime] NULL,
    [PPnLC2] [float](53) NULL,
    [PPnLC3] [float](53) NULL,
    [Kode_IDN] [nvarchar](50) NULL,
    [ModulSource] [nvarchar](50) NULL,
    [MajorDiskon] [nvarchar](20) NULL,
    [AWBBL] [nvarchar](100) NULL,
    [DPPNilaiLain] [float](53) NULL,
    [NOPEN] [nvarchar](50) NULL,
    [TglNopen] [smalldatetime] NULL,
    [AWB_BL] [nvarchar](50) NULL,
    [SourceType] [nvarchar](20) NULL,
    [RowVersion] [timestamp] NOT NULL,
    CONSTRAINT [PK_VoucherAP] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VoucherAP] ON [dbo].[VoucherAP] ([TglDoku])
GO

ALTER TABLE [dbo].[VoucherAP]
    ADD CONSTRAINT [CK_VoucherAP_TipeBiaya]
    CHECK ([TipeBiaya] IS NULL OR [TipeBiaya] IN ('LPB', 'PO'));
GO

CREATE NONCLUSTERED INDEX [IX_VoucherAP_TipeBiaya_Doku]
    ON [dbo].[VoucherAP] ([TipeBiaya], [Doku]);
GO

-- Hiapt02 (prod-faithful: Doku_Faktur/Giro/Kode_Bank FX-payment columns)
/****** Object:  Table [dbo].[Hiapt02]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hiapt02](
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [Doku] [varchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](20) NULL,
    [Doku_Faktur] [nvarchar](50) NULL,
    [Doku_LPB] [nvarchar](50) NULL,
    [SuratJalan] [nvarchar](50) NULL,
    [Giro] [nvarchar](25) NULL,
    [TglGiro] [smalldatetime] NULL,
    [Nilai] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [TotalNilai] [float](53) NULL,
    [Sts] [nvarchar](1) NULL,
    [Doku_Muka] [nvarchar](50) NULL,
    [NoUrut] [smallint] NULL,
    [Cara] [nvarchar](100) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Kode_ValasBayar] [nvarchar](10) NULL,
    [NilaiLocal] [float](53) NULL,
    [NilaiForeign] [float](53) NULL,
    [Kurs] [float](53) NULL,
    [KursBayar] [float](53) NULL,
    [KursLocal] [float](53) NULL,
    [KursKonversi] [float](53) NULL,
    [Kode_Bank] [nvarchar](20) NULL,
    [SelisihTagih] [float](53) NULL,
    [Keterangan] [nvarchar](100) NULL,
    [Status] [nvarchar](1) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [Kode_Dept] [nvarchar](10) NULL,
    [Reference] [nvarchar](20) NULL,
    [NoUrutDN] [int] NULL,
    [ReferenceKasBank] [nvarchar](50) NULL,
    [FakturPajak] [nvarchar](30) NULL,
    CONSTRAINT [PK_Hiapt02] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReturBeli]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturBeli](
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [Doku] [nvarchar](50) NULL,
    [Tgl] [smalldatetime] NULL,
    [Doku_Faktur] [nvarchar](50) NULL,
    [Kode_Supplier] [nvarchar](20) NULL,
    [Kode_Dept] [nvarchar](20) NULL,
    [Kode_Gudang] [nvarchar](20) NULL,
    [PPn] [float](53) NULL,
    [PPnTunai] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [Total] [float](53) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Kurs] [float](53) NULL,
    [STS] [nvarchar](2) NULL,
    [LIHAT] [nvarchar](1) NULL,
    [MATERAI] [float](53) NULL,
    [NILAI] [float](53) NULL,
    [NILAI_MUKA] [float](53) NULL,
    [SYARAT] [float](53) NULL,
    [AlmKirim] [nvarchar](50) NULL,
    [Type] [nvarchar](50) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [StatusGL] [nvarchar](10) NULL,
    [Kode_buyer] [nvarchar](100) NULL,
    [TipeRetur] [nvarchar](10) NULL,
    [Validasi] [bit] NULL,
    [Doku_FP] [nvarchar](50) NULL,
    [Tgl_FP] [smalldatetime] NULL,
    [EFaktur] [nvarchar](255) NULL,
    [MEMO] [nvarchar](255) NULL,
    [Kode_IDN] [nvarchar](50) NULL,
    [SyncToCMG] [bit] NULL,
    [CreatedInWMS] [bit] NULL,
    [CreatedByInWMS] [nvarchar](50) NULL,
    [CreatedDateInWMS] [datetime] NULL,
    [RowVersion] [timestamp] NOT NULL,
    CONSTRAINT [PK_ReturBeli] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubReturBeli]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubReturBeli](
    [PKbas] [bigint] IDENTITY(1,1) NOT NULL,
    [kode_BRGganti] [nvarchar](50) NULL,
    [Doku] [nvarchar](25) NULL,
    [Tgl] [smalldatetime] NULL,
    [Kode_Supplier] [nvarchar](20) NULL,
    [Doku_Faktur2] [nvarchar](20) NULL,
    [NPO] [nvarchar](50) NULL,
    [Kode_Dept] [nvarchar](20) NULL,
    [Kode_Brg] [nvarchar](50) NULL,
    [Kode_Gudang] [nvarchar](20) NULL,
    [Alias] [nvarchar](20) NULL,
    [Jumlah] [float](53) NULL,
    [Harga] [float](53) NULL,
    [HPP] [float](53) NULL,
    [Diskon] [float](53) NULL,
    [DiskonTunai] [float](53) NULL,
    [PPN] [float](53) NULL,
    [PPnBm] [float](53) NULL,
    [Nilai] [float](53) NULL,
    [Kode_Valas] [nvarchar](10) NULL,
    [Kurs] [float](53) NULL,
    [Comercial] [tinyint] NULL,
    [NoUrut] [smallint] NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [KodeRnd] [nvarchar](100) NULL,
    [Doku_Faktur] [nvarchar](50) NULL,
    [Doku_LPB] [nvarchar](50) NULL,
    [RowVersion] [timestamp] NOT NULL,
    CONSTRAINT [PK_SubReturBeli] PRIMARY KEY CLUSTERED ([PKbas]) ON [PRIMARY]
) ON [PRIMARY]
GO



-- Optimistic Concurrency: RowVersion on transaction headers
ALTER TABLE [dbo].[SPB] ADD [RowVersion] ROWVERSION NOT NULL;
GO
ALTER TABLE [dbo].[POSem] ADD [RowVersion] ROWVERSION NOT NULL;
GO
ALTER TABLE [dbo].[PO] ADD [RowVersion] ROWVERSION NOT NULL;
GO
ALTER TABLE [dbo].[LPB] ADD [RowVersion] ROWVERSION NOT NULL;
GO
ALTER TABLE [dbo].[Faktur] ADD [RowVersion] ROWVERSION NOT NULL;
GO
ALTER TABLE [dbo].[Hiapt06] ADD [RowVersion] ROWVERSION NOT NULL;
GO
ALTER TABLE [dbo].[Supplier] ADD [RowVersion] ROWVERSION NOT NULL;
GO


-- =========================================
-- PROD-FAITHFUL EXTENSIONS (fetched from XTechnologies2018IN via sys.columns)
-- =========================================

-- Department master. Prod's dbo.Dept has id_dept IDENTITY PK; Kode is a natural key.
-- ponytail: trimmed Dept's print-layout + approver columns; re-add if PO/Faktur
--           signature-block rendering is needed.
/****** Object:  Table [dbo].[Dept]    Script Date: 07/28/2026 03:12:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dept](
    [KodeGTC] [nvarchar](12) NULL,
    [KodeEPK] [nvarchar](12) NULL,
    [Kode] [nvarchar](20) NULL,
    [Nama] [nvarchar](50) NULL,
    [NoCounter1] [nvarchar](20) NULL,
    [Nama10] [nvarchar](50) NULL,
    [Nama11] [nvarchar](50) NULL,
    [Nama12] [nvarchar](50) NULL,
    [Jabatan10] [nvarchar](50) NULL,
    [Jabatan11] [nvarchar](50) NULL,
    [Jabatan12] [nvarchar](50) NULL,
    [NoCounter2] [nvarchar](20) NULL,
    [Nama20] [nvarchar](50) NULL,
    [Nama21] [nvarchar](50) NULL,
    [Nama22] [nvarchar](50) NULL,
    [Jabatan20] [nvarchar](50) NULL,
    [Jabatan21] [nvarchar](50) NULL,
    [Jabatan22] [nvarchar](50) NULL,
    [NoCounter3] [nvarchar](20) NULL,
    [Nama30] [nvarchar](50) NULL,
    [Nama31] [nvarchar](50) NULL,
    [Nama32] [nvarchar](50) NULL,
    [Jabatan30] [nvarchar](50) NULL,
    [Jabatan31] [nvarchar](50) NULL,
    [Jabatan32] [nvarchar](50) NULL,
    [NoCounter4] [nvarchar](20) NULL,
    [Nama40] [nvarchar](50) NULL,
    [Nama41] [nvarchar](50) NULL,
    [Nama42] [nvarchar](50) NULL,
    [Jabatan40] [nvarchar](50) NULL,
    [Jabatan41] [nvarchar](50) NULL,
    [Jabatan42] [nvarchar](50) NULL,
    [NoCounter5] [nvarchar](20) NULL,
    [Nama50] [nvarchar](50) NULL,
    [Nama51] [nvarchar](50) NULL,
    [Nama52] [nvarchar](50) NULL,
    [Jabatan50] [nvarchar](50) NULL,
    [Jabatan51] [nvarchar](50) NULL,
    [Jabatan52] [nvarchar](50) NULL,
    [NamaUser] [nvarchar](50) NULL,
    [TglUpDate] [smalldatetime] NULL,
    [NoPO] [nvarchar](20) NULL,
    [SignPO] [nvarchar](35) NULL,
    [PossPO] [nvarchar](35) NULL,
    [NoFaktur] [nvarchar](20) NULL,
    [SignFaktur] [nvarchar](35) NULL,
    [PossFaktur] [nvarchar](35) NULL,
    [Head] [nvarchar](35) NULL,
    [Chief] [nvarchar](35) NULL,
    [Staff] [nvarchar](35) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [NewEPK] [nvarchar](50) NULL,
    [SYARAT] [int] NULL,
    [id_dept] [bigint] IDENTITY(1,1) NOT NULL,
    [HideReport] [bit] NULL,
    [dept_group] [varchar](50) NULL,
    [NonAktif] [bit] NULL,
    [NonAktifTime] [smalldatetime] NULL,
    [Kode_Master_Department] [nvarchar](50) NULL,
    CONSTRAINT [PK_Dept] PRIMARY KEY CLUSTERED ([id_dept]) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Area master (Kode_Area on Supplier/Gudang/Bank)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area](
    [id_area] [bigint] IDENTITY(1,1) NOT NULL,
    [KodeGTC] [nvarchar](12) NULL,
    [KodeEPK] [nvarchar](12) NULL,
    [Kode] [nvarchar](50) NULL,
    [Nama] [nvarchar](255) NULL,
    [Lokasi] [nvarchar](255) NULL,
    [NoCounter1] [nvarchar](50) NULL,
    [NoCounter2] [nvarchar](50) NULL,
    [NoCounter3] [nvarchar](50) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [ALAMAT1] [nvarchar](250) NULL,
    [ALAMAT2] [nvarchar](250) NULL,
    [NPWP] [nvarchar](100) NULL,
    [PT] [nvarchar](100) NULL,
    [NewEPK] [nvarchar](50) NULL,
    [kodelama] [nvarchar](50) NULL,
    [KodeAcer] [nvarchar](50) NULL,
    [KodeECom] [nvarchar](20) NULL,
    [HideReport] [bit] NULL,
    [kode_master_area] [varchar](50) NULL,
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED
 ([id_area] ASC) WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Sales rep master (Kode_Sales on Supplier/SubSPB/Faktur)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales](
    [id_sales] [bigint] IDENTITY(1,1) NOT NULL,
    [Kode] [nvarchar](12) NULL,
    [KodeLama] [nvarchar](12) NULL,
    [Nama] [nvarchar](50) NULL,
    [NoCounter1] [nvarchar](50) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [kode_area] [nvarchar](20) NULL,
    [NewEPK] [nvarchar](50) NULL,
    [Telepon1] [nvarchar](20) NULL,
    [Telepon2] [nvarchar](20) NULL,
    [email] [nvarchar](50) NULL,
    [no_rekening] [varchar](50) NULL,
    [UserLogin] [varchar](50) NULL,
    [handphone] [varchar](30) NULL,
    [kode_admin] [varchar](50) NULL,
    [Diskontinue] [bit] NULL,
    [TglDiskontinue] [datetime] NULL,
    [Kode_AreaOld] [nvarchar](50) NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED
 ([id_sales] ASC) WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Currency rate history (Kode_Valas on transaction headers). Loose, no PK.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VALAS2](
    [Keterangan] [varchar](255) NULL,
    [Tanggal] [datetime2](7) NULL,
    [RateBI] [real] NULL,
    [RatePajak] [real] NULL,
    [Rate] [real] NULL,
    [Kode] [varchar](50) NULL
) ON [PRIMARY]
GO

-- Item transfer type (48 rows); referenced by stock movements / TTP family.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JenisTransferBarang](
    [IdJenisTransferBarang] [bigint] IDENTITY(1,1) NOT NULL,
    [Kode] [nvarchar](20) NULL,
    [Nama] [nvarchar](100) NULL,
    [Major] [nvarchar](20) NULL,
    [UserID] [nvarchar](100) NULL,
    [Hapus] [nvarchar](100) NULL,
    [EntryDate] [smalldatetime] NULL,
    [ShowDOJ] [int] NULL,
    [SJLoanJurnal] [bit] NULL,
 CONSTRAINT [PK_JenisTransferBarang] PRIMARY KEY CLUSTERED
 ([IdJenisTransferBarang] ASC) WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Current stock balance per item/warehouse/dept. Loose (no PK in prod).
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SKU_Stok](
    [Kode_Brand] [varchar](50) NULL,
    [kode_dept] [varchar](50) NULL,
    [Lokasi] [varchar](50) NULL,
    [ItemCode] [varchar](50) NULL,
    [kode_baru] [varchar](50) NULL,
    [Kode_Gudang] [varchar](50) NULL,
    [Qty] [varchar](50) NULL
) ON [PRIMARY]
GO

-- Monthly stock/saldo history per item/dept/area. Composite PK.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistStokMon](
    [ItemCode] [nvarchar](50) NOT NULL,
    [Period] [datetime] NOT NULL,
    [Kode_Dept] [nvarchar](20) NOT NULL,
    [Stok] [float] NOT NULL,
    [Saldo] [float] NOT NULL,
    [Kode_Area] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_histstokmon] PRIMARY KEY CLUSTERED
 ([ItemCode] ASC, [Kode_Dept] ASC, [Period] ASC, [Kode_Area] ASC)
 WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Stock count header (Opname). 0 rows in prod but schema provided for completeness.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRStokOpname](
    [Doku] [nvarchar](50) NOT NULL,
    [Tgl] [smalldatetime] NOT NULL,
    [GudangCode] [nvarchar](20) NOT NULL,
    [Ket] [nvarchar](255) NOT NULL,
    [CreatedBy] [nvarchar](50) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [CreatedFromModul] [nvarchar](50) NOT NULL,
    [LastUpdatedBy] [nvarchar](50) NOT NULL,
    [LastUpdatedDate] [datetime] NOT NULL,
    [LastUpdatedFromModul] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TRStokOpname] PRIMARY KEY CLUSTERED
 ([Doku] ASC) WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Stock count line. Composite PK (Doku + Kode).
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRStokOpnameSub](
    [Doku] [nvarchar](50) NOT NULL,
    [Kode] [nvarchar](50) NOT NULL,
    [Stok] [float] NOT NULL,
    [Qty] [float] NOT NULL,
    [Ket] [nvarchar](255) NOT NULL,
    [UnitCode] [nvarchar](20) NOT NULL,
    [Adj] [float] NOT NULL,
    [AD] [int] NOT NULL,
 CONSTRAINT [PK_TRStokOpnameSub] PRIMARY KEY CLUSTERED
 ([Doku] ASC, [Kode] ASC) WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON) ON [PRIMARY]
) ON [PRIMARY]
GO
