using System.Text.Json.Serialization;

namespace GalconWebAPI.Models
{
    public class OrderDetails
    {
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public decimal SalePrice { get; set; }
        public int Quantity { get; set; }

        public class GetOrderDetails : OrderDetails
        {
            public DateTime CreationTime { get; set; }
            public DateTime? LastUpdatedTime { get; set; }

            [JsonConstructor]
            public GetOrderDetails(int orderId, int productId, decimal salePrice, int quantity, DateTime creationTime, DateTime lastUpdatedTime)
            {
                OrderId = orderId;
                ProductId = productId;
                SalePrice = salePrice;
                Quantity = quantity;
                CreationTime = creationTime;
                LastUpdatedTime = lastUpdatedTime;
            }
        }

        public class CreateOrderDetails : OrderDetails
        {
            [JsonConstructor]
            public CreateOrderDetails(int orderId, int productId, decimal salePrice, int quantity)
            {
                OrderId = orderId;
                ProductId = productId;
                SalePrice = salePrice;
                Quantity = quantity;
            }
        }
    }
}
