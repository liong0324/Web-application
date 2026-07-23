using System;
using System.Data;
using System.Data.SqlClient;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Instructor
{
    public partial class MyCourses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("~/Pages/Login.aspx"); return; }
            if (Session["Role"]?.ToString() != "Instructor") { Response.Redirect("~/Pages/Login.aspx"); return; }

            if (!IsPostBack) LoadCourses();
        }

        private void LoadCourses()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DataTable dt = DBHelper.Query(@"
                SELECT c.Id, c.Title, c.Description, c.Level, c.IsPublished,
                       cat.Name AS CategoryName,
                       (SELECT COUNT(*) FROM Enrollments WHERE CourseId = c.Id) AS EnrollmentCount,
                       (SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.Id AND e.IsCompleted = 1) AS Completions
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
