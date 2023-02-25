using Newtonsoft.Json.Linq;

namespace GalconWebAPI.Models
{
    public class Order
    {
        public int OrderId { get; set; }
        public string OrderName { get; set; }
        public int UserId { get; set; }
        public DateTime OrderDate { get; set; }
        public int TotalPrice { get; set; }

        public Order(int orderId, string orderName, int userId, int totalPrice)
        {
            OrderId = orderId;
            OrderName = orderName;
            UserId = userId;
            OrderDate = DateTime.Now;
            TotalPrice = totalPrice;
        }

        public Order(int orderId, string orderName, int userId, DateTime orderDate, int totalPrice)
        {
            OrderId = orderId;
            OrderName = orderName;
            UserId = userId;
            OrderDate = orderDate;
            TotalPrice = totalPrice;
        }

        public Order(JObject data)
        {
            int tmp;
            if (!data.Children().Contains("OrderId"))
            {
                throw new Exception("Parameter 'OrderId' missing");
            }
            OrderId = int.TryParse(data["OrderId"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'OrderId' value");

            if (!data.Children().Contains("UserId"))
            {
                throw new Exception("Parameter 'UserId' missing");
            }
            UserId = int.TryParse(data["UserId"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'UserId' value");

            if (!data.Children().Contains("OrderDate"))
            {
                throw new Exception("Parameter 'OrderDate' missing");
            }
            OrderDate = DateTime.Parse(data["OrderDate"].ToString());

            if (!data.Children().Contains("TotalPrice"))
            {
                throw new Exception("Parameter 'TotalPrice' missing");
            }
            TotalPrice = int.TryParse(data["TotalPrice"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'TotalPrice' value");
        }
    }
}
