using System.Data.SqlClient;
using System.Net;

namespace GalconWebAPI.Services.Database
{
    public class DatabaseConnection : IDatabaseConnection
    {
        public async Task<SqlConnection> GetConnection()
        {
            await Task.Delay(0);
            string host = Dns.GetHostName();
            //0=OfekPC/1=OfekLaptop
            string ds = "";
            switch (host)
            {
                case "DESKTOP-2O2CFNS":
                    ds = "DESKTOP-2O2CFNS";
                    break;
                case "LAPTOP-L88P5UHT":
                    ds = "LAPTOP-L88P5UHT";
                    break;
                default:
                    ds = "DESKTOP-2O2CFNS";
                    break;

            }
            var conStr = @$"Data Source={ds};Initial Catalog=GalconDB;Integrated Security=true;";

            return new SqlConnection(conStr);
        }


    }
}
