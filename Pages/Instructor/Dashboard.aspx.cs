using System;
using System.Data;
using System.Data.SqlClient;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Instructor
{
    public partial class InstructorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("~/Pages/Login.aspx"); return; }
            if (Session["Role"]?.ToString() != "Instructor") { Response.Redirect("~/Pages/Login.aspx"); return; }

            if (!IsPostBack) LoadDashboard();
        }

        private void LoadDashboard()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            litName.Text = Session["FullName"]?.ToString();

            // Course count
            object courseCount = DBHelper.Scalar(
                "SELECT COUNT(*) FROM Courses WHERE InstructorId = @Id",
                new SqlParameter("@Id", userId));
            litMyCourses.Text = courseCount?.ToString() ?? "0";

            // Total students enrolled across instructor's courses
            object students = DBHelper.Scalar(
                "SELECT COUNT(*) FROM Enrollments e INNER JOIN Courses c ON e.CourseId = c.Id WHERE c.InstructorId = @Id",
                new SqlParameter("@Id", userId));
            litTotalStudents.Text = students?.ToString() ?? "0";

            // Total quizzes across instructor's courses
            object quizzes = DBHelper.Scalar(
                "SELECT COUNT(*) FROM Quizzes q INNER JOIN Lessons l ON q.LessonId = l.Id INNER JOIN Courses c ON l.CourseId = c.Id WHERE c.InstructorId = @Id",
                new SqlParameter("@Id", userId));
            litTotalQuizzes.Text = quizzes?.ToString() ?? "0";

            // Total completions
            object completions = DBHelper.Scalar(
                "SELECT COUNT(*) FROM Enrollments e INNER JOIN Courses c ON e.CourseId = c.Id WHERE c.InstructorId = @Id AND e.IsCompleted = 1",
                new SqlParameter("@Id", userId));
            litCompletions.Text = completions?.ToString() ?? "0";

            // My courses list
            DataTable dt = DBHelper.Query(@"
                SELECT c.Title, c.Level, c.IsPublished,
                       cat.Name AS CategoryName,
                       (SELECT COUNT(*) FROM Enrollments WHERE CourseId = c.Id) AS EnrollmentCount
                FROM Courses c
                INNER JOIN Categories cat ON c.CategoryId = cat.Id
                WHERE c.InstructorId = @Id
                ORDER BY c.CreatedDate DESC",
                new SqlParameter("@Id", userId));
            rptCourses.DataSource = dt;
            rptCourses.DataBind();
        }
    }
}
