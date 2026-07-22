using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Admin
{
    public partial class ManageCourses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }
            if (!IsPostBack) LoadCourses();
        }

        private void LoadCourses()
        {
            string sql = @"SELECT c.Id, c.Title, c.Description, c.Price, c.IsPublished, c.EnrollmentCount, c.CategoryId, c.Level,
                           cat.Name AS CategoryName FROM Courses c
                           LEFT JOIN Categories cat ON c.CategoryId = cat.Id ORDER BY c.CreatedDate DESC";
            DataTable dt = DBHelper.Query(sql);
            rptCourses.DataSource = dt;
            rptCourses.DataBind();

            DataTable cats = DBHelper.Query("SELECT Id, Name FROM Categories");
            ddlCategory.DataSource = cats;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "Id";
            ddlCategory.DataBind();
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            pnlAdd.Visible = true;
            litFormTitle.Text = "Add Course";
            hdnEditId.Value = "";
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtPrice.Text = "0";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            int userId = Convert.ToInt32(Session["UserId"]);
            if (string.IsNullOrEmpty(hdnEditId.Value))
            {
                DBHelper.Execute(@"INSERT INTO Courses (Title, Description, CategoryId, InstructorId, Price, IsPublished, Level, CreatedDate)
                    VALUES (@Title, @Desc, @CatId, @InstId, @Price, 1, @Level, GETDATE())",
                    new SqlParameter("@Title", txtTitle.Text.Trim()),
                    new SqlParameter("@Desc", txtDescription.Text.Trim()),
                    new SqlParameter("@CatId", ddlCategory.SelectedValue),
                    new SqlParameter("@InstId", userId),
                    new SqlParameter("@Price", decimal.Parse(txtPrice.Text)),
                    new SqlParameter("@Level", ddlLevel.SelectedValue));
            }
            else
            {
                DBHelper.Execute(@"UPDATE Courses SET Title=@Title, Description=@Desc, CategoryId=@CatId, Price=@Price, Level=@Level WHERE Id=@Id",
                    new SqlParameter("@Title", txtTitle.Text.Trim()),
                    new SqlParameter("@Desc", txtDescription.Text.Trim()),
                    new SqlParameter("@CatId", ddlCategory.SelectedValue),
                    new SqlParameter("@Price", decimal.Parse(txtPrice.Text)),
                    new SqlParameter("@Level", ddlLevel.SelectedValue),
                    new SqlParameter("@Id", hdnEditId.Value));
            }

            pnlAdd.Visible = false;
            LoadCourses();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlAdd.Visible = false;
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Edit":
                    DataTable dt = DBHelper.Query("SELECT * FROM Courses WHERE Id = @Id", new SqlParameter("@Id", id));
                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];
                        txtTitle.Text = row["Title"].ToString();
                        txtDescription.Text = row["Description"]?.ToString() ?? "";
                        txtPrice.Text = row["Price"].ToString();
                        ddlCategory.SelectedValue = row["CategoryId"].ToString();
                        ddlLevel.SelectedValue = row["Level"]?.ToString() ?? "Beginner";
                        hdnEditId.Value = id.ToString();
                        litFormTitle.Text = "Edit Course";
                        pnlAdd.Visible = true;
                    }
                    break;
                case "Delete":
                    DBHelper.Execute("DELETE FROM Lessons WHERE CourseId = @Id", new SqlParameter("@Id", id));
                    DBHelper.Execute("DELETE FROM Courses WHERE Id = @Id", new SqlParameter("@Id", id));
                    LoadCourses();
                    break;
                case "Toggle":
                    DBHelper.Execute("UPDATE Courses SET IsPublished = CASE WHEN IsPublished=1 THEN 0 ELSE 1 END WHERE Id = @Id", new SqlParameter("@Id", id));
                    LoadCourses();
                    break;
            }
        }
    }
}
