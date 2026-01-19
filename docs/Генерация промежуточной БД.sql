-- ===============================================
-- Скрипт заполнения тестовыми данными
-- MS SQL Server - База данных: CompanyDB
-- Генерация 100 записей для каждой таблицы
-- ===============================================

USE CompanyDB;
GO

SET NOCOUNT ON;
GO

PRINT N'========================================';
PRINT N'Начало заполнения таблиц тестовыми данными...';
PRINT N'========================================';
PRINT N'';
GO

-- ===============================================
-- 1. Заполнение таблицы Country (100 записей)
-- ===============================================

PRINT N'[1/6] Заполнение таблицы Country...';
GO

INSERT INTO dbo.Country (Id, Name, ДругиеПоля, Result, MigrateTime)
SELECT
    'OU001:CTR:' + Code,
    CountryName,
    N'{"код":"' + Code + N'","население":' + CAST(Population AS NVARCHAR) + N'}',
    CASE WHEN ROW_NUMBER() OVER (ORDER BY Code) % 30 = 0 THEN 'MigratedWithNotes' ELSE 'Migrated' END,
    DATEADD(SECOND, ROW_NUMBER() OVER (ORDER BY Code) * 5, '2024-01-15 10:30:00')
FROM (VALUES
    ('RU', N'Россия', 146000000), ('US', N'США', 331000000), ('CN', N'Китай', 1400000000),
    ('DE', N'Германия', 83000000), ('FR', N'Франция', 67000000), ('GB', N'Великобритания', 67000000),
    ('JP', N'Япония', 126000000), ('IT', N'Италия', 60000000), ('BR', N'Бразилия', 212000000),
    ('CA', N'Канада', 38000000), ('AU', N'Австралия', 25000000), ('IN', N'Индия', 1380000000),
    ('ES', N'Испания', 47000000), ('MX', N'Мексика', 128000000), ('KR', N'Южная Корея', 51000000),
    ('NL', N'Нидерланды', 17000000), ('SE', N'Швеция', 10000000), ('PL', N'Польша', 38000000),
    ('BE', N'Бельгия', 11500000), ('CH', N'Швейцария', 8600000), ('AT', N'Австрия', 9000000),
    ('NO', N'Норвегия', 5400000), ('DK', N'Дания', 5800000), ('FI', N'Финляндия', 5500000),
    ('IE', N'Ирландия', 5000000), ('PT', N'Португалия', 10000000), ('GR', N'Греция', 10700000),
    ('CZ', N'Чехия', 10700000), ('RO', N'Румыния', 19000000), ('HU', N'Венгрия', 9700000),
    ('TR', N'Турция', 84000000), ('IL', N'Израиль', 9200000), ('SA', N'Саудовская Аравия', 34000000),
    ('AE', N'ОАЭ', 9900000), ('SG', N'Сингапур', 5700000), ('MY', N'Малайзия', 32000000),
    ('TH', N'Таиланд', 69800000), ('ID', N'Индонезия', 273000000), ('PH', N'Филиппины', 109000000),
    ('VN', N'Вьетнам', 97000000), ('NZ', N'Новая Зеландия', 5000000), ('AR', N'Аргентина', 45000000),
    ('CL', N'Чили', 19000000), ('CO', N'Колумбия', 50000000), ('PE', N'Перу', 32000000),
    ('ZA', N'ЮАР', 59000000), ('EG', N'Египет', 102000000), ('NG', N'Нигерия', 206000000),
    ('KE', N'Кения', 53000000), ('UA', N'Украина', 44000000), ('BY', N'Беларусь', 9400000),
    ('KZ', N'Казахстан', 18800000), ('UZ', N'Узбекистан', 34000000), ('AZ', N'Азербайджан', 10100000),
    ('GE', N'Грузия', 3700000), ('AM', N'Армения', 2900000), ('LT', N'Литва', 2800000),
    ('LV', N'Латвия', 1900000), ('EE', N'Эстония', 1300000), ('SK', N'Словакия', 5500000),
    ('SI', N'Словения', 2100000), ('HR', N'Хорватия', 4100000), ('RS', N'Сербия', 6900000),
    ('BG', N'Болгария', 6900000), ('LU', N'Люксембург', 626000), ('MT', N'Мальта', 514000),
    ('CY', N'Кипр', 1200000), ('IS', N'Исландия', 364000), ('LI', N'Лихтенштейн', 38000),
    ('MC', N'Монако', 39000), ('AD', N'Андорра', 77000), ('SM', N'Сан-Марино', 33000),
    ('VA', N'Ватикан', 800), ('BA', N'Босния и Герцеговина', 3300000), ('MK', N'Северная Македония', 2100000),
    ('AL', N'Албания', 2900000), ('ME', N'Черногория', 622000), ('MD', N'Молдова', 2600000),
    ('XK', N'Косово', 1800000), ('PK', N'Пакистан', 220000000), ('BD', N'Бангладеш', 164000000),
    ('NP', N'Непал', 29000000), ('LK', N'Шри-Ланка', 21000000), ('MM', N'Мьянма', 54000000),
    ('KH', N'Камбоджа', 16000000), ('LA', N'Лаос', 7200000), ('MN', N'Монголия', 3200000),
    ('BN', N'Бруней', 437000), ('TL', N'Восточный Тимор', 1300000), ('MV', N'Мальдивы', 540000),
    ('BT', N'Бутан', 771000), ('TW', N'Тайвань', 23000000), ('HK', N'Гонконг', 7500000),
    ('MO', N'Макао', 649000), ('KW', N'Кувейт', 4200000), ('QA', N'Катар', 2800000),
    ('BH', N'Бахрейн', 1700000), ('OM', N'Оман', 5100000), ('JO', N'Иордания', 10200000),
    ('LB', N'Ливан', 6800000), ('IQ', N'Ирак', 40000000), ('YE', N'Йемен', 29800000)
) AS Countries(Code, CountryName, Population);
GO

