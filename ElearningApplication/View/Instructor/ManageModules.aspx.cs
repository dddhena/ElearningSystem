using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Instructor
{
    public partial class ManageModules : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["courseId"] != null)
                {
                    ddlCourses.SelectedValue = Request.QueryString["courseId"];
                }
            }
            Page.DataBind();
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlCourses.SelectedValue))
            {
                Response.Write("<script>alert('Please select a course first.');</script>");
                return;
            }

            try
            {
                sqlModules.InsertParameters["Title"].DefaultValue = txtTitle.Text;
                sqlModules.InsertParameters["Description"].DefaultValue = txtDescription.Text;
                sqlModules.InsertParameters["OrderNumber"].DefaultValue = txtOrder.Text;
                sqlModules.InsertParameters["IsLocked"].DefaultValue = chkIsLocked.Checked.ToString();

                sqlModules.Insert();

                // Clear fields
                txtTitle.Text = "";
                txtDescription.Text = "";
                txtOrder.Text = (int.Parse(txtOrder.Text) + 1).ToString();
                chkIsLocked.Checked = false;

                Response.Write("<script>alert('Module added successfully!');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }
    }
}