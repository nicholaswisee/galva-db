USE [XTechnologies2018IN]
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
/****** Object:  Table [dbo].[Bank]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bank](
	[Kode] [nvarchar](20) NULL,
	[KodeLama] [nvarchar](50) NULL,
	[Nama] [nvarchar](100) NULL,
	[LookupBank] [bit] NULL,
	[Major] [nvarchar](12) NULL,
	[Kode_JenisBayar] [nvarchar](20) NULL,
	[Reference] [nvarchar](12) NULL,
	[Kode_Valas] [nvarchar](12) NULL,
	[Alamat1] [nvarchar](50) NULL,
	[Alamat2] [nvarchar](50) NULL,
	[Kota] [nvarchar](35) NULL,
	[KodePos] [nvarchar](20) NULL,
	[Telepon] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[AC] [nvarchar](35) NULL,
	[AN] [nvarchar](50) NULL,
	[Awal] [float] NULL,
	[Masuk] [float] NULL,
	[Keluar] [float] NULL,
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
 CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED 
(
	[PKindex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Barang]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Barang](
	[Kode] [nvarchar](50) NULL,
	[Nama] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bayar]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bayar](
	[Doku] [varchar](50) NULL,
	[Tgl] [smalldatetime] NULL,
	[Kode_Supplier] [nvarchar](50) NULL,
	[Kode_BankSupplier] [nvarchar](50) NULL,
	[Keterangan] [nvarchar](255) NULL,
	[NilaiKas] [float] NULL,
	[NilaiGiro] [float] NULL,
	[NilaiAJE] [float] NULL,
	[NilMuka] [float] NULL,
	[STS] [nvarchar](1) NULL,
	[Kode_Valas] [nvarchar](12) NULL,
	[Kurs] [float] NULL,
	[Selisih_Bayar] [float] NULL,
	[Cara] [nvarchar](20) NULL,
	[Jenis] [nvarchar](10) NULL,
	[Hapus] [nvarchar](100) NULL,
	[UserID] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[StatusGL] [nvarchar](12) NULL,
	[PKindex] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Bayar] PRIMARY KEY CLUSTERED 
(
	[PKindex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Category]    Script Date: 6/26/2026 3:26:09 PM ******/
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
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[id_category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
/****** Object:  Table [dbo].[Gudang]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[WHBlocked] [bit] NULL,
	[Kode_AreaOld] [nvarchar](50) NULL,
 CONSTRAINT [PK_Gudang] PRIMARY KEY CLUSTERED 
(
	[id_gudang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LPB]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[PPN] [float] NULL,
	[PPnTunai] [float] NULL,
	[PPnBm] [float] NULL,
	[Kode_Valas] [nvarchar](20) NULL,
	[Kurs] [float] NULL,
	[Nilai] [float] NULL,
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
	[KursAsuransi] [float] NULL,
	[Biaya_Asuransi] [float] NULL,
	[Kode_Sup_Biaya_Interest] [nvarchar](50) NULL,
	[Kode_Valas_Interest] [nvarchar](10) NULL,
	[KursInterest] [float] NULL,
	[Biaya_Interest] [float] NULL,
	[Kode_Sup_Biaya_Exp1] [nvarchar](50) NULL,
	[Kode_Valas_Exp1] [nvarchar](10) NULL,
	[KursExp1] [float] NULL,
	[Biaya_Exp1] [float] NULL,
	[Kode_Sup_Biaya_Exp2] [nvarchar](50) NULL,
	[Kode_Valas_Exp2] [nvarchar](10) NULL,
	[KursExp2] [float] NULL,
	[Biaya_Exp2] [float] NULL,
	[Kode_Sup_Biaya_Angkut] [nvarchar](50) NULL,
	[Kode_Valas_Angkut] [nvarchar](10) NULL,
	[KursAngkut] [float] NULL,
	[Biaya_Angkut] [float] NULL,
	[Kode_Sup_Biaya_LC] [nvarchar](50) NULL,
	[Kode_Valas_LC] [nvarchar](10) NULL,
	[KursLC] [float] NULL,
	[Biaya_LC] [float] NULL,
	[Kode_Sup_Biaya_Bea] [nvarchar](50) NULL,
	[Kode_Valas_Bea] [nvarchar](10) NULL,
	[KursBea] [float] NULL,
	[Biaya_Bea] [float] NULL,
	[Kode_Sup_Biaya_Lain] [nvarchar](50) NULL,
	[Kode_Valas_Lain] [nvarchar](10) NULL,
	[KursLain] [float] NULL,
	[Biaya_Lain] [float] NULL,
	[STS_Biaya] [nvarchar](3) NULL,
	[Term] [smallint] NULL,
	[Syarat] [smallint] NULL,
	[UserID] [nvarchar](100) NULL,
	[Hapus] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[Validasi] [bit] NULL,
	[Kode_buyer] [nvarchar](100) NULL,
	[BiayaMasuk] [float] NULL,
	[BiayaMasukP] [float] NULL,
	[id_lpb] [bigint] IDENTITY(1,1) NOT NULL,
	[Kode_IDN] [nvarchar](50) NULL,
	[ModulSource] [nvarchar](50) NULL,
	[SyncToCMG] [bit] NULL,
	[CreatedInWMS] [bit] NULL,
	[CreatedByInWMS] [nvarchar](50) NULL,
	[CreatedDateInWMS] [datetime] NULL,
	[DPPNilaiLain] [float] NULL,
 CONSTRAINT [PK_LPB] PRIMARY KEY CLUSTERED 
(
	[id_lpb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PO]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
	[Weight] [float] NULL,
	[Memo] [text] NULL,
	[ContactPr] [nvarchar](40) NULL,
	[Syarat] [smallint] NULL,
	[Revisi] [nvarchar](10) NULL,
	[Terms] [nvarchar](50) NULL,
	[PPH22] [float] NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[PPN] [float] NULL,
	[PPnBM] [float] NULL,
	[Nilai] [float] NULL,
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
	[Kurs] [float] NULL,
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
	[BiayaMasuk] [float] NULL,
	[BiayaMasukP] [float] NULL,
	[id_po] [bigint] IDENTITY(1,1) NOT NULL,
	[Kode_IDN] [nvarchar](50) NULL,
	[ModulSource] [nvarchar](50) NULL,
	[CreatedInWMS] [bit] NULL,
	[CreatedByInWMS] [nvarchar](50) NULL,
	[CreatedDateInWMS] [datetime] NULL,
	[DPPNilaiLain] [float] NULL,
	[PPnTunai] [float] NULL,
 CONSTRAINT [PK_PO] PRIMARY KEY CLUSTERED 
(
	[id_po] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
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
/****** Object:  Table [dbo].[Satuan]    Script Date: 6/26/2026 3:26:09 PM ******/
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
 CONSTRAINT [PK_Satuan] PRIMARY KEY CLUSTERED 
(
	[id_satuan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SPB]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[NPO] [nvarchar](50) NULL,
	[TglNPO] [smalldatetime] NULL,
	[Hubungi] [nvarchar](75) NULL,
	[JmlKirim] [float] NULL,
	[TglKirim] [smalldatetime] NULL,
	[NamaKirim] [nvarchar](255) NULL,
	[AlmKirim] [nvarchar](255) NULL,
	[PPn] [float] NULL,
	[PPnTunai] [float] NULL,
	[PPnBm] [float] NULL,
	[PPnBmTunai] [float] NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[Total] [float] NULL,
	[Nilai] [float] NULL,
	[Kode_Valas] [nvarchar](12) NULL,
	[Kurs] [float] NULL,
	[Sts] [nvarchar](2) NULL,
	[Status] [nvarchar](20) NULL,
	[Waktu] [smalldatetime] NULL,
	[Ship] [nvarchar](10) NULL,
	[Pay] [nvarchar](10) NULL,
	[Lihat] [nvarchar](1) NULL,
	[Kode_Sales] [nvarchar](12) NULL,
	[JMPRN] [float] NULL,
	[Syarat] [float] NULL,
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
	[kurspajak] [float] NULL,
	[tgl_PD] [smalldatetime] NULL,
	[PPHJasa] [float] NULL,
	[GROSS] [float] NULL,
	[GRANDTOTAL] [float] NULL,
	[DPP] [float] NULL,
	[PPHJasaTunai] [float] NULL,
	[MEMO] [nvarchar](255) NULL,
	[Hadiah] [bit] NULL,
	[NAMA_PD] [nvarchar](100) NULL,
	[DPP_PD] [float] NULL,
	[Kode_PIC] [nvarchar](50) NULL,
	[ProInv] [bit] NULL,
	[NewEPK] [nvarchar](50) NULL,
	[SalesLama] [nvarchar](20) NULL,
	[id_spb] [bigint] IDENTITY(1,1) NOT NULL,
	[HangusSO] [float] NULL,
	[NoteHangusSO] [nvarchar](50) NULL,
	[TglSewa1] [smalldatetime] NULL,
	[TglSewa2] [smalldatetime] NULL,
	[PeriodSewa] [int] NULL,
	[DokuSFA] [nvarchar](50) NULL,
	[TglDokuSFA] [smalldatetime] NULL,
	[Titip] [nvarchar](10) NULL,
	[DiskonOth] [float] NULL,
	[CDLangsung] [float] NULL,
	[Jenis] [nvarchar](30) NOT NULL,
	[KirimKd] [nvarchar](30) NOT NULL,
	[Kode_IDN] [nvarchar](50) NULL,
	[Doku_Sewa] [nvarchar](50) NULL,
	[Rebet] [float] NULL,
	[lokasi] [nvarchar](5) NULL,
	[EclipseID] [nvarchar](20) NULL,
	[MCCode] [nvarchar](20) NULL,
	[Kode_MarketSegment] [nvarchar](20) NULL,
	[NIK] [nvarchar](20) NULL,
	[ModulSource] [nvarchar](50) NULL,
	[ClaimCode] [nvarchar](50) NULL,
	[CDLangsungPersen] [float] NULL,
	[Kode_MarketSegmentGrup] [nvarchar](20) NULL,
	[Doku_LPB] [nvarchar](50) NULL,
	[NPWPSub] [nvarchar](50) NULL,
	[KursJual] [float] NULL,
	[CDOut] [float] NULL,
	[CDOutPersen] [float] NULL,
	[CDOutTunai] [float] NULL,
	[CDOutHari] [int] NULL,
	[CDOutTglAwal] [smalldatetime] NULL,
	[CDOutTglAkhir] [smalldatetime] NULL,
	[CDOutBasicCal] [nvarchar](20) NULL,
	[CDOutDayCal] [nvarchar](20) NULL,
	[NamaPenerima] [nvarchar](50) NULL,
	[Kode_MarketSegmentGrupOld] [nvarchar](10) NOT NULL,
	[BusinessModel] [nvarchar](50) NULL,
	[Order_Class] [nvarchar](50) NULL,
	[Order_Type] [nvarchar](50) NULL,
	[Kode_Area] [nvarchar](50) NULL,
 CONSTRAINT [PK_SPB] PRIMARY KEY CLUSTERED 
(
	[id_spb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

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
/****** Object:  Table [dbo].[SubLPB]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[Jumlah] [float] NULL,
	[JML_LPB_Temp] [float] NULL,
	[JML_Retur] [float] NULL,
	[JML_Retur_Temp] [float] NULL,
	[JumlahKeluar] [float] NULL,
	[Kode_Valas] [nvarchar](12) NULL,
	[Harga] [float] NULL,
	[Nilai] [float] NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[PPN] [float] NULL,
	[PPnBm] [float] NULL,
	[NilaiDistribusi] [float] NULL,
	[JML_BYR] [float] NULL,
	[TERM_BYR] [smallint] NULL,
	[TglCreate] [smalldatetime] NULL,
	[TGL_BAYAR] [smalldatetime] NULL,
	[MEMO1] [nvarchar](255) NULL,
	[STP] [nvarchar](1) NULL,
	[JMRLPB] [smallint] NULL,
	[NAMAUSER] [nvarchar](20) NULL,
	[Kurs] [float] NULL,
	[Kode_Dept_PO] [nvarchar](12) NULL,
	[Ext_Doku_PO] [nvarchar](50) NULL,
	[Keterangan] [nvarchar](50) NULL,
	[SuratJalan] [nvarchar](50) NULL,
	[Tgl_PO] [smalldatetime] NULL,
	[TempNama] [nvarchar](70) NULL,
	[TempOrder] [float] NULL,
	[Estimated] [nvarchar](50) NULL,
	[Urut] [float] NULL,
	[KodeRnd] [nvarchar](100) NULL,
	[UserID] [nvarchar](100) NULL,
	[Hapus] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[Model] [nvarchar](255) NULL,
 CONSTRAINT [PK_SubLPB] PRIMARY KEY CLUSTERED 
(
	[id_sub_lpb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubPO]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[HargaJasa] [float] NULL,
	[HargaMaterial] [float] NULL,
	[Harga] [float] NULL,
	[Total] [float] NULL,
	[Kode_Valas] [nvarchar](10) NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[Jumlah] [float] NULL,
	[JumlahTemp] [float] NULL,
	[JumlahKirim] [float] NULL,
	[JmlKirimTemp] [float] NULL,
	[JumlahVerify] [float] NULL,
	[JumlahVerifyTemp] [float] NULL,
	[Keterangan] [nvarchar](255) NULL,
	[PPN] [float] NULL,
	[PPnBm] [float] NULL,
	[PPH22] [float] NULL,
	[RTPO] [float] NULL,
	[REALISASI] [float] NULL,
	[TGL_LPB] [smalldatetime] NULL,
	[KETNPSD] [nvarchar](50) NULL,
	[NilValas] [float] NULL,
	[Doku_LPB] [nvarchar](12) NULL,
	[ExtDokuPO] [nvarchar](20) NULL,
	[SISA_ORDER_TEMP] [float] NULL,
	[REALISASI_TEMP] [float] NULL,
	[TempNama] [nvarchar](70) NULL,
	[TglKirim] [smalldatetime] NULL,
	[Major] [nvarchar](20) NULL,
	[Ref] [nvarchar](20) NULL,
	[KodeRnd] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[Urut] [float] NULL,
	[UserID] [nvarchar](100) NULL,
	[JumlahKonfirm] [float] NULL,
	[Doku_SO] [nvarchar](255) NULL,
	[KodeRnd_SO] [nvarchar](255) NULL,
	[id_sub_po] [bigint] IDENTITY(1,1) NOT NULL,
	[Model] [nvarchar](255) NULL,
 CONSTRAINT [PK_SubPO] PRIMARY KEY CLUSTERED 
(
	[id_sub_po] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubSPB]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[Harga] [float] NULL,
	[Jumlah] [float] NULL,
	[JumlahTemp] [float] NULL,
	[Nilai] [float] NULL,
	[Realisasi] [float] NULL,
	[JmlKirim] [float] NULL,
	[JmlKirimTemp] [float] NULL,
	[JmlKirimSem] [float] NULL,
	[JumlahVerify] [float] NULL,
	[JumlahVerifyTemp] [float] NULL,
	[SisaOrder] [float] NULL,
	[TglKirim] [smalldatetime] NULL,
	[AlmKirim] [nvarchar](255) NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[PPn] [float] NULL,
	[PPnBm] [nvarchar](50) NULL,
	[Kode_Valas] [nvarchar](10) NULL,
	[Kurs] [float] NULL,
	[NoUrut] [smallint] NULL,
	[Kode_Sales] [nvarchar](12) NULL,
	[Sts] [nvarchar](1) NULL,
	[Kode_Dept] [nvarchar](20) NULL,
	[KodeRnd] [nvarchar](255) NULL,
	[UserID] [nvarchar](100) NULL,
	[EntryDate] [smalldatetime] NULL,
	[Hapus] [nvarchar](100) NULL,
	[kursPajak] [float] NULL,
	[Doku_Paket] [nvarchar](100) NULL,
	[kode_Paket] [nvarchar](100) NULL,
	[Nama_Paket] [nvarchar](100) NULL,
	[tgl_Paket] [smalldatetime] NULL,
	[PPhJasa] [float] NULL,
	[Gross] [float] NULL,
	[Dpp] [float] NULL,
	[SubTotal] [float] NULL,
	[MajorPSD] [nvarchar](50) NULL,
	[MajorAR] [nvarchar](50) NULL,
	[MajorHPP] [nvarchar](50) NULL,
	[MajorCustomer] [nvarchar](50) NULL,
	[ReferenceCustomer] [nvarchar](50) NULL,
	[MajorPPn] [nvarchar](50) NULL,
	[MajorDiskon] [nvarchar](50) NULL,
	[MajorPPnBM] [nvarchar](50) NULL,
	[MajorPPhJasa] [nvarchar](50) NULL,
	[HargaNet] [float] NULL,
	[HargaPPnNet] [float] NULL,
	[PPnNet] [float] NULL,
	[DiskonNet] [float] NULL,
	[SN] [int] NULL,
	[TIPEPROJECT] [nvarchar](50) NULL,
	[HPPGLOBAL] [float] NULL,
	[HargaPaket] [float] NULL,
	[Memo] [nvarchar](255) NULL,
	[NewEPK] [nvarchar](50) NULL,
	[SalesLama] [nvarchar](20) NULL,
	[id_sub_spb] [bigint] IDENTITY(1,1) NOT NULL,
	[JumlahMin] [float] NULL,
	[DokuSFA] [nvarchar](50) NULL,
	[Jenis] [nvarchar](30) NOT NULL,
	[KirimKd] [nvarchar](30) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[Jumhar]  AS ([jumlah]*[Harga]),
	[Proyekkd] [nvarchar](30) NULL,
	[CustKd] [nvarchar](30) NULL,
	[SerialNumber] [nvarchar](150) NULL,
	[Nm_Brg] [nvarchar](200) NULL,
	[InfoCM] [nvarchar](50) NULL,
	[AliasCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_SubSPB] PRIMARY KEY CLUSTERED 
(
	[id_sub_spb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubTandaTerimaAr]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[Nilai] [float] NULL,
	[DiskonTunai] [float] NULL,
	[TotalNilai] [float] NULL,
	[STS] [nvarchar](5) NULL,
	[Doku_Muka] [nvarchar](20) NULL,
	[NoUrut] [smallint] NULL,
	[Cara] [nvarchar](100) NULL,
	[Kode_Valas] [nvarchar](10) NULL,
	[Kode_ValasBayar] [nvarchar](10) NULL,
	[NilaiLocal] [float] NULL,
	[NilaiForeign] [float] NULL,
	[Kurs] [float] NULL,
	[KursBayar] [float] NULL,
	[KursLocal] [float] NULL,
	[KursKonversi] [float] NULL,
	[Kode_Bank] [nvarchar](100) NULL,
	[SelisihTagih] [float] NULL,
	[Keterangan] [nvarchar](255) NULL,
	[Status] [nvarchar](5) NULL,
	[UserID] [nvarchar](20) NULL,
	[Hapus] [nvarchar](25) NULL,
	[EntryDate] [datetime] NULL,
	[MajorRef] [nvarchar](20) NOT NULL,
	[Reference] [nvarchar](50) NULL,
	[DokuKwitansiAR] [nvarchar](50) NULL,
 CONSTRAINT [PK_SubTandaTerimaAr] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
/****** Object:  Table [dbo].[SubVoucherAP]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[Kurs] [float] NULL,
	[KursPajak] [float] NULL,
	[Diskon] [float] NULL,
	[DiskonTunai] [float] NULL,
	[PPn] [float] NULL,
	[PPnBm] [float] NULL,
	[Misc] [float] NULL,
	[NilaiLPB] [float] NULL,
	[Nilai] [float] NULL,
	[Keterangan] [nvarchar](255) NULL,
	[NoUrut] [smallint] NULL,
	[EntryDate] [smalldatetime] NULL,
	[UserID] [nvarchar](100) NULL,
	[Kode_Supplier] [nvarchar](50) NULL,
 CONSTRAINT [PK_SubVoucherAP] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 6/26/2026 3:26:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[PKbas] [bigint] IDENTITY(1,1) NOT NULL,
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
	[Limit] [float] NULL,
	[Diskon] [float] NULL,
	[PHD] [nvarchar](50) NULL,
	[PPN] [float] NULL,
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
	[Muka] [float] NULL,
	[Giro] [float] NULL,
	[Awal] [float] NULL,
	[D1] [float] NULL,
	[D2] [float] NULL,
	[D3] [float] NULL,
	[D4] [float] NULL,
	[D5] [float] NULL,
	[D6] [float] NULL,
	[D7] [float] NULL,
	[D8] [float] NULL,
	[D9] [float] NULL,
	[D10] [float] NULL,
	[D11] [float] NULL,
	[D12] [float] NULL,
	[K1] [float] NULL,
	[K2] [float] NULL,
	[K3] [float] NULL,
	[K4] [float] NULL,
	[K5] [float] NULL,
	[K6] [float] NULL,
	[K7] [float] NULL,
	[K8] [float] NULL,
	[K9] [float] NULL,
	[K10] [float] NULL,
	[K11] [float] NULL,
	[K12] [float] NULL,
	[R1] [float] NULL,
	[R2] [float] NULL,
	[R3] [float] NULL,
	[R4] [float] NULL,
	[R5] [float] NULL,
	[R6] [float] NULL,
	[R7] [float] NULL,
	[R8] [float] NULL,
	[R9] [float] NULL,
	[R10] [float] NULL,
	[R11] [float] NULL,
	[R12] [float] NULL,
	[MTU] [nvarchar](12) NULL,
	[VMuka] [float] NULL,
	[VGiro] [float] NULL,
	[VAwal] [float] NULL,
	[VD1] [float] NULL,
	[VD2] [float] NULL,
	[VD3] [float] NULL,
	[VD4] [float] NULL,
	[VD5] [float] NULL,
	[VD6] [float] NULL,
	[VD7] [float] NULL,
	[VD8] [float] NULL,
	[VD9] [float] NULL,
	[VD10] [float] NULL,
	[VD11] [float] NULL,
	[VD12] [float] NULL,
	[VK1] [float] NULL,
	[VK2] [float] NULL,
	[VK3] [float] NULL,
	[VK4] [float] NULL,
	[VK5] [float] NULL,
	[VK6] [float] NULL,
	[VK7] [float] NULL,
	[VK8] [float] NULL,
	[VK9] [float] NULL,
	[VK10] [float] NULL,
	[VK11] [float] NULL,
	[VK12] [float] NULL,
	[VR1] [float] NULL,
	[VR2] [float] NULL,
	[VR3] [float] NULL,
	[VR4] [float] NULL,
	[VR5] [float] NULL,
	[VR6] [float] NULL,
	[VR7] [float] NULL,
	[VR8] [float] NULL,
	[VR9] [float] NULL,
	[VR10] [float] NULL,
	[VR11] [float] NULL,
	[VR12] [float] NULL,
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
	[PPNGST] [float] NULL,
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
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
/****** Object:  Table [dbo].[TandaTerimaAr]    Script Date: 6/26/2026 3:26:09 PM ******/
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
	[NilKas] [float] NOT NULL,
	[NilGiro] [float] NOT NULL,
	[NilAJE] [float] NOT NULL,
	[NilMuka] [float] NOT NULL,
	[STS] [nvarchar](1) NULL,
	[Kode_Valas] [nvarchar](20) NULL,
	[Kurs] [float] NOT NULL,
	[Selisih_Bayar] [float] NOT NULL,
	[Cara] [nvarchar](20) NULL,
	[Jenis] [nvarchar](20) NULL,
	[Hapus] [nvarchar](50) NULL,
	[UserID] [nvarchar](30) NULL,
	[EntryDate] [nvarchar](30) NULL,
	[StatusGL] [nvarchar](10) NULL,
	[StsTipe] [nvarchar](5) NULL,
	[Selisih_Tagih] [float] NOT NULL,
	[Nilai] [float] NOT NULL,
	[InUse] [nvarchar](50) NULL,
	[UserArea] [nvarchar](50) NULL,
 CONSTRAINT [PK_TandaTerimaAr] PRIMARY KEY CLUSTERED 
(
	[PKbas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
ALTER TABLE [dbo].[SPB] ADD  CONSTRAINT [DF_SPB_Jenis]  DEFAULT ('') FOR [Jenis]
GO
ALTER TABLE [dbo].[SPB] ADD  CONSTRAINT [DF_SPB_KirimKd]  DEFAULT ('') FOR [KirimKd]
GO
ALTER TABLE [dbo].[SPB] ADD  CONSTRAINT [SPB_Kode_MarketSegmentGrupOld]  DEFAULT ('') FOR [Kode_MarketSegmentGrupOld]
GO
ALTER TABLE [dbo].[SUBFAKTUR] ADD  CONSTRAINT [DF_SUBFAKTUR_ProyekKe]  DEFAULT ('') FOR [ProyekKe]
GO
ALTER TABLE [dbo].[SubSPB] ADD  CONSTRAINT [DF_SubSPB_Jenis]  DEFAULT ('') FOR [Jenis]
GO
ALTER TABLE [dbo].[SubSPB] ADD  CONSTRAINT [DF_SubSPB_KirimKd]  DEFAULT ('') FOR [KirimKd]
GO
ALTER TABLE [dbo].[SubSPB] ADD  CONSTRAINT [DF_SubSPB_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[SubTandaTerimaAr] ADD  CONSTRAINT [DF_SubTandaTerimaAr_MajorRef]  DEFAULT ('') FOR [MajorRef]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_NilKas]  DEFAULT ((0)) FOR [NilKas]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_NilGiro]  DEFAULT ((0)) FOR [NilGiro]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_NilAJE]  DEFAULT ((0)) FOR [NilAJE]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_NilMuka]  DEFAULT ((0)) FOR [NilMuka]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_Kurs]  DEFAULT ((0)) FOR [Kurs]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_Selisih_Bayar]  DEFAULT ((0)) FOR [Selisih_Bayar]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_Selisih_Tagih]  DEFAULT ((0)) FOR [Selisih_Tagih]
GO
ALTER TABLE [dbo].[TandaTerimaAr] ADD  CONSTRAINT [DF_TandaTerimaAr_Nilai]  DEFAULT ((0)) FOR [Nilai]
GO
