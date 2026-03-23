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
        public virtual async Task<List<Dictionary<string, object>>> ReadTableAsync(string tableName, string sqlQuery, int migrationId, long? take = null, long offset = 0, string? order = null)
        {
            sqlQuery = sqlQuery.Replace("@MigrationID", migrationId.ToString());
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
        /// Обновить состояние записи в БД
        /// </summary>
        public async Task UpdateDbMigrationResult(string tablename, string externalId, string result, DateTime migrateDate, string? message = null)
        {
            var messageParam = message != null ? ", MigrateMessage = @Message" : "";
            var query = $"UPDATE {tablename} SET Result = @Result, MigrateTime = @MigrateTime{messageParam} WHERE IdPaydox = @ExternalId";

            _logger.LogDebug("UpdateDbMigrationResult. Execute query {}", query);

            await SqlConnection.ExecuteAsync(query, new { Result = result, MigrateTime = migrateDate, Message = message, ExternalId = externalId });
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
        "WHERE MigrationID = @MigrationID AND Result is null ORDER BY Id";
    }
}
