using GalconWebAPI.Services;
using Newtonsoft.Json.Linq;
using System.Text.Json.Serialization;

namespace GalconWebAPI.Models
{
    public class User
    {
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public DateTime LastPasswordUpdatedTime { get; set; }
        public DateTime PasswordExperationTime { get; set; }
        public int UserRole { get; set; }
        public DateTime CreatedTime { get; set; }
        public DateTime? LastUpdatedTime { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Tel { get; set; }
        public string Email { get; set; }
        public bool EmailConfirmed { get; set; }

        public User(string userName, string password, int userRole, string firstName, string lastName, string tel, string email, bool emailConfirmed)
        {
            UserId = GlobalService.GenerateUniqueId();
            UserName = userName;
            Password = password;
            LastPasswordUpdatedTime = DateTime.Now;
            PasswordExperationTime = DateTime.Now.AddDays(120);
            UserRole = userRole;
            CreatedTime = DateTime.Now;
            LastUpdatedTime = null;
            FirstName = firstName;
            LastName = lastName;
            Tel = tel;
            Email = email;
            EmailConfirmed = emailConfirmed;
        }

        [JsonConstructor]
        public User(string userId, string userName, string password, DateTime lastPasswordUpdatedTime, DateTime passwordExperationTime, int userRole, DateTime createdTime, DateTime? lastUpdatedTime, string firstName, string lastName, string tel, string email, bool emailConfirmed)
        {
            UserId = userId;
            UserName = userName;
            Password = password;
            LastPasswordUpdatedTime = lastPasswordUpdatedTime;
            PasswordExperationTime = passwordExperationTime;
            UserRole = userRole;
            CreatedTime = createdTime;
            LastUpdatedTime = lastUpdatedTime;
            FirstName = firstName;
            LastName = lastName;
            Tel = tel;
            Email = email;
            EmailConfirmed = emailConfirmed;
        }

        //public User(JObject data)
        //{
        //    int tmp;
        //    if (!data.Children().Contains("UserId"))
        //    {
        //        throw new Exception("Parameter 'UserId' missing");
        //    }
        //    UserId = data["UserId"].ToString();

        //    if (!data.Children().Contains("UserName"))
        //    {
        //        throw new Exception("Parameter 'UserName' missing");
        //    }
        //    UserName = data["UserName"].ToString();

        //    if (!data.Children().Contains("HashPassword"))
        //    {
        //        throw new Exception("Parameter 'HashPassword' missing");
        //    }
        //    Password = data["HashPassword"].ToString();

        //    if (!data.Children().Contains("LastPasswordUpdatedTime"))
        //    {
        //        throw new Exception("Parameter 'LastPasswordUpdatedTime' missing");
        //    }
        //    LastPasswordUpdatedTime = DateTime.Parse(data["LastPasswordUpdatedTime"].ToString());

        //    if (!data.Children().Contains("PasswordExperationTime"))
        //    {
        //        throw new Exception("Parameter 'PasswordExperationTime' missing");
        //    }
        //    PasswordExperationTime = DateTime.Parse(data["PasswordExperationTime"].ToString());

        //    if (!data.Children().Contains("UserRole"))
        //    {
        //        throw new Exception("Parameter 'UserRole' missing");
        //    }
        //    UserRole = int.TryParse(data["UserRole"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'UserRole' value");

        //    if (!data.Children().Contains("CreatedTime"))
        //    {
        //        throw new Exception("Parameter 'CreatedTime' missing");
        //    }
        //    CreatedTime = DateTime.Parse(data["CreatedTime"].ToString());

        //    if (!data.Children().Contains("LastUpdatedTime"))
        //    {
        //        throw new Exception("Parameter 'LastUpdatedTime' missing");
        //    }
        //    LastUpdatedTime = DateTime.Parse(data["LastUpdatedTime"].ToString());

        //    if (!data.Children().Contains("FirstName"))
        //    {
        //        throw new Exception("Parameter 'FirstName' missing");
        //    }
        //    FirstName = data["FirstName"].ToString();

        //    if (!data.Children().Contains("LastName"))
        //    {
        //        throw new Exception("Parameter 'LastName' missing");
        //    }
        //    LastName = data["LastName"].ToString();

        //    if (!data.Children().Contains("Tel"))
        //    {
        //        throw new Exception("Parameter 'Tel' missing");
        //    }
        //    Tel = data["Tel"].ToString();

        //    if (!data.Children().Contains("Email"))
        //    {
        //        throw new Exception("Parameter 'Email' missing");
        //    }
        //    Email = data["Email"].ToString();

        //    if (!data.Children().Contains("EmailConfirmed"))
        //    {
        //        throw new Exception("Parameter 'EmailConfirmed' missing");
        //    }
        //    EmailConfirmed = bool.Parse(data["EmailConfirmed"].ToString()) ? true : false;
        //}
    }
}
