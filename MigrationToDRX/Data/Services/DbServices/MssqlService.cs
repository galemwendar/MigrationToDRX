using Dapper;
using Microsoft.Data.SqlClient;

namespace MigrationToDRX.Data.Services.DbServices
{
    public class MssqlService : DbService
    {
        public MssqlService(string connectionString) : base(new SqlConnection(connectionString))
        {
        }

        public override async Task<IEnumerable<string>> GetTablesAsync() => await SqlConnection.QueryAsync<string>("SELECT TABLE_NAME AS TableName FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'");
       
    }
}
