using System;
using System.Data.SqlClient;
using System.Web.UI;
using LumoraWebForms.App_Code;

namespace LumoraWebForms.Pages
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserId"] != null)
            {
                txtName.Text = Session["FullName"]?.ToString() ?? "";
                txtEmail.Text = Session["Email"]?.ToString() ?? "";
                txtName.ReadOnly = true;
                txtEmail.ReadOnly = true;
                txtName.CssClass = "form-control bg-transparent";
                txtEmail.CssClass = "form-control bg-transparent";
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            DBHelper.Execute(@"INSERT INTO ContactMessages (Name, Email, Subject, Message, DateSent, IsRead) 
                VALUES (@Name, @Email, @Subject, @Message, GETDATE(), 0)",
                new SqlParameter("@Name", txtName.Text.Trim()),
                new SqlParameter("@Email", txtEmail.Text.Trim()),
                new SqlParameter("@Subject", txtSubject.Text.Trim()),
                new SqlParameter("@Message", txtMessage.Text.Trim()));

            lblSuccess.Text = "Your message has been sent! We'll get back to you soon.";
            lblSuccess.Visible = true;

            // Only clear name/email for guests — logged-in users keep their pre-filled values
            if (Session["UserId"] == null)
            {
                txtName.Text = "";
                txtEmail.Text = "";
            }
            txtSubject.Text = "";
            txtMessage.Text = "";
        }
    }
}
