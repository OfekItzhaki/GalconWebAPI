using GalconWebAPI.Models;
using GalconWebAPI.Models.Enums;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Reflection.PortableExecutable;
using System.Runtime.Serialization;
using GalconWebAPI.Models.NullObjects;
using Microsoft.OpenApi.Extensions;

namespace GalconWebAPI.Services
{
    public class DataService
    {
        IConfiguration _config;

        public DataService(IConfiguration config)
        {
            _config = config;
        }

        public bool Login(string email, string userName, string password)
        {
            var state = false;
            using (SqlConnection con = new SqlConnection(_config.GetConnectionString("DbConnectionString")))
            {
                try
                {
                    if ((string.IsNullOrEmpty(email) && string.IsNullOrEmpty(userName)) || string.IsNullOrEmpty(password))
                        return state;
                    else
                    {
                        if (email == null) email = string.Empty;
                        if (userName == null) userName = string.Empty;
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

        public bool Register(User user)
        {
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
                    cmd.Parameters.Add("@UserId", SqlDbType.VarChar).Value = user.UserId;
                    cmd.Parameters.Add("@UserName", SqlDbType.VarChar).Value = user.UserName;
                    cmd.Parameters.Add("@HashPassWord", SqlDbType.VarChar).Value = user.Password;
                    cmd.Parameters.Add("@LastPasswordUpdatedTime", SqlDbType.DateTime).Value = user.LastPasswordUpdatedTime;
                    cmd.Parameters.Add("@PasswordExpirationTime", SqlDbType.DateTime).Value = user.PasswordExperationTime;
                    cmd.Parameters.Add("@UserRole", SqlDbType.Int).Value = user.UserRole;
                    cmd.Parameters.Add("@CreatedTime", SqlDbType.DateTime).Value = user.CreatedTime;
                    cmd.Parameters.Add("@LastUpdatedTime", SqlDbType.DateTime).Value = user.LastUpdatedTime;
                    cmd.Parameters.Add("@FirstName", SqlDbType.VarChar).Value = user.FirstName;
                    cmd.Parameters.Add("@LastName", SqlDbType.VarChar).Value = user.LastName;
                    cmd.Parameters.Add("@Tel", SqlDbType.VarChar).Value = user.Tel;
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = user.Email;
                    cmd.Parameters.Add("@EmailConfirmed", SqlDbType.Bit).Value = user.EmailConfirmed;

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

        public string GetOrdersSum(string userId, DateTime from, DateTime to)
        {
            var result = "";

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

                using (SqlCommand cmd = new SqlCommand("SP_GetOrdersSum", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add($"@UserId", SqlDbType.VarChar).Value = userId;
                    cmd.Parameters.Add($"@FromDate", SqlDbType.DateTime).Value = from;
                    cmd.Parameters.Add($"@ToDate", SqlDbType.DateTime).Value = to;

                    try
                    {
                        //var result = cmd.ExecuteScalar();
                        //cmd.Dispose();
                        //con.Close();

                        //if (result == null) return orderSum;
                        //else orderSum = $"The orders sum for user id {userId} is: {result.ToString()}";

                        var reader = cmd.ExecuteReader();

                        var orderSum = 0;
                        while (reader.Read())
                        {
                            var value = reader.GetValue("TotalPrice").ToString();
                            if (!string.IsNullOrEmpty(value))
                            {
                                orderSum += int.Parse(value);
                            }

                        }
                        reader.Close();
                        cmd.Dispose();
                        con.Close();

                        if (orderSum > 0) result = $"The orders sum for user id {userId} is: {orderSum}";

                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received/User already exists");
                    }
                }

                return result;
            }
        }

        public User GetUserData(string data, DataType type)
        {
            User user = new NullUser();

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

                using (SqlCommand cmd = new SqlCommand("SP_CheckExists", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    string userId = "";
                    string userName = "";
                    string tel = "";
                    string email = "";
                    if (type == DataType.UserId) userId = data;
                    else if (type == DataType.UserName) userName = data;
                    else if (type == DataType.Tel) tel = data;
                    else email = data;

                    cmd.Parameters.Add($"@UserId", SqlDbType.VarChar).Value = userId;
                    cmd.Parameters.Add($"@UserName", SqlDbType.VarChar).Value = userName;
                    cmd.Parameters.Add($"@Tel", SqlDbType.VarChar).Value = tel;
                    cmd.Parameters.Add($"@Email", SqlDbType.VarChar).Value = email;

                    try
                    {
                        var reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {                          
                            user = new User(
                                reader.GetValue("UserId").ToString(),
                                reader.GetValue("UserName").ToString(),
                                reader.GetValue("HashPassword").ToString(),
                                DateTime.Parse(reader.GetValue("LastPasswordUpdatedTime").ToString()),
                                DateTime.Parse(reader.GetValue("PasswordExpirationDate").ToString()),
                                int.Parse(reader.GetValue("UserRole").ToString()),
                                DateTime.Parse(reader.GetValue("CreatedTime").ToString()),
                                DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString()),
                                reader.GetValue("FirstName").ToString(),
                                reader.GetValue("LastName").ToString(),
                                reader.GetValue("Tel").ToString(),
                                reader.GetValue("Email").ToString(),
                                bool.Parse(reader.GetValue("EmailConfirmed").ToString())
                            );

                        }
                        reader.Close();
                        cmd.Dispose();
                        con.Close();
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received/User already exists");
                    }
                }
                return user;
            }
        }

        public List<User> GetUsersByRole(int userRole)
        {
            var users = new List<User>();

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

                using (SqlCommand cmd = new SqlCommand("SP_GetUsersByRole", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserRole", SqlDbType.Int).Value = userRole;

                    try
                    {
                        var reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            DateTime? lastUpdatedTime = reader.GetValue("LastUpdatedTime").ToString() == "" ? null : DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString());

                            var user = new User(
                                reader.GetValue("UserId").ToString(),
                                reader.GetValue("UserName").ToString(),
                                reader.GetValue("HashPassword").ToString(),
                                DateTime.Parse(reader.GetValue("LastPasswordUpdatedTime").ToString()),
                                DateTime.Parse(reader.GetValue("PasswordExpirationTime").ToString()),
                                int.Parse(reader.GetValue("UserRole").ToString()),
                                DateTime.Parse(reader.GetValue("CreatedTime").ToString()),
                                DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString()),
                                reader.GetValue("FirstName").ToString(),
                                reader.GetValue("LastName").ToString(),
                                reader.GetValue("Tel").ToString(),
                                reader.GetValue("Email").ToString(),
                                bool.Parse(reader.GetValue("EmailConfirmed").ToString())
                            );

                            users.Add(user);

                        }
                        reader.Close();
                        cmd.Dispose();
                        con.Close();
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received");
                    }
                }
                return users;
            }
        }

        public List<Order> GetOrders(int userId)
        {
            var orders = new List<Order>();

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

                using (SqlCommand cmd = new SqlCommand("Dyn_UserOrders_Get", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserId", SqlDbType.VarChar).Value = userId;

                    try
                    {
                        var reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            var order = new Order(
                                int.Parse(reader.GetValue("OrderId").ToString()),
                                reader.GetValue("OrderName").ToString(),
                                int.Parse(reader.GetValue("UserId").ToString()),
                                DateTime.Parse(reader.GetValue("OrderDate").ToString()),
                                int.Parse(reader.GetValue("TotalPrice").ToString())
                            );

                            orders.Add(order);

                        }
                        reader.Close();
                        cmd.Dispose();
                        con.Close();
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received");
                    }
                }
                return orders;
            }
        }
    }
}
