using GalconWebAPI.Models.Enums;
using System.Text.Json.Serialization;

namespace GalconWebAPI.Models.Structs
{
    public class UserCredentials
    {
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }

        [JsonConstructor]
        public UserCredentials(string userName, string password, string email)
        {
            UserName = userName;
            Password = password;
            Email = email;
        }
    }
}
