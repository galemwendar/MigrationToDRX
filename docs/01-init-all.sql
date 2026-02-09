-- ===============================================
-- Скрипт создания таблиц БД для системы миграции документов
-- MS SQL Server
-- ===============================================

IF DB_ID('CompanyDB') IS NULL
    CREATE DATABASE CompanyDB;
GO

USE CompanyDB;
GO

-- Удаление существующих таблиц (если нужно пересоздать)
IF OBJECT_ID('dbo.Relation', 'U') IS NOT NULL DROP TABLE dbo.Relation;
IF OBJECT_ID('dbo.Version', 'U') IS NOT NULL DROP TABLE dbo.Version;
IF OBJECT_ID('dbo.Document', 'U') IS NOT NULL DROP TABLE dbo.Document;
IF OBJECT_ID('dbo.RelationType', 'U') IS NOT NULL DROP TABLE dbo.RelationType;
IF OBJECT_ID('dbo.Recipient', 'U') IS NOT NULL DROP TABLE dbo.Recipient;
IF OBJECT_ID('dbo.Country', 'U') IS NOT NULL DROP TABLE dbo.Country;
IF OBJECT_ID('dbo.BusinessUnits', 'U') IS NOT NULL DROP TABLE dbo.BusinessUnits;
GO

-- ===============================================
-- Справочные таблицы
-- ===============================================

-- Таблица: BusinessUnits (Бизнес-единицы)
CREATE TABLE dbo.BusinessUnits (
    Id NVARCHAR(30) PRIMARY KEY,
    Name NVARCHAR(250) NOT NULL,
    Code NVARCHAR(3),
    ДругиеПоля NVARCHAR(MAX),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
    MigrateMessage NVARCHAR(MAX)
);
GO

-- Таблица: Country (Страны)
CREATE TABLE dbo.Country (
    Id NVARCHAR(30) PRIMARY KEY,
    Name NVARCHAR(250) NOT NULL,
    Code NVARCHAR(3),
    ДругиеПоля NVARCHAR(MAX),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
    MigrateMessage NVARCHAR(MAX)
);
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Страны',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Country';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Составной ключ из нескольких полей - Орг единица:Ид документа:Буквенный ИД',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Country',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Результат миграции: Migrated, MigratedWithNotes, MigratedError',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Country',
    @level2type = N'COLUMN', @level2name = N'Result';
GO

-- ===============================================

-- Таблица: Recipient (Получатели/Сотрудники)
CREATE TABLE dbo.Recipient (
    Id NVARCHAR(30) PRIMARY KEY,
    [Type] NVARCHAR(300) NOT NULL,
    ПоляRecipientов NVARCHAR(MAX),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
    MigrateMessage NVARCHAR(MAX)
);
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Сотрудники, роли, подразделения, все кто подходят как группа пользователей',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Recipient';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Сотрудник, подразделения, наша организация, роли и т.д.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Recipient',
    @level2type = N'COLUMN', @level2name = N'Type';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Результат миграции: Migrated, MigratedWithNotes, MigratedError',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Recipient',
    @level2type = N'COLUMN', @level2name = N'Result';
GO

-- ===============================================

-- Таблица: RelationType (Типы связей)
CREATE TABLE dbo.RelationType (
    IdRx INT PRIMARY KEY,
    Name NVARCHAR(250) NOT NULL
);
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Типы связей между документами (Приложение, на основании и т.д)',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'RelationType';
GO

-- ===============================================
-- Основные таблицы
-- ===============================================

-- Таблица: Document (Документы)
CREATE TABLE dbo.Document (
    Id NVARCHAR(30) PRIMARY KEY,
    Name NVARCHAR(250) NOT NULL,
    ДругиеПоля NVARCHAR(MAX),
    CountryId NVARCHAR(30),
    AuthorId NVARCHAR(30),
    Note NVARCHAR(500),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
    MigrateMessage NVARCHAR(MAX),
    CONSTRAINT FK_Document_Country FOREIGN KEY (CountryId) REFERENCES dbo.Country(Id),
    CONSTRAINT FK_Document_Author FOREIGN KEY (AuthorId) REFERENCES dbo.Recipient(Id)
);
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Документы',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Document';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Составной ключ из нескольких полей - Орг единица:Ид документа:Буквенный ИД',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Document',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Результат миграции: Migrated, MigratedWithNotes, MigratedError',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Document',
    @level2type = N'COLUMN', @level2name = N'Result';
