using System;
using System.Data;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Learn : System.Web.UI.Page
    {
        public int courseId;
        public int currentLessonId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["courseId"], out courseId))
            {
                Response.Redirect("Courses.aspx");
                return;
            }

            int.TryParse(Request.QueryString["lessonId"], out currentLessonId);

            if (!IsPostBack)
            {
                LoadLesson();
            }
        }

        private void LoadLesson()
        {
            DataTable courseLessons = DBHelper.Query("SELECT * FROM Lessons WHERE CourseId = @CourseId ORDER BY [Order]",
                new System.Data.SqlClient.SqlParameter("@CourseId", courseId));

            if (courseLessons.Rows.Count == 0)
            {
                Response.Redirect("CourseDetail.aspx?id=" + courseId);
                return;
            }

            rptSidebar.DataSource = courseLessons;
            rptSidebar.DataBind();

            string courseTitle = DBHelper.Scalar("SELECT Title FROM Courses WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", courseId))?.ToString() ?? "";
            litCourseTitle.Text = courseTitle;

            DataRow lesson;
            if (currentLessonId == 0)
            {
                lesson = courseLessons.Rows[0];
                currentLessonId = Convert.ToInt32(lesson["Id"]);
            }
            else
            {
                DataView dv = new DataView(courseLessons);
                dv.RowFilter = "Id = " + currentLessonId;
                if (dv.Count == 0)
                {
                    lesson = courseLessons.Rows[0];
                    currentLessonId = Convert.ToInt32(lesson["Id"]);
                }
                else
                {
                    lesson = dv[0].Row;
                }
            }

            litOrder.Text = lesson["Order"].ToString();
            litTitle.Text = lesson["Title"].ToString();
            litDuration.Text = lesson["DurationMinutes"].ToString();
            litContent.Text = lesson["Content"]?.ToString() ?? "";

            DataTable quizzes = DBHelper.Query("SELECT * FROM Quizzes WHERE LessonId = @LessonId",
                new System.Data.SqlClient.SqlParameter("@LessonId", currentLessonId));
            rptQuizzes.DataSource = quizzes;
            rptQuizzes.DataBind();
            pnlQuizzes.Visible = quizzes.Rows.Count > 0;

            LoadDiscussions();
        }

        private void LoadDiscussions()
        {
            DataTable discussions = DBHelper.Query(@"SELECT d.*, u.FullName 
                FROM Discussions d LEFT JOIN Users u ON d.UserId = u.Id 
                WHERE d.LessonId = @LessonId AND d.ParentId IS NULL 
                ORDER BY d.CreatedDate DESC",
                new System.Data.SqlClient.SqlParameter("@LessonId", currentLessonId));
            rptDiscussions.DataSource = discussions;
            rptDiscussions.DataBind();
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDiscussion.Text)) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            DBHelper.Execute("INSERT INTO Discussions (Message, LessonId, UserId, CreatedDate) VALUES (@Message, @LessonId, @UserId, GETDATE())",
                new System.Data.SqlClient.SqlParameter("@Message", txtDiscussion.Text.Trim()),
                new System.Data.SqlClient.SqlParameter("@LessonId", currentLessonId),
                new System.Data.SqlClient.SqlParameter("@UserId", userId));

            txtDiscussion.Text = "";
            LoadDiscussions();
        }

        protected void btnComplete_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            DBHelper.Execute("UPDATE Enrollments SET Progress = 100, IsCompleted = 1, CompletedDate = GETDATE() WHERE UserId = @UserId AND CourseId = @CourseId",
                new System.Data.SqlClient.SqlParameter("@UserId", userId),
                new System.Data.SqlClient.SqlParameter("@CourseId", courseId));

            DBHelper.Execute("UPDATE Users SET Points = Points + 10 WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", userId));

            Response.Redirect("CourseDetail.aspx?id=" + courseId);
        }
    }
}
