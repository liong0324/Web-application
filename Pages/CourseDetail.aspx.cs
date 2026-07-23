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
            string sql = @"SELECT c.*, cat.Name AS CategoryName, u.FullName AS InstructorName,
                           (SELECT COUNT(*) FROM Enrollments WHERE CourseId = c.Id) AS LiveEnrollments
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
            courseEnrollments.Text = row["LiveEnrollments"].ToString();
            courseDescription.Text = row["Description"]?.ToString() ?? "";
            coursePrice.InnerHtml = Convert.ToDecimal(row["Price"]) == 0 ? "Free" : "$" + Convert.ToDecimal(row["Price"]).ToString("F2");
            lessonCount.Text = DBHelper.Scalar("SELECT COUNT(*) FROM Lessons WHERE CourseId = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", courseId)).ToString();
            enrollmentCount2.Text = row["LiveEnrollments"].ToString();
            categoryName2.Text = row["CategoryName"].ToString();

            DataTable lessons = DBHelper.Query("SELECT * FROM Lessons WHERE CourseId = @Id ORDER BY [Order]",
                new System.Data.SqlClient.SqlParameter("@Id", courseId));
            rptLessons.DataSource = lessons;
            rptLessons.DataBind();
            pnlLessons.Visible = lessons.Rows.Count > 0;
            pnlNoLessons.Visible = lessons.Rows.Count == 0;

            bool hasLessons = lessons.Rows.Count > 0;

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
                    btnContinue.HRef = hasLessons ? string.Format("Learn.aspx?courseId={0}", courseId) : "#";
                    btnContinue.Visible = hasLessons;
                }
            }
            else if (Session["UserId"] != null)
            {
                // Admin gets Manage Course, Instructor gets View Course (read-only)
                pnlEnroll.Visible = false;
                pnlManage.Visible = true;
                if (Session["Role"]?.ToString() == "Admin")
                {
                    btnManageCourse.InnerHtml = "<i class='bi bi-gear me-2'></i>Manage Course";
                    btnManageCourse.HRef = ResolveUrl("~/Pages/Admin/ManageCourse.aspx?id=" + courseId);
                }
                else
                {
                    btnManageCourse.InnerHtml = "<i class='bi bi-patch-question me-2'></i>Manage Quizzes";
                    btnManageCourse.HRef = ResolveUrl("~/Pages/Instructor/ManageCourse.aspx?id=" + courseId);
                }
            }

            btnEnroll.Enabled = hasLessons;
            if (!hasLessons)
            {
                btnEnroll.Text = "No Lessons Yet";
            }
        }

        protected string GetLessonUrl(int lessonId)
        {
            string role = Session["Role"]?.ToString() ?? "";
            // Instructors and admins can always view lesson content
            if (role == "Instructor" || role == "Admin")
                return string.Format("Learn.aspx?courseId={0}&lessonId={1}", courseId, lessonId);
            // Members must be enrolled first
            if (role == "Member" && Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                object enrolled = DBHelper.Scalar(
                    "SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId AND CourseId = @CourseId",
                    new System.Data.SqlClient.SqlParameter("@UserId", userId),
                    new System.Data.SqlClient.SqlParameter("@CourseId", courseId));
                if (Convert.ToInt32(enrolled) > 0)
                    return string.Format("Learn.aspx?courseId={0}&lessonId={1}", courseId, lessonId);
            }
            // Not enrolled or not logged in — return # (no link)
            return "#";
        }

        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Only students (Member role) can enroll
            string role = Session["Role"]?.ToString();
            if (role != "Member")
            {
                Response.Redirect(string.Format("CourseDetail.aspx?id={0}", courseId));
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

            object lessonCount = DBHelper.Scalar("SELECT COUNT(*) FROM Lessons WHERE CourseId = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", courseId));
            if (Convert.ToInt32(lessonCount) == 0)
            {
                Response.Redirect(string.Format("CourseDetail.aspx?id={0}", courseId));
                return;
            }

            Response.Redirect(string.Format("Learn.aspx?courseId={0}", courseId));
        }
    }
}
