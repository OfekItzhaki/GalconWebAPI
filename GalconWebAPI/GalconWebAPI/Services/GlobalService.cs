namespace GalconWebAPI.Services
{
    public static class GlobalService
    {
        public static string GenerateUniqueId()
        {
            return Guid.NewGuid().ToString("N");
        }
    }
}
