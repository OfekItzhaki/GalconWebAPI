
namespace GalconWebAPI.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductDescription { get; set; }
        public int ProductPrice { get; set; }

        public Product(int productId, string productName, string productDescription, int productPrice)
        {
            ProductId = productId;
            ProductName = productName;
            ProductDescription = productDescription;
            ProductPrice = productPrice;
        }

        //public Product(JObject data)
        //{
        //    int tmp;
        //    if (!data.Children().Contains("ProductId"))
        //    {
        //        throw new Exception("Parameter 'ProductId' missing");
        //    }
        //    ProductId = int.TryParse(data["ProductId"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'ProductId' value");

        //    if (!data.Children().Contains("ProductName"))
        //    {
        //        throw new Exception("Parameter 'ProductName' missing");
        //    }
        //    ProductName = data["ProductName"].ToString();

        //    if (!data.Children().Contains("ProductDescription"))
        //    {
        //        throw new Exception("Parameter 'ProductDescription' missing");
        //    }
        //    ProductDescription = data["ProductDescription"].ToString();

        //    if (!data.Children().Contains("ProductPrice"))
        //    {
        //        throw new Exception("Parameter 'ProductPrice' missing");
        //    }
        //    ProductPrice = int.TryParse(data["ProductPrice"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'ProductPrice' value");
        //}
    }
}
