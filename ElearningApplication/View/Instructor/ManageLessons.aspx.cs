using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Instructor
{
    public partial class ManageLessons : System.Web.UI.Page
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
            if (string.IsNullOrEmpty(ddlModules.SelectedValue))
            {
                Response.Write("<script>alert('Please select a module first.');</script>");
                return;
            }

            try
            {
                sqlLessons.InsertParameters["Title"].DefaultValue = txtTitle.Text;
                sqlLessons.InsertParameters["Content"].DefaultValue = txtContent.Text;
                sqlLessons.InsertParameters["VideoUrl"].DefaultValue = txtVideoUrl.Text;
                sqlLessons.InsertParameters["Duration"].DefaultValue = txtDuration.Text;
                sqlLessons.InsertParameters["OrderNumber"].DefaultValue = txtOrder.Text;

                sqlLessons.Insert();

                // Clear fields
                txtTitle.Text = "";
                txtContent.Text = "";
                txtVideoUrl.Text = "";
                txtDuration.Text = "0";
                txtOrder.Text = (int.Parse(txtOrder.Text) + 1).ToString();

                Response.Write("<script>alert('Lesson added successfully!');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }

        protected void gvLessons_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}