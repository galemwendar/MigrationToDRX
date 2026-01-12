using Dapper;
using System.Data;
using System.Data.Common;

namespace MigrationToDRX.Data.Services.DbServices
{
    public abstract class DbService : IAsyncDisposable, IDisposable
    {
        protected DbConnection SqlConnection { get; set; }

        public DbService(DbConnection connection)
        {
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
        /// <returns></returns>
        public virtual async Task<List<Dictionary<string, object>>> ReadTableAsync(string tableName)
        {
            var queryResult = await SqlConnection.QueryAsync($"SELECT * FROM {tableName};");
            return queryResult
                .Cast<IDictionary<string, object>>()
                .Select(x => x.ToDictionary(k => k.Key, k => k.Value))
                .ToList();
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
    }
}
