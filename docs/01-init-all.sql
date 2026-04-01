-- Создание базы данных, если она не существует
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RusalIntermediate')
BEGIN
    CREATE DATABASE [RusalIntermediate];
    PRINT 'Database RusalIntermediate created';
END
GO

-- Переключение на базу данных RusalIntermediate
USE [RusalIntermediate];
GO
CREATE TABLE [UsdExchangeRatesByYear] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [RateCode] nvarchar(30) NOT NULL,
  [Date] datetime2 NOT NULL,
  [RateValueToUsd] float NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [UsdExchangeRatesByMonth] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [RateCode] nvarchar(30) NOT NULL,
  [Date] datetime2 NOT NULL,
  [RateValueToUsd] float NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [CorporateApproval] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [GoverningBody] nvarchar(250) NOT NULL,
  [Description] nvarchar(500),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [OrganizationalAndLegalForm] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [FullName] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ExpenseItem] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [FullName] nvarchar(250) NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [TmcCode] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [ParentTmcCode] nvarchar(150),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [OkvedCode] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [ParentOkvedCode] nvarchar(150),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Division] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [ParentDivision] nvarchar(150),
  [Note] nvarchar(max),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [PlanningAndBudgetUnit] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [InvestmentActivity] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [EngName] nvarchar(250),
  [Code] nvarchar(12) NOT NULL,
  [Year] nvarchar(4) NOT NULL,
  [PlanningAndBudgetUnitCode] nvarchar(30) NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [TaxAccreditationStatus] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(64) NOT NULL,
  [EngName] nvarchar(64) NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ComplianceAccreditationStatuse] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(64) NOT NULL,
  [EngName] nvarchar(64) NOT NULL,
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [DocumentKind] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [AbbreviatedName] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [DocumentTypeId] bigint NOT NULL,
  [DocumentFlow] nvarchar(15),
  [NumberingType] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Country] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(3),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Document] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [DocumentType] int NOT NULL,
  [DocumentKind] nvarchar(30) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Subject] nvarchar(250),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [DocVersion] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [AddendumPaydoxId] nvarchar(190),
  [MigrationId] int,
  [RxId] bigint,
  [Filepath] nvarchar(3000) UNIQUE NOT NULL,
  [Name] nvarchar(250),
  [RxDocId] bigint,
  [RxVersionId] bigint,
  [IsMain] bit NOT NULL,
  [IsSignature] bit NOT NULL,
  [MainDocFilepath] nvarchar(3000),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Курсы валют к USD (годовой)]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Курсы валют к USD (месячный)]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Корпоративное одобрение]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Организационно-правовые формы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Статьи расходов]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Укрупненное название статьи расхода',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'FullName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [ТМЦ]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'ParentTmcCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [ОКВЭД]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'ParentOkvedCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Дивизионы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'ParentDivision';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Планово-бюджетные единицы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Инвестиционные мероприятия]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'PaydoxId планово-бюджетной единицы',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'PlanningAndBudgetUnitCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Статусы налоговой аккредитации]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Справочник «Статусы комплаенс аккредитации]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Виды документов]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Incoming | Outgoing | Inner | Contracts',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'DocumentFlow';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Numerable | NotNumerable | Registrable',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'NumberingType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Страны]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Таблица [Документы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentKind';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Таблица [Версии документов]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор приложения, сгенерированный DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'AddendumPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Путь к файлу на сетевом диске',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'Filepath';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Имя файла (приложения). Если это не основной документ, чтобы понимать как назвать карточку приложения',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Версия документа в RX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'RxVersionId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Признак основного документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'IsMain';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Признак файла подписи',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'IsSignature';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Для подписи — ссылка на версию основного файла',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MainDocFilepath';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'Result';
GO

ALTER TABLE [DocVersion] ADD FOREIGN KEY ([MainDocFilepath]) REFERENCES [DocVersion] ([Filepath])
GO

-- =====================================================
-- Вставка тестовых данных (по 100 записей в каждую таблицу)
-- Генерация через WHILE, поля Result/MigrateTime/MigrateMessage не заполняются
-- =====================================================

-- 1. UsdExchangeRatesByYear
IF NOT EXISTS (SELECT 1 FROM [UsdExchangeRatesByYear])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        DECLARE @rateCode NVARCHAR(10) = CASE WHEN @i % 2 = 0 THEN N'EUR' ELSE N'USD' END
        DECLARE @year INT = 2000 + (@i % 25)
        INSERT INTO [UsdExchangeRatesByYear] ([PaydoxId], [Name], [MigrationId], [RateCode], [Date], [RateValueToUsd], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            @rateCode + N' Rate ' + CAST(@year AS NVARCHAR),
            NULL,
            @rateCode,
            DATEFROMPARTS(@year, 12, 31),
            ROUND(60 + (@i % 50) * 0.7, 2),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 2. UsdExchangeRatesByMonth
IF NOT EXISTS (SELECT 1 FROM [UsdExchangeRatesByMonth])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        DECLARE @rateCode2 NVARCHAR(10) = CASE WHEN @i % 2 = 0 THEN N'EUR' ELSE N'USD' END
        DECLARE @month INT = ((@i - 1) % 12) + 1
        DECLARE @year2 INT = 2020 + (@i / 12)
        DECLARE @lastDay INT = CASE @month
            WHEN 2 THEN CASE WHEN @year2 % 4 = 0 THEN 29 ELSE 28 END
            WHEN 4 THEN 30 WHEN 6 THEN 30 WHEN 9 THEN 30 WHEN 11 THEN 30
            ELSE 31 END
        INSERT INTO [UsdExchangeRatesByMonth] ([PaydoxId], [Name], [MigrationId], [RateCode], [Date], [RateValueToUsd], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            @rateCode2 + N' Rate ' + RIGHT('0' + CAST(@month AS NVARCHAR), 2) + N'.' + CAST(@year2 AS NVARCHAR),
            NULL,
            @rateCode2,
            DATEFROMPARTS(@year2, @month, @lastDay),
            ROUND(CASE WHEN @rateCode2 = N'USD' THEN 75 + (@i % 30) * 0.8 ELSE 1.05 + (@i % 20) * 0.01 END, 2),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 3. CorporateApproval
IF NOT EXISTS (SELECT 1 FROM [CorporateApproval])
BEGIN
    DECLARE @i INT = 1
    DECLARE @bodies NVARCHAR(MAX) = N'Board of Directors|Audit Committee|Remuneration Committee|Strategy Committee|Risk Committee'
    WHILE @i <= 100
    BEGIN
        DECLARE @bodyIdx INT = ((@i - 1) % 5) + 1
        DECLARE @body NVARCHAR(100) = TRIM(VALUE) FROM STRING_SPLIT(@bodies, '|') ORDER BY (SELECT NULL) OFFSET @bodyIdx - 1 ROWS FETCH NEXT 1 ROWS ONLY
        INSERT INTO [CorporateApproval] ([PaydoxId], [MigrationId], [GoverningBody], [Description], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            @body,
            N'Approval item #' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 4. OrganizationalAndLegalForm
IF NOT EXISTS (SELECT 1 FROM [OrganizationalAndLegalForm])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [OrganizationalAndLegalForm] ([PaydoxId], [MigrationId], [FullName], [Code], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Организационно-правовая форма ' + CAST(@i AS NVARCHAR),
            N'ОПФ' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 5. ExpenseItem
IF NOT EXISTS (SELECT 1 FROM [ExpenseItem])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [ExpenseItem] ([PaydoxId], [MigrationId], [Name], [FullName], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Статья расходов ' + CAST(@i AS NVARCHAR),
            N'Полное наименование статьи расходов ' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 6. TmcCode (первые 10 - корневые, остальные ссылаются на корневые)
IF NOT EXISTS (SELECT 1 FROM [TmcCode])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        DECLARE @parentTmc NVARCHAR(150) = CASE
            WHEN @i <= 10 THEN NULL
            ELSE CAST(((@i - 11) % 10) + 1 AS NVARCHAR)
        END
        INSERT INTO [TmcCode] ([PaydoxId], [MigrationId], [Name], [Code], [ParentTmcCode], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'ТМЦ ' + CAST(@i AS NVARCHAR),
            N'TMC' + CAST(@i AS NVARCHAR),
            @parentTmc,
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 7. OkvedCode (первые 10 - корневые, остальные ссылаются на корневые)
IF NOT EXISTS (SELECT 1 FROM [OkvedCode])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        DECLARE @parentOkv NVARCHAR(150) = CASE
            WHEN @i <= 10 THEN NULL
            ELSE CAST(((@i - 11) % 10) + 1 AS NVARCHAR)
        END
        INSERT INTO [OkvedCode] ([PaydoxId], [MigrationId], [Name], [Code], [ParentOkvedCode], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Код ОКВЭД ' + CAST(@i AS NVARCHAR),
            CAST(@i AS NVARCHAR) + '.' + CAST(@i % 9 AS NVARCHAR),
            @parentOkv,
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 8. Division (первые 10 - корневые, остальные ссылаются на корневые)
IF NOT EXISTS (SELECT 1 FROM [Division])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        DECLARE @parentDiv NVARCHAR(150) = CASE
            WHEN @i <= 10 THEN NULL
            ELSE CAST(((@i - 11) % 10) + 1 AS NVARCHAR)
        END
        INSERT INTO [Division] ([PaydoxId], [MigrationId], [Name], [Code], [ParentDivision], [Note], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Подразделение ' + CAST(@i AS NVARCHAR),
            N'DIV' + CAST(@i AS NVARCHAR),
            @parentDiv,
            N'Примечание к подразделению ' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 9. PlanningAndBudgetUnit
IF NOT EXISTS (SELECT 1 FROM [PlanningAndBudgetUnit])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [PlanningAndBudgetUnit] ([PaydoxId], [MigrationId], [Name], [Code], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Планово-бюджетная единица ' + CAST(@i AS NVARCHAR),
            N'PBU' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 10. InvestmentActivity (ссылается на PlanningAndBudgetUnit)
IF NOT EXISTS (SELECT 1 FROM [InvestmentActivity])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [InvestmentActivity] ([PaydoxId], [MigrationId], [Name], [EngName], [Code], [Year], [PlanningAndBudgetUnitCode], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Инвестиционное мероприятие ' + CAST(@i AS NVARCHAR),
            N'Investment Activity ' + CAST(@i AS NVARCHAR),
            N'INV' + CAST(@i AS NVARCHAR),
            CAST(2020 + (@i % 5) AS NVARCHAR(4)),
            N'PBU_' + RIGHT('000' + CAST((@i % 100) + 1 AS NVARCHAR), 3),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 11. TaxAccreditationStatus
IF NOT EXISTS (SELECT 1 FROM [TaxAccreditationStatus])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [TaxAccreditationStatus] ([PaydoxId], [MigrationId], [Name], [EngName], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Статус налоговой аккредитации ' + CAST(@i AS NVARCHAR),
            N'Tax Accreditation Status ' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 12. ComplianceAccreditationStatuse
IF NOT EXISTS (SELECT 1 FROM [ComplianceAccreditationStatuse])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [ComplianceAccreditationStatuse] ([PaydoxId], [MigrationId], [Name], [EngName], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Статус комплаенс аккредитации ' + CAST(@i AS NVARCHAR),
            N'Compliance Accreditation Status ' + CAST(@i AS NVARCHAR),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 13. DocumentKind
IF NOT EXISTS (SELECT 1 FROM [DocumentKind])
BEGIN
    DECLARE @i INT = 1
    DECLARE @flows NVARCHAR(MAX) = N'Inner|Outgoing|Incoming|Contracts'
    DECLARE @numberings NVARCHAR(MAX) = N'Numerable|Registrable|NotNumerable'
    WHILE @i <= 100
    BEGIN
        INSERT INTO [DocumentKind] ([PaydoxId], [MigrationId], [Name], [AbbreviatedName], [Code], [DocumentTypeId], [DocumentFlow], [NumberingType])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Вид документа ' + CAST(@i AS NVARCHAR),
            N'ВД' + CAST(@i AS NVARCHAR),
            N'DK' + CAST(@i AS NVARCHAR),
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            CASE (@i % 4) WHEN 0 THEN N'Inner' WHEN 1 THEN N'Outgoing' WHEN 2 THEN N'Incoming' ELSE N'Contracts' END,
            CASE (@i % 3) WHEN 0 THEN N'Numerable' WHEN 1 THEN N'Registrable' ELSE N'NotNumerable' END
        )
        SET @i = @i + 1
    END
END
GO

-- 14. Country
IF NOT EXISTS (SELECT 1 FROM [Country])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [Country] ([PaydoxId], [MigrationId], [Name], [Code])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Страна ' + CAST(@i AS NVARCHAR),
            RIGHT('000' + CAST(@i AS NVARCHAR), 3)
        )
        SET @i = @i + 1
    END
END
GO

-- 15. Document (ссылается на DocumentKind)
IF NOT EXISTS (SELECT 1 FROM [Document])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        DECLARE @typeIdx INT = (@i % 5) + 1
        INSERT INTO [Document] ([PaydoxId], [MigrationId], [DocumentType], [DocumentKind], [Name], [Subject])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            @typeIdx,
            N'DK_' + RIGHT('000' + CAST(4 AS NVARCHAR), 3),
            N'Документ ' + CAST(@i AS NVARCHAR),
            N'Тема документа ' + CAST(@i AS NVARCHAR)
        )
        SET @i = @i + 1
    END
END
GO

-- 16. DocVersion (по одной версии на каждый документ)
INSERT INTO [DocVersion] ([PaydoxId], [AddendumPaydoxId], [MigrationId], [Filepath], [IsMain], [IsSignature], [MainDocFilepath])
        VALUES (
            'Test',
            NULL,
            NULL,
            N'D:\Downloads\Выгрузка от 04.03.26 11_40_49\Версия документа.pdf',
            1,
            0,
            NULL
        ),
        (
            'Test',
            NULL,
            NULL,
            N'D:\Downloads\Выгрузка от 04.03.26 11_40_49\Версия документа — копия.pdf',
            0,
            0,
            NULL
        );

PRINT 'Test data load successfull'
