using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;

namespace MigrationToDRX.Data.Services.DbServices
{
    public class MssqlService : DbService
    {
        public MssqlService(string connectionString, ILogger logger) : base(new SqlConnection(connectionString), logger)
        {
        }

        public override async Task<IEnumerable<string>> GetTablesAsync() => await SqlConnection.QueryAsync<string>("SELECT TABLE_NAME AS TableName FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'");
    }
}