GO

-- ===============================================

-- Таблица: Version (Версии документов)
CREATE TABLE dbo.Version (
    Id NVARCHAR(30) PRIMARY KEY,
    Filepath NVARCHAR(3000) NOT NULL,
    RxDocId NVARCHAR(30) NOT NULL,
    RxVersionId BIGINT,
    IsMain BIT NOT NULL,
    IsSignature BIT NOT NULL,
    MainDocFilepath NVARCHAR(30),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
    MigrateMessage NVARCHAR(MAX),
    CONSTRAINT FK_Version_Document FOREIGN KEY (RxDocId) REFERENCES dbo.Document(Id),
    CONSTRAINT FK_Version_MainDoc FOREIGN KEY (MainDocFilepath) REFERENCES dbo.Version(Id)
);
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Версии документов',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Составной ключ из нескольких полей - Орг единица:Ид документа:Номер документа',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Путь к файлу на сетевом диске',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'Filepath';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Версия документа в RX',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'RxVersionId';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Признак основного документа',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'IsMain';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Признак что это файл подписи',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'IsSignature';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Для файла подписи указывается к какой версии он относится',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'MainDocFilepath';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Результат миграции: Migrated, MigratedWithNotes, MigratedError',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Version',
    @level2type = N'COLUMN', @level2name = N'Result';
GO

-- ===============================================

-- Таблица: Relation (Связи документов)
CREATE TABLE dbo.Relation (
    Id NVARCHAR(30) PRIMARY KEY,
    RelationTypeId INT NOT NULL,
    SourceDocId NVARCHAR(30) NOT NULL,
    TargetDocId NVARCHAR(30) NOT NULL,
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
    MigrateMessage NVARCHAR(MAX),
    CONSTRAINT FK_Relation_Type FOREIGN KEY (RelationTypeId) REFERENCES dbo.RelationType(IdRx),
    CONSTRAINT FK_Relation_SourceDoc FOREIGN KEY (SourceDocId) REFERENCES dbo.Document(Id),
    CONSTRAINT FK_Relation_TargetDoc FOREIGN KEY (TargetDocId) REFERENCES dbo.Document(Id)
);
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Таблица связей документов',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Relation';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Тип связи',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Relation',
    @level2type = N'COLUMN', @level2name = N'RelationTypeId';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description', @value = N'Результат миграции: Migrated, MigratedWithNotes, MigratedError',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Relation',
    @level2type = N'COLUMN', @level2name = N'Result';
GO

-- ===============================================
-- Индексы для оптимизации запросов
-- ===============================================

-- Индексы для таблицы Document
CREATE NONCLUSTERED INDEX IX_Document_CountryId ON dbo.Document(CountryId);
CREATE NONCLUSTERED INDEX IX_Document_AuthorId ON dbo.Document(AuthorId);
CREATE NONCLUSTERED INDEX IX_Document_Result ON dbo.Document(Result);
CREATE NONCLUSTERED INDEX IX_Document_MigrateTime ON dbo.Document(MigrateTime);
GO

-- Индексы для таблицы Version
CREATE NONCLUSTERED INDEX IX_Version_RxDocId ON dbo.Version(RxDocId);
CREATE NONCLUSTERED INDEX IX_Version_IsMain ON dbo.Version(IsMain);
CREATE NONCLUSTERED INDEX IX_Version_IsSignature ON dbo.Version(IsSignature);
CREATE NONCLUSTERED INDEX IX_Version_Result ON dbo.Version(Result);
GO

-- Индексы для таблицы Relation
CREATE NONCLUSTERED INDEX IX_Relation_RelationTypeId ON dbo.Relation(RelationTypeId);
CREATE NONCLUSTERED INDEX IX_Relation_SourceDocId ON dbo.Relation(SourceDocId);
CREATE NONCLUSTERED INDEX IX_Relation_TargetDocId ON dbo.Relation(TargetDocId);
CREATE NONCLUSTERED INDEX IX_Relation_Result ON dbo.Relation(Result);
GO

