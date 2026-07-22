using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace LumoraWebForms.App_Code
{
    public class DBHelper
    {
        private static string connStr = WebConfigurationManager.ConnectionStrings["LumoraDB"].ConnectionString;

        public static DataTable Query(string sql, params SqlParameter[] pars)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (pars != null) cmd.Parameters.AddRange(pars);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        public static int Execute(string sql, params SqlParameter[] pars)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (pars != null) cmd.Parameters.AddRange(pars);
                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public static object Scalar(string sql, params SqlParameter[] pars)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (pars != null) cmd.Parameters.AddRange(pars);
                conn.Open();
                return cmd.ExecuteScalar();
            }
        }

        public static string HashPassword(string password)
        {
            using (var sha = System.Security.Cryptography.SHA256.Create())
            {
                var bytes = System.Text.Encoding.UTF8.GetBytes(password);
                var hash = sha.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }
    }
}
