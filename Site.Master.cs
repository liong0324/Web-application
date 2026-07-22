using System;
using System.Web;
using System.Web.Security;

namespace LumoraWebForms
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("~/Default.aspx");
        }
    }
}
