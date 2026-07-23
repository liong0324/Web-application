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

        /// <summary>
        /// Runs automatically from Global.asax on app start.
        /// Creates the LumoraDB database (if missing) and runs database.sql
        /// (if the Users table is missing) so nobody on the team has to
        /// manually run the script in SSMS.
        /// </summary>
        public static void EnsureDatabase(string sqlFilePath)
        {
            var builder = new SqlConnectionStringBuilder(connStr);
            string targetDb = builder.InitialCatalog;

            // Step 1: make sure the database itself exists.
            // Connect using "master" instead of the target DB, since the target DB might not exist yet.
            var masterBuilder = new SqlConnectionStringBuilder(connStr) { InitialCatalog = "master" };

            using (SqlConnection conn = new SqlConnection(masterBuilder.ConnectionString))
            {
                conn.Open();
                // Check if DB already exists before trying to create it
                // to avoid "file already exists" errors after a LocalDB reset
                string checkDbSql = string.Format(@"
                    IF DB_ID('{0}') IS NULL
                    BEGIN
                        IF EXISTS (SELECT 1 FROM sys.databases WHERE name = '{0}')
                            PRINT 'Already exists'
                        ELSE
                            CREATE DATABASE [{0}]
                    END", targetDb);
                try
                {
                    using (SqlCommand cmd = new SqlCommand(checkDbSql, conn))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (SqlException ex)
                {
                    if (ex.Message.Contains("already exists"))
                    {
                        // Orphaned .mdf file - attach it instead
                        string mdfPath = System.IO.Path.Combine(
                            System.Environment.GetFolderPath(System.Environment.SpecialFolder.UserProfile),
                            targetDb + ".mdf");
                        if (System.IO.File.Exists(mdfPath))
                        {
                            string attachSql = string.Format(
                                "CREATE DATABASE [{0}] ON (FILENAME='{1}') FOR ATTACH;", targetDb, mdfPath);
                            using (SqlCommand cmd = new SqlCommand(attachSql, conn))
                                cmd.ExecuteNonQuery();
                        }
                        // If file doesn't exist either, just continue - tables check will catch it
                    }
                    else
                    {
                        throw;
                    }
                }
            }

            // Step 2: check if the schema (Users table) already exists in the target DB.
            bool usersTableExists;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT CASE WHEN OBJECT_ID('dbo.Users') IS NULL THEN 0 ELSE 1 END", conn))
                {
                    usersTableExists = Convert.ToInt32(cmd.ExecuteScalar()) == 1;
                }
            }

            if (usersTableExists)
            {
                EnsureLessonSeed(sqlFilePath);
                return; // schema already set up, nothing to do
            }

            // Step 3: read database.sql from disk and run it against the target DB.
            if (!System.IO.File.Exists(sqlFilePath))
            {
                return; // can't find the script - fail silently, page-level errors will still show if tables are missing
            }

            string script = System.IO.File.ReadAllText(sqlFilePath);

            // Strip out the CREATE DATABASE / USE lines at the top - we already made sure
            // the database exists in Step 1, and we're already connected to it directly.
            var lines = script.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
            var filtered = new System.Collections.Generic.List<string>();
            foreach (var line in lines)
            {
                string trimmed = line.Trim();
                if (trimmed.StartsWith("CREATE DATABASE", StringComparison.OrdinalIgnoreCase)) continue;
                if (trimmed.StartsWith("USE ", StringComparison.OrdinalIgnoreCase)) continue;
                if (trimmed.Equals("GO", StringComparison.OrdinalIgnoreCase)) continue;
                filtered.Add(line);
            }
            string cleanedScript = string.Join("\n", filtered);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(cleanedScript, conn))
                {
                    cmd.CommandTimeout = 120;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Seeds lessons, quizzes, and quiz questions when the database already
        /// exists but was created before lesson content was added to database.sql.
        /// </summary>
        private static void EnsureLessonSeed(string sqlFilePath)
        {
            object lessonCount = Scalar("SELECT COUNT(*) FROM Lessons");
            if (lessonCount != null && Convert.ToInt32(lessonCount) > 0)
            {
                return;
            }

            if (!System.IO.File.Exists(sqlFilePath))
            {
                return;
            }

            string script = System.IO.File.ReadAllText(sqlFilePath);
            const string marker = "-- Seed Lessons";
            int startIndex = script.IndexOf(marker, StringComparison.OrdinalIgnoreCase);
            if (startIndex < 0)
            {
                return;
            }

            string seedScript = script.Substring(startIndex);
            var lines = seedScript.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
            var filtered = new System.Collections.Generic.List<string>();
            foreach (var line in lines)
            {
                if (line.Trim().Equals("GO", StringComparison.OrdinalIgnoreCase)) continue;
                filtered.Add(line);
            }

            string cleanedScript = string.Join("\n", filtered);
            if (string.IsNullOrWhiteSpace(cleanedScript))
            {
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(cleanedScript, conn))
                {
                    cmd.CommandTimeout = 120;
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
