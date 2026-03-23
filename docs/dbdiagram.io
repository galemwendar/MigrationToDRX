// CompanyDB — система миграции документов
// MS SQL Server

// Справочник «Курсы валют к USD (годовой)»
Table UsdExchangeRatesByYear [note: "Справочник [Курсы валют к USD (годовой)]"]{
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  Name nvarchar(250) [not null]
  MigrationID int [not null]
  RateCode nvarchar(30) [not null]
  Date datetime2 [not null]
  RateValueToUsd float [not null]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Курсы валют к USD (месячный)»
Table UsdExchangeRatesByMonth [note: "Справочник [Курсы валют к USD (месячный)]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  Name nvarchar(250) [not null]
  MigrationID int [not null]
  RateCode nvarchar(30) [not null]
  Date datetime2 [not null]
  RateValueToUsd float [not null]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Корпоративное одобрение»
Table CorporateApproval [note: "Справочник [Корпоративное одобрение]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  GoverningBody nvarchar(250) [not null]
  Description nvarchar(500)
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Организационно-правовые формы»
Table OrganizationalAndLegalForm [note: "Справочник [Организационно-правовые формы]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  FullName nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Статьи расходов"
Table ExpenseItem [note: "Справочник [Статьи расходов]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  FullName nvarchar(250) [not null, note: "Укрупненное название статьи расхода"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Коды ТМЦ"
Table TmcCode [note: "Справочник [ТМЦ]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  ParentTmcCode nvarchar(30)  [note: "Составной ключ: ОргЕдиница:Тип:Код"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Коды ОКВЭД"
Table OkvedCode [note: "Справочник [ОКВЭД]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  ParentOkvedCode nvarchar(30)  [note: "Составной ключ: ОргЕдиница:Тип:Код"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Дивизионы"
Table Division [note: "Справочник [Дивизионы]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  ParentDivision nvarchar(30)  [note: "Составной ключ: ОргЕдиница:Тип:Код"]
  Note nvarchar(max)
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Планово-бюджетные единицы"
Table PlanningAndBudgetUnit [note: "Справочник [Планово-бюджетные единицы]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Инвестиционные мероприятия"
Table InvestmentActivity [note: "Справочник [Инвестиционные мероприятия]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  EngName nvarchar(250)
  Code nvarchar(12) [not null]
  Year nvarchar(4) [not null]
  PlanningAndBudgetUnitCode nvarchar(30) [not null, note: "IdPaydox планово-бюджетной единицы"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Статусы налоговой аккредитации»
Table TaxAccreditationStatus [note: "Справочник [Статусы налоговой аккредитации]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(64) [not null]
  EngName nvarchar(64) [not null]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Статусы комплаенс аккредитации»
Table ComplianceAccreditationStatuse [note: "Справочник [Справочник «Статусы комплаенс аккредитации]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(64) [not null]
  EngName nvarchar(64) [not null]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Виды документов»
Table DocumentKind [note: "Справочник [Виды документов]"] {
  Id bigint [pk, increment]
  IdPaydox  nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Тип:Код"]
  MigrationID int [not null]
  Name nvarchar(250) [not null]
  AbbreviatedName nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  DocumentTypeId bigint [not null]
  DocumentFlow nvarchar(15) [note: "Incoming | Outgoing | Inner | Contracts"]
  NumberingType nvarchar(15) [note: "Numerable | NotNumerable | Registrable"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

Table Country {
  Id bigint [pk, increment]
  IdPaydox           nvarchar(30)  [not null, note: "Составной ключ: ОргЕдиница:Ид:БуквенныйИД"]
  MigrationID  int           [not null]
  Name         nvarchar(250) [not null]
  Code         nvarchar(3)
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

Table RelationType {
  IdRx  int          [pk]
  Name  nvarchar(250) [not null, note: "Приложение, На основании, Ответ на и т.д."]
}

Table Document {
  IdPaydox       nvarchar(30)  [pk, note: "Составной ключ: ОргЕдиница:Ид:БуквенныйИД"]

  DocType        nvarchar(50)  [note: "Тип документа", not null]
  RegNumber      nvarchar(50)  [note: "Рег. №"]
  DocumentDate   datetime2     [note: "Дата документа", not null]
  DocumentKind   nvarchar(30)  [note: "Вид документа"]

  Result         nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime    datetime2
  MigrateMessage nvarchar(max)
}

Table Version {
  Id              bigint        [pk, note: "Уникальный числовой идентификатор версии"]
  ExternalId      nvarchar(30)  [note: "Внешний ID из исходной системы"]
  Filepath        nvarchar(3000) [not null, unique, note: "Путь к файлу на сетевом диске"]
  RxDocId         nvarchar(30)  [not null, ref: > Document.IdPaydox]
  RxVersionId     bigint        [note: "Версия документа в RX"]
  IsMain          bit           [not null, note: "Признак основного документа"]
  IsSignature     bit           [not null, note: "Признак файла подписи"]
  MainDocFilepath nvarchar(3000) [ref: > Version.Filepath, note: "Для подписи — ссылка на версию основного файла"]
  Result          nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime     datetime2
  MigrateMessage  nvarchar(max)
}

Table Relation {
  Id             nvarchar(30) [pk]
  RelationTypeId int          [not null, ref: > RelationType.IdRx]
  SourceIdPaydox    nvarchar(30) [not null, ref: > Document.IdPaydox]
  TargetIdPaydox    nvarchar(30) [not null, ref: > Document.IdPaydox]
  Result         nvarchar(50) [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime    datetime2
  MigrateMessage nvarchar(max)
}
