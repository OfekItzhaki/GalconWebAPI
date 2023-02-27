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
using GalconWebAPI.Models.NullObjects.NullUser;

namespace GalconWebAPI.Services
{
    public class DataService
    {
        IConfiguration _config;

        public DataService(IConfiguration config)
        {
            _config = config;
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

                using (SqlCommand cmd = new SqlCommand("Dyn_User_Get", con))
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
                            DateTime? lastUpdatedTime = reader.GetValue("LastUpdatedTime").ToString() == "" ? null : DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString());
                            DateTime? lastPasswordUpdatedTime = reader.GetValue("LastUpdatedTime").ToString() == "" ? null : DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString());

                            user = new User.GetUser(
                                int.Parse(reader.GetValue("UserId").ToString()),
                                reader.GetValue("UserName").ToString(),
                                lastPasswordUpdatedTime,
                                DateTime.Parse(reader.GetValue("PasswordExpirationTime").ToString()),
                                (Role)int.Parse(reader.GetValue("UserRole").ToString()),
                                DateTime.Parse(reader.GetValue("CreationTime").ToString()),
                                lastUpdatedTime,
                                reader.GetValue("FirstName").ToString(),
                                reader.GetValue("LastName").ToString(),
                                reader.GetValue("Tel").ToString(),
                                reader.GetValue("Email").ToString(),
                                bool.Parse(reader.GetValue("EmailConfirmed").ToString()),
                                bool.Parse(reader.GetValue("IsActive").ToString())
                            );

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
                return user;
            }
        }

        public List<User.GetUser> GetUsersByRole(Role userRole)
        {
            var users = new List<User.GetUser>();

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
                    cmd.Parameters.Add("@UserRole", SqlDbType.Int).Value = (int)userRole;

                    try
                    {
                        var reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            DateTime? lastUpdatedTime = reader.GetValue("LastUpdatedTime").ToString() == "" ? null : DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString());
                            DateTime? lastPasswordUpdatedTime = reader.GetValue("LastUpdatedTime").ToString() == "" ? null : DateTime.Parse(reader.GetValue("LastUpdatedTime").ToString());

                            var user = new User.GetUser(
                                int.Parse(reader.GetValue("UserId").ToString()),
                                reader.GetValue("UserName").ToString(),
                                lastPasswordUpdatedTime,
                                DateTime.Parse(reader.GetValue("PasswordExpirationTime").ToString()),
                                (Role)int.Parse(reader.GetValue("UserRole").ToString()),
                                DateTime.Parse(reader.GetValue("CreationTime").ToString()),
                                lastUpdatedTime,
                                reader.GetValue("FirstName").ToString(),
                                reader.GetValue("LastName").ToString(),
                                reader.GetValue("Tel").ToString(),
                                reader.GetValue("Email").ToString(),
                                bool.Parse(reader.GetValue("EmailConfirmed").ToString()),
                                bool.Parse(reader.GetValue("IsActive").ToString())
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

        public List<Order.GetOrder> GetOrders(int userId)
        {
            var orders = new List<Order.GetOrder>();

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

                using (SqlCommand cmd = new SqlCommand("SP_GetOrders", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserId", SqlDbType.VarChar).Value = userId;

                    try
                    {
                        var reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            var order = new Order.GetOrder(
                                int.Parse(reader.GetValue("OrderId").ToString()),
                                reader.GetValue("OrderName").ToString(),
                                int.Parse(reader.GetValue("UserId").ToString()),
                                DateTime.Parse(reader.GetValue("OrderDate").ToString()),
                                decimal.Parse(reader.GetValue("TotalPrice").ToString()),
                                bool.Parse(reader.GetValue("IsCancelled").ToString())
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

        public string GetOrdersSum(string userId, DateTime? from, DateTime? to)
        {
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
                    var result = "";

                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add($"@UserId", SqlDbType.VarChar).Value = userId;
                    cmd.Parameters.Add($"@FromDate", SqlDbType.DateTime).Value = from;
                    cmd.Parameters.Add($"@ToDate", SqlDbType.DateTime).Value = to;

                    try
                    {
                        var orderSum = Convert.ToInt32(cmd.ExecuteScalar());
                        result = $"The orders sum for user id {userId} is: {orderSum}";
                        cmd.Dispose();
                        con.Close();

                        return result;

                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received/User already exists");
                    }
                }
            }
        }

        public bool AddProduct(Product product)
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
                using (SqlCommand cmd = new SqlCommand("Dyn_Product_Insert", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ProductId", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@ProductBarcode", SqlDbType.VarChar).Value = product.ProductBarcode;
                    cmd.Parameters.Add("@ProductName", SqlDbType.VarChar).Value = product.ProductName;
                    cmd.Parameters.Add("@ProductDescription", SqlDbType.VarChar).Value = product.ProductDescription;
                    cmd.Parameters.Add("@ProductPrice", SqlDbType.Int).Value = product.ProductPrice;

                    try
                    {
                        //var productId = Convert.ToInt32(cmd.Parameters["ProductId"].Value);

                        var reader = cmd.ExecuteNonQuery();
                        cmd.Dispose();
                        con.Close();
                        state = true;
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received/Order already exists");
                    }
                }
                return state;
            }
        }

        public bool AddOrder(Order.CreateOrder order)
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
                using (SqlCommand cmd = new SqlCommand("Dyn_Order_Insert", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@OrderId", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@OrderName", SqlDbType.VarChar).Value = order.OrderName;
                    cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = order.UserId;

                    try
                    {
                        //var orderId = Convert.ToInt32(cmd.Parameters["OrderId"].Value);

                        var reader = cmd.ExecuteNonQuery();
                        cmd.Dispose();
                        con.Close();
                        state = true;
                    }
                    catch (Exception err)
                    {
                        throw new Exception("Error: Invalid params/No data was received/Order already exists");
                    }
                }
                return state;
            }
        }

        public bool AddOrderDetails(OrderDetails orderDetails)
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
                using (SqlCommand cmd = new SqlCommand("Dyn_OrderDetails_Upsert", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@OrderDetailsId", SqlDbType.Int).Value = null;
                    cmd.Parameters.Add("@OrderId", SqlDbType.Int).Value = orderDetails.OrderId;
                    cmd.Parameters.Add("@ProductId", SqlDbType.Int).Value = orderDetails.ProductId;
                    cmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = orderDetails.Quantity;
                    cmd.Parameters.Add("@SalePrice", SqlDbType.Decimal).Value = orderDetails.SalePrice;

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
    }
}
