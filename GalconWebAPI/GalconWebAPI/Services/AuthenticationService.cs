using GalconWebAPI.Models;
using GalconWebAPI.Models.Enums;
using System.Data.SqlClient;
using System.Data;
using System.Reflection;

namespace GalconWebAPI.Services
{
    public class AuthenticationService
    {
        private readonly DataService _dataService;
        IConfiguration _config;

        public AuthenticationService(DataService dataService, IConfiguration config)
        {
            _dataService = dataService;
            _config = config;
        }

        public bool Login(string email, string userName, string password)
        {
            // Need to save UserId in global state -- User is logged in

            password = HashService.ComputeSha256Hash(password);

            if ((string.IsNullOrEmpty(userName) && string.IsNullOrEmpty(userName)) || string.IsNullOrEmpty(password))
                throw new Exception("Username or password are empty");

            var state = false;
            using (SqlConnection con = new SqlConnection(_config.GetConnectionString("DbConnectionString")))
            {
                try
                {
                    if ((string.IsNullOrEmpty(email) && string.IsNullOrEmpty(userName)) || string.IsNullOrEmpty(password))
                        return state;
                    else
                    {
                        if (string.IsNullOrEmpty(email)) email = string.Empty;
                        if (string.IsNullOrEmpty(userName)) userName = string.Empty;
                    }
                    con.Open();
                }
                catch (Exception err)
                {
                    throw new Exception("Failed to connect to DB.");
                }

                using (SqlCommand cmd = new SqlCommand("SP_Login", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = email;
                    cmd.Parameters.Add("@UserName", SqlDbType.VarChar).Value = userName;
                    cmd.Parameters.Add("@HashPassword", SqlDbType.VarChar).Value = password;

                    try
                    {
                        var count = Convert.ToInt32(cmd.ExecuteScalar());
                        if (count > 0) state = true;

                        cmd.Dispose();
                        con.Close();
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received");
                    }
                }
                return state;
            }
        }

        public void Logout() 
        {
            // Future implementation
        }
        public bool Register(User.CreateUser user)
        {
            // validate
            var tempAccount = _dataService.GetUserData(user.UserName, DataType.UserName);
            if (tempAccount.UserName == user.UserName)
                throw new Exception("Username '" + user.UserName + "' already exists!");

            var tempData = _dataService.GetUserData(user.Email, DataType.Email);
            if (tempData.Email == user.Email)
                throw new Exception("Email '" + user.Email + "' already exists");

            tempData = _dataService.GetUserData(user.Tel, DataType.Tel);
            if (tempData.Tel == user.Tel)
                throw new Exception("Tel '" + user.Tel + "' already exists");


            var state = false;
            using (SqlConnection con = new SqlConnection(_config.GetConnectionString("DbConnectionString")))
            {
                try
                {
                    con.Open();
                }
                catch (Exception err)
                {
                    throw new Exception("Failed to connect to DB.");
                }
                using (SqlCommand cmd = new SqlCommand("Dyn_User_Insert", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserName", SqlDbType.VarChar).Value = user.UserName;
                    cmd.Parameters.Add("@HashPassWord", SqlDbType.VarChar).Value = user.Password;
                    cmd.Parameters.Add("@UserRole", SqlDbType.Int).Value = (int)user.UserRole;
                    cmd.Parameters.Add("@FirstName", SqlDbType.VarChar).Value = user.FirstName;
                    cmd.Parameters.Add("@LastName", SqlDbType.VarChar).Value = user.LastName;
                    cmd.Parameters.Add("@Tel", SqlDbType.VarChar).Value = user.Tel;
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = user.Email;

                    try
                    {
                        var reader = cmd.ExecuteNonQuery();
                        cmd.Dispose();
                        con.Close();
                        state = true;
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received");
                    }
                }
                return state;
            }
        }

        public bool ForgotPassword(string userName, string email, out string password)
        {
            // Basic, just for now.
            password = "";

            // Check user name.
            if (userName == null || userName == "") return false;

            // Check email.
            if (email == null || email == "") return false;

            // Change password
            return true;
        }
    }
}
