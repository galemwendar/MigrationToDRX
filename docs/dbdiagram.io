// CompanyDB — система миграции документов
// MS SQL Server

// Справочник «Курсы валют к USD (годовой)»
Table UsdExchangeRatesByYear [note: "Справочник [Курсы валют к USD (годовой)]"]{
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  Name nvarchar(250) [not null]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  Name nvarchar(250) [not null]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  ParentTmcCode  nvarchar(150)  [note: "Идентификатор в системе PayDox"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Коды ОКВЭД"
Table OkvedCode [note: "Справочник [ОКВЭД]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  ParentOkvedCode nvarchar(150)  [note: "Идентификатор в системе PayDox"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Дивизионы"
Table Division [note: "Справочник [Дивизионы]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null]
  Code nvarchar(12) [not null]
  ParentDivision  nvarchar(150)  [note: "Идентификатор в системе PayDox"]
  Note nvarchar(max)
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник "Планово-бюджетные единицы"
Table PlanningAndBudgetUnit [note: "Справочник [Планово-бюджетные единицы]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null]
  EngName nvarchar(250)
  Code nvarchar(12) [not null]
  Year nvarchar(4) [not null]
  PlanningAndBudgetUnitCode nvarchar(30) [not null, note: "PaydoxId планово-бюджетной единицы"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2
  MigrateMessage nvarchar(max)
}

// Справочник «Статусы налоговой аккредитации»
Table TaxAccreditationStatus [note: "Справочник [Статусы налоговой аккредитации]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
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

// Справочник «Страны»
Table Country [note: "Справочник [Страны]"] {
  Id              bigint        [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId            bigint          [note: "Идентификатор в системе DRX"]
  Name            nvarchar(250) [not null]
  Code            nvarchar(3)
  Result          nvarchar(50)  [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime     datetime2
  MigrateMessage  nvarchar(max)
}

// Таблица «Документы»
Table Document [note: "Таблица [Документы]"] {
  Id bigint       [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  DocumentType    int             [not null]
  DocumentKind    nvarchar(30)    [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId            bigint          [note: "Идентификатор в системе DRX"]
  Name            nvarchar(250)   [not null]
  Subject         nvarchar(250)
  Result          nvarchar(50)    [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime     datetime2
  MigrateMessage  nvarchar(max)
}

// Таблица «Версии документов»
Table DocVersion [note: "Таблица [Версии документов]"] {
  Id              bigint          [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  AddendumPaydoxId  nvarchar(190)  [note: "Идентификатор приложения, сгенерированный DRX"]
  MigrationId int [ note: "Идентификатор в системе PayDox"]
  RxId            bigint          [note: "Идентификатор в системе DRX"]
  Filepath        nvarchar(3000)  [not null, unique, note: "Путь к файлу на сетевом диске"]
  Name            nvarchar(250)   [note: "Имя файла (приложения). Если это не основной документ, чтобы понимать как назвать карточку приложения"]
  RxDocId         bigint          [note: "Идентификатор документа в системе DRX"]
  RxVersionId     bigint          [note: "Версия документа в RX"]
  IsMain          bit             [not null, note: "Признак основного документа"]
  IsSignature     bit             [not null, note: "Признак файла подписи"]
  MainDocFilepath nvarchar(3000)  [ref: > DocVersion.Filepath, note: "Для подписи — ссылка на версию основного файла"]
  Result          nvarchar(50)    [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime     datetime2
  MigrateMessage  nvarchar(max)
}
