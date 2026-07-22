using System;
using System.Data.SqlClient;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("Login.aspx"); return; }
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            string oldHash = DBHelper.HashPassword(txtOldPassword.Text);
            string newHash = DBHelper.HashPassword(txtNewPassword.Text);

            object current = DBHelper.Scalar("SELECT PasswordHash FROM Users WHERE Id = @Id",
                new SqlParameter("@Id", userId));

            if (current?.ToString() != oldHash)
            {
                lblError.Text = "Current password is incorrect.";
                lblError.Visible = true;
                return;
            }

            DBHelper.Execute("UPDATE Users SET PasswordHash = @Hash WHERE Id = @Id",
                new SqlParameter("@Hash", newHash), new SqlParameter("@Id", userId));

            lblSuccess.Text = "Password changed successfully!";
            lblSuccess.Visible = true;
            lblError.Visible = false;
        }
    }
}