PRINT N'  ✓ Таблица Country заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' записей';
PRINT N'';
GO

-- ===============================================
-- 2. Заполнение таблицы RelationType (20 записей)
-- ===============================================

PRINT N'[2/6] Заполнение таблицы RelationType...';
GO

INSERT INTO dbo.RelationType (IdRx, Name) VALUES
(1, N'Приложение'), (2, N'На основании'), (3, N'Ответ на'), (4, N'Связан с'),
(5, N'Дополнение'), (6, N'Замена'), (7, N'Аннулирует'), (8, N'Ссылается на'),
(9, N'Продолжение'), (10, N'Копия'), (11, N'Версия'), (12, N'Черновик'),
(13, N'Утверждает'), (14, N'Отменяет'), (15, N'Согласует'), (16, N'Подтверждает'),
(17, N'Возражает'), (18, N'Изменяет'), (19, N'Дополняет'), (20, N'Уточняет');
GO

PRINT N'  ✓ Таблица RelationType заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' записей';
PRINT N'';
GO

-- ===============================================
-- 3. Заполнение таблицы Recipient (100 записей)
-- ===============================================

PRINT N'[3/6] Заполнение таблицы Recipient...';
GO

-- Сотрудники (64 записи)
DECLARE @LastNames TABLE (LastName NVARCHAR(50));
INSERT INTO @LastNames VALUES
(N'Иванов'), (N'Петров'), (N'Сидоров'), (N'Козлов'), (N'Морозов'),
(N'Новиков'), (N'Волков'), (N'Соколов'), (N'Лебедев'), (N'Смирнов'),
(N'Федоров'), (N'Егоров'), (N'Павлов'), (N'Романов'), (N'Кузнецов'),
(N'Николаев'), (N'Григорьев'), (N'Захаров'), (N'Семенов'), (N'Михайлов'),
(N'Александров'), (N'Тимофеев'), (N'Борисов'), (N'Давыдов'), (N'Фролов'),
(N'Белов'), (N'Степанов'), (N'Антонов'), (N'Гусев'), (N'Макаров'),
(N'Орлов'), (N'Зайцев'), (N'Медведев'), (N'Королев'), (N'Киселев'),
(N'Жуков'), (N'Воробьев'), (N'Соловьев'), (N'Матвеев'), (N'Крылов'),
(N'Тарасов'), (N'Никитин'), (N'Титов'), (N'Калинин'), (N'Виноградов'),
(N'Фомин'), (N'Крючков'), (N'Комаров'), (N'Громов'), (N'Беляев'),
(N'Князев'), (N'Ковалев'), (N'Голубев'), (N'Чернов'), (N'Панов'),
(N'Денисов'), (N'Осипов'), (N'Трофимов'), (N'Куликов'), (N'Григорьев'),
(N'Ефимов'), (N'Vasil'), (N'Поляков'), (N'Марков');

