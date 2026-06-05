using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Instructor
{
    public partial class InstructorEngagementScores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserId"] == null)
                {
                    Response.Redirect("~/View/Account/Login.aspx");
                }
            }
        }

        protected void ddlCourses_SelectedIndexChanged(object sender, EventArgs e)
        {
            // GridView will automatically update due to AutoPostBack and ControlParameter
        }
    }
}
