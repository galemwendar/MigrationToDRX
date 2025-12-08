using Dapper;
using System.Data.Common;

namespace MigrationToDRX.Data.Services.DbServices
{
    public abstract class DbService : IAsyncDisposable
    {
        protected DbConnection SqlConnection { get; set; }

        public DbService(DbConnection connection)
        {
            SqlConnection = connection;
        }

        public virtual async Task<IEnumerable<dynamic>> ReadTableAsync(string tableName) => await SqlConnection.QueryAsync($"SELECT * FROM {tableName};");

        public abstract Task<IEnumerable<string>> GetTablesAsync();

        public virtual async ValueTask DisposeAsync() => await SqlConnection.DisposeAsync();
    }
}
