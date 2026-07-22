using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack) LoadProfile();
        }

        private void LoadProfile()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DataTable dt = DBHelper.Query("SELECT * FROM Users WHERE Id = @Id", new SqlParameter("@Id", userId));
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                litFullName.Text = row["FullName"].ToString();
                litUsername.Text = row["Username"].ToString();
                litPoints.Text = row["Points"].ToString();
                litDateJoined.Text = Convert.ToDateTime(row["DateJoined"]).ToString("MMM yyyy");
                txtFullName.Text = row["FullName"].ToString();
                txtUsername.Text = row["Username"].ToString();
                txtBio.Text = row["Bio"]?.ToString() ?? "";

                litEnrolled.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId", new SqlParameter("@UserId", userId)).ToString();
                litCompleted.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId AND IsCompleted = 1", new SqlParameter("@UserId", userId)).ToString();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DBHelper.Execute("UPDATE Users SET FullName = @FullName, Username = @Username, Bio = @Bio WHERE Id = @Id",
                new SqlParameter("@FullName", txtFullName.Text.Trim()),
                new SqlParameter("@Username", txtUsername.Text.Trim()),
                new SqlParameter("@Bio", txtBio.Text.Trim()),
                new SqlParameter("@Id", userId));

            Session["FullName"] = txtFullName.Text.Trim();
            Session["Username"] = txtUsername.Text.Trim();

            lblSuccess.Text = "Profile updated successfully!";
            lblSuccess.Visible = true;
            LoadProfile();
        }
    }
}
