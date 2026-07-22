using System;
using System.Data;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Member")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        private void LoadDashboard()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            litUserName.Text = Session["FullName"]?.ToString() ?? "";
            litPoints.Text = (GetUserPoints(userId)).ToString();
            litTotalPoints.Text = litPoints.Text;

            object enrolled = DBHelper.Scalar("SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId",
                new System.Data.SqlClient.SqlParameter("@UserId", userId));
            object completed = DBHelper.Scalar("SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId AND IsCompleted = 1",
                new System.Data.SqlClient.SqlParameter("@UserId", userId));
            object avgScore = DBHelper.Scalar("SELECT ISNULL(AVG(Score),0) FROM QuizResults WHERE UserId = @UserId",
                new System.Data.SqlClient.SqlParameter("@UserId", userId));

            litEnrolled.Text = enrolled?.ToString() ?? "0";
            litCompleted.Text = completed?.ToString() ?? "0";
            litAvgScore.Text = Convert.ToInt32(avgScore).ToString();

            DataTable courses = DBHelper.Query(@"SELECT c.Id, c.Title, cat.Name AS CategoryName, e.Progress
                FROM Enrollments e INNER JOIN Courses c ON e.CourseId = c.Id
                LEFT JOIN Categories cat ON c.CategoryId = cat.Id
                WHERE e.UserId = @UserId ORDER BY e.EnrollmentDate DESC",
                new System.Data.SqlClient.SqlParameter("@UserId", userId));
            rptMyCourses.DataSource = courses;
            rptMyCourses.DataBind();
            pnlCourses.Visible = courses.Rows.Count > 0;

            DataTable results = DBHelper.Query(@"SELECT q.Title AS QuizTitle, qr.Score, qr.Passed, qr.DateTaken
                FROM QuizResults qr INNER JOIN Quizzes q ON qr.QuizId = q.Id
                WHERE qr.UserId = @UserId ORDER BY qr.DateTaken DESC",
                new System.Data.SqlClient.SqlParameter("@UserId", userId));
            rptResults.DataSource = results;
            rptResults.DataBind();
            pnlResults.Visible = results.Rows.Count > 0;
        }

        private int GetUserPoints(int userId)
        {
            object pts = DBHelper.Scalar("SELECT Points FROM Users WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", userId));
            return Convert.ToInt32(pts ?? 0);
        }
    }
}
