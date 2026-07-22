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
        }

        private void LoadCourses(int? categoryId)
        {
            string sql = @"SELECT c.Id, c.Title, c.Description, c.Level, c.EnrollmentCount,
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
            LoadCourses(int.Parse(btn.CommandArgument));
        }

        protected void btnAll_Click(object sender, EventArgs e)
        {
            LoadCourses(null);
        }
    }
}
