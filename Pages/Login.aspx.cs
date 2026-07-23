using System;
using System.Data;
using System.Web;
using System.Web.Security;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            string hash = DBHelper.HashPassword(password);
            string sql = "SELECT Id, FullName, Username, Email, Role, IsActive FROM Users WHERE Email = @Email AND PasswordHash = @Password";
            DataTable dt = DBHelper.Query(sql,
                new System.Data.SqlClient.SqlParameter("@Email", email),
                new System.Data.SqlClient.SqlParameter("@Password", hash));

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                if (!(bool)row["IsActive"])
                {
                    lblError.Text = "Your account has been suspended.";
                    lblError.Visible = true;
                    return;
                }

                Session["UserId"] = row["Id"];
                Session["FullName"] = row["FullName"];
                Session["Username"] = row["Username"];
                Session["Email"] = row["Email"];
                Session["Role"] = row["Role"];

                FormsAuthentication.SetAuthCookie(row["Username"].ToString(), chkRemember.Checked);

                if (row["Role"].ToString() == "Admin")
                    Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                else if (row["Role"].ToString() == "Instructor")
                    Response.Redirect("~/Pages/Instructor/Dashboard.aspx");
                else
                    Response.Redirect("~/Pages/Dashboard.aspx");
            }
            else
            {
                lblError.Text = "Invalid email or password.";
                lblError.Visible = true;
            }
        }
    }
}
