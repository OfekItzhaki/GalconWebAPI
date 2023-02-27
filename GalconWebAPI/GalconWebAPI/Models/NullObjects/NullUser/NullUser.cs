using GalconWebAPI.Models.Enums;

namespace GalconWebAPI.Models.NullObjects.NullUser
{
    public class NullUser : User.GetUser
    {
        public NullUser() : base("", "", "", "", "")
        {

        }
    }
}
