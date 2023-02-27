
namespace GalconWebAPI.Models
{
    public class Product
    {
        public string ProductBarcode { get; set; }
        public string ProductName { get; set; }
        public string ProductDescription { get; set; }
        public int ProductPrice { get; set; }

        public Product(string productBarcode, string productName, string productDescription, int productPrice)
        {
            ProductBarcode = productBarcode;
            ProductName = productName;
            ProductDescription = productDescription;
            ProductPrice = productPrice;
        }
    }
}
