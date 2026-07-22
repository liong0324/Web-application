using System;
using System.Data;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                litUsers.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Users").ToString();
                litCourses.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Courses").ToString();
                litEnrollments.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Enrollments").ToString();
                litLessons.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Lessons").ToString();
                litMessages.Text = DBHelper.Scalar("SELECT COUNT(*) FROM ContactMessages WHERE IsRead = 0").ToString();

                DataTable recentCourses = DBHelper.Query(@"SELECT TOP 5 c.Title, cat.Name AS CategoryName, c.IsPublished 
                    FROM Courses c LEFT JOIN Categories cat ON c.CategoryId = cat.Id ORDER BY c.CreatedDate DESC");
                rptRecentCourses.DataSource = recentCourses;
                rptRecentCourses.DataBind();
            }
        }
    }
}
