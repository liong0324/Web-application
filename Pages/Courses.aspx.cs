using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Instructors should use their own course management page
            if (Session["Role"] != null && Session["Role"].ToString() == "Instructor")
            {
                Response.Redirect("~/Pages/Instructor/MyCourses.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
                LoadCourses(null);
            }
        }

        private void LoadCategories()
        {
            DataTable dt = DBHelper.Query("SELECT Id, Name FROM Categories ORDER BY Name");
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
            // Update All button style based on active state
            btnAll.CssClass = ViewState["ActiveCat"] == null
                ? "filter-btn btn-lumora-primary"
                : "filter-btn btn-lumora-secondary";
        }

        private void LoadCourses(int? categoryId)
        {
            string sql = @"SELECT c.Id, c.Title, c.Description, c.Level, c.InstructorId,
                           (SELECT COUNT(*) FROM Enrollments WHERE CourseId = c.Id) AS EnrollmentCount,
                           cat.Name AS CategoryName, u.FullName AS InstructorName
                           FROM Courses c
                           INNER JOIN Categories cat ON c.CategoryId = cat.Id
                           LEFT JOIN Users u ON c.InstructorId = u.Id
                           WHERE c.IsPublished = 1";
            if (categoryId.HasValue)
                sql += " AND c.CategoryId = @CategoryId";
            sql += " ORDER BY c.CreatedDate DESC";

            DataTable dt = categoryId.HasValue
                ? DBHelper.Query(sql, new System.Data.SqlClient.SqlParameter("@CategoryId", categoryId.Value))
                : DBHelper.Query(sql);

            rptCourses.DataSource = dt;
            rptCourses.DataBind();
            pnlNoResults.Visible = dt.Rows.Count == 0;
        }

        protected void btnCategory_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            ViewState["ActiveCat"] = btn.CommandArgument;
            LoadCategories();
            LoadCourses(int.Parse(btn.CommandArgument));
        }

        protected void btnAll_Click(object sender, EventArgs e)
        {
            ViewState["ActiveCat"] = null;
            LoadCategories();
            LoadCourses(null);
        }

        protected string GetCourseButton(object id)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            if (role == "Admin")
                return "<a href='" + ResolveUrl("~/Pages/Admin/ManageCourse.aspx?id=" + id) + "' class=\"btn-lumora-secondary w-100 text-center d-block\"><i class=\"bi bi-gear me-1\"></i>Manage Course</a>";
            return "<a href='" + ResolveUrl("~/Pages/CourseDetail.aspx?id=" + id) + "' class=\"btn-lumora-primary w-100 text-center d-block\">View Details <i class=\"bi bi-arrow-right ms-1\"></i></a>";
        }
    }
}
