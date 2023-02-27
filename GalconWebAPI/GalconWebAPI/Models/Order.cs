using System.Text.Json.Serialization;

namespace GalconWebAPI.Models
{
    public abstract class Order
    {
        public string OrderName { get; set; }
        public int UserId { get; set; }

        public class GetOrder : Order
        {
            public int OrderId { get; set; }
            public DateTime OrderDate { get; set; }
            public decimal TotalPrice { get; set; }
            public bool IsCancelled { get; set; }
            public GetOrder(string orderName, int userId)
            {
                OrderName = orderName;
                UserId = userId;
            }

            public GetOrder(int orderId, string orderName, int userId) : this(orderName, userId)
            {
                OrderId = orderId;
                OrderDate = DateTime.Now;
                TotalPrice = 0;
                IsCancelled = false;
            }

            [JsonConstructor]
            public GetOrder(int orderId, string orderName, int userId, DateTime orderDate, decimal totalPrice, bool isCancelled) : this(orderId, orderName, userId)
            {
                OrderDate = orderDate;
                TotalPrice = totalPrice;
                IsCancelled = isCancelled;
            }
        }

        public class CreateOrder : Order
        {
            [JsonConstructor]
            public CreateOrder(string orderName, int userId)
            {
                OrderName = orderName;
                UserId = userId;
            }
        }
    }
}
