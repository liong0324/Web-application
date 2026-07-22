using System;
using System.Data.SqlClient;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (!chkTerms.Checked)
            {
                lblError.Text = "You must agree to the Terms & Conditions.";
                lblError.Visible = true;
                return;
            }

            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            object exists = DBHelper.Scalar("SELECT COUNT(*) FROM Users WHERE Email = @Email OR Username = @Username",
                new SqlParameter("@Email", email), new SqlParameter("@Username", username));

            if (Convert.ToInt32(exists) > 0)
            {
                lblError.Text = "Email or username already exists.";
                lblError.Visible = true;
                return;
            }

            string hash = DBHelper.HashPassword(password);
            DBHelper.Execute(@"INSERT INTO Users (FullName, Email, Username, PasswordHash, Role, IsActive, DateJoined) 
                              VALUES (@FullName, @Email, @Username, @PasswordHash, 'Member', 1, GETDATE())",
                new SqlParameter("@FullName", fullName),
                new SqlParameter("@Email", email),
                new SqlParameter("@Username", username),
                new SqlParameter("@PasswordHash", hash));

            lblSuccess.Text = "Account created successfully! You can now login.";
            lblSuccess.Visible = true;
            lblError.Visible = false;
        }
    }
}
