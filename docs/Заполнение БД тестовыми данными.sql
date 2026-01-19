-- ===============================================
-- Скрипт создания таблиц БД для системы миграции документов
-- MS SQL Server
-- База данных: CompanyDB
-- ===============================================

USE CompanyDB;
GO

-- Удаление существующих таблиц (если нужно пересоздать)

IF OBJECT_ID('dbo.Relation', 'U') IS NOT NULL DROP TABLE dbo.Relation;
IF OBJECT_ID('dbo.Version', 'U') IS NOT NULL DROP TABLE dbo.Version;
IF OBJECT_ID('dbo.Document', 'U') IS NOT NULL DROP TABLE dbo.Document;
IF OBJECT_ID('dbo.RelationType', 'U') IS NOT NULL DROP TABLE dbo.RelationType;
IF OBJECT_ID('dbo.Recipient', 'U') IS NOT NULL DROP TABLE dbo.Recipient;
IF OBJECT_ID('dbo.Country', 'U') IS NOT NULL DROP TABLE dbo.Country;
GO


-- ===============================================
-- Справочные таблицы
-- ===============================================

-- Таблица: Country (Страны)
CREATE TABLE dbo.Country (
    Id NVARCHAR(30) PRIMARY KEY,
    Name NVARCHAR(250) NOT NULL,
    ДругиеПоля NVARCHAR(MAX),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2
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
    MigrateTime DATETIME2
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
    RxDocId NVARCHAR(30),
    RxVersionId BIGINT,
    IsMain BIT NOT NULL,
    IsSignature BIT NOT NULL,
    MainDocFilepath NVARCHAR(30),
    Result NVARCHAR(50) CHECK(Result IN ('Migrated', 'MigratedWithNotes', 'MigratedError')),
    MigrateTime DATETIME2,
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
    @name = N'MS_Description', @value = N'Автоинкремент (если требуется, добавить IDENTITY)',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Relation',
    @level2type = N'COLUMN', @level2name = N'Id';
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

-- ===============================================
-- Завершение скрипта
-- ===============================================

PRINT N'Таблицы успешно созданы в базе данных CompanyDB';
GO
