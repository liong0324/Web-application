using System;
using System.Data;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Leaderboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("Login.aspx"); return; }
            if (Session["Role"]?.ToString() != "Member") { Response.Redirect("~/Pages/Admin/Dashboard.aspx"); return; }
            if (!IsPostBack) LoadLeaderboard();
        }

        private void LoadLeaderboard()
        {
            DataTable topUsers = DBHelper.Query("SELECT TOP 20 FullName, Points, Level FROM Users WHERE IsActive = 1 AND Role = 'Member' ORDER BY Points DESC");
            rptLeaderboard.DataSource = topUsers;
            rptLeaderboard.DataBind();

            int userId = Convert.ToInt32(Session["UserId"]);
            object rank = DBHelper.Scalar("SELECT COUNT(*) FROM Users WHERE IsActive = 1 AND Role = 'Member' AND Points > (SELECT Points FROM Users WHERE Id = @Id)",
                new System.Data.SqlClient.SqlParameter("@Id", userId));
            litMyRank.Text = (Convert.ToInt32(rank) + 1).ToString();

            object pts = DBHelper.Scalar("SELECT Points FROM Users WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", userId));
            litMyPoints.Text = pts?.ToString() ?? "0";
        }
    }
}