-- Индексы для таблицы Recipient
CREATE NONCLUSTERED INDEX IX_Recipient_Type ON dbo.Recipient([Type]);
CREATE NONCLUSTERED INDEX IX_Recipient_Result ON dbo.Recipient(Result);
GO

-- Индексы для таблицы Country
CREATE NONCLUSTERED INDEX IX_Country_Result ON dbo.Country(Result);
GO

PRINT N'Таблицы успешно созданы в базе данных CompanyDB';
GO

-- ===============================================
-- ЗАПОЛНЕНИЕ ТЕСТОВЫМИ ДАННЫМИ
-- ===============================================

PRINT N'Начало заполнения тестовыми данными...';
GO

-- 1. Заполнение таблицы RelationType
INSERT INTO dbo.RelationType (IdRx, Name) VALUES
(1, N'Приложение'),
(2, N'На основании'),
(3, N'Ответ на'),
(4, N'Связан с'),
(5, N'Дополнение'),
(6, N'Замена'),
(7, N'Аннулирует'),
(8, N'Ссылается на'),
(9, N'Продолжение'),
(10, N'Копия'),
(11, N'Версия'),
(12, N'Черновик'),
(13, N'Утверждает'),
(14, N'Отменяет'),
(15, N'Согласует'),
(16, N'Подтверждает'),
(17, N'Возражает'),
(18, N'Изменяет'),
(19, N'Дополняет'),
(20, N'Уточняет');
GO

PRINT N'Таблица RelationType заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

-- 2. Заполнение таблицы Country
INSERT INTO dbo.Country (Id, Name, Code, ДругиеПоля) VALUES
(N'OU001:CTR:RU', N'Россия', N'101', N'{"население":146000000}'),
(N'OU001:CTR:US', N'США', N'102', N'{"население":331000000}'),
(N'OU001:CTR:CN', N'Китай', N'103', N'{"население":1400000000}'),
(N'OU001:CTR:DE', N'Германия', N'104', N'{"население":83000000}'),
(N'OU001:CTR:FR', N'Франция', N'105', N'{"население":67000000}'),
(N'OU001:CTR:GB', N'Великобритания', N'106', N'{"население":67000000}'),
(N'OU001:CTR:JP', N'Япония', N'107', N'{"население":126000000}'),
(N'OU001:CTR:IT', N'Италия', N'108', N'{"население":60000000}'),
(N'OU001:CTR:BR', N'Бразилия', N'109', N'{"население":212000000}'),
(N'OU001:CTR:CA', N'Канада', N'110', N'{"население":38000000}');
GO

PRINT N'Таблица Country заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

