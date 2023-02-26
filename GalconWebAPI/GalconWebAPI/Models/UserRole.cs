
namespace GalconWebAPI.Models
{
    public class UserRole
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }

        public UserRole(int roleId, string roleName)
        {
            RoleId = roleId;
            RoleName = roleName;
        }

        //public UserRole(JObject data)
        //{
        //    int tmp;
        //    if (!data.Children().Contains("RoleId"))
        //    {
        //        throw new Exception("Parameter 'RoleId' missing");
        //    }
        //    RoleId = int.TryParse(data["RoleId"].ToString(), out tmp) ? tmp : throw new Exception("Invalid 'RoleId' value");

        //    if (!data.Children().Contains("RoleName"))
        //    {
        //        throw new Exception("Parameter 'RoleName' missing");
        //    }
        //    RoleName = data["RoleName"].ToString();
        //}
    }
}
