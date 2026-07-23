using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class TakeQuiz : System.Web.UI.Page
    {
        public int quizId, courseId, lessonId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) { Response.Redirect("Login.aspx"); return; }
            int.TryParse(Request.QueryString["quizId"], out quizId);
            int.TryParse(Request.QueryString["courseId"], out courseId);
            int.TryParse(Request.QueryString["lessonId"], out lessonId);

            // Members must be enrolled to take a quiz
            if (Session["Role"]?.ToString() == "Member" && courseId > 0)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                object enrolled = DBHelper.Scalar(
                    "SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId AND CourseId = @CourseId",
                    new System.Data.SqlClient.SqlParameter("@UserId", userId),
                    new System.Data.SqlClient.SqlParameter("@CourseId", courseId));
                if (Convert.ToInt32(enrolled) == 0)
                {
                    Response.Redirect("CourseDetail.aspx?id=" + courseId);
                    return;
                }
            }

            if (!IsPostBack) LoadQuiz();
        }

        private void LoadQuiz()
        {
            DataTable quiz = DBHelper.Query("SELECT * FROM Quizzes WHERE Id = @Id", new System.Data.SqlClient.SqlParameter("@Id", quizId));
            if (quiz.Rows.Count == 0) { Response.Redirect("Courses.aspx"); return; }

            DataRow q = quiz.Rows[0];
            litQuizTitle.Text = q["Title"].ToString();
            litTimeLimit.Text = q["TimeLimitMinutes"].ToString();

            DataTable questions = DBHelper.Query("SELECT * FROM QuizQuestions WHERE QuizId = @QuizId", new System.Data.SqlClient.SqlParameter("@QuizId", quizId));
            rptQuestions.DataSource = questions;
            rptQuestions.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DataTable questions = DBHelper.Query("SELECT * FROM QuizQuestions WHERE QuizId = @QuizId", new System.Data.SqlClient.SqlParameter("@QuizId", quizId));

            int correct = 0;
            int total = questions.Rows.Count;

            foreach (DataRow row in questions.Rows)
            {
                string selected = Request.Form["q" + row["Id"]];
                if (selected != null && int.Parse(selected) == Convert.ToInt32(row["CorrectOption"]))
                    correct++;
            }

            int score = total > 0 ? (correct * 100) / total : 0;
            bool passed = score >= Convert.ToInt32(DBHelper.Scalar("SELECT PassingScore FROM Quizzes WHERE Id = @Id", new System.Data.SqlClient.SqlParameter("@Id", quizId)));

            DBHelper.Execute(@"INSERT INTO QuizResults (UserId, QuizId, Score, TotalQuestions, CorrectAnswers, Passed, DateTaken) 
                VALUES (@UserId, @QuizId, @Score, @Total, @Correct, @Passed, GETDATE())",
                new System.Data.SqlClient.SqlParameter("@UserId", userId),
                new System.Data.SqlClient.SqlParameter("@QuizId", quizId),
                new System.Data.SqlClient.SqlParameter("@Score", score),
                new System.Data.SqlClient.SqlParameter("@Total", total),
                new System.Data.SqlClient.SqlParameter("@Correct", correct),
                new System.Data.SqlClient.SqlParameter("@Passed", passed));

            DBHelper.Execute("UPDATE Users SET Points = Points + @Pts WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Pts", passed ? 25 : 5),
                new System.Data.SqlClient.SqlParameter("@Id", userId));

            DBHelper.Execute(@"INSERT INTO Notifications (UserId, Message, Type, CreatedDate) 
                VALUES (@UserId, @Message, 'QuizResult', GETDATE())",
                new System.Data.SqlClient.SqlParameter("@UserId", userId),
                new System.Data.SqlClient.SqlParameter("@Message", passed
                    ? string.Format("You passed the quiz with {0}%!", score)
                    : string.Format("You scored {0}% on the quiz. Try again!", score)));

            Response.Redirect(string.Format("QuizResult.aspx?score={0}&correct={1}&total={2}&passed={3}&quizId={4}", score, correct, total, passed, quizId));
        }
    }
}