-- 2a. Заполнение таблицы BusinessUnits (30 записей)
INSERT INTO dbo.BusinessUnits (Id, Name, Code, ДругиеПоля, Result, MigrateTime, MigrateMessage) VALUES
(N'OU001:BU:MSK', N'Главный офис Москва', N'HQ', N'{"адрес":"г. Москва, ул. Ленина, 1","тип":"Головной офис"}', NULL, NULL, NULL),
(N'OU001:BU:SPB', N'Филиал Санкт-Петербург', N'SPB', N'{"адрес":"г. Санкт-Петербург, Невский пр., 50","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:NSK', N'Филиал Новосибирск', N'NSK', N'{"адрес":"г. Новосибирск, Красный пр., 18","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:EKB', N'Филиал Екатеринбург', N'EKB', N'{"адрес":"г. Екатеринбург, ул. Малышева, 36","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:KZN', N'Представительство Казань', N'KZN', N'{"адрес":"г. Казань, ул. Баумана, 22","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:CHE', N'Филиал Челябинск', N'CHE', N'{"адрес":"г. Челябинск, пр. Ленина, 83","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:VLG', N'Представительство Волгоград', N'VLG', N'{"адрес":"г. Волгоград, ул. Мира, 15","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:NNV', N'Филиал Нижний Новгород', N'NNV', N'{"адрес":"г. Нижний Новгород, ул. Большая Покровская, 7","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:RST', N'Филиал Ростов-на-Дону', N'RST', N'{"адрес":"г. Ростов-на-Дону, ул. Большая Садовая, 47","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:SMR', N'Представительство Самара', N'SMR', N'{"адрес":"г. Самара, ул. Куйбышева, 90","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:PRM', N'Филиал Пермь', N'PRM', N'{"адрес":"г. Пермь, ул. Ленина, 64","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:UFA', N'Филиал Уфа', N'UFA', N'{"адрес":"г. Уфа, пр. Октября, 132","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:VOR', N'Представительство Воронеж', N'VOR', N'{"адрес":"г. Воронеж, пр. Революции, 25","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:KRD', N'Филиал Краснодар', N'KRD', N'{"адрес":"г. Краснодар, ул. Красная, 109","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:OMS', N'Представительство Омск', N'OMS', N'{"адрес":"г. Омск, ул. Ленина, 20","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:IRK', N'Филиал Иркутск', N'IRK', N'{"адрес":"г. Иркутск, ул. Карла Маркса, 40","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:VLV', N'Филиал Владивосток', N'VLV', N'{"адрес":"г. Владивосток, ул. Светланская, 12","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:TMN', N'Представительство Тюмень', N'TMN', N'{"адрес":"г. Тюмень, ул. Республики, 55","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:YAR', N'Представительство Ярославль', N'YAR', N'{"адрес":"г. Ярославль, ул. Свободы, 30","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:KRS', N'Филиал Красноярск', N'KRS', N'{"адрес":"г. Красноярск, пр. Мира, 94","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:NKZ', N'Представительство Новокузнецк', N'NKZ', N'{"адрес":"г. Новокузнецк, ул. Кирова, 5","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:LPK', N'Представительство Липецк', N'LPK', N'{"адрес":"г. Липецк, ул. Советская, 14","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:KMR', N'Представительство Кемерово', N'KMR', N'{"адрес":"г. Кемерово, пр. Советский, 61","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:RYZ', N'Представительство Рязань', N'RYZ', N'{"адрес":"г. Рязань, ул. Почтовая, 3","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:SAR', N'Филиал Саратов', N'SAR', N'{"адрес":"г. Саратов, ул. Московская, 72","тип":"Филиал"}', NULL, NULL, NULL),
(N'OU001:BU:PNZ', N'Представительство Пенза', N'PNZ', N'{"адрес":"г. Пенза, ул. Московская, 86","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:ORE', N'Представительство Оренбург', N'ORE', N'{"адрес":"г. Оренбург, ул. Советская, 48","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:SIM', N'Представительство Симферополь', N'SIM', N'{"адрес":"г. Симферополь, пр. Кирова, 17","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:ZLN', N'Представительство Зеленоград', N'ZLN', N'{"адрес":"г. Зеленоград, Центральный пр., 401","тип":"Представительство"}', NULL, NULL, NULL),
(N'OU001:BU:SCH', N'Представительство Сочи', N'SCH', N'{"адрес":"г. Сочи, ул. Навагинская, 9","тип":"Представительство"}', NULL, NULL, NULL);
GO

PRINT N'Таблица BusinessUnits заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

