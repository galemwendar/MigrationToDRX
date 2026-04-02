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
Table Currency [note: "Справочник [Курсы валют к USD (месячный)]"] {
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
  Filepath        nvarchar(850)  [not null, unique, note: "Путь к файлу на сетевом диске"]
  Name            nvarchar(250)   [note: "Имя файла (приложения). Если это не основной документ, чтобы понимать как назвать карточку приложения"]
  RxDocId         bigint          [note: "Идентификатор документа в системе DRX"]
  RxVersionId     bigint          [note: "Версия документа в RX"]
  IsMain          bit             [not null, note: "Признак основного документа"]
  IsSignature     bit             [not null, note: "Признак файла подписи"]
  MainDocFilepath nvarchar(850)  [ref: > DocVersion.Filepath, note: "Для подписи — ссылка на версию основного файла"]
  Result          nvarchar(50)    [note: "Migrated | MigratedWithNotes | MigratedError"]
  MigrateTime     datetime2
  MigrateMessage  nvarchar(max)
}