DECLARE @FirstNames TABLE (FirstName NVARCHAR(50), Gender CHAR(1));
INSERT INTO @FirstNames VALUES
(N'Иван', 'М'), (N'Мария', 'Ж'), (N'Алексей', 'М'), (N'Елена', 'Ж'),
(N'Дмитрий', 'М'), (N'Ольга', 'Ж'), (N'Сергей', 'М'), (N'Анна', 'Ж'),
(N'Михаил', 'М'), (N'Павел', 'М'), (N'Татьяна', 'Ж'), (N'Андрей', 'М'),
(N'Екатерина', 'Ж'), (N'Николай', 'М'), (N'Светлана', 'Ж'), (N'Владимир', 'М'),
(N'Наталья', 'Ж'), (N'Артем', 'М'), (N'Ирина', 'Ж'), (N'Денис', 'М'),
(N'Игорь', 'М'), (N'Виктория', 'Ж'), (N'Константин', 'М'), (N'Людмила', 'Ж'),
(N'Максим', 'М'), (N'Галина', 'Ж'), (N'Артур', 'М'), (N'Оксана', 'Ж'),
(N'Роман', 'М'), (N'Марина', 'Ж'), (N'Валерий', 'М'), (N'Юлия', 'Ж');

DECLARE @Positions TABLE (Position NVARCHAR(100));
INSERT INTO @Positions VALUES
(N'Генеральный директор'), (N'Финансовый директор'), (N'Технический директор'),
(N'Начальник отдела кадров'), (N'Начальник юридического отдела'), (N'Главный бухгалтер'),
(N'Руководитель отдела продаж'), (N'Начальник отдела закупок'), (N'Руководитель IT-отдела'),
(N'Менеджер по развитию'), (N'Секретарь'), (N'Старший юрист'), (N'Бухгалтер'),
(N'Менеджер по продажам'), (N'Специалист по закупкам'), (N'Системный администратор'),
(N'Менеджер по персоналу'), (N'Аналитик'), (N'Маркетолог'), (N'Программист'),
(N'Аудитор'), (N'Дизайнер'), (N'Логист'), (N'Экономист'), (N'Инженер'),
(N'Архивариус'), (N'Водитель'), (N'Офис-менеджер'), (N'Специалист по безопасности'),
(N'Переводчик'), (N'Юрисконсульт'), (N'Специалист по кадрам');

WITH Numbers AS (
    SELECT TOP 64 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Num
    FROM sys.all_objects
)
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов, Result, MigrateTime)
SELECT
    'OU001:EMP:' + RIGHT('00000' + CAST(Num AS VARCHAR), 5),
    N'Сотрудник',
    N'{"ФИО":"' +
    (SELECT TOP 1 LastName FROM @LastNames ORDER BY NEWID()) + N' ' +
    (SELECT TOP 1 FirstName FROM @FirstNames ORDER BY NEWID()) + N' ' +
    (SELECT TOP 1 FirstName FROM @FirstNames WHERE Gender = 'М' ORDER BY NEWID()) + N'ович' +
    N'","должность":"' +
    (SELECT TOP 1 Position FROM @Positions ORDER BY NEWID()) +
    N'","email":"emp' + CAST(Num AS NVARCHAR) + N'@company.ru"}',
    CASE WHEN Num % 25 = 0 THEN 'MigratedWithNotes' ELSE 'Migrated' END,
    DATEADD(SECOND, Num * 5, '2024-01-15 11:00:00')
