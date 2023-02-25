using GalconWebAPI.Models;
using GalconWebAPI.Models.Structs;
using GalconWebAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace GalconWebAPI.Controllers
{
    [ApiController]
    public class ApiController : Controller
    {
        private readonly ILogger<ApiController> _logger;
        private readonly IConfiguration _configuration;
        private readonly DataService _dataService;
        private readonly AuthenticationService _authenticationService;
        public ApiController(ILogger<ApiController> logger, IConfiguration configuration, DataService dataService, AuthenticationService authenticationService)
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

        //POST: ApiController/Register
        [HttpPost]
        [Route("[controller]/Register")]
        public string Register([FromBody] User user)
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
            return result ? "User was successfully logged-in!" : "Wrong Username or Password!";
        }

        //GET: ApiController/GetUsersByRole/{userRole}
        [HttpGet]
        [Route("[controller]/GetUsersByRole/{userRole}")]
        public IEnumerable<User> GetUsersByRole(int userRole)
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
        public string GetOrdersSum(string userId, DateTime from, DateTime to)
        {
            return _dataService.GetOrdersSum(userId, from, to);
        }
    }
}
