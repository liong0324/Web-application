using System;
using System.Web;

namespace LumoraWebForms.Pages
{
    public partial class QuizResultPage : System.Web.UI.Page
    {
        public int score, correctAnswers, totalQuestions;
        public bool passed;

        protected void Page_Load(object sender, EventArgs e)
        {
            int.TryParse(Request.QueryString["score"], out score);
            int.TryParse(Request.QueryString["correct"], out correctAnswers);
            int.TryParse(Request.QueryString["total"], out totalQuestions);
            passed = Request.QueryString["passed"] == "True";
        }
    }
}
