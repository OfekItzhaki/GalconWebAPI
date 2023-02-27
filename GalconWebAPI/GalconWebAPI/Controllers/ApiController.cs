using GalconWebAPI.Models;
using GalconWebAPI.Models.Enums;
using GalconWebAPI.Models.Structs;
using GalconWebAPI.Services.AuthenticationService;
using GalconWebAPI.Services.DataService;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace GalconWebAPI.Controllers
{
    [ApiController]
    public class ApiController : Controller
    {
        private readonly ILogger<ApiController> _logger;
        private readonly IConfiguration _configuration;
        private readonly IDataService _dataService;
        private readonly IAuthenticationService _authenticationService;
        public ApiController(ILogger<ApiController> logger, IConfiguration configuration, IDataService dataService, IAuthenticationService authenticationService)
        {
            _logger = logger;
            _configuration = configuration;
            _dataService = dataService;
            _authenticationService = authenticationService;
        }

        // GET: ApiController
        [HttpGet]
        [Route("[controller]")]
        public string Index()
        {
            return "INFORMATION: GalconWebAPI - by Ofek Itzhaki";
        }

        //GET: ApiController/GetUsersByRole/{userRole}
        [HttpGet]
        [Route("[controller]/GetUsersByRole/{userRole}")]
        public IEnumerable<User.GetUser> GetUsersByRole(Role userRole)
        {
            return _dataService.GetUsersByRole(userRole);
        }

        // GET: ApiController/GetOrders/{userId}
        [HttpGet]
        [Route("[controller]/GetOrders/{userId}")]
        public IEnumerable<Order> GetOrders(int userId)
        {
            return _dataService.GetOrders(userId);
        }

        // GET: ApiController/GetOrdersSum/{userId}/{from}/{to}
        [HttpGet]
        [Route("[controller]/GetOrdersSum/{userId}/{from}/{to}")]
        public string GetOrdersSum(string userId, DateTime? from, DateTime? to)
        {
            return _dataService.GetOrdersSum(userId, from, to);
        }

        //POST: ApiController/Register
        [HttpPost]
        [Route("[controller]/Register")]
        public string Register([FromBody] User.CreateUser user)
        {
            var result = _authenticationService.Register(user);
            return result ? "User was created successfully!" : "Registration failed.";
        }

        //POST: ApiController/Login
        [HttpPost]
        [Route("[controller]/Login")]
        public string Login([FromBody] UserCredentials userCreds)
        {
            var result = _authenticationService.Login(userCreds.Email, userCreds.UserName, userCreds.Password); ;
            return result ? "User has successfully logged-in!" : "Wrong Username or Password!";
        }

        //POST: ApiController/AddProduct
        [HttpPost]
        [Route("[controller]/AddProduct")]
        public string AddProduct([FromBody] Product product)
        {
            var result = _dataService.AddProduct(product);
            return result ? "Product was added successfully!" : "Adding Product failed.";
        }

        //POST: ApiController/AddOrder
        [HttpPost]
        [Route("[controller]/AddOrder")]
        public string AddOrder([FromBody] Order.CreateOrder order)
        {
            var result = _dataService.AddOrder(order);
            return result ? "Order was added successfully!" : "Adding Order failed.";
        }

        //POST: ApiController/AddOrderDetails
        [HttpPost]
        [Route("[controller]/AddOrderDetails")]
        public string AddOrderDetails([FromBody] OrderDetails.CreateOrderDetails orderDetails)
        {
            var result = _dataService.AddOrderDetails(orderDetails);
            return result ? "OrderDetails was added successfully!" : "Adding OrderDetails failed.";
        }
    }
}
