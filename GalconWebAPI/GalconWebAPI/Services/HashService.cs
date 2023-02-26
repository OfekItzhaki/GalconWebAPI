using BCrypt.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace GalconWebAPI.Services
{
    public static class HashService
    {
        private static string BCryptGetSalt()
        {
            return BCrypt.Net.BCrypt.GenerateSalt(12);
        }

        public static string BCryptHash(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password, BCryptGetSalt());
        }

        public static bool BCryptVerify(string password, string correctHash)
        {
            return BCrypt.Net.BCrypt.Verify(password, correctHash);
        }

        public static string ComputeSha256Hash(string rawData)
        {
            // Create a SHA256   
            using (SHA256 sha256Hash = SHA256.Create())
            {
                // ComputeHash - returns byte array  
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(rawData));

                // Convert byte array to a string   
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