-- 3. Заполнение таблицы Recipient - Сотрудники
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов) VALUES
(N'OU001:EMP:00001', N'Сотрудник', N'{"ФИО":"Иванов Иван Иванович","должность":"Генеральный директор","email":"ivanov@company.ru"}'),
(N'OU001:EMP:00002', N'Сотрудник', N'{"ФИО":"Петрова Мария Сергеевна","должность":"Финансовый директор","email":"petrova@company.ru"}'),
(N'OU001:EMP:00003', N'Сотрудник', N'{"ФИО":"Сидоров Алексей Петрович","должность":"Технический директор","email":"sidorov@company.ru"}'),
(N'OU001:EMP:00004', N'Сотрудник', N'{"ФИО":"Козлова Елена Андреевна","должность":"Начальник отдела кадров","email":"kozlova@company.ru"}'),
(N'OU001:EMP:00005', N'Сотрудник', N'{"ФИО":"Морозов Дмитрий Владимирович","должность":"Начальник юридического отдела","email":"morozov@company.ru"}'),
(N'OU001:EMP:00006', N'Сотрудник', N'{"ФИО":"Новикова Ольга Николаевна","должность":"Главный бухгалтер","email":"novikova@company.ru"}'),
(N'OU001:EMP:00007', N'Сотрудник', N'{"ФИО":"Волков Сергей Александрович","должность":"Руководитель отдела продаж","email":"volkov@company.ru"}'),
(N'OU001:EMP:00008', N'Сотрудник', N'{"ФИО":"Соколова Анна Михайловна","должность":"Менеджер по продажам","email":"sokolova@company.ru"}'),
(N'OU001:EMP:00009', N'Сотрудник', N'{"ФИО":"Лебедев Михаил Игоревич","должность":"Системный администратор","email":"lebedev@company.ru"}'),
(N'OU001:EMP:00010', N'Сотрудник', N'{"ФИО":"Смирнова Татьяна Викторовна","должность":"Секретарь","email":"smirnova@company.ru"}');
GO

-- Подразделения
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов) VALUES
(N'OU001:DEP:001', N'Подразделение', N'{"название":"Администрация","руководитель":"Иванов И.И."}'),
(N'OU001:DEP:002', N'Подразделение', N'{"название":"Финансовый департамент","руководитель":"Петрова М.С."}'),
(N'OU001:DEP:003', N'Подразделение', N'{"название":"Технический департамент","руководитель":"Сидоров А.П."}'),
(N'OU001:DEP:004', N'Подразделение', N'{"название":"Отдел кадров","руководитель":"Козлова Е.А."}'),
(N'OU001:DEP:005', N'Подразделение', N'{"название":"Юридический отдел","руководитель":"Морозов Д.В."}');
GO

-- Роли
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов) VALUES
(N'OU001:ROLE:001', N'Роль', N'{"название":"Руководители","описание":"Все руководители подразделений"}'),
(N'OU001:ROLE:002', N'Роль', N'{"название":"Бухгалтеры","описание":"Сотрудники бухгалтерии"}'),
(N'OU001:ROLE:003', N'Роль', N'{"название":"Менеджеры","описание":"Все менеджеры компании"}');
GO

-- Организации
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов) VALUES
(N'OU001:ORG:001', N'Организация', N'{"название":"ООО Компания","ИНН":"7701234567","КПП":"770101001"}'),
(N'OU001:ORG:002', N'Организация', N'{"название":"АО Партнер","ИНН":"7702345678","КПП":"770201001"}');
GO

PRINT N'Таблица Recipient заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

-- 4. Заполнение таблицы Document
INSERT INTO dbo.Document (Id, Name, ДругиеПоля, CountryId, AuthorId, Note) VALUES
(N'OU001:DOC:2024-001', N'Приказ №П-001/24', N'{"номер":"П-001","дата":"2024-01-15","сумма":0}', N'OU001:CTR:RU', N'OU001:EMP:00001', N'О назначении комиссии'),
(N'OU001:DOC:2024-002', N'Договор №ДГ-002/24', N'{"номер":"ДГ-002","дата":"2024-01-20","сумма":500000}', N'OU001:CTR:RU', N'OU001:EMP:00007', N'Договор поставки оборудования'),
(N'OU001:DOC:2024-003', N'Акт №АКТ-003/24', N'{"номер":"АКТ-003","дата":"2024-02-01","сумма":500000}', N'OU001:CTR:RU', N'OU001:EMP:00007', N'Акт выполненных работ'),
(N'OU001:DOC:2024-004', N'Служебная записка №СЗ-004/24', N'{"номер":"СЗ-004","дата":"2024-02-05","сумма":0}', N'OU001:CTR:RU', N'OU001:EMP:00004', NULL),
(N'OU001:DOC:2024-005', N'Протокол №ПР-005/24', N'{"номер":"ПР-005","дата":"2024-02-10","сумма":0}', N'OU001:CTR:RU', N'OU001:EMP:00001', N'Протокол заседания правления'),
(N'OU001:DOC:2024-006', N'Положение №ПЛЖ-006/24', N'{"номер":"ПЛЖ-006","дата":"2024-02-15","сумма":0}', N'OU001:CTR:RU', N'OU001:EMP:00005', N'Положение о премировании'),
(N'OU001:DOC:2024-007', N'Отчет №ОТЧ-007/24', N'{"номер":"ОТЧ-007","дата":"2024-02-20","сумма":0}', N'OU001:CTR:RU', N'OU001:EMP:00002', N'Финансовый отчет за январь'),
(N'OU001:DOC:2024-008', N'Заявка №ЗВК-008/24', N'{"номер":"ЗВК-008","дата":"2024-02-25","сумма":150000}', N'OU001:CTR:RU', N'OU001:EMP:00003', NULL),
(N'OU001:DOC:2024-009', N'Счет №СЧ-009/24', N'{"номер":"СЧ-009","дата":"2024-03-01","сумма":250000}', N'OU001:CTR:RU', N'OU001:EMP:00007', NULL),
(N'OU001:DOC:2024-010', N'Письмо №ПСМ-010/24', N'{"номер":"ПСМ-010","дата":"2024-03-05","сумма":0}', N'OU001:CTR:US', N'OU001:EMP:00001', N'Письмо партнерам');
GO

