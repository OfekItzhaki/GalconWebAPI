using System.Data.SqlClient;

namespace GalconWebAPI.Services.Database
{
    public interface IDatabaseConnection
    {
        Task<SqlConnection> GetConnection();
    }
}
