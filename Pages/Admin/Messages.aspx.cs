using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Admin
{
    public partial class Messages : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }
            if (!IsPostBack) LoadMessages();
        }

        private void LoadMessages()
        {
            DataTable dt = DBHelper.Query("SELECT * FROM ContactMessages ORDER BY DateSent DESC");
            rptMessages.DataSource = dt;
            rptMessages.DataBind();
            pnlNoMessages.Visible = dt.Rows.Count == 0;
        }

        protected void rptMessages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            if (e.CommandName == "MarkRead")
            {
                DBHelper.Execute("UPDATE ContactMessages SET IsRead = 1 WHERE Id = @Id", new SqlParameter("@Id", id));
                LoadMessages();
            }
            else if (e.CommandName == "Delete")
            {
                DBHelper.Execute("DELETE FROM ContactMessages WHERE Id = @Id", new SqlParameter("@Id", id));
                LoadMessages();
            }
        }
    }
}
