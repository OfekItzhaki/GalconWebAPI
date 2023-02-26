using GalconWebAPI.Models.Enums;

namespace GalconWebAPI.Models.NullObjects
{
    public class NullUser : User
    {
        public NullUser() : base("", "", Role.User, "", "", "", "", false, false)
        {

        }
    }
}
