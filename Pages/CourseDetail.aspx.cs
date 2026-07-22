using System;
using System.Data;
using System.Web;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class CourseDetail : System.Web.UI.Page
    {
        private int courseId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out courseId))
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourse();
            }
        }

        private void LoadCourse()
        {
            string sql = @"SELECT c.*, cat.Name AS CategoryName, u.FullName AS InstructorName
                           FROM Courses c
                           INNER JOIN Categories cat ON c.CategoryId = cat.Id
                           LEFT JOIN Users u ON c.InstructorId = u.Id
                           WHERE c.Id = @Id";
            DataTable dt = DBHelper.Query(sql, new System.Data.SqlClient.SqlParameter("@Id", courseId));

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            DataRow row = dt.Rows[0];
            breadcrumbTitle.Text = row["Title"].ToString();
            courseTitle.Text = row["Title"].ToString();
            courseCategory.Text = row["CategoryName"].ToString();
            courseInstructor.Text = row["InstructorName"]?.ToString() ?? "N/A";
            courseEnrollments.Text = row["EnrollmentCount"].ToString();
            courseDescription.Text = row["Description"]?.ToString() ?? "";
            coursePrice.InnerHtml = Convert.ToDecimal(row["Price"]) == 0 ? "Free" : "$" + Convert.ToDecimal(row["Price"]).ToString("F2");
            lessonCount.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Lessons WHERE CourseId = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", courseId)).ToString();
            enrollmentCount2.Text = row["EnrollmentCount"].ToString();
            categoryName2.Text = row["CategoryName"].ToString();

            DataTable lessons = DBHelper.Query("SELECT * FROM Lessons WHERE CourseId = @Id ORDER BY [Order]",
                new System.Data.SqlClient.SqlParameter("@Id", courseId));
            rptLessons.DataSource = lessons;
            rptLessons.DataBind();

            if (Session["UserId"] != null && Session["Role"]?.ToString() == "Member")
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                DataTable enrollment = DBHelper.Query("SELECT * FROM Enrollments WHERE UserId = @UserId AND CourseId = @CourseId",
                    new System.Data.SqlClient.SqlParameter("@UserId", userId),
                    new System.Data.SqlClient.SqlParameter("@CourseId", courseId));

                if (enrollment.Rows.Count > 0)
                {
                    pnlEnroll.Visible = false;
                    pnlProgress.Visible = true;
                    int progress = Convert.ToInt32(enrollment.Rows[0]["Progress"]);
                    progressBar.Text = "<div class='progress-bar' style='width:" + progress + "%'></div>";
                    progressText.Text = progress + "% complete";
                    btnContinue.HRef = string.Format("Learn.aspx?courseId={0}", courseId);
                }
            }
        }

        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            object exists = DBHelper.Scalar("SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId AND CourseId = @CourseId",
                new System.Data.SqlClient.SqlParameter("@UserId", userId),
                new System.Data.SqlClient.SqlParameter("@CourseId", courseId));

            if (Convert.ToInt32(exists) == 0)
            {
                DBHelper.Execute("INSERT INTO Enrollments (UserId, CourseId, EnrollmentDate, Progress, IsCompleted) VALUES (@UserId, @CourseId, GETDATE(), 0, 0)",
                    new System.Data.SqlClient.SqlParameter("@UserId", userId),
                    new System.Data.SqlClient.SqlParameter("@CourseId", courseId));

                DBHelper.Execute("UPDATE Courses SET EnrollmentCount = EnrollmentCount + 1 WHERE Id = @Id",
                    new System.Data.SqlClient.SqlParameter("@Id", courseId));
            }

            Response.Redirect(string.Format("Learn.aspx?courseId={0}", courseId));
        }
    }
}
