using GalconWebAPI.Models;
using GalconWebAPI.Models.Enums;
using System.Reflection;

namespace GalconWebAPI.Services
{
    public class AuthenticationService
    {
        private readonly DataService _dataService;

        public AuthenticationService(DataService dataService)
        {
            _dataService = dataService;
        }

        public bool Login(string email, string userName, string password)
        {
            string hashPassword = BCryptService.Hash(password);

            if ((string.IsNullOrEmpty(userName) && string.IsNullOrEmpty(userName)) || string.IsNullOrEmpty(password))
                throw new Exception("Username or password are empty");

            var state = _dataService.Login(email, userName, hashPassword);
            return state;


            // Need to save UserId in global state -- User is logged in
        }

        public void Logout() 
        {
            // Future implementation
        }

        public bool Register(User user)
        {
            // validate
            var tempAccount = _dataService.GetUserData(user.UserName, DataType.UserName);
            if (tempAccount.UserName == user.UserName)
                throw new Exception("Username '" + user.UserName + "' is already taken");

            var tempData = _dataService.GetUserData(user.Email, DataType.Email);
            if (tempData.Email == user.Email)
                throw new Exception("Email '" + user.Email + "' is already taken");

            tempData = _dataService.GetUserData(user.Tel, DataType.Tel);
            if (tempData.Tel == user.Tel)
                throw new Exception("Tel '" + user.Tel + "' is already taken");

            var hashPassword = BCryptService.Hash(user.Password);
            var newUserAccount = new User(
                                          user.UserId,
                                          user.UserName, 
                                          hashPassword, 
                                          user.LastPasswordUpdatedTime, 
                                          user.PasswordExperationTime,
                                          user.UserRole,
                                          user.CreatedTime,
                                          user.LastUpdatedTime,
                                          user.FirstName,
                                          user.LastName,
                                          user.Tel,
                                          user.Email, 
                                          user.EmailConfirmed
                                          );

            // INSERT new userAccount and new userData to DB
            var wasSuccessful = _dataService.Register(newUserAccount);
            return wasSuccessful;
        }

        public bool ForgotPassword(string userName, string email, out string password)
        {
            // Basic, just for now.
            password = "";

            // Check user name.
            if (userName == null || userName == "") return false;

            // Check email.
            if (email == null || email == "") return false;

            // Change password
            return true;
        }
    }
}