FROM Numbers;
GO

-- Подразделения (20 записей)
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов, Result, MigrateTime)
SELECT
    'OU001:DEP:' + RIGHT('000' + CAST(Num AS VARCHAR), 3),
    N'Подразделение',
    N'{"название":"' + DeptName + N'","руководитель":"Руководитель ' + CAST(Num AS NVARCHAR) + N'"}',
    'Migrated',
    DATEADD(SECOND, (64 + Num) * 5, '2024-01-15 11:00:00')
FROM (VALUES
    (1, N'Администрация'), (2, N'Финансовый департамент'), (3, N'Технический департамент'),
    (4, N'Отдел кадров'), (5, N'Юридический отдел'), (6, N'Бухгалтерия'),
    (7, N'Отдел продаж'), (8, N'Отдел закупок'), (9, N'IT-отдел'),
    (10, N'Отдел маркетинга'), (11, N'Отдел логистики'), (12, N'Планово-экономический отдел'),
    (13, N'Инженерный отдел'), (14, N'Архив'), (15, N'Административно-хозяйственный отдел'),
    (16, N'Отдел безопасности'), (17, N'Отдел качества'), (18, N'Производственный отдел'),
    (19, N'Отдел развития'), (20, N'Отдел по работе с клиентами')
) AS Departments(Num, DeptName);
GO

-- Роли (10 записей)
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов, Result, MigrateTime)
SELECT
    'OU001:ROLE:' + RIGHT('000' + CAST(Num AS VARCHAR), 3),
    N'Роль',
    N'{"название":"' + RoleName + N'","описание":"' + RoleDesc + N'"}',
    'Migrated',
    DATEADD(SECOND, (84 + Num) * 5, '2024-01-15 11:00:00')
FROM (VALUES
    (1, N'Руководители', N'Все руководители подразделений'),
    (2, N'Бухгалтеры', N'Сотрудники бухгалтерии'),
    (3, N'Менеджеры', N'Все менеджеры компании'),
    (4, N'Юристы', N'Сотрудники юридического отдела'),
    (5, N'IT-специалисты', N'Сотрудники IT-отдела'),
    (6, N'Специалисты', N'Все специалисты компании'),
    (7, N'Разработчики', N'Программисты и разработчики'),
    (8, N'Аналитики', N'Бизнес и системные аналитики'),
    (9, N'Дизайнеры', N'UX/UI дизайнеры'),
    (10, N'Маркетологи', N'Сотрудники отдела маркетинга')
) AS Roles(Num, RoleName, RoleDesc);
GO

-- Организации (6 записей)
INSERT INTO dbo.Recipient (Id, [Type], ПоляRecipientов, Result, MigrateTime) VALUES
('OU001:ORG:001', N'Организация', N'{"название":"ООО Компания","ИНН":"7701234567","КПП":"770101001"}', 'Migrated', '2024-01-15 11:05:00'),
('OU001:ORG:002', N'Организация', N'{"название":"АО Партнер","ИНН":"7702345678","КПП":"770201001"}', 'Migrated', '2024-01-15 11:05:05'),
('OU001:ORG:003', N'Организация', N'{"название":"ООО Техснаб","ИНН":"7703456789","КПП":"770301001"}', 'Migrated', '2024-01-15 11:05:10'),
('OU001:ORG:004', N'Организация', N'{"название":"ЗАО Консалт","ИНН":"7704567890","КПП":"770401001"}', 'Migrated', '2024-01-15 11:05:15'),
('OU001:ORG:005', N'Организация', N'{"название":"ООО Прогресс","ИНН":"7705678901","КПП":"770501001"}', 'Migrated', '2024-01-15 11:05:20'),
('OU001:ORG:006', N'Организация', N'{"название":"ПАО Развитие","ИНН":"7706789012","КПП":"770601001"}', 'Migrated', '2024-01-15 11:05:25');
GO

