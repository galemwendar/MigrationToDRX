// CompanyDB — система миграции документов
// MS SQL Server

// Справочник «Курсы валют к USD (годовой)»
Table UsdExchangeRatesByYear [note: "Справочник [Курсы валют к USD (годовой)]"]{
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  RateCode nvarchar(30) [not null, note: "Код валюты"]
  Year datetime2 [not null, note: "Год (дата первого января соответствующего года)"]
  RateValueToUsd float [not null, note: "Значение курса к USD"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Курсы валют к USD (месячный)»
Table UsdExchangeRatesByMonth [note: "Справочник [Курсы валют к USD (месячный)]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  RateCode nvarchar(30) [not null, note: "Код валюты"]
  Date datetime2 [not null, note: "Дата"]
  RateValueToUsd float [not null, note: "Значение курса к USD"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Валюты»
Table Currency [note: "Справочник [Валюты]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграци"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  ShortName nvarchar(250) [not null, note: "Сокращенное наименование"]
  LetterCode nvarchar(250) [not null, note: "Буквенный код"]
  NumberCode nvarchar(3) [not null, note: "Цифровой код"]
  State nvarchar(15) [note: "Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Органы корпоративного одобрения»
Table CorporateApproval [note: "Справочник [Органы корпоративного одобрения]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  GoverningBody nvarchar(250) [not null, note: "Орган управления"]
  Description nvarchar(500) [note: "Описание"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}


// Справочник «Организационно-правовые формы»
Table OrganizationalAndLegalForm [note: "Справочник [Организационно-правовые формы]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  FullName nvarchar(250) [not null, note: "Полное наименование ОПФ"]
  Code nvarchar(12) [not null, note: "Код ОПФ"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник "Статьи расходов"
/*
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
*/

// Справочник "Коды ТМЦ"
Table TmcCode [note: "Справочник [ТМЦ]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  Code nvarchar(12) [not null, note: "Код ТМЦ"]
  ParentTmcCode  nvarchar(150)  [note: "Идентификатор в системе PayDox на Код ТМЦ высшестоящего уровня"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник "Коды ОКВЭД"
Table OkvedCode [note: "Справочник [ОКВЭД]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  Code nvarchar(12) [not null, note: "Код ОКВЭД"]
  ParentOkvedCode nvarchar(150)  [note: "Идентификатор в системе PayDox на Код ОКВЭД высшестоящего уровня"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник "Дивизионы"
Table Division [note: "Справочник [Дивизионы]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  Code nvarchar(12) [not null, note: "Код"]
  ParentDivision  nvarchar(150)  [note: "Идентификатор в системе PayDox на ведущий дивизион"]
  Note nvarchar(max) [note: "Примечание"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Виды документов»
Table DocumentKind [note: "Справочник [Виды документов]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  AbbreviatedName nvarchar(250) [not null, note: "Сокращенное имя"]
  Code nvarchar(12) [note: "Код"]
  DocumentTypeId bigint [not null, note: "ИД Типа документа в DRX"]
  DocumentFlow nvarchar(15) [note: "Incoming | Outgoing | Inner | Contracts"]
  NumberingType nvarchar(15) [note: "Numerable | NotNumerable | Registrable"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Страны»
Table Country [note: "Справочник [Страны]"] {
  Id              bigint        [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId            bigint          [note: "Идентификатор в системе DRX"]
  Name            nvarchar(250) [not null, note: "Наименование"]
  Code            nvarchar(3) [not null, note: "Код"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Организации»
Table Company [note: "Справочник [Организации]"] {
  Id bigint [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  RopId nvarchar(64) [not null, note: "РОП ИД, переносим в ExternalId поле"]
  Name nvarchar(250) [not null, note: "Наименование"]
  CodeCountryPaydoxId nvarchar(150) [not null, note: "Идентификатор Paydox Кода страны"]
  CountryPaydoxId nvarchar(150) [not null, note: "Идентификатор Paydox Страны"]
  Note nvarchar(500) [note: "Примечание со значением Создана автоматически при миграции данных"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Подразделения»
Table Department [note: "Справочник [Подразделения]"] {
  Id bigint [pk, increment]
  RopId nvarchar(64) [not null, note: "РОП ИД, переносим в ExternalId поле"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник «Сотрудинки»
Table Employee [note: "Справочник [Подразделения]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  FirstName nvarchar(250) [not null, note: "Имя"]
  LastName nvarchar(250) [not null, note: "Фамилия"]
  BusinessUnitRopId nvarchar(150) [not null, note: "Идентификатор в системе РОП Нашей организации"]
  BusinessUnitName nvarchar(250) [not null, note: "Имя Нашей организации, для создания закрытой НОР в случае, если не нашли по BusinessUnitRopId"]
  DepartmentRopId nvarchar(150) [not null, note: "Идентификатор в системе РОП Подразделения"]
  DepartmentName nvarchar(250) [not null, note: "Имя Подразделения, для создания закрытой записи Подразделения в случае, если не нашли по DepartmentRopId"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник "Планово-бюджетные единицы"
Table PlanningAndBudgetUnit [note: "Справочник [Планово-бюджетные единицы]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Наименование"]
  Code nvarchar(12) [not null, note: "Код"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Справочник "Инвестиционные мероприятия"
Table InvestmentActivity [note: "Справочник [Инвестиционные мероприятия]"] {
  Id bigint [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  RxId        bigint          [note: "Идентификатор в системе DRX"]
  Name nvarchar(250) [not null, note: "Мероприятие"]
  EngName nvarchar(250) [note: "Наименование на английском языке"]
  Code nvarchar(12) [not null, note: "Код ИМ"]
  Year datetime2 [not null, note: "Год (дата первого января соответствующего года)"]
  PlanningAndBudgetUnitCode nvarchar(150) [not null, note: "PaydoxId планово-бюджетной единицы"]
  State nvarchar(15) [note: "Состояние: Active | Closed"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица «Документы»
Table Document [note: "Таблица [Документы]"] {
  Id bigint       [pk, increment]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]

  DocumentType    int             [not null, note: "Тип документа"]
  DocumentDate    int             [note: "Дата документа"]
  RegNumber       nvarchar(250)   [note: "Рег №"]
  DocumentKind    nvarchar(30)    [not null, note: "Идентификатор в системе PayDox"]
  IsMixedKindTransaction bit [note: "Сделка смешанных видов"]
  ContractNature nvarchar(15) [not null, note: "Характер договора. Варианты: Incomerusal, Expenserusal, Reciprocalrusal, Gratuitorusal, NoPaymentrusal"]
  Name            nvarchar(250)   [not null, note: "Заголовок"]
  ShortDescription nvarchar(850) [note: "Краткое описание"]
  MainDocExternalId nvarchar(150) [note: "Основной договор"]
  BusinessUnitExternalId nvarchar(150) [note: "Внешний ИД орг. единицы (наша организация"]
  InitiatorDepartmentExternalId nvarchar(150) [note: "Внешний ИД подразделения инициатора"]
  ExecutorDepartmentExternalId nvarchar(150) [note: "Внешний ИД подразделения исполнителя"]
  ResponsibleForExecutionExternalId nvarchar(150) [note: "Внешний ИД ответственного за исполнение"]
  LegalEntityExternalId nvarchar(150) [note: "Внешний ИД юр. лица"]
  LegalEntityBranchExternalId nvarchar(150) [note: "Филиал юр. лица"]
  SignatoryExternalId nvarchar(150) [note: "Внешний ИД подписанта"]
  LegalEntityRoleInTransactionExternalId nvarchar(150) [note: "Внешний ИД (НД) Роль Юр. лица в сделке"]
  IsDebtObligationsOhdCompliant bit [note: "(НД) Сделка соответствует ОХД с т.з. долговых финансовых обязательств"]
  IsLegalEntityOhdCompliant bit [note: "(НД) Сделка соответствует ОХД Юр.лица"]
  DealResultCustomerDepartmentExternalId bit [note: "Внешний ИД (НД) Подразделение-заказчик результата по Сделке"]
  UseDdvs bit [note: "Использовать ДДВС"]
  ValidFrom datetime2 [note: "Действует с"]
  ValidTo datetime2 [note: "Действует по"]
  CurrencyExternalId nvarchar(150) [note: "Код Валюты"]
  DocumentAmoutStandart float [note: "Сумма документа (с учетом процентов и проч. расходов)"]
  AtMonthlyRateUsd nvarchar(250) [note: "По ежемесячному курсу, USD"]
  AtAnnualRateUsd nvarchar(250) [note: "По годовому курсу, USD"]
  AmoutVat float [note: "Сумма НДС"]
  AmoutWithoutVat float [note: "Сумма без НДС"]
  PaymentCurrency nvarchar(250) [note: "(НД) Валюта платежа"]
  PaymentMethod nvarchar(15) [note: "(НД) Средство платежа/условия расчетов: MutualOffset, ExternalSec, InternalSec, Cash, UncoveredLoc, AssetExchange"]
  PaymentOrderForOnerousTransaction nvarchar(15) [note: "(НД) Порядок оплаты по возмездным сделкам: FullPrepay, DeferredPay"]
  IsSingleSupplierPurchase bit [note: "Данная сделка является ЗАКУПКОЙ У ЕДИНСТВЕННОГО ПОСТАВЩИКА"]
  IsTransactionInterconnected bit [note: "(НД) Сделка взаимосвязана с другими сделками"]
  TransactionAmountWithInterconnExcludCurrent float [note: "(НД) Сумма по Сделке с учётом взаимосвязанных Сделок, без учета текущей"]
  BookValueOfTransferredAsset float [note: "(НД) Балансовая стоимость имущества/имущественных прав, передаваемых по Сделке"]
  IsServicesPerformedOnLegalEntityTerritory bit [note: "(НД) Работы / Услуги осуществляются на территории Участника Группы, указанного в поле «Юр.лицо»"]
  PaperNumber nvarchar(250) [note: "Номер на бумаге"]
  NoneOfTheAboveValue bit [note: "(НД) 25.1000 Ни одно значение вышеперечисленное"]
  ApplicableLasw nvarchar(30) [note: "(НД) Применимое право: ForeignLawExclFormerUSSR, LawOfFormerUSSRepublic, RussianLaw"]
  SizeTestResult nvarchar(30) [note: "(НД) Результат Test Size: AtLeastOneReaches5Percent, NoneReaches5Percent"]
  AccessLevel nvarchar(30) [note: "Уровень доступа"]

  // Для отборов
  Curator nvarchar(150) [note: "Внешний ИД Куратора отбора"]
  SelectionMethod nvarchar(30) [note: "Метод отбора"]
  PublishedSelection bit [note: "Опубликованный отбор"]
  PublishedOnETP bit [note: "Размещено на ЭТП"]
  DateStart datetime2 [note: "Дата начала работ/услуг/поставки по заявке"]
  DateEnd datetime2 [note: "Дата окончания работ/услуг/поставки по заявке"]
  EveryMonthlyCourse float [note: "По ежемесячному курсу, USD"]
  EveryYearCourse float [note: "По годовому курсу, USD"]
  SavengsPercent float [note: "Экономия в процентах"]
  //

  RxId            bigint          [note: "Идентификатор в системе DRX"]
  Subject         nvarchar(250)
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Виды документов для смешанных сделок»
Table MixedDocumentKindCollection [note: "Таблица-коллекция [Виды документов для смешанных сделок]"]{
  Id bigint       [pk, increment]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  DocumentKindExternalId bigint [not null, note: "Вид документа"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Виды документов для смешанных сделок»
Table CounterpartiesCollection [note: "Таблица-коллекция [Контрагент]"]{
  Id bigint       [pk, increment]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  Name nvarchar(250) [not null, note: "Заголовок"]
  BranchExternalId nvarchar(150) [not null, note: "Внешний ИД Филиала контрагента"]
  RoleInTransactionExternalId nvarchar(150) [not null, note: "Внешний ИД (НД) Роль контрагента в сделке"]
  SignerExternalId nvarchar(150) [note: "Подписант"]
  AdditionalInfo nvarchar(1000) [note: "Дополнительная информация"]
  IsMajorDealForCounterparty bit [note: "(НД) Роль Контрагента в сделке"]
  IsCounterpartyOhdCompliant bit [note: "Сделка соответствует ОХД Контрагента"]
  AuthorityConnection nvarchar(15) [note: "(НД) Связь с органами власти: NoRFAuthority, RFAuthorityBody, RFAuthoritySub, ForeignAuthorit"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица «(НД) Страны заключения/исполнения Сделки. Страны происхождения оборудования/ТМЦ/объекта прав»
Table CountriesOfConclusionExecutionAndOriginCollection [note: "Таблица-коллекция [(НД) Страны заключения/исполнения Сделки. Страны происхождения оборудования/ТМЦ/объекта прав]"] {
  Id bigint [pk, increment]
  MigrationId int [note: "Идентификатор номера итерации миграции"]
  DocPaydoxId nvarchar(150) [not null, note: "PaydoxId документа"]
  CountriesOfConclusionExecutionAndOrigin nvarchar(150) [note: "(НД) Страны заключения/исполнения Сделки. Страны происхождения оборудования/ТМЦ/объекта прав"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Доставка и логистика»
Table DeliveryAndLogisticCollection [note: "Таблица-коллекция [Доставка и логистика]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  DealFeatureExternalId nvarchar(150) [note: "Внешний ИД справочника Особенность сделки"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Строительство, проектирование и экспертиза»
Table ConstructionDesignExpertiserCollection [note: "Таблица-коллекция [(НД) Строительство, проектирование и экспертиза]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  DealFeatureExternalId nvarchar(150) [note: "Внешний ИД справочника Особенность сделки"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Иностранный элемент»
Table ForeignElementCollection [note: "Таблица-коллекция [(НД) Иностранный элемент]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  DealFeatureExternalId nvarchar(150) [note: "Внешний ИД справочника Особенность сделки"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Особенности дополнений в договоры»
Table FeaturesOfContractAddendaCollection [note: "Таблица-коллекция [(НД) Особенности дополнений в договоры]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  DealFeatureExternalId nvarchar(150) [note: "Внешний ИД справочника Особенность сделки"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Прочие особенности сделки»
Table OtherDealCollection [note: "Таблица-коллекция [(НД) Прочие особенности сделки]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  DealFeatureExternalId nvarchar(150) [note: "Внешний ИД справочника Особенность сделки"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Соответствие правилам долговых финансовых обязательств Группы»
Table GroupDebtRulesComplianceCollection [note: "Таблица-коллекция [(НД) Соответствие правилам долговых финансовых обязательств Группы]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  GroupDebtRulesCompliance nvarchar(150) [note: "Внешний ИД справочника (НД) Соответствие правилам долговых финансовых обязательств Группы"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Оценка по правилам долговых финансовых обязательств Группы »
Table GroupDebtRulesAssessmentCollection [note: "Таблица-коллекция [(НД) Оценка по правилам долговых финансовых обязательств Группы]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  GroupDebtRulesAssesment nvarchar(150) [note: "Внешний ИД справочника (НД) Соответствие правилам долговых финансовых обязательств Группы"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «(НД) Оценка по антимонопольным правилам»
Table AntimonopolyRulesAssessmentCollection [note: "Таблица-коллекция [(НД) Оценка по антимонопольным правилам]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  AntimonopolyRulesAssessment nvarchar(150) [note: "Внешний ИД справочника (НД) Соответствие правилам долговых финансовых обязательств Группы"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Победители»
Table WinnersCollection [note: "Таблица-коллекция [Победители]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  Name nvarchar(250) [note: "Наименование"]
  Amount float [note: "Сумма"]
  CurrencyExternalId nvarchar(150) [note: "Внешний ИД справочника Валюта"]
  Advance float [note: "Аванс"]
  BankGuarantee float [note: "Банковская гарантия"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Резервисты»
Table ReserversCollection [note: "Таблица-коллекция [Резервисты]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  Name nvarchar(250) [note: "Наименование"]
  Amount float [note: "Сумма"]
  CurrencyExternalId nvarchar(150) [note: "Внешний ИД справочника Валюта"]
  Advance float [note: "Аванс"]
  BankGarant float [note: "Банковская гарантия"]
  QueueNumber bigint [note: "Номер очереди"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Решение»
Table SolutionCollection [note: "Таблица-коллекция [Решение]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  SolutionProject nvarchar(1000) [note: "Проект решения"]
  Note nvarchar(1000) [note: "Примечание"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Предприятия-заказчики»
Table CustomerEnterprisesCollection [note: "Таблица-коллекция [Предприятие заказчики]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  CompanyExternalId nvarchar(150) [note: "Наименование - Внешний ИД справочника Организации"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Участники»
Table ParticipantsCollection [note: "Таблица-коллекция [Участники]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  CompanyExternalId nvarchar(150) [note: "Наименование - Внешний ИД справочника Организации"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Коды ТМЦ»
Table TmcCodesCollection [note: "Таблица-коллекция [Коды ТМЦ]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  TmcPaydoxId nvarchar(150) [note: "Наименование - Внешний ИД справочника Коды ТМЦ"]
  Code nvarchar(30) [note: "Код"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Коды ОКВЭД»
Table OkvedCodesCollection [note: "Таблица-коллекция [Коды ОКВЭД]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  OkvedPaydoxId nvarchar(150) [note: "Наименование - Внешний ИД справочника Коды ТМЦ"]
  Code nvarchar(30) [note: "Код"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица-коллекция «Внешние ссылки»
Table ExternalLinksCollection [note: "Таблица-коллекция [Внешние ссылки]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  DocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  Link nvarchar(250) [note: "Ссылка"]
  Comment nvarchar(250) [note: "Комментарий"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица «Права доступа»
Table AccessRights [note: "Таблица [Права доступа]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  FirstDocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  SecondDocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  AccessRightType nvarchar(50) [not null, note: "Тип прав"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица «Связи между документами»
Table DocumentRelations [note: "Таблица [Связи между документами]"]{
  Id bigint       [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  FirstDocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  SecondDocPaydoxId   nvarchar(150) [not null, note: "PaydoxId документа"]
  RelationType nvarchar(50) [not null, note: "Тип связи"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}

// Таблица «Версии документов»
Table DocVersion [note: "Таблица [Версии документов]"] {
  Id              bigint          [pk, increment]
  MigrationId int [ note: "Идентификатор номера итерации миграции"]
  PaydoxId  nvarchar(150)  [not null, note: "Идентификатор в системе PayDox"]
  AddendumPaydoxId  nvarchar(190)  [note: "Идентификатор приложения, сгенерированный DRX"]
  RxId            bigint          [note: "Идентификатор в системе DRX"]
  Filepath        nvarchar(850)  [not null, unique, note: "Путь к файлу на сетевом диске"]
  Name            nvarchar(250)   [note: "Имя файла (приложения). Если это не основной документ, чтобы понимать как назвать карточку приложения"]
  RxDocId         bigint          [note: "Идентификатор документа в системе DRX"]
  RxVersionId     bigint          [note: "Версия документа в RX"]
  IsMain          bit             [not null, note: "Признак основного документа"]
  IsSignature     bit             [not null, note: "Признак файла подписи"]
  MainDocFilepath nvarchar(850)  [ref: > DocVersion.Filepath, note: "Для подписи — ссылка на версию основного файла"]
  Result       nvarchar(50)  [note: "Результат миграции: Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime  datetime2 [note: "Дата миграции"]
  MigrateMessage nvarchar(max) [note: "Сообщение при миграции (обычно в случае ошибки)"]
}
