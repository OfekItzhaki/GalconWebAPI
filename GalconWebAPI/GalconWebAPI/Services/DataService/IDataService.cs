using GalconWebAPI.Models;
using GalconWebAPI.Models.Enums;

namespace GalconWebAPI.Services.DataService
{
    public interface IDataService
    {
        public User GetUserData(string data, DataType type);
        public List<User.GetUser> GetUsersByRole(Role userRole);
        public List<Order.GetOrder> GetOrders(int userId);
        public string GetOrdersSum(string userId, DateTime? from, DateTime? to);
        public bool AddProduct(Product product);
        public bool AddOrder(Order.CreateOrder order);
        public bool AddOrderDetails(OrderDetails orderDetails);
    }
}
