using Newtonsoft.Json.Linq;

namespace GalconWebAPI.Models
{
    public class UserRole
    {
        public string RoleName { get; set; }

        public UserRole(string roleName)
        {
            RoleName = roleName;
        }

        public UserRole(JObject data)
        {
            if (!data.Children().Contains("RoleName"))
            {
                throw new Exception("Parameter 'RoleName' missing");
            }
            RoleName = data["RoleName"].ToString();
        }
    }
}
