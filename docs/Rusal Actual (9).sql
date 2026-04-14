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

CREATE TABLE [TmcCode] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(500) NOT NULL,
  [Code] nvarchar(20) NOT NULL,
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
  [Name] nvarchar(500) NOT NULL,
  [Code] nvarchar(20) NOT NULL,
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
  [PortalId] nvarchar(50),
  [Note] nvarchar(max),
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
  [ParentDocumentKindPaydoxId] nvarchar(150),
  [DocumentFlow] nvarchar(15),
  [NumberingType] nvarchar(15),
  [State] nvarchar(15),
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
  [State] nvarchar(15),
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

CREATE TABLE [DeliveryMethod] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [RxId] bigint,
  [Name] nvarchar(250) NOT NULL,
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

CREATE TABLE [Document] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [PaydoxId] nvarchar(150) NOT NULL,
  [MigrationId] int,
  [DocumentType] int NOT NULL,
  [DocumentDate] int,
  [RegNumber] nvarchar(250),
  [DocumentKind] nvarchar(30) NOT NULL,
  [IsMixedKindTransaction] bit,
  [ContractNature] nvarchar(15) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [ShortDescription] nvarchar(850),
  [MainDocExternalId] nvarchar(150),
  [BusinessUnitExternalId] nvarchar(150),
  [InitiatorDepartmentExternalId] nvarchar(150),
  [ExecutorDepartmentExternalId] nvarchar(150),
  [ResponsibleForExecutionExternalId] nvarchar(150),
  [LegalEntityExternalId] nvarchar(150),
  [LegalEntityBranchExternalId] nvarchar(150),
  [SignatoryExternalId] nvarchar(150),
  [LegalEntityRoleInTransactionExternalId] nvarchar(150),
  [IsDebtObligationsOhdCompliant] bit,
  [IsLegalEntityOhdCompliant] bit,
  [DealResultCustomerDepartmentExternalId] bit,
  [UseDdvs] bit,
  [ValidFrom] datetime2,
  [ValidTo] datetime2,
  [CurrencyExternalId] nvarchar(150),
  [DocumentAmoutStandart] float,
  [AtMonthlyRateUsd] nvarchar(250),
  [AtAnnualRateUsd] nvarchar(250),
  [AmoutVat] float,
  [AmoutWithoutVat] float,
  [PaymentCurrency] nvarchar(250),
  [PaymentMethod] nvarchar(15),
  [PaymentOrderForOnerousTransaction] nvarchar(15),
  [IsSingleSupplierPurchase] bit,
  [IsTransactionInterconnected] bit,
  [TransactionAmountWithInterconnExcludCurrent] float,
  [BookValueOfTransferredAsset] float,
  [IsServicesPerformedOnLegalEntityTerritory] bit,
  [PaperNumber] nvarchar(250),
  [NoneOfTheAboveValue] bit,
  [ApplicableLasw] nvarchar(30),
  [SizeTestResult] nvarchar(30),
  [AccessLevel] nvarchar(30),
  [AdditionalAmount] float,
  [Curator] nvarchar(150),
  [SelectionMethod] nvarchar(30),
  [PublishedSelection] bit,
  [PublishedOnETP] bit,
  [DateStart] datetime2,
  [DateEnd] datetime2,
  [EveryMonthlyCourse] float,
  [EveryYearCourse] float,
  [SavengsPercent] float,
  [RxId] bigint,
  [Subject] nvarchar(250),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [MixedDocumentKindCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [DocumentKindExternalId] bigint NOT NULL,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [CounterpartiesCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [Name] nvarchar(250) NOT NULL,
  [BranchExternalId] nvarchar(150) NOT NULL,
  [RoleInTransactionExternalId] nvarchar(150) NOT NULL,
  [SignerExternalId] nvarchar(150),
  [AdditionalInfo] nvarchar(1000),
  [IsMajorDealForCounterparty] bit,
  [IsCounterpartyOhdCompliant] bit,
  [AuthorityConnection] nvarchar(15),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [CountriesOfConclusionExecutionAndOriginCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [CountriesOfConclusionExecutionAndOrigin] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [DeliveryAndLogisticCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [DealFeatureExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ConstructionDesignExpertiserCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [DealFeatureExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ForeignElementCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [DealFeatureExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [FeaturesOfContractAddendaCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [DealFeatureExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [OtherDealCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [DealFeatureExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [GroupDebtRulesComplianceCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [GroupDebtRulesCompliance] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [GroupDebtRulesAssessmentCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [GroupDebtRulesAssesment] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [AntimonopolyRulesAssessmentCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [AntimonopolyRulesAssessment] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [WinnersCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [Name] nvarchar(250),
  [Amount] float,
  [CurrencyExternalId] nvarchar(150),
  [Advance] float,
  [BankGuarantee] float,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ReserversCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [Name] nvarchar(250),
  [Amount] float,
  [CurrencyExternalId] nvarchar(150),
  [Advance] float,
  [BankGarant] float,
  [QueueNumber] bigint,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [SolutionCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [SolutionProject] nvarchar(1000),
  [Note] nvarchar(1000),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [CustomerEnterprisesCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [CompanyExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ParticipantsCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [CompanyExternalId] nvarchar(150),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [TmcCodesCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [TmcPaydoxId] nvarchar(150),
  [Code] nvarchar(30),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [OkvedCodesCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [OkvedPaydoxId] nvarchar(150),
  [Code] nvarchar(30),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [ExternalLinksCollection] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [DocPaydoxId] nvarchar(150) NOT NULL,
  [Link] nvarchar(250),
  [Comment] nvarchar(250),
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [AccessRights] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [FirstDocPaydoxId] nvarchar(150) NOT NULL,
  [SecondDocPaydoxId] nvarchar(150) NOT NULL,
  [AccessRightType] nvarchar(50) NOT NULL,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [DocumentRelations] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [FirstDocPaydoxId] nvarchar(150) NOT NULL,
  [SecondDocPaydoxId] nvarchar(150) NOT NULL,
  [RelationType] nvarchar(50) NOT NULL,
  [Result] nvarchar(50),
  [MigrateTime] datetime2,
  [MigrateMessage] nvarchar(max)
)
GO

CREATE TABLE [DocVersion] (
  [Id] bigint PRIMARY KEY IDENTITY(1, 1),
  [MigrationId] int,
  [PaydoxId] nvarchar(150) NOT NULL,
  [AddendumPaydoxId] nvarchar(190),
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
@value = N'Справочник [Курсы валют к USD (годовой)]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код валюты',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'RateCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Год (дата первого января соответствующего года)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'Year';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Значение курса к USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'RateValueToUsd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByYear',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Курсы валют к USD (месячный)]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код валюты',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'RateCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'Date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Значение курса к USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'RateValueToUsd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UsdExchangeRatesByMonth',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Валюты]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграци',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сокращенное наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'ShortName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Буквенный код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'LetterCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Цифровой код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'NumberCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Currency',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Органы корпоративного одобрения]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Орган управления',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'GoverningBody';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Описание',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'Description';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CorporateApproval',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Организационно-правовые формы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Полное наименование ОПФ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'FullName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код ОПФ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OrganizationalAndLegalForm',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [ТМЦ]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код ТМЦ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox на Код ТМЦ высшестоящего уровня',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'ParentTmcCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCode',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [ОКВЭД]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код ОКВЭД',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox на Код ОКВЭД высшестоящего уровня',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'ParentOkvedCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCode',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Дивизионы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox на ведущий дивизион',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'ParentDivision';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор на портале',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'PortalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Примечание',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Note';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Division',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Виды документов]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сокращенное имя',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'AbbreviatedName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'ИД Типа документа в DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'DocumentTypeId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox на родительский вид документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'ParentDocumentKindPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Incoming | Outgoing | Inner | Contracts',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'DocumentFlow';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Numerable | NotNumerable | Registrable',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'NumberingType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentKind',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Страны]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Country',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Организации]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'РОП ИД, переносим в ExternalId поле',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'RopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор Paydox Кода страны',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'CodeCountryPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор Paydox Страны',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'CountryPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Примечание со значением Создана автоматически при миграции данных',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'Note';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Company',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Подразделения]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'РОП ИД, переносим в ExternalId поле',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'RopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Department',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Подразделения]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Имя',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'FirstName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Фамилия',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'LastName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе РОП Нашей организации',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'BusinessUnitRopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Имя Нашей организации, для создания закрытой НОР в случае, если не нашли по BusinessUnitRopId',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'BusinessUnitName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе РОП Подразделения',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'DepartmentRopId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Имя Подразделения, для создания закрытой записи Подразделения в случае, если не нашли по DepartmentRopId',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'DepartmentName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Employee',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Планово-бюджетные единицы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'PlanningAndBudgetUnit',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Способы доставки]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Мероприятие',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryMethod',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Справочник [Инвестиционные мероприятия]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Мероприятие',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование на английском языке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'EngName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код ИМ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Год (дата первого января соответствующего года)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Year';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId планово-бюджетной единицы',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'PlanningAndBudgetUnitCode';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Состояние: Active | Closed',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'State';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'InvestmentActivity',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица [Документы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Тип документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentDate';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Рег №',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'RegNumber';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentKind';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сделка смешанных видов',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IsMixedKindTransaction';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Характер договора. Варианты: Incomerusal, Expenserusal, Reciprocalrusal, Gratuitorusal, NoPaymentrusal',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ContractNature';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Заголовок',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Краткое описание',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ShortDescription';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Основной договор',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MainDocExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД орг. единицы (наша организация',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'BusinessUnitExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД подразделения инициатора',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'InitiatorDepartmentExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД подразделения исполнителя',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ExecutorDepartmentExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД ответственного за исполнение',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ResponsibleForExecutionExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД юр. лица',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'LegalEntityExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Филиал юр. лица',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'LegalEntityBranchExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД подписанта',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'SignatoryExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД (НД) Роль Юр. лица в сделке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'LegalEntityRoleInTransactionExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Сделка соответствует ОХД с т.з. долговых финансовых обязательств',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IsDebtObligationsOhdCompliant';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Сделка соответствует ОХД Юр.лица',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IsLegalEntityOhdCompliant';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД (НД) Подразделение-заказчик результата по Сделке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DealResultCustomerDepartmentExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Использовать ДДВС',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'UseDdvs';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Действует с',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ValidFrom';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Действует по',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ValidTo';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код Валюты',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'CurrencyExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сумма документа (с учетом процентов и проч. расходов)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DocumentAmoutStandart';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'По ежемесячному курсу, USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'AtMonthlyRateUsd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'По годовому курсу, USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'AtAnnualRateUsd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сумма НДС',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'AmoutVat';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сумма без НДС',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'AmoutWithoutVat';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Валюта платежа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PaymentCurrency';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Средство платежа/условия расчетов: MutualOffset, ExternalSec, InternalSec, Cash, UncoveredLoc, AssetExchange',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PaymentMethod';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Порядок оплаты по возмездным сделкам: FullPrepay, DeferredPay',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PaymentOrderForOnerousTransaction';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Данная сделка является ЗАКУПКОЙ У ЕДИНСТВЕННОГО ПОСТАВЩИКА',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IsSingleSupplierPurchase';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Сделка взаимосвязана с другими сделками',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IsTransactionInterconnected';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Сумма по Сделке с учётом взаимосвязанных Сделок, без учета текущей',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'TransactionAmountWithInterconnExcludCurrent';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Балансовая стоимость имущества/имущественных прав, передаваемых по Сделке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'BookValueOfTransferredAsset';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Работы / Услуги осуществляются на территории Участника Группы, указанного в поле «Юр.лицо»',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'IsServicesPerformedOnLegalEntityTerritory';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Номер на бумаге',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PaperNumber';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) 25.1000 Ни одно значение вышеперечисленное',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'NoneOfTheAboveValue';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Применимое право: ForeignLawExclFormerUSSR, LawOfFormerUSSRepublic, RussianLaw',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'ApplicableLasw';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Результат Test Size: AtLeastOneReaches5Percent, NoneReaches5Percent',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'SizeTestResult';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Уровень доступа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'AccessLevel';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Доп сумма',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'AdditionalAmount';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД Куратора отбора',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'Curator';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Метод отбора',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'SelectionMethod';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Опубликованный отбор',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PublishedSelection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Размещено на ЭТП',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'PublishedOnETP';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата начала работ/услуг/поставки по заявке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DateStart';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата окончания работ/услуг/поставки по заявке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'DateEnd';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'По ежемесячному курсу, USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'EveryMonthlyCourse';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'По годовому курсу, USD',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'EveryYearCourse';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Экономия в процентах',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'SavengsPercent';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Document',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Виды документов для смешанных сделок]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'MixedDocumentKindCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'MixedDocumentKindCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Вид документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'MixedDocumentKindCollection',
@level2type = N'Column', @level2name = 'DocumentKindExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'MixedDocumentKindCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'MixedDocumentKindCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'MixedDocumentKindCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Контрагент]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Заголовок',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД Филиала контрагента',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'BranchExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД (НД) Роль контрагента в сделке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'RoleInTransactionExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Подписант',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'SignerExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дополнительная информация',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'AdditionalInfo';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Роль Контрагента в сделке',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'IsMajorDealForCounterparty';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сделка соответствует ОХД Контрагента',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'IsCounterpartyOhdCompliant';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Связь с органами власти: NoRFAuthority, RFAuthorityBody, RFAuthoritySub, ForeignAuthorit',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'AuthorityConnection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CounterpartiesCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Страны заключения/исполнения Сделки. Страны происхождения оборудования/ТМЦ/объекта прав]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'(НД) Страны заключения/исполнения Сделки. Страны происхождения оборудования/ТМЦ/объекта прав',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection',
@level2type = N'Column', @level2name = 'CountriesOfConclusionExecutionAndOrigin';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CountriesOfConclusionExecutionAndOriginCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Доставка и логистика]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Особенность сделки',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection',
@level2type = N'Column', @level2name = 'DealFeatureExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DeliveryAndLogisticCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Строительство, проектирование и экспертиза]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Особенность сделки',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection',
@level2type = N'Column', @level2name = 'DealFeatureExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ConstructionDesignExpertiserCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Иностранный элемент]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Особенность сделки',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection',
@level2type = N'Column', @level2name = 'DealFeatureExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ForeignElementCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Особенности дополнений в договоры]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Особенность сделки',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection',
@level2type = N'Column', @level2name = 'DealFeatureExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeaturesOfContractAddendaCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Прочие особенности сделки]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Особенность сделки',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection',
@level2type = N'Column', @level2name = 'DealFeatureExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OtherDealCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Соответствие правилам долговых финансовых обязательств Группы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника (НД) Соответствие правилам долговых финансовых обязательств Группы',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection',
@level2type = N'Column', @level2name = 'GroupDebtRulesCompliance';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesComplianceCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Оценка по правилам долговых финансовых обязательств Группы]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника (НД) Соответствие правилам долговых финансовых обязательств Группы',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'GroupDebtRulesAssesment';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'GroupDebtRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [(НД) Оценка по антимонопольным правилам]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника (НД) Соответствие правилам долговых финансовых обязательств Группы',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'AntimonopolyRulesAssessment';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AntimonopolyRulesAssessmentCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Победители]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сумма',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'Amount';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Валюта',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'CurrencyExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Аванс',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'Advance';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Банковская гарантия',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'BankGuarantee';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'WinnersCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Резервисты]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сумма',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'Amount';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Внешний ИД справочника Валюта',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'CurrencyExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Аванс',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'Advance';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Банковская гарантия',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'BankGarant';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Номер очереди',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'QueueNumber';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ReserversCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Решение]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Проект решения',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'SolutionProject';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Примечание',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'Note';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'SolutionCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Предприятие заказчики]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование - Внешний ИД справочника Организации',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection',
@level2type = N'Column', @level2name = 'CompanyExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CustomerEnterprisesCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Участники]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование - Внешний ИД справочника Организации',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection',
@level2type = N'Column', @level2name = 'CompanyExternalId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ParticipantsCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Коды ТМЦ]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование - Внешний ИД справочника Коды ТМЦ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'TmcPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TmcCodesCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Коды ОКВЭД]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Наименование - Внешний ИД справочника Коды ТМЦ',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'OkvedPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Код',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'Code';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'OkvedCodesCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица-коллекция [Внешние ссылки]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'DocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Ссылка',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'Link';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Комментарий',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'Comment';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'ExternalLinksCollection',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица [Права доступа]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'FirstDocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'SecondDocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Тип прав',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'AccessRightType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'AccessRights',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица [Связи между документами]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'FirstDocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'PaydoxId документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'SecondDocPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Тип связи',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'RelationType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocumentRelations',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = N'Таблица [Версии документов]',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор номера итерации миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MigrationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе PayDox',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'PaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор приложения, сгенерированный DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'AddendumPaydoxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'RxId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Путь к файлу на сетевом диске',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'Filepath';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Имя файла (приложения). Если это не основной документ, чтобы понимать как назвать карточку приложения',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'Name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Идентификатор документа в системе DRX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'RxDocId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Версия документа в RX',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'RxVersionId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Признак основного документа',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'IsMain';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Признак файла подписи',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'IsSignature';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Для подписи — ссылка на версию основного файла',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MainDocFilepath';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Результат миграции: Migrated | MigratedWithNotes | MigratedError',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'Result';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Дата миграции',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MigrateTime';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = N'Сообщение при миграции (обычно в случае ошибки)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DocVersion',
@level2type = N'Column', @level2name = 'MigrateMessage';
GO

ALTER TABLE [DocVersion] ADD FOREIGN KEY ([MainDocFilepath]) REFERENCES [DocVersion] ([Filepath])
GO