PRINT N'Таблица Document заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

-- 5. Заполнение таблицы Version
INSERT INTO dbo.Version (Id, Filepath, RxDocId, RxVersionId, IsMain, IsSignature, MainDocFilepath) VALUES
(N'OU001:DOC:2024-001:V1', N'\\fileserver\documents\2024\001\main.pdf', N'OU001:DOC:2024-001', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-002:V1', N'\\fileserver\documents\2024\002\main.pdf', N'OU001:DOC:2024-002', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-002:SIG', N'\\fileserver\documents\2024\002\signature.sig', N'OU001:DOC:2024-002', NULL, 0, 1, N'OU001:DOC:2024-002:V1'),
(N'OU001:DOC:2024-003:V1', N'\\fileserver\documents\2024\003\main.pdf', N'OU001:DOC:2024-003', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-003:SIG', N'\\fileserver\documents\2024\003\signature.sig', N'OU001:DOC:2024-003', NULL, 0, 1, N'OU001:DOC:2024-003:V1'),
(N'OU001:DOC:2024-004:V1', N'\\fileserver\documents\2024\004\main.docx', N'OU001:DOC:2024-004', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-005:V1', N'\\fileserver\documents\2024\005\main.pdf', N'OU001:DOC:2024-005', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-006:V1', N'\\fileserver\documents\2024\006\main.pdf', N'OU001:DOC:2024-006', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-007:V1', N'\\fileserver\documents\2024\007\report.xlsx', N'OU001:DOC:2024-007', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-008:V1', N'\\fileserver\documents\2024\008\main.pdf', N'OU001:DOC:2024-008', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-009:V1', N'\\fileserver\documents\2024\009\invoice.pdf', N'OU001:DOC:2024-009', NULL, 1, 0, NULL),
(N'OU001:DOC:2024-010:V1', N'\\fileserver\documents\2024\010\letter.pdf', N'OU001:DOC:2024-010', NULL, 1, 0, NULL);
GO

PRINT N'Таблица Version заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

-- 6. Заполнение таблицы Relation
INSERT INTO dbo.Relation (Id, RelationTypeId, SourceDocId, TargetDocId) VALUES
(N'REL-00001', 1, N'OU001:DOC:2024-003', N'OU001:DOC:2024-002'),
(N'REL-00002', 2, N'OU001:DOC:2024-003', N'OU001:DOC:2024-002'),
(N'REL-00003', 1, N'OU001:DOC:2024-009', N'OU001:DOC:2024-002'),
(N'REL-00004', 8, N'OU001:DOC:2024-004', N'OU001:DOC:2024-006'),
(N'REL-00005', 4, N'OU001:DOC:2024-005', N'OU001:DOC:2024-001');
GO

PRINT N'Таблица Relation заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR);
GO

PRINT N'Заполнение тестовыми данными завершено успешно!';
GO
