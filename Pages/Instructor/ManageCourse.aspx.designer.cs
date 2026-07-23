namespace LumoraWebForms.Pages.Instructor
{
    public partial class InstructorManageCourse : System.Web.UI.Page
    {
        protected global::System.Web.UI.WebControls.Literal litBreadcrumb;
        protected global::System.Web.UI.WebControls.Label lblMsg;
        protected global::System.Web.UI.WebControls.Repeater rptLessons;
        // Lesson edit panel
        protected global::System.Web.UI.WebControls.Panel pnlLessonEdit;
        protected global::System.Web.UI.WebControls.HiddenField hdnLessonId;
        protected global::System.Web.UI.WebControls.Literal litEditLessonName;
        protected global::System.Web.UI.WebControls.Label lblLessonMsg;
        protected global::System.Web.UI.WebControls.TextBox txtLessonTitle;
        protected global::System.Web.UI.WebControls.TextBox txtDuration;
        protected global::System.Web.UI.WebControls.TextBox txtLessonContent;
        protected global::System.Web.UI.WebControls.Button btnSaveLesson;
        protected global::System.Web.UI.WebControls.Button btnCloseLessonEdit;
        // Quiz section
        protected global::System.Web.UI.WebControls.Panel pnlQuizSection;
        protected global::System.Web.UI.WebControls.HiddenField hdnQuizLessonId;
        protected global::System.Web.UI.WebControls.HiddenField hdnQuizId;
        protected global::System.Web.UI.WebControls.Literal litQuizLessonName;
        protected global::System.Web.UI.WebControls.Label lblQuizMsg;
        protected global::System.Web.UI.WebControls.TextBox txtQuizTitle;
        protected global::System.Web.UI.WebControls.TextBox txtQuizTime;
        protected global::System.Web.UI.WebControls.TextBox txtPassingScore;
        protected global::System.Web.UI.WebControls.Button btnSaveQuiz;
        protected global::System.Web.UI.WebControls.Button btnCloseQuiz;
        protected global::System.Web.UI.WebControls.Button btnAddQuestion;
        protected global::System.Web.UI.WebControls.Panel pnlQuestionForm;
        protected global::System.Web.UI.WebControls.HiddenField hdnQuestionId;
        protected global::System.Web.UI.WebControls.TextBox txtQuestion;
        protected global::System.Web.UI.WebControls.TextBox txtOpt1;
        protected global::System.Web.UI.WebControls.TextBox txtOpt2;
        protected global::System.Web.UI.WebControls.TextBox txtOpt3;
        protected global::System.Web.UI.WebControls.TextBox txtOpt4;
        protected global::System.Web.UI.WebControls.DropDownList ddlCorrect;
        protected global::System.Web.UI.WebControls.Button btnSaveQuestion;
        protected global::System.Web.UI.WebControls.Button btnCancelQuestion;
        protected global::System.Web.UI.WebControls.Repeater rptQuestions;
    }
}
