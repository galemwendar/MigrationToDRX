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
  [MigrationId] int,
  [RxId] bigint,
  [RateCode] nvarchar(30) NOT NULL,
  [Year] datetime2 NOT NULL,
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

CREATE TABLE [Currency] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [ShortName] nvarchar(250) NOT NULL,
  [LetterCode] nvarchar(250) NOT NULL,
  [NumberCode] nvarchar(3) NOT NULL,
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

-- Таблица ExpenseItem исключена из схемы (закомментирована в dbdiagram)

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
  [Year] datetime2 NOT NULL,
  [PlanningAndBudgetUnitCode] nvarchar(150) NOT NULL,
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
  [Code] nvarchar(12),
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
  [Code] nvarchar(3) NOT NULL,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Company] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [RxId] bigint,
  [RopId] nvarchar(64) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [CodeCountryPaydoxId] nvarchar(150) NOT NULL,
  [CountryPaydoxId] nvarchar(150) NOT NULL,
  [Note] nvarchar(500),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Department] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [RopId] nvarchar(64) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [Employee] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [FirstName] nvarchar(250) NOT NULL,
  [LastName] nvarchar(250) NOT NULL,
  [BusinessUnitRopId] nvarchar(150) NOT NULL,
  [BusinessUnitName] nvarchar(250) NOT NULL,
  [DepartmentRopId] nvarchar(150) NOT NULL,
  [DepartmentName] nvarchar(250) NOT NULL,
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
  [Filepath] nvarchar(850) UNIQUE NOT NULL,
  [Name] nvarchar(250),
  [RxDocId] bigint,
  [RxVersionId] bigint,
  [IsMain] bit NOT NULL,
  [IsSignature] bit NOT NULL,
  [MainDocFilepath] nvarchar(850),
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код валюты',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'RateCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Год',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'Year';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Значение курса к USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'RateValueToUsd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код валюты',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'RateCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'Date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Значение курса к USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'RateValueToUsd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Орган управления',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'GoverningBody';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Описание',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'Description';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Полное наименование ОПФ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'FullName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код ОПФ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Идентификатор в системе PayDox на Код ТМЦ высшестоящего уровня',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'ParentTmcCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код ТМЦ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Идентификатор в системе PayDox на Код ОКВЭД высшестоящего уровня',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'ParentOkvedCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код ОКВЭД',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Идентификатор в системе PayDox на ведущий дивизион',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'ParentDivision';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Примечание',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Note';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Мероприятие',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование на английском языке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'EngName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код ИМ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Год',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Year';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сокращенное имя',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'AbbreviatedName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'ИД Типа документа в DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'DocumentTypeId';
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
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Валюты]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сокращенное наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'ShortName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Буквенный код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'LetterCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Цифровой код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'NumberCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Организации]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'РОП ИД, переносим в ExternalId поле',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'RopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор Paydox Кода страны',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'CodeCountryPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор Paydox Страны',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'CountryPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Примечание со значением "Создана автоматически при миграции данных"',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'Note';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Подразделения]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'РОП ИД, переносим в ExternalId поле',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'RopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Справочник [Сотрудники]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Имя',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'FirstName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Фамилия',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'LastName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе РОП Нашей организации',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'BusinessUnitRopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Имя Нашей организации, для создания закрытой НОР в случае, если не нашли по BusinessUnitRopId',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'BusinessUnitName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Идентификатор в системе РОП Подразделения',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'DepartmentRopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Имя Подразделения, для создания закрытой записи Подразделения в случае, если не нашли по DepartmentRopId',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'DepartmentName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
@value = 'Идентификатор номера итерации миграции',
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
@value = 'Идентификатор документа в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'RxDocId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
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
        INSERT INTO [UsdExchangeRatesByYear] ([PaydoxId], [MigrationId], [RateCode], [Year], [RateValueToUsd], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            @rateCode,
            DATEFROMPARTS(@year, 1, 1),
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
        INSERT INTO [UsdExchangeRatesByMonth] ([PaydoxId], [MigrationId], [RateCode], [Date], [RateValueToUsd], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
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
        DECLARE @body NVARCHAR(100) = CASE @bodyIdx
            WHEN 1 THEN N'Board of Directors'
            WHEN 2 THEN N'Audit Committee'
            WHEN 3 THEN N'Remuneration Committee'
            WHEN 4 THEN N'Strategy Committee'
            ELSE N'Risk Committee'
        END
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

-- 5. Currency
IF NOT EXISTS (SELECT 1 FROM [Currency])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 20
    BEGIN
        INSERT INTO [Currency] ([PaydoxId], [MigrationId], [Name], [ShortName], [LetterCode], [NumberCode], [State])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Валюта ' + CAST(@i AS NVARCHAR),
            N'Вал' + CAST(@i AS NVARCHAR),
            N'C' + RIGHT('00' + CAST(@i AS NVARCHAR), 2) + 'R',
            RIGHT('000' + CAST(@i AS NVARCHAR), 3),
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
            DATEFROMPARTS(2020 + (@i % 5), 1, 1),
            N'PBU_' + RIGHT('000' + CAST((@i % 100) + 1 AS NVARCHAR), 3),
            CASE WHEN @i % 10 = 0 THEN N'Closed' ELSE N'Active' END
        )
        SET @i = @i + 1
    END
END
GO

-- 11. Company
IF NOT EXISTS (SELECT 1 FROM [Company])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 50
    BEGIN
        INSERT INTO [Company] ([MigrationId], [RopId], [Name], [CodeCountryPaydoxId], [CountryPaydoxId], [Note])
        VALUES (
            NULL,
            N'ROP_' + RIGHT('000' + CAST(@i AS NVARCHAR), 3),
            N'Организация ' + CAST(@i AS NVARCHAR),
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            N'Создана автоматически при миграции данных'
        )
        SET @i = @i + 1
    END
END
GO

-- 12. Department
IF NOT EXISTS (SELECT 1 FROM [Department])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 50
    BEGIN
        INSERT INTO [Department] ([RopId], [MigrationId], [Name])
        VALUES (
            N'DEP_' + RIGHT('000' + CAST(@i AS NVARCHAR), 3),
            NULL,
            N'Подразделение ' + CAST(@i AS NVARCHAR)
        )
        SET @i = @i + 1
    END
END
GO

-- 13. Employee
IF NOT EXISTS (SELECT 1 FROM [Employee])
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 100
    BEGIN
        INSERT INTO [Employee] ([PaydoxId], [MigrationId], [FirstName], [LastName], [BusinessUnitRopId], [BusinessUnitName], [DepartmentRopId], [DepartmentName])
        VALUES (
            LOWER(CAST(NEWID() AS NVARCHAR(36))),
            NULL,
            N'Имя' + CAST(@i AS NVARCHAR),
            N'Фамилия' + CAST(@i AS NVARCHAR),
            N'ROP_' + RIGHT('000' + CAST((@i % 50) + 1 AS NVARCHAR), 3),
            N'Организация ' + CAST((@i % 50) + 1 AS NVARCHAR),
            N'DEP_' + RIGHT('000' + CAST((@i % 50) + 1 AS NVARCHAR), 3),
            N'Подразделение ' + CAST((@i % 50) + 1 AS NVARCHAR)
        )
        SET @i = @i + 1
    END
END
GO

-- 14. DocumentKind
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
            CAST(@i AS bigint),
            CASE (@i % 4) WHEN 0 THEN N'Inner' WHEN 1 THEN N'Outgoing' WHEN 2 THEN N'Incoming' ELSE N'Contracts' END,
            CASE (@i % 3) WHEN 0 THEN N'Numerable' WHEN 1 THEN N'Registrable' ELSE N'NotNumerable' END
        )
        SET @i = @i + 1
    END
END
GO

-- 15. Country
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

-- 16. Document (ссылается на DocumentKind)
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

-- 17. DocVersion (по одной версии на каждый документ)
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
        ),
        (
            'Test',
            NULL,
            NULL,
            N'D:\Downloads\Выгрузка от 04.03.26 11_40_49\Подпись к документу.sig',
            1,
            1,
            N'D:\Downloads\Выгрузка от 04.03.26 11_40_49\Версия документа — копия.pdf'
        ),
        (
            'Test',
            NULL,
            NULL,
            N'D:\Downloads\Выгрузка от 04.03.26 11_40_49\Подпись к документу - копия.sig',
            0,
            1,
            N'D:\Downloads\Выгрузка от 04.03.26 11_40_49\Версия документа — копия.pdf'
        );

PRINT 'Test data load successfull'
