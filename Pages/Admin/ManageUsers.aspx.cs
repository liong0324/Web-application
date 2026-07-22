using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }
            if (!IsPostBack) LoadUsers();
        }

        private void LoadUsers()
        {
            DataTable dt = DBHelper.Query("SELECT * FROM Users ORDER BY DateJoined DESC");
            rptUsers.DataSource = dt;
            rptUsers.DataBind();
            litCount.Text = dt.Rows.Count.ToString();
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            if (e.CommandName == "Toggle")
            {
                DBHelper.Execute("UPDATE Users SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE Id = @Id", new SqlParameter("@Id", id));
                LoadUsers();
            }
            else if (e.CommandName == "Delete")
            {
                DBHelper.Execute("DELETE FROM Users WHERE Id = @Id", new SqlParameter("@Id", id));
                LoadUsers();
            }
        }
    }
}
