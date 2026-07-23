using System;
using System.Data;
using System.Data.SqlClient;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Admin
{
    public partial class ManageCourse : System.Web.UI.Page
    {
        private int courseId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx"); return;
            }
            if (!int.TryParse(Request.QueryString["id"], out courseId))
            {
                Response.Redirect("ManageCourses.aspx"); return;
            }
            if (!IsPostBack)
            {
                LoadCourseForm();
                LoadLessons();
            }
        }

        private void LoadCourseForm()
        {
            DataTable dt = DBHelper.Query("SELECT * FROM Courses WHERE Id = @Id",
                new SqlParameter("@Id", courseId));
            if (dt.Rows.Count == 0) { Response.Redirect("ManageCourses.aspx"); return; }

            DataRow row = dt.Rows[0];
            litBreadcrumb.Text = row["Title"].ToString();
            txtTitle.Text = row["Title"].ToString();
            txtDescription.Text = row["Description"]?.ToString() ?? "";
            txtPrice.Text = row["Price"].ToString();
            chkPublished.Checked = Convert.ToBoolean(row["IsPublished"]);
            ddlLevel.SelectedValue = row["Level"]?.ToString() ?? "Beginner";

            DataTable cats = DBHelper.Query("SELECT Id, Name FROM Categories ORDER BY Name");
            ddlCategory.DataSource = cats;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "Id";
            ddlCategory.DataBind();
            ddlCategory.SelectedValue = row["CategoryId"].ToString();
        }

        private void LoadLessons()
        {
            DataTable dt = DBHelper.Query(
                "SELECT Id, Title, [Order], DurationMinutes FROM Lessons WHERE CourseId = @Id ORDER BY [Order]",
                new SqlParameter("@Id", courseId));
            rptLessons.DataSource = dt;
            rptLessons.DataBind();
        }

        private void LoadQuizSection(int lessonId)
        {
            hdnQuizLessonId.Value = lessonId.ToString();
            string lessonTitle = DBHelper.Scalar("SELECT Title FROM Lessons WHERE Id = @Id",
                new SqlParameter("@Id", lessonId))?.ToString() ?? "";
            litQuizLessonName.Text = lessonTitle;

            // Load existing quiz for this lesson
            DataTable quiz = DBHelper.Query("SELECT * FROM Quizzes WHERE LessonId = @Id",
                new SqlParameter("@Id", lessonId));
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
            pnlQuizSection.Visible = true;
        }

        private void LoadQuestions(int quizId)
        {
            DataTable dt = DBHelper.Query("SELECT * FROM QuizQuestions WHERE QuizId = @Id",
                new SqlParameter("@Id", quizId));
            rptQuestions.DataSource = dt;
            rptQuestions.DataBind();
        }

        // ---- Course ----
        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            DBHelper.Execute(@"UPDATE Courses SET Title=@Title, Description=@Desc, CategoryId=@CatId,
                               Price=@Price, Level=@Level, IsPublished=@Pub WHERE Id=@Id",
                new SqlParameter("@Title", txtTitle.Text.Trim()),
                new SqlParameter("@Desc", txtDescription.Text.Trim()),
                new SqlParameter("@CatId", ddlCategory.SelectedValue),
                new SqlParameter("@Price", decimal.Parse(txtPrice.Text.Trim())),
                new SqlParameter("@Level", ddlLevel.SelectedValue),
                new SqlParameter("@Pub", chkPublished.Checked ? 1 : 0),
                new SqlParameter("@Id", courseId));
            litBreadcrumb.Text = txtTitle.Text.Trim();
            lblMsg.Text = "Course updated successfully.";
            lblMsg.Visible = true;
        }

        // ---- Lessons ----
        protected void btnAddLesson_Click(object sender, EventArgs e)
        {
            hdnLessonId.Value = "";
            txtLessonTitle.Text = "";
            txtLessonContent.Text = "";
            txtDuration.Text = "30";
            litLessonFormTitle.Text = "Add Lesson";
            pnlLessonForm.Visible = true;
            pnlQuizSection.Visible = false;
        }

        protected void btnSaveLesson_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (string.IsNullOrEmpty(hdnLessonId.Value))
            {
                object maxOrder = DBHelper.Scalar("SELECT ISNULL(MAX([Order]),0) FROM Lessons WHERE CourseId=@Id",
                    new SqlParameter("@Id", courseId));
                DBHelper.Execute(@"INSERT INTO Lessons(Title,Content,CourseId,[Order],DurationMinutes)
                                   VALUES(@Title,@Content,@CourseId,@Order,@Duration)",
                    new SqlParameter("@Title", txtLessonTitle.Text.Trim()),
                    new SqlParameter("@Content", txtLessonContent.Text.Trim()),
                    new SqlParameter("@CourseId", courseId),
                    new SqlParameter("@Order", Convert.ToInt32(maxOrder) + 1),
                    new SqlParameter("@Duration", int.Parse(txtDuration.Text.Trim())));
            }
            else
            {
                DBHelper.Execute(@"UPDATE Lessons SET Title=@Title,Content=@Content,DurationMinutes=@Duration WHERE Id=@Id",
                    new SqlParameter("@Title", txtLessonTitle.Text.Trim()),
                    new SqlParameter("@Content", txtLessonContent.Text.Trim()),
                    new SqlParameter("@Duration", int.Parse(txtDuration.Text.Trim())),
                    new SqlParameter("@Id", hdnLessonId.Value));
            }
            pnlLessonForm.Visible = false;
            LoadLessons();
        }

        protected void btnCancelLesson_Click(object sender, EventArgs e) { pnlLessonForm.Visible = false; }

        protected void rptLessons_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            if (e.CommandName == "EditLesson")
            {
                DataTable dt = DBHelper.Query("SELECT * FROM Lessons WHERE Id=@Id", new SqlParameter("@Id", id));
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hdnLessonId.Value = id.ToString();
                    txtLessonTitle.Text = row["Title"].ToString();
                    txtLessonContent.Text = row["Content"]?.ToString() ?? "";
                    txtDuration.Text = row["DurationMinutes"].ToString();
                    litLessonFormTitle.Text = "Edit Lesson";
                    pnlLessonForm.Visible = true;
                    pnlQuizSection.Visible = false;
                }
            }
            else if (e.CommandName == "ManageQuiz")
            {
                pnlLessonForm.Visible = false;
                LoadQuizSection(id);
            }
            else if (e.CommandName == "DeleteLesson")
            {
                DBHelper.Execute("DELETE FROM QuizQuestions WHERE QuizId IN (SELECT Id FROM Quizzes WHERE LessonId=@Id)", new SqlParameter("@Id", id));
                DBHelper.Execute("DELETE FROM Quizzes WHERE LessonId=@Id", new SqlParameter("@Id", id));
                DBHelper.Execute("DELETE FROM Lessons WHERE Id=@Id", new SqlParameter("@Id", id));
                DBHelper.Execute(@"WITH Ordered AS(SELECT Id,ROW_NUMBER() OVER(ORDER BY [Order]) AS N FROM Lessons WHERE CourseId=@CId)
                                   UPDATE Lessons SET [Order]=Ordered.N FROM Lessons INNER JOIN Ordered ON Lessons.Id=Ordered.Id",
                    new SqlParameter("@CId", courseId));
                pnlQuizSection.Visible = false;
                LoadLessons();
            }
        }

        // ---- Quiz ----
        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            int lessonId = int.Parse(hdnQuizLessonId.Value);
            if (string.IsNullOrEmpty(hdnQuizId.Value))
            {
                object newId = DBHelper.Scalar(@"INSERT INTO Quizzes(Title,LessonId,TimeLimitMinutes,PassingScore)
                               VALUES(@Title,@LId,@Time,@Pass); SELECT SCOPE_IDENTITY();",
                    new SqlParameter("@Title", txtQuizTitle.Text.Trim()),
                    new SqlParameter("@LId", lessonId),
                    new SqlParameter("@Time", int.Parse(txtQuizTime.Text.Trim())),
                    new SqlParameter("@Pass", int.Parse(txtPassingScore.Text.Trim())));
                hdnQuizId.Value = newId.ToString();
            }
            else
            {
                DBHelper.Execute("UPDATE Quizzes SET Title=@Title,TimeLimitMinutes=@Time,PassingScore=@Pass WHERE Id=@Id",
                    new SqlParameter("@Title", txtQuizTitle.Text.Trim()),
                    new SqlParameter("@Time", int.Parse(txtQuizTime.Text.Trim())),
                    new SqlParameter("@Pass", int.Parse(txtPassingScore.Text.Trim())),
                    new SqlParameter("@Id", hdnQuizId.Value));
            }
            lblQuizMsg.Text = "Quiz saved.";
            lblQuizMsg.Visible = true;
            LoadQuestions(int.Parse(hdnQuizId.Value));
        }

        protected void btnCloseQuiz_Click(object sender, EventArgs e) { pnlQuizSection.Visible = false; }

        // ---- Questions ----
        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hdnQuizId.Value))
            {
                lblQuizMsg.Text = "Save the quiz settings first before adding questions.";
                lblQuizMsg.Visible = true;
                return;
            }
            hdnQuestionId.Value = "";
            txtQuestion.Text = "";
            txtOpt1.Text = ""; txtOpt2.Text = ""; txtOpt3.Text = ""; txtOpt4.Text = "";
            ddlCorrect.SelectedIndex = 0;
            pnlQuestionForm.Visible = true;
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            int quizId = int.Parse(hdnQuizId.Value);
            if (string.IsNullOrEmpty(hdnQuestionId.Value))
            {
                DBHelper.Execute(@"INSERT INTO QuizQuestions(QuestionText,QuizId,Option1,Option2,Option3,Option4,CorrectOption)
                                   VALUES(@Q,@QId,@O1,@O2,@O3,@O4,@Cor)",
                    new SqlParameter("@Q", txtQuestion.Text.Trim()),
                    new SqlParameter("@QId", quizId),
                    new SqlParameter("@O1", txtOpt1.Text.Trim()),
                    new SqlParameter("@O2", txtOpt2.Text.Trim()),
                    new SqlParameter("@O3", txtOpt3.Text.Trim()),
                    new SqlParameter("@O4", txtOpt4.Text.Trim()),
                    new SqlParameter("@Cor", int.Parse(ddlCorrect.SelectedValue)));
            }
            else
            {
                DBHelper.Execute(@"UPDATE QuizQuestions SET QuestionText=@Q,Option1=@O1,Option2=@O2,Option3=@O3,Option4=@O4,CorrectOption=@Cor WHERE Id=@Id",
                    new SqlParameter("@Q", txtQuestion.Text.Trim()),
                    new SqlParameter("@O1", txtOpt1.Text.Trim()),
                    new SqlParameter("@O2", txtOpt2.Text.Trim()),
                    new SqlParameter("@O3", txtOpt3.Text.Trim()),
                    new SqlParameter("@O4", txtOpt4.Text.Trim()),
                    new SqlParameter("@Cor", int.Parse(ddlCorrect.SelectedValue)),
                    new SqlParameter("@Id", hdnQuestionId.Value));
            }
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
                    txtOpt1.Text = row["Option1"].ToString();
                    txtOpt2.Text = row["Option2"].ToString();
                    txtOpt3.Text = row["Option3"].ToString();
                    txtOpt4.Text = row["Option4"].ToString();
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
