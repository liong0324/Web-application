using System;
using System.Data;
using System.Data.SqlClient;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Instructor
{
    public partial class InstructorManageCourse : System.Web.UI.Page
    {
        private int courseId;
        private int instructorId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Instructor")
            { Response.Redirect("~/Pages/Login.aspx"); return; }

            instructorId = Convert.ToInt32(Session["UserId"]);
            if (!int.TryParse(Request.QueryString["id"], out courseId))
            { Response.Redirect("MyCourses.aspx"); return; }

            object owns = DBHelper.Scalar("SELECT COUNT(*) FROM Courses WHERE Id=@Id AND InstructorId=@Inst",
                new SqlParameter("@Id", courseId), new SqlParameter("@Inst", instructorId));
            if (Convert.ToInt32(owns) == 0) { Response.Redirect("MyCourses.aspx"); return; }

            if (!IsPostBack) LoadLessons();
        }

        private void LoadLessons()
        {
            DataTable course = DBHelper.Query("SELECT Title FROM Courses WHERE Id=@Id", new SqlParameter("@Id", courseId));
            if (course.Rows.Count > 0) litBreadcrumb.Text = course.Rows[0]["Title"].ToString();

            DataTable lessons = DBHelper.Query(
                "SELECT Id, Title, [Order], DurationMinutes FROM Lessons WHERE CourseId=@Id ORDER BY [Order]",
                new SqlParameter("@Id", courseId));
            rptLessons.DataSource = lessons;
            rptLessons.DataBind();
        }

        // ---- Lesson Edit ----
        protected void rptLessons_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int lessonId = int.Parse(e.CommandArgument.ToString());
            if (e.CommandName == "EditLesson")
            {
                DataTable dt = DBHelper.Query("SELECT * FROM Lessons WHERE Id=@Id", new SqlParameter("@Id", lessonId));
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hdnLessonId.Value = lessonId.ToString();
                    litEditLessonName.Text = row["Title"].ToString();
                    txtLessonTitle.Text = row["Title"].ToString();
                    txtDuration.Text = row["DurationMinutes"].ToString();
                    txtLessonContent.Text = row["Content"]?.ToString() ?? "";
                    lblLessonMsg.Visible = false;
                    pnlLessonEdit.Visible = true;
                    pnlQuizSection.Visible = false;
                }
            }
            else if (e.CommandName == "ManageQuiz")
            {
                pnlLessonEdit.Visible = false;
                LoadQuizSection(lessonId);
            }
        }

        protected void btnSaveLesson_Click(object sender, EventArgs e)
        {
            DBHelper.Execute("UPDATE Lessons SET Title=@Title, Content=@Content, DurationMinutes=@Duration WHERE Id=@Id",
                new SqlParameter("@Title", txtLessonTitle.Text.Trim()),
                new SqlParameter("@Content", txtLessonContent.Text.Trim()),
                new SqlParameter("@Duration", int.Parse(txtDuration.Text.Trim())),
                new SqlParameter("@Id", hdnLessonId.Value));
            litEditLessonName.Text = txtLessonTitle.Text.Trim();
            lblLessonMsg.Text = "Lesson saved successfully.";
            lblLessonMsg.Visible = true;
            LoadLessons();
        }

        protected void btnCloseLessonEdit_Click(object sender, EventArgs e) { pnlLessonEdit.Visible = false; }

        // ---- Quiz ----
        private void LoadQuizSection(int lessonId)
        {
            hdnQuizLessonId.Value = lessonId.ToString();
            string lessonTitle = DBHelper.Scalar("SELECT Title FROM Lessons WHERE Id=@Id",
                new SqlParameter("@Id", lessonId))?.ToString() ?? "";
            litQuizLessonName.Text = lessonTitle;

            DataTable quiz = DBHelper.Query("SELECT * FROM Quizzes WHERE LessonId=@Id", new SqlParameter("@Id", lessonId));
            if (quiz.Rows.Count > 0)
            {
                DataRow q = quiz.Rows[0];
                hdnQuizId.Value = q["Id"].ToString();
                txtQuizTitle.Text = q["Title"].ToString();
                txtQuizTime.Text = q["TimeLimitMinutes"].ToString();
                txtPassingScore.Text = q["PassingScore"].ToString();
                LoadQuestions(Convert.ToInt32(q["Id"]));
            }
            else
            {
                hdnQuizId.Value = "";
                txtQuizTitle.Text = lessonTitle + " Quiz";
                txtQuizTime.Text = "15";
                txtPassingScore.Text = "70";
                rptQuestions.DataSource = null;
                rptQuestions.DataBind();
            }
            lblQuizMsg.Visible = false;
            pnlQuizSection.Visible = true;
        }

        private void LoadQuestions(int quizId)
        {
            rptQuestions.DataSource = DBHelper.Query("SELECT * FROM QuizQuestions WHERE QuizId=@Id", new SqlParameter("@Id", quizId));
            rptQuestions.DataBind();
        }

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            int lessonId = int.Parse(hdnQuizLessonId.Value);
            if (string.IsNullOrEmpty(hdnQuizId.Value))
            {
                object newId = DBHelper.Scalar(
                    "INSERT INTO Quizzes(Title,LessonId,TimeLimitMinutes,PassingScore) VALUES(@T,@L,@Ti,@P); SELECT SCOPE_IDENTITY();",
                    new SqlParameter("@T", txtQuizTitle.Text.Trim()),
                    new SqlParameter("@L", lessonId),
                    new SqlParameter("@Ti", int.Parse(txtQuizTime.Text.Trim())),
                    new SqlParameter("@P", int.Parse(txtPassingScore.Text.Trim())));
                hdnQuizId.Value = newId.ToString();
            }
            else
            {
                DBHelper.Execute("UPDATE Quizzes SET Title=@T,TimeLimitMinutes=@Ti,PassingScore=@P WHERE Id=@Id",
                    new SqlParameter("@T", txtQuizTitle.Text.Trim()),
                    new SqlParameter("@Ti", int.Parse(txtQuizTime.Text.Trim())),
                    new SqlParameter("@P", int.Parse(txtPassingScore.Text.Trim())),
                    new SqlParameter("@Id", hdnQuizId.Value));
            }
            lblQuizMsg.Text = "Quiz saved.";
            lblQuizMsg.Visible = true;
            LoadQuestions(int.Parse(hdnQuizId.Value));
        }

        protected void btnCloseQuiz_Click(object sender, EventArgs e) { pnlQuizSection.Visible = false; }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hdnQuizId.Value))
            { lblQuizMsg.Text = "Save the quiz settings first."; lblQuizMsg.Visible = true; return; }
            hdnQuestionId.Value = "";
            txtQuestion.Text = ""; txtOpt1.Text = ""; txtOpt2.Text = ""; txtOpt3.Text = ""; txtOpt4.Text = "";
            ddlCorrect.SelectedIndex = 0;
            pnlQuestionForm.Visible = true;
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            int quizId = int.Parse(hdnQuizId.Value);
            if (string.IsNullOrEmpty(hdnQuestionId.Value))
                DBHelper.Execute("INSERT INTO QuizQuestions(QuestionText,QuizId,Option1,Option2,Option3,Option4,CorrectOption) VALUES(@Q,@QId,@O1,@O2,@O3,@O4,@C)",
                    new SqlParameter("@Q", txtQuestion.Text.Trim()), new SqlParameter("@QId", quizId),
                    new SqlParameter("@O1", txtOpt1.Text.Trim()), new SqlParameter("@O2", txtOpt2.Text.Trim()),
                    new SqlParameter("@O3", txtOpt3.Text.Trim()), new SqlParameter("@O4", txtOpt4.Text.Trim()),
                    new SqlParameter("@C", int.Parse(ddlCorrect.SelectedValue)));
            else
                DBHelper.Execute("UPDATE QuizQuestions SET QuestionText=@Q,Option1=@O1,Option2=@O2,Option3=@O3,Option4=@O4,CorrectOption=@C WHERE Id=@Id",
                    new SqlParameter("@Q", txtQuestion.Text.Trim()), new SqlParameter("@O1", txtOpt1.Text.Trim()),
                    new SqlParameter("@O2", txtOpt2.Text.Trim()), new SqlParameter("@O3", txtOpt3.Text.Trim()),
                    new SqlParameter("@O4", txtOpt4.Text.Trim()), new SqlParameter("@C", int.Parse(ddlCorrect.SelectedValue)),
                    new SqlParameter("@Id", hdnQuestionId.Value));
            pnlQuestionForm.Visible = false;
            LoadQuestions(quizId);
        }

        protected void btnCancelQuestion_Click(object sender, EventArgs e) { pnlQuestionForm.Visible = false; }

        protected void rptQuestions_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int qId = int.Parse(e.CommandArgument.ToString());
            int quizId = int.Parse(hdnQuizId.Value);
            if (e.CommandName == "EditQ")
            {
                DataTable dt = DBHelper.Query("SELECT * FROM QuizQuestions WHERE Id=@Id", new SqlParameter("@Id", qId));
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hdnQuestionId.Value = qId.ToString();
                    txtQuestion.Text = row["QuestionText"].ToString();
                    txtOpt1.Text = row["Option1"].ToString(); txtOpt2.Text = row["Option2"].ToString();
                    txtOpt3.Text = row["Option3"].ToString(); txtOpt4.Text = row["Option4"].ToString();
                    ddlCorrect.SelectedValue = row["CorrectOption"].ToString();
                    pnlQuestionForm.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteQ")
            {
                DBHelper.Execute("DELETE FROM QuizQuestions WHERE Id=@Id", new SqlParameter("@Id", qId));
                LoadQuestions(quizId);
            }
        }
    }
}
