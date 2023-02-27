using GalconWebAPI.Models.Enums;
using GalconWebAPI.Services;
using Microsoft.AspNetCore.SignalR;
using System.Diagnostics.Eventing.Reader;
using System.Text.Json.Serialization;

namespace GalconWebAPI.Models
{
    public abstract class User
    {
        public string UserName { get; set; }
        public Role UserRole { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Tel { get; set; }
        public string Email { get; set; }

        public class GetUser : User
        {
            public int UserId { get; set; }
            public DateTime? LastPasswordUpdatedTime { get; set; }
            public DateTime PasswordExperationTime { get; set; }
            public DateTime CreatedTime { get; set; }
            public DateTime? LastUpdatedTime { get; set; }
            public bool EmailConfirmed { get; set; }
            public bool IsActive { get; set; }

            public GetUser(string userName, string firstName, string lastName, string tel, string email)
            {
                UserName = userName;
                LastPasswordUpdatedTime = null;
                PasswordExperationTime = DateTime.Now.AddDays(120);
                UserRole = Role.User;
                CreatedTime = DateTime.Now;
                LastUpdatedTime = null;
                FirstName = firstName;
                LastName = lastName;
                Tel = tel;
                Email = email;
                EmailConfirmed = false;
                IsActive = true;
            }

            public GetUser(string userName, Role userRole, string firstName, string lastName, string tel, string email) : this(userName, firstName, lastName, tel, email)
            {
                LastPasswordUpdatedTime = DateTime.Now;
                PasswordExperationTime = DateTime.Now.AddDays(120);
                UserRole = userRole;
                CreatedTime = DateTime.Now;
                LastUpdatedTime = null;
                EmailConfirmed = false;
                IsActive = true;
            }

            [JsonConstructor]
            public GetUser(int userId, string userName, DateTime? lastPasswordUpdatedTime, DateTime passwordExperationTime, Role userRole, DateTime createdTime, DateTime? lastUpdatedTime, string firstName, string lastName, string tel, string email, bool emailConfirmed, bool isActive) : this(userName, userRole, firstName, lastName, tel, email)
            {
                UserId = userId;
                LastPasswordUpdatedTime = lastPasswordUpdatedTime;
                PasswordExperationTime = passwordExperationTime;
                CreatedTime = createdTime;
                LastUpdatedTime = lastUpdatedTime;
                EmailConfirmed = emailConfirmed;
                IsActive = isActive;
            }
        }

        public class CreateUser : User
        {
            public string Password { get; set; }

            [JsonConstructor]
            public CreateUser(string userName, string password, string firstName, string lastName, string tel, string email)
            {
                UserName = userName;
                Password = password;
                UserRole = Role.User;
                FirstName = firstName;
                LastName = lastName;
                Tel = tel;
                Email = email;
            }

            public CreateUser(string userName, string password, Role userRole, string firstName, string lastName, string tel, string email) : this(userName, password, firstName, lastName, tel, email)
            {
                UserRole = userRole;
            }
        }
    }
}
