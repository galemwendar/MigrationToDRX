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
  [IdPaydox] nvarchar(30) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [ParentTmcCode] nvarchar(30),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [OkvedCode] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [ParentOkvedCode] nvarchar(30),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Division] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(12) NOT NULL,
  [ParentDivision] nvarchar(30),
  [Note] nvarchar(max),
  [State] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [PlanningAndBudgetUnit] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
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
  [IdPaydox] nvarchar(30) NOT NULL,
  [MigrationID] int NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [Code] nvarchar(3),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [RelationType] (
  [IdRx] int PRIMARY KEY,
  [Name] nvarchar(250) NOT NULL
)
GO

CREATE TABLE [Document] (
  [IdPaydox] nvarchar(30) PRIMARY KEY,
  [DocType] nvarchar(50) NOT NULL,
  [RegNumber] nvarchar(50),
  [DocumentDate] datetime2 NOT NULL,
  [DocumentKind] nvarchar(30),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Version] (
  [Id] bigint PRIMARY KEY,
  [ExternalId] nvarchar(30),
  [Filepath] nvarchar(3000) UNIQUE NOT NULL,
  [RxDocId] nvarchar(30) NOT NULL,
  [RxVersionId] bigint,
  [IsMain] bit NOT NULL,
  [IsSignature] bit NOT NULL,
  [MainDocFilepath] nvarchar(3000),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Relation] (
  [Id] nvarchar(30) PRIMARY KEY,
  [RelationTypeId] int NOT NULL,
  [SourceIdPaydox] nvarchar(30) NOT NULL,
  [TargetIdPaydox] nvarchar(30) NOT NULL,
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExpenseItem',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'IdPaydox';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'IdPaydox';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'IdPaydox';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TaxAccreditationStatus',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ComplianceAccreditationStatuse',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@value = 'Составной ключ: ОргЕдиница:Тип:Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'IdPaydox';
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
@name = N'Column_Description',
@value = 'Составной ключ: ОргЕдиница:Ид:БуквенныйИД',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'IdPaydox';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Приложение, На основании, Ответ на и т.д.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'RelationType',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Составной ключ: ОргЕдиница:Ид:БуквенныйИД',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IdPaydox';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Тип документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Рег. №',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'RegNumber';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentDate';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Вид документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentKind';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Уникальный числовой идентификатор версии',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'Id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Внешний ID из исходной системы',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'ExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Путь к файлу на сетевом диске',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'Filepath';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Версия документа в RX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'RxVersionId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Признак основного документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'IsMain';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Признак файла подписи',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'IsSignature';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Для подписи — ссылка на версию основного файла',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'MainDocFilepath';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Version',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Relation',
@level2type = N'Column', @level2name = 'Result';
GO

ALTER TABLE [Version] ADD FOREIGN KEY ([RxDocId]) REFERENCES [Document] ([IdPaydox])
GO

ALTER TABLE [Version] ADD FOREIGN KEY ([MainDocFilepath]) REFERENCES [Version] ([Filepath])
GO

ALTER TABLE [Relation] ADD FOREIGN KEY ([RelationTypeId]) REFERENCES [RelationType] ([IdRx])
GO

ALTER TABLE [Relation] ADD FOREIGN KEY ([SourceIdPaydox]) REFERENCES [Document] ([IdPaydox])
GO

ALTER TABLE [Relation] ADD FOREIGN KEY ([TargetIdPaydox]) REFERENCES [Document] ([IdPaydox])
GO


-- =====================================================
-- Вставка тестовых данных (по 10 записей в каждую таблицу)
-- Поля Result, MigrateTime, MigrateMessage не заполняются
-- Используется префикс N для корректного отображения русских символов
-- =====================================================

-- 1. UsdExchangeRatesByYear
IF NOT EXISTS (SELECT 1 FROM [UsdExchangeRatesByYear])
INSERT INTO [UsdExchangeRatesByYear] ([IdPaydox], [Name], [MigrationID], [RateCode], [Date], [RateValueToUsd], [State])
VALUES
(N'USD_YR_001', N'USD Rate 2020', 1, N'USD', '2020-12-31', 74.50, N'Active'),
(N'USD_YR_002', N'USD Rate 2021', 1, N'USD', '2021-12-31', 73.20, N'Active'),
(N'USD_YR_003', N'USD Rate 2022', 1, N'USD', '2022-12-31', 70.80, N'Active'),
(N'USD_YR_004', N'USD Rate 2023', 1, N'USD', '2023-12-31', 90.50, N'Active'),
(N'USD_YR_005', N'USD Rate 2024', 1, N'USD', '2024-12-31', 95.30, N'Active'),
(N'USD_YR_006', N'EUR Rate 2020', 1, N'EUR', '2020-12-31', 1.18, N'Active'),
(N'USD_YR_007', N'EUR Rate 2021', 1, N'EUR', '2021-12-31', 1.13, N'Active'),
(N'USD_YR_008', N'EUR Rate 2022', 1, N'EUR', '2022-12-31', 1.05, N'Active'),
(N'USD_YR_009', N'EUR Rate 2023', 1, N'EUR', '2023-12-31', 1.08, N'Active'),
(N'USD_YR_010', N'EUR Rate 2024', 1, N'EUR', '2024-12-31', 1.10, N'Closed')
GO

-- 2. UsdExchangeRatesByMonth
IF NOT EXISTS (SELECT 1 FROM [UsdExchangeRatesByMonth])
INSERT INTO [UsdExchangeRatesByMonth] ([IdPaydox], [Name], [MigrationID], [RateCode], [Date], [RateValueToUsd], [State])
VALUES
(N'USD_MTH_001', N'USD Rate Jan 2024', 1, N'USD', '2024-01-31', 92.50, N'Active'),
(N'USD_MTH_002', N'USD Rate Feb 2024', 1, N'USD', '2024-02-29', 93.20, N'Active'),
(N'USD_MTH_003', N'USD Rate Mar 2024', 1, N'USD', '2024-03-31', 94.80, N'Active'),
(N'USD_MTH_004', N'USD Rate Apr 2024', 1, N'USD', '2024-04-30', 95.30, N'Active'),
(N'USD_MTH_005', N'USD Rate May 2024', 1, N'USD', '2024-05-31', 94.50, N'Active'),
(N'USD_MTH_006', N'EUR Rate Jan 2024', 1, N'EUR', '2024-01-31', 1.09, N'Active'),
(N'USD_MTH_007', N'EUR Rate Feb 2024', 1, N'EUR', '2024-02-29', 1.10, N'Active'),
(N'USD_MTH_008', N'EUR Rate Mar 2024', 1, N'EUR', '2024-03-31', 1.08, N'Active'),
(N'USD_MTH_009', N'EUR Rate Apr 2024', 1, N'EUR', '2024-04-30', 1.07, N'Active'),
(N'USD_MTH_010', N'EUR Rate May 2024', 1, N'EUR', '2024-05-31', 1.08, N'Closed')
GO

-- 3. CorporateApproval
IF NOT EXISTS (SELECT 1 FROM [CorporateApproval])
INSERT INTO [CorporateApproval] ([IdPaydox], [MigrationID], [GoverningBody], [Description], [State])
VALUES
(N'CA_001', 1, N'Board of Directors', N'Approval of annual budget 2024', N'Active'),
(N'CA_002', 1, N'Board of Directors', N'Approval of investment program', N'Active'),
(N'CA_003', 1, N'Audit Committee', N'Approval of audit plan', N'Active'),
(N'CA_004', 1, N'Remuneration Committee', N'Approval of executive compensation', N'Active'),
(N'CA_005', 1, N'Strategy Committee', N'Approval of strategic initiatives', N'Active'),
(N'CA_006', 1, N'Board of Directors', N'Approval of dividend policy', N'Active'),
(N'CA_007', 1, N'Audit Committee', N'Approval of internal controls', N'Active'),
(N'CA_008', 1, N'Board of Directors', N'Approval of major transaction', N'Active'),
(N'CA_009', 1, N'Strategy Committee', N'Approval of M&A strategy', N'Active'),
(N'CA_010', 1, N'Remuneration Committee', N'Approval of bonus program', N'Closed')
GO

-- 4. OrganizationalAndLegalForm (русские символы)
IF NOT EXISTS (SELECT 1 FROM [OrganizationalAndLegalForm])
INSERT INTO [OrganizationalAndLegalForm] ([IdPaydox], [MigrationID], [FullName], [Code], [State])
VALUES
(N'OLF_001', 1, N'Общество с ограниченной ответственностью', N'ООО', N'Active'),
(N'OLF_002', 1, N'Акционерное общество', N'АО', N'Active'),
(N'OLF_003', 1, N'Публичное акционерное общество', N'ПАО', N'Active'),
(N'OLF_004', 1, N'Непубличное акционерное общество', N'НАО', N'Active'),
(N'OLF_005', 1, N'Индивидуальный предприниматель', N'ИП', N'Active'),
(N'OLF_006', 1, N'Закрытое акционерное общество', N'ЗАО', N'Closed'),
(N'OLF_007', 1, N'Открытое акционерное общество', N'ОАО', N'Closed'),
(N'OLF_008', 1, N'Полное товарищество', N'ПТ', N'Active'),
(N'OLF_009', 1, N'Коммандитное товарищество', N'КТ', N'Active'),
(N'OLF_010', 1, N'Производственный кооператив', N'ПК', N'Active')
GO

-- 5. ExpenseItem (русские символы)
IF NOT EXISTS (SELECT 1 FROM [ExpenseItem])
INSERT INTO [ExpenseItem] ([IdPaydox], [MigrationID], [Name], [FullName], [State])
VALUES
(N'EI_001', 1, N'Зарплата', N'Расходы на оплату труда', N'Active'),
(N'EI_002', 1, N'Материалы', N'Материальные расходы', N'Active'),
(N'EI_003', 1, N'Аренда', N'Арендные платежи', N'Active'),
(N'EI_004', 1, N'Транспорт', N'Транспортные расходы', N'Active'),
(N'EI_005', 1, N'Связь', N'Услуги связи', N'Active'),
(N'EI_006', 1, N'Коммунальные', N'Коммунальные услуги', N'Active'),
(N'EI_007', 1, N'IT услуги', N'Информационные технологии', N'Active'),
(N'EI_008', 1, N'Консультации', N'Консультационные услуги', N'Active'),
(N'EI_009', 1, N'Реклама', N'Рекламные расходы', N'Active'),
(N'EI_010', 1, N'Командировки', N'Командировочные расходы', N'Closed')
GO

-- 6. TmcCode (русские символы)
IF NOT EXISTS (SELECT 1 FROM [TmcCode])
INSERT INTO [TmcCode] ([IdPaydox], [MigrationID], [Name], [Code], [ParentTmcCode], [State])
VALUES
(N'TMC_001', 1, N'Основные средства', N'OS', NULL, N'Active'),
(N'TMC_002', 1, N'Оборудование', N'EQ', N'TMC_001', N'Active'),
(N'TMC_003', 1, N'Компьютеры', N'PC', N'TMC_002', N'Active'),
(N'TMC_004', 1, N'Ноутбуки', N'NB', N'TMC_002', N'Active'),
(N'TMC_005', 1, N'Транспорт', N'TR', N'TMC_001', N'Active'),
(N'TMC_006', 1, N'Материалы', N'MT', NULL, N'Active'),
(N'TMC_007', 1, N'Канцтовары', N'ST', N'TMC_006', N'Active'),
(N'TMC_008', 1, N'Расходники', N'SP', N'TMC_006', N'Active'),
(N'TMC_009', 1, N'Мебель', N'FR', N'TMC_001', N'Active'),
(N'TMC_010', 1, N'Серверы', N'SR', N'TMC_002', N'Closed')
GO

-- 7. OkvedCode (русские символы)
IF NOT EXISTS (SELECT 1 FROM [OkvedCode])
INSERT INTO [OkvedCode] ([IdPaydox], [MigrationID], [Name], [Code], [ParentOkvedCode], [State])
VALUES
(N'OKV_001', 1, N'Добыча полезных ископаемых', N'07', NULL, N'Active'),
(N'OKV_002', 1, N'Добыча угля', N'07.1', N'OKV_001', N'Active'),
(N'OKV_003', 1, N'Добыча нефти', N'07.2', N'OKV_001', N'Active'),
(N'OKV_004', 1, N'Обрабатывающие производства', N'10', NULL, N'Active'),
(N'OKV_005', 1, N'Производство пищевых продуктов', N'10.1', N'OKV_004', N'Active'),
(N'OKV_006', 1, N'Производство напитков', N'10.2', N'OKV_004', N'Active'),
(N'OKV_007', 1, N'Строительство', N'41', NULL, N'Active'),
(N'OKV_008', 1, N'Строительство зданий', N'41.2', N'OKV_007', N'Active'),
(N'OKV_009', 1, N'Торговля', N'45', NULL, N'Active'),
(N'OKV_010', 1, N'Оптовая торговля', N'45.1', N'OKV_009', N'Closed')
GO

-- 8. Division (русские символы)
IF NOT EXISTS (SELECT 1 FROM [Division])
INSERT INTO [Division] ([IdPaydox], [MigrationID], [Name], [Code], [ParentDivision], [Note], [State])
VALUES
(N'DIV_001', 1, N'Головной офис', N'HQ', NULL, N'Центральный офис', N'Active'),
(N'DIV_002', 1, N'Департамент финансов', N'FIN', N'DIV_001', N'Финансовое управление', N'Active'),
(N'DIV_003', 1, N'Департамент IT', N'IT', N'DIV_001', N'Информационные технологии', N'Active'),
(N'DIV_004', 1, N'Отдел бухгалтерии', N'ACC', N'DIV_002', N'Бухгалтерский учет', N'Active'),
(N'DIV_005', 1, N'Отдел казначейства', N'TRE', N'DIV_002', N'Управление денежными средствами', N'Active'),
(N'DIV_006', 1, N'Отдел разработки', N'DEV', N'DIV_003', N'Разработка ПО', N'Active'),
(N'DIV_007', 1, N'Отдел инфраструктуры', N'INF', N'DIV_003', N'IT инфраструктура', N'Active'),
(N'DIV_008', 1, N'Филиал Москва', N'MSK', N'DIV_001', N'Московский филиал', N'Active'),
(N'DIV_009', 1, N'Филиал СПб', N'SPB', N'DIV_001', N'Санкт-Петербургский филиал', N'Active'),
(N'DIV_010', 1, N'Филиал Новосибирск', N'NSK', N'DIV_001', N'Сибирский филиал', N'Closed')
GO

-- 9. PlanningAndBudgetUnit (русские символы)
IF NOT EXISTS (SELECT 1 FROM [PlanningAndBudgetUnit])
INSERT INTO [PlanningAndBudgetUnit] ([IdPaydox], [MigrationID], [Name], [Code], [State])
VALUES
(N'PBU_001', 1, N'Центральный аппарат', N'CA', N'Active'),
(N'PBU_002', 1, N'Производственный департамент', N'PROD', N'Active'),
(N'PBU_003', 1, N'Коммерческий департамент', N'COM', N'Active'),
(N'PBU_004', 1, N'Департамент развития', N'DEV', N'Active'),
(N'PBU_005', 1, N'Региональное управление', N'REG', N'Active'),
(N'PBU_006', 1, N'Завод №1', N'PL01', N'Active'),
(N'PBU_007', 1, N'Завод №2', N'PL02', N'Active'),
(N'PBU_008', 1, N'Логистический центр', N'LOG', N'Active'),
(N'PBU_009', 1, N'Исследовательский центр', N'RND', N'Active'),
(N'PBU_010', 1, N'Учебный центр', N'EDU', N'Closed')
GO

-- 10. InvestmentActivity (русские символы)
IF NOT EXISTS (SELECT 1 FROM [InvestmentActivity])
INSERT INTO [InvestmentActivity] ([IdPaydox], [MigrationID], [Name], [EngName], [Code], [Year], [PlanningAndBudgetUnitCode], [State])
VALUES
(N'INV_001', 1, N'Модернизация завода', N'Plant Modernization', N'PM001', N'2024', N'PBU_006', N'Active'),
(N'INV_002', 1, N'Внедрение ERP системы', N'ERP Implementation', N'ERP001', N'2024', N'PBU_003', N'Active'),
(N'INV_003', 1, N'Строительство склада', N'Warehouse Construction', N'WH001', N'2024', N'PBU_007', N'Active'),
(N'INV_004', 1, N'Разработка нового продукта', N'New Product Development', N'NP001', N'2024', N'PBU_009', N'Active'),
(N'INV_005', 1, N'Открытие филиала', N'Branch Opening', N'BR001', N'2024', N'PBU_005', N'Active'),
(N'INV_006', 1, N'Закупка оборудования', N'Equipment Purchase', N'EQ001', N'2024', N'PBU_006', N'Active'),
(N'INV_007', 1, N'Обучение персонала', N'Staff Training', N'ST001', N'2024', N'PBU_010', N'Active'),
(N'INV_008', 1, N'Автоматизация производства', N'Production Automation', N'PA001', N'2024', N'PBU_002', N'Active'),
(N'INV_009', 1, N'Маркетинговые исследования', N'Marketing Research', N'MR001', N'2024', N'PBU_003', N'Active'),
(N'INV_010', 1, N'Развитие IT инфраструктуры', N'IT Infrastructure', N'IT001', N'2024', N'PBU_003', N'Closed')
GO

-- 11. TaxAccreditationStatus (русские символы)
IF NOT EXISTS (SELECT 1 FROM [TaxAccreditationStatus])
INSERT INTO [TaxAccreditationStatus] ([IdPaydox], [MigrationID], [Name], [EngName], [State])
VALUES
(N'TAX_001', 1, N'Аккредитован', N'Accredited', N'Active'),
(N'TAX_002', 1, N'Не аккредитован', N'Not Accredited', N'Active'),
(N'TAX_003', 1, N'На рассмотрении', N'Under Review', N'Active'),
(N'TAX_004', 1, N'Приостановлен', N'Suspended', N'Active'),
(N'TAX_005', 1, N'Отозван', N'Revoked', N'Active'),
(N'TAX_006', 1, N'Просрочен', N'Expired', N'Active'),
(N'TAX_007', 1, N'Восстановлен', N'Restored', N'Active'),
(N'TAX_008', 1, N'Отказано', N'Denied', N'Active'),
(N'TAX_009', 1, N'Продлен', N'Extended', N'Active'),
(N'TAX_010', 1, N'Архивный', N'Archived', N'Closed')
GO

-- 12. ComplianceAccreditationStatuse (русские символы)
IF NOT EXISTS (SELECT 1 FROM [ComplianceAccreditationStatuse])
INSERT INTO [ComplianceAccreditationStatuse] ([IdPaydox], [MigrationID], [Name], [EngName], [State])
VALUES
(N'CMP_001', 1, N'Соответствует', N'Compliant', N'Active'),
(N'CMP_002', 1, N'Не соответствует', N'Non-Compliant', N'Active'),
(N'CMP_003', 1, N'Частично соответствует', N'Partially Compliant', N'Active'),
(N'CMP_004', 1, N'Аудит назначен', N'Audit Scheduled', N'Active'),
(N'CMP_005', 1, N'Аудит в процессе', N'Audit in Progress', N'Active'),
(N'CMP_006', 1, N'Требует улучшения', N'Improvement Required', N'Active'),
(N'CMP_007', 1, N'Сертифицирован', N'Certified', N'Active'),
(N'CMP_008', 1, N'Сертификация отозвана', N'Certification Revoked', N'Active'),
(N'CMP_009', 1, N'На рассмотрении', N'Under Review', N'Active'),
(N'CMP_010', 1, N'Приостановлен', N'Suspended', N'Closed')
GO

-- 13. DocumentKind (русские символы)
IF NOT EXISTS (SELECT 1 FROM [DocumentKind])
INSERT INTO [DocumentKind] ([IdPaydox], [MigrationID], [Name], [AbbreviatedName], [Code], [DocumentTypeId], [DocumentFlow], [NumberingType])
VALUES
(N'DK_001', 1, N'Приказ', N'Пр.', N'ORD', 1, N'Inner', N'Numerable'),
(N'DK_002', 1, N'Договор', N'Дог.', N'CON', 2, N'Contracts', N'Registrable'),
(N'DK_003', 1, N'Счет-фактура', N'Счф.', N'INV', 3, N'Outgoing', N'Numerable'),
(N'DK_004', 1, N'Акт', N'Акт', N'ACT', 4, N'Inner', N'Numerable'),
(N'DK_005', 1, N'Письмо', N'Письмо', N'LTR', 5, N'Outgoing', N'Registrable'),
(N'DK_006', 1, N'Входящее письмо', N'Вх.', N'INL', 6, N'Incoming', N'Registrable'),
(N'DK_007', 1, N'Накладная', N'Накл.', N'WAY', 7, N'Outgoing', N'Numerable'),
(N'DK_008', 1, N'Протокол', N'Прот.', N'MIN', 8, N'Inner', N'Numerable'),
(N'DK_009', 1, N'Служебная записка', N'СЗ', N'MEM', 9, N'Inner', N'Registrable'),
(N'DK_010', 1, N'Дополнительное соглашение', N'ДС', N'ADD', 10, N'Contracts', N'Registrable')
GO

-- 14. Country
IF NOT EXISTS (SELECT 1 FROM [Country])
INSERT INTO [Country] ([IdPaydox], [MigrationID], [Name], [Code])
VALUES
(N'COUNTRY_001', 1, N'Российская Федерация', '001'),
(N'COUNTRY_002', 1, N'США', '002'),
(N'COUNTRY_003', 1, N'Германия', '003'),
(N'COUNTRY_004', 1, N'Китай', '004'),
(N'COUNTRY_005', 1, N'Великобритания', '005'),
(N'COUNTRY_006', 1, N'Франция', '006'),
(N'COUNTRY_007', 1, N'Япония', '007'),
(N'COUNTRY_008', 1, N'Казахстан', '008'),
(N'COUNTRY_009', 1, N'Беларусь', '009'),
(N'COUNTRY_010', 1, N'Турция', '010')
GO

-- 15. RelationType (русские символы)
IF NOT EXISTS (SELECT 1 FROM [RelationType])
INSERT INTO [RelationType] ([IdRx], [Name])
VALUES
(1, N'Приложение'),
(2, N'На основании'),
(3, N'Ответ на'),
(4, N'Ссылка'),
(5, N'Замена'),
(6, N'Отменяет'),
(7, N'Копия'),
(8, N'Оригинал'),
(9, N'Перевод'),
(10, N'Сопроводительное письмо')
GO

-- 16. Document
IF NOT EXISTS (SELECT 1 FROM [Document])
INSERT INTO [Document] ([IdPaydox], [DocType], [RegNumber], [DocumentDate], [DocumentKind])
VALUES
(N'DOC_001', N'Order', N'PR-001', '2024-01-15', N'DK_001'),
(N'DOC_002', N'Order', N'PR-002', '2024-02-10', N'DK_001'),
(N'DOC_003', N'Contract', N'C-2024-001', '2024-01-20', N'DK_002'),
(N'DOC_004', N'Contract', N'C-2024-002', '2024-02-25', N'DK_002'),
(N'DOC_005', N'Invoice', N'INV-001', '2024-01-31', N'DK_003'),
(N'DOC_006', N'Act', N'ACT-001', '2024-01-31', N'DK_004'),
(N'DOC_007', N'Letter', N'OUT-001', '2024-01-10', N'DK_005'),
(N'DOC_008', N'Incoming', N'IN-001', '2024-01-12', N'DK_006'),
(N'DOC_009', N'Waybill', N'WAY-001', '2024-01-25', N'DK_007'),
(N'DOC_010', N'Memo', N'MEM-001', '2024-02-01', N'DK_009')
GO

-- 17. Version (с экранированными обратными слешами)
IF NOT EXISTS (SELECT 1 FROM [Version])
INSERT INTO [Version] ([Id], [ExternalId], [Filepath], [RxDocId], [RxVersionId], [IsMain], [IsSignature], [MainDocFilepath])
VALUES
(1, N'EXT001', N'\\\\server\\docs\\order_001.pdf', N'DOC_001', 100, 1, 0, NULL),
(2, N'EXT002', N'\\\\server\\docs\\order_002.pdf', N'DOC_002', 101, 1, 0, NULL),
(3, N'EXT003', N'\\\\server\\docs\\contract_001.pdf', N'DOC_003', 102, 1, 0, NULL),
(4, N'EXT004', N'\\\\server\\docs\\contract_002.pdf', N'DOC_004', 103, 1, 0, NULL),
(5, N'EXT005', N'\\\\server\\docs\\invoice_001.pdf', N'DOC_005', 104, 1, 0, NULL),
(6, N'EXT006', N'\\\\server\\docs\\act_001.pdf', N'DOC_006', 105, 1, 0, NULL),
(7, N'EXT007', N'\\\\server\\docs\\letter_001.pdf', N'DOC_007', 106, 1, 0, NULL),
(8, N'EXT008', N'\\\\server\\docs\\incoming_001.pdf', N'DOC_008', 107, 1, 0, NULL),
(9, N'EXT009', N'\\\\server\\docs\\waybill_001.pdf', N'DOC_009', 108, 1, 0, NULL),
(10, N'EXT010', N'\\\\server\\docs\\memo_001.pdf', N'DOC_010', 109, 1, 0, NULL)
GO

-- 18. Relation
IF NOT EXISTS (SELECT 1 FROM [Relation])
INSERT INTO [Relation] ([Id], [RelationTypeId], [SourceIdPaydox], [TargetIdPaydox])
VALUES
(N'REL_001', 1, N'DOC_003', N'DOC_001'),
(N'REL_002', 2, N'DOC_001', N'DOC_002'),
(N'REL_003', 3, N'DOC_008', N'DOC_007'),
(N'REL_004', 1, N'DOC_006', N'DOC_005'),
(N'REL_005', 4, N'DOC_004', N'DOC_003'),
(N'REL_006', 5, N'DOC_010', N'DOC_009'),
(N'REL_007', 2, N'DOC_006', N'DOC_005'),
(N'REL_008', 1, N'DOC_009', N'DOC_005'),
(N'REL_009', 3, N'DOC_007', N'DOC_008'),
(N'REL_010', 4, N'DOC_002', N'DOC_001')
GO

PRINT 'Test data load successfull'
