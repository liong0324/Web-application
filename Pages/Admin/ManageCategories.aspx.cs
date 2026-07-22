using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages.Admin
{
    public partial class ManageCategories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }
            if (!IsPostBack) LoadCategories();
        }

        private void LoadCategories()
        {
            DataTable dt = DBHelper.Query("SELECT * FROM Categories ORDER BY Name");
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (string.IsNullOrEmpty(hdnEditId.Value))
            {
                DBHelper.Execute("INSERT INTO Categories (Name, Description) VALUES (@Name, @Desc)",
                    new SqlParameter("@Name", txtName.Text.Trim()),
                    new SqlParameter("@Desc", txtDescription.Text.Trim()));
            }
            else
            {
                DBHelper.Execute("UPDATE Categories SET Name=@Name, Description=@Desc WHERE Id=@Id",
                    new SqlParameter("@Name", txtName.Text.Trim()),
                    new SqlParameter("@Desc", txtDescription.Text.Trim()),
                    new SqlParameter("@Id", hdnEditId.Value));
                hdnEditId.Value = "";
                formTitle.InnerText = "Add Category";
            }

            txtName.Text = "";
            txtDescription.Text = "";
            LoadCategories();
        }

        protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                hdnEditId.Value = parts[0];
                txtName.Text = parts[1];
                txtDescription.Text = parts.Length > 2 ? parts[2] : "";
                formTitle.InnerText = "Edit Category";
            }
            else if (e.CommandName == "Delete")
            {
                int id = int.Parse(e.CommandArgument.ToString());
                DBHelper.Execute("DELETE FROM Categories WHERE Id = @Id", new SqlParameter("@Id", id));
                LoadCategories();
            }
        }
    }
}