PRINT N'  ✓ Таблица Recipient заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' записей';
PRINT N'';
GO

-- ===============================================
-- 4. Заполнение таблицы Document (100 записей)
-- ===============================================

PRINT N'[4/6] Заполнение таблицы Document...';
GO

DECLARE @DocTypes TABLE (DocType NVARCHAR(100), Prefix NVARCHAR(10));
INSERT INTO @DocTypes VALUES
(N'Приказ', N'П'), (N'Договор', N'ДГ'), (N'Акт', N'АКТ'), (N'Служебная записка', N'СЗ'),
(N'Протокол', N'ПР'), (N'Положение', N'ПЛЖ'), (N'Отчет', N'ОТЧ'), (N'Заявка', N'ЗВК'),
(N'Счет', N'СЧ'), (N'Письмо', N'ПСМ'), (N'Инструкция', N'ИНС'), (N'Контракт', N'КНТ');

WITH Numbers AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Num
    FROM sys.all_objects
),
RandomData AS (
    SELECT
        Num,
        ABS(CHECKSUM(NEWID())) % 12 + 1 AS DocTypeIdx,
        ABS(CHECKSUM(NEWID())) % 100 + 1 AS CountryIdx,
        ABS(CHECKSUM(NEWID())) % 64 + 1 AS AuthorIdx
    FROM Numbers
)
INSERT INTO dbo.Document (Id, Name, ДругиеПоля, CountryId, AuthorId, Note, Result, MigrateTime)
SELECT
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3),
    dt.DocType + N' №' + dt.Prefix + N'-' + CAST(Num AS NVARCHAR) + N'/24',
    N'{"номер":"' + dt.Prefix + N'-' + CAST(Num AS NVARCHAR) +
    N'","дата":"2024-' + RIGHT('0' + CAST((Num % 12) + 1 AS VARCHAR), 2) + N'-' +
    RIGHT('0' + CAST((Num % 28) + 1 AS VARCHAR), 2) +
    N'","сумма":' + CAST((Num * 10000) AS NVARCHAR) + N'}',
    'OU001:CTR:' + (SELECT TOP 1 Code FROM (VALUES
        ('RU'),('US'),('CN'),('DE'),('FR'),('GB'),('JP'),('IT'),('BR'),('CA'),
        ('AU'),('IN'),('ES'),('MX'),('KR'),('NL'),('SE'),('PL'),('BE'),('CH')
    ) AS C(Code) ORDER BY NEWID()),
    'OU001:EMP:' + RIGHT('00000' + CAST(rd.AuthorIdx AS VARCHAR), 5),
    CASE WHEN Num % 10 = 0 THEN N'Важный документ' ELSE NULL END,
    CASE
        WHEN Num % 30 = 0 THEN 'MigratedWithNotes'
        WHEN Num % 50 = 0 THEN 'MigratedError'
        ELSE 'Migrated'
    END,
    DATEADD(MINUTE, Num * 2, '2024-01-15 12:00:00')
FROM RandomData rd
CROSS APPLY (
    SELECT TOP 1 * FROM @DocTypes ORDER BY NEWID()
) dt;
GO

PRINT N'  ✓ Таблица Document заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' записей';
PRINT N'';
GO

-- ===============================================
-- 5. Заполнение таблицы Version (100+ записей)
-- ===============================================

PRINT N'[5/6] Заполнение таблицы Version...';
GO

-- Основные версии документов
WITH Numbers AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Num
    FROM sys.all_objects
)
INSERT INTO dbo.Version (Id, Filepath, RxDocId, RxVersionId, IsMain, IsSignature, MainDocFilepath, Result, MigrateTime)
SELECT
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3) + ':V1',
    N'\\fileserver\documents\2024\' + RIGHT('000' + CAST(Num AS VARCHAR), 3) + N'\main.pdf',
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3),
    Num * 100,
    1,
    0,
    NULL,
    CASE WHEN Num % 40 = 0 THEN 'MigratedWithNotes' ELSE 'Migrated' END,
    DATEADD(MINUTE, Num * 2 + 1, '2024-01-15 12:00:00')
