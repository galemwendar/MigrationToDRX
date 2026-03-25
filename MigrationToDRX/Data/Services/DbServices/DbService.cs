using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Data.Common;

namespace MigrationToDRX.Data.Services.DbServices
{
    public abstract class DbService : IAsyncDisposable, IDisposable
    {
        protected DbConnection SqlConnection { get; set; }
        private readonly ILogger _logger;

        public DbService(DbConnection connection, ILogger logger)
        {
            _logger = logger;
            SqlConnection = connection;
        }

        /// <summary>
        /// Подключиться к базе денных
        /// </summary>
        /// <returns></returns>
        public virtual async Task ConnectAsync()
        {
            await SqlConnection.OpenAsync();
        }

        /// <summary>
        /// Прочитать все данные из таблицы
        /// </summary>
        /// <param name="tableName">Таблица БД</param>
        /// <param name="filter">Подстрока фильтрации. Будет добавлена в where</param>
        /// /// <param name="take">Взять N количество строк</param>
        /// /// <param name="offset">Пропустить N количество строк</param>
        /// <returns></returns>
        public virtual async Task<List<Dictionary<string, object>>> ReadTableAsync(string tableName, string sqlQuery, int migrationId, long take = 30, long offset = 0, string? order = null)
        {
            sqlQuery = sqlQuery.Replace("@MigrationID", migrationId.ToString());
            sqlQuery += $" offset {offset} rows fetch next {take} rows only";
            _logger.LogDebug("DbService ReadTableAsync. Выполнение запроса {}", sqlQuery);

            var queryResult = await SqlConnection.QueryAsync(sqlQuery);
            return queryResult
                .Cast<IDictionary<string, object>>()
                .Select(x => x.ToDictionary(k => k.Key, k => k.Value))
                .ToList();
        }

        public virtual async Task<int> GetRowsCountAsync(string tableName, string? filter = null)
        {
            var filterSubqyery = filter == null ? "" : $"where {filter}";
            var query = $"SELECT Count(*) FROM {tableName} {filterSubqyery}";

            _logger.LogDebug("DbService GetRowsCount. Выполнение запроса {}", query);

            var queryResult = await SqlConnection.QueryAsync<int>(query);
            return queryResult.FirstOrDefault();
        }

        /// <summary>
        /// Получить количество строк по SQL-запросу (оборачивает в SELECT COUNT)
        /// </summary>
        public virtual async Task<int> GetRowCountAsync(string tableName, string sqlQuery, int migrationId)
        {
            var resolvedQuery = sqlQuery.Replace("@MigrationID", migrationId.ToString());
            // Убираем ORDER BY — для COUNT он не нужен
            var queryForCount = System.Text.RegularExpressions.Regex.Replace(
                resolvedQuery, @"\bORDER\s+BY\b[\s\S]*$", "",
                System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            string countQuery;
            // CTE (WITH) нельзя обернуть в подзапрос — заменяем колонки в финальном SELECT на COUNT(*)
            if (queryForCount.TrimStart(';').TrimStart().StartsWith("WITH", StringComparison.OrdinalIgnoreCase))
            {
                var lastSelectIdx = queryForCount.LastIndexOf("SELECT", StringComparison.OrdinalIgnoreCase);
                var fromIdx = queryForCount.IndexOf("FROM", lastSelectIdx, StringComparison.OrdinalIgnoreCase);
                countQuery = queryForCount.Substring(0, lastSelectIdx) + "SELECT COUNT(*) " + queryForCount.Substring(fromIdx);
            }
            else
            {
                countQuery = $"SELECT COUNT(*) FROM ({queryForCount}) AS __cnt";
            }

            _logger.LogDebug("DbService GetRowCountAsync. Выполнение запроса {}", countQuery);

            var result = await SqlConnection.QueryAsync<int>(countQuery);
            return result.FirstOrDefault();
        }

        /// <summary>
        /// Обновить состояние записи в БД
        /// </summary>
        public async Task UpdateDbMigrationResult(string tablename, string externalId, string result, DateTime migrateDate, int inerationId, long? entityId, string? message = null)
        {
            var messageParam = message != null ? ", MigrateMessage = @Message" : "";
            var query = $"UPDATE {tablename} SET RxId = @RxId, IterationId = @IterationId, Result = @Result, MigrateTime = @MigrateTime {messageParam} WHERE PaydoxId = @ExternalId";

            _logger.LogDebug("UpdateDbMigrationResult. Execute query {}", query);

            await SqlConnection.ExecuteAsync(query, new
            {
                RxId = entityId,
                IterationId = inerationId,
                Result = result,
                MigrateTime = migrateDate,
                Message = message,
                ExternalId = externalId
            });
        }

        /// <summary>
        /// Статус подключен ли сервис к БД
        /// </summary>
        public virtual bool IsConnected => SqlConnection.State == ConnectionState.Open;

        /// <summary>
        /// Получить список таблиц
        /// </summary>
        /// <returns></returns>
        public abstract Task<IEnumerable<string>> GetTablesAsync();

        public virtual async ValueTask DisposeAsync() => await SqlConnection.DisposeAsync();

        public void Dispose()
        {
            SqlConnection.Dispose();
        }

        public virtual string GetSqlTemplate(string selectedTable) => $"SELECT * FROM {selectedTable}" + Environment.NewLine +
        "WHERE Result is null ORDER BY Id";
    }
}
