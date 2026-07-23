using System;
using System.Web;
using LumoraWebForms.App_Code;

namespace LumoraWebForms
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // Auto-create the database and tables from database.sql if they don't exist yet.
            // This means teammates can just clone the repo and press F5 - no manual SSMS step.
            string sqlFilePath = Server.MapPath("~/database.sql");
            DBHelper.EnsureDatabase(sqlFilePath);
        }

        protected void Application_Error(object sender, EventArgs e)
        {
        }
    }
}