FROM Numbers;
GO

-- Файлы подписей (50 записей)
WITH Numbers AS (
    SELECT TOP 50 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Num
    FROM sys.all_objects
)
INSERT INTO dbo.Version (Id, Filepath, RxDocId, RxVersionId, IsMain, IsSignature, MainDocFilepath, Result, MigrateTime)
SELECT
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3) + ':SIG',
    N'\\fileserver\documents\2024\' + RIGHT('000' + CAST(Num AS VARCHAR), 3) + N'\signature.sig',
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3),
    NULL,
    0,
    1,
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3) + ':V1',
    'Migrated',
    DATEADD(MINUTE, Num * 2 + 2, '2024-01-15 12:00:00')
FROM Numbers;
GO

PRINT N'  ✓ Таблица Version заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' записей';
PRINT N'';
GO

-- ===============================================
-- 6. Заполнение таблицы Relation (100 записей)
-- ===============================================

PRINT N'[6/6] Заполнение таблицы Relation...';
GO

WITH Numbers AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Num
    FROM sys.all_objects
)
INSERT INTO dbo.Relation (Id, RelationTypeId, SourceDocId, TargetDocId, Result, MigrateTime)
SELECT
    'REL-' + RIGHT('00000' + CAST(Num AS VARCHAR), 5),
    (Num % 20) + 1,
    'OU001:DOC:2024-' + RIGHT('000' + CAST(Num AS VARCHAR), 3),
    'OU001:DOC:2024-' + RIGHT('000' + CAST((Num % 99) + 1 AS VARCHAR), 3),
    CASE WHEN Num % 35 = 0 THEN 'MigratedWithNotes' ELSE 'Migrated' END,
    DATEADD(MINUTE, Num * 3, '2024-01-15 13:00:00')
FROM Numbers
WHERE Num != (Num % 99) + 1; -- Избегаем самосвязей
GO

PRINT N'  ✓ Таблица Relation заполнена: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' записей';
PRINT N'';
GO

-- ===============================================
-- Статистика по заполнению
-- ===============================================

PRINT N'========================================';
PRINT N'Статистика заполнения:';
PRINT N'========================================';

SELECT
    N'Country' AS Таблица,
    COUNT(*) AS [Количество записей],
    SUM(CASE WHEN Result = 'Migrated' THEN 1 ELSE 0 END) AS [Migrated],
    SUM(CASE WHEN Result = 'MigratedWithNotes' THEN 1 ELSE 0 END) AS [MigratedWithNotes],
    SUM(CASE WHEN Result = 'MigratedError' THEN 1 ELSE 0 END) AS [MigratedError]
FROM dbo.Country
UNION ALL
SELECT
    N'RelationType',
    COUNT(*),
    COUNT(*),
    0,
    0
FROM dbo.RelationType
UNION ALL
SELECT
    N'Recipient',
    COUNT(*),
    SUM(CASE WHEN Result = 'Migrated' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedWithNotes' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedError' THEN 1 ELSE 0 END)
FROM dbo.Recipient
UNION ALL
SELECT
    N'Document',
    COUNT(*),
    SUM(CASE WHEN Result = 'Migrated' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedWithNotes' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedError' THEN 1 ELSE 0 END)
FROM dbo.Document
UNION ALL
SELECT
    N'Version',
    COUNT(*),
    SUM(CASE WHEN Result = 'Migrated' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedWithNotes' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedError' THEN 1 ELSE 0 END)
FROM dbo.Version
UNION ALL
SELECT
    N'Relation',
    COUNT(*),
    SUM(CASE WHEN Result = 'Migrated' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedWithNotes' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Result = 'MigratedError' THEN 1 ELSE 0 END)
FROM dbo.Relation;

PRINT N'';
PRINT N'========================================';
PRINT N'Заполнение завершено успешно!';
PRINT N'========================================';
GO

SET NOCOUNT OFF;
GO
