using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Simple page load logic can go here. Data binding is handled by SqlDataSource.
            lblMessage.Text = ""; // Clear messages on postback
        }

        protected void GridView1_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            if (e.Exception != null)
            {
                lblMessage.Text = "An error occurred while updating the user: " + e.Exception.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                e.ExceptionHandled = true;
                e.KeepInEditMode = true;
            }
            else
            {
                lblMessage.Text = "User updated successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
        }

        protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            if (e.Exception != null)
            {
                lblMessage.Text = "An error occurred while deleting the user: " + e.Exception.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                e.ExceptionHandled = true;
            }
            else
            {
                lblMessage.Text = "User deleted successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
        }
    }
}