

namespace GalconWebAPI.Models
{
    public class OrderDetails
    {
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }

        public OrderDetails(int orderId, int productId, int unitPrice, int quantity)
        {
            OrderId = orderId;
            ProductId = productId;
            Quantity = quantity;
        }

        //public OrderDetails(JObject data)
        //{
        //    int tmp;
        //    if (!data.Children().Contains("OrderId"))
        //    {
        //        throw new Exception("Parameter 'OrderId' missing");
        //    }
        //    OrderId = int.TryParse(data["OrderId"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'OrderId' value");

        //    if (!data.Children().Contains("ProductId"))
        //    {
        //        throw new Exception("Parameter 'ProductId' missing");
        //    }
        //    ProductId = int.TryParse(data["ProductId"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'ProductId' value");

        //    if (!data.Children().Contains("Quantity"))
        //    {
        //        throw new Exception("Parameter 'Quantity' missing");
        //    }
        //    Quantity = int.TryParse(data["Quantity"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'Quantity' value");
        //}
    }
}
