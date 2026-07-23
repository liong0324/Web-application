using System;
using System.Data;
using System.Data.SqlClient;
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

            if (e.CommandName == "View")
            {
                DataTable dt = DBHelper.Query("SELECT * FROM ContactMessages WHERE Id = @Id",
                    new SqlParameter("@Id", id));
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    litDetailSubject.Text = System.Web.HttpUtility.HtmlEncode(row["Subject"]?.ToString() ?? "(No subject)");
                    litDetailName.Text = System.Web.HttpUtility.HtmlEncode(row["Name"].ToString());
                    litDetailEmail.Text = System.Web.HttpUtility.HtmlEncode(row["Email"].ToString());
                    litDetailDate.Text = Convert.ToDateTime(row["DateSent"]).ToString("dd MMM yyyy HH:mm");
                    litDetailMessage.Text = System.Web.HttpUtility.HtmlEncode(row["Message"].ToString());
                    pnlDetail.Visible = true;

                    // Auto mark as read when viewed
                    DBHelper.Execute("UPDATE ContactMessages SET IsRead = 1 WHERE Id = @Id",
                        new SqlParameter("@Id", id));
                    LoadMessages();
                }
            }
            else if (e.CommandName == "Delete")
            {
                DBHelper.Execute("DELETE FROM ContactMessages WHERE Id = @Id",
                    new SqlParameter("@Id", id));
                pnlDetail.Visible = false;
                LoadMessages();
            }
        }

        protected void btnCloseDetail_Click(object sender, EventArgs e)
        {
            pnlDetail.Visible = false;
        }
    }
}
