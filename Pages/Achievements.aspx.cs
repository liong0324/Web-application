using System;
using System.Data;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Achievements : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack) LoadAchievements();
        }

        private void LoadAchievements()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            litPoints.Text = DBHelper.Scalar("SELECT Points FROM Users WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", userId))?.ToString() ?? "0";

            string sql = @"SELECT b.*, 
                CASE WHEN ub.Id IS NOT NULL THEN 1 ELSE 0 END AS Earned,
                ub.EarnedDate
                FROM Badges b
                LEFT JOIN UserBadges ub ON b.Id = ub.BadgeId AND ub.UserId = @UserId
                ORDER BY b.Id";

            DataTable dt = DBHelper.Query(sql, new System.Data.SqlClient.SqlParameter("@UserId", userId));
            rptBadges.DataSource = dt;
            rptBadges.DataBind();
        }
    }
}
