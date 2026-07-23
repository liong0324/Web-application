using System;
using System.Data;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect logged-in users straight to their dashboard
            if (Session["UserId"] != null)
            {
                string role = Session["Role"]?.ToString();
                if (role == "Admin")
                    Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                else if (role == "Instructor")
                    Response.Redirect("~/Pages/Instructor/Dashboard.aspx");
                else
                    Response.Redirect("~/Pages/Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourses();
                LoadStats();
            }
        }

        private void LoadCourses()
        {
            string sql = @"SELECT c.Id, c.Title, c.Description, c.Level,
                           cat.Name AS CategoryName,
                           (SELECT COUNT(*) FROM Lessons WHERE CourseId = c.Id) AS LessonCount,
                           (SELECT COUNT(*) FROM Enrollments WHERE CourseId = c.Id) AS EnrollmentCount
                           FROM Courses c
                           INNER JOIN Categories cat ON c.CategoryId = cat.Id
                           WHERE c.IsPublished = 1
                           ORDER BY c.CreatedDate DESC";
            DataTable dt = DBHelper.Query(sql);
            rptCourses.DataSource = dt;
            rptCourses.DataBind();
        }

        private void LoadStats()
        {
            object students = DBHelper.Scalar("SELECT COUNT(DISTINCT UserId) FROM Enrollments");
            object courses = DBHelper.Scalar("SELECT COUNT(*) FROM Courses WHERE IsPublished = 1");
            object quizzes = DBHelper.Scalar("SELECT COUNT(*) FROM Quizzes");

            string script = string.Format(@"document.getElementById('statStudents').textContent = '+{0}';
                document.getElementById('statCourses').textContent = '+{1}';
                document.getElementById('statQuizzes').textContent = '+{2}';",
                students ?? 0, courses ?? 0, quizzes ?? 0);

            ClientScript.RegisterStartupScript(this.GetType(), "Stats", script, true);
        }
    }
}
