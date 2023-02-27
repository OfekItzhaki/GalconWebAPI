using GalconWebAPI.Models;

namespace GalconWebAPI.Services.AuthenticationService
{
    public interface IAuthenticationService
    {
        public bool Login(string email, string userName, string password);
        public void Logout();
        public bool Register(User.CreateUser user);
        public bool ForgotPassword(string userName, string email, out string password);
    }
}
