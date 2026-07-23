namespace LumoraWebForms.Pages.Admin
{
    public partial class ManageCourse : System.Web.UI.Page
    {
        // Course fields
        protected global::System.Web.UI.WebControls.Literal litBreadcrumb;
        protected global::System.Web.UI.WebControls.Label lblMsg;
        protected global::System.Web.UI.WebControls.TextBox txtTitle;
        protected global::System.Web.UI.WebControls.TextBox txtDescription;
        protected global::System.Web.UI.WebControls.TextBox txtPrice;
        protected global::System.Web.UI.WebControls.DropDownList ddlCategory;
        protected global::System.Web.UI.WebControls.DropDownList ddlLevel;
        protected global::System.Web.UI.WebControls.CheckBox chkPublished;
        protected global::System.Web.UI.WebControls.Button btnSaveCourse;
        // Lesson fields
        protected global::System.Web.UI.WebControls.Button btnAddLesson;
        protected global::System.Web.UI.WebControls.Panel pnlLessonForm;
        protected global::System.Web.UI.WebControls.Literal litLessonFormTitle;
        protected global::System.Web.UI.WebControls.HiddenField hdnLessonId;
        protected global::System.Web.UI.WebControls.TextBox txtLessonTitle;
        protected global::System.Web.UI.WebControls.TextBox txtLessonContent;
        protected global::System.Web.UI.WebControls.TextBox txtDuration;
        protected global::System.Web.UI.WebControls.Button btnSaveLesson;
        protected global::System.Web.UI.WebControls.Button btnCancelLesson;
        protected global::System.Web.UI.WebControls.Repeater rptLessons;
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
