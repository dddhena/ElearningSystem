using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ElearningApplication.View.Instructor
{
    public partial class ManageAssignments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlCourses.SelectedValue))
            {
                Response.Write("<script>alert('Please select a course.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Assignments (CourseId, Title, Description, DueDate, MaxScore) VALUES (@CourseId, @Title, @Description, @DueDate, @MaxScore)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", ddlCourses.SelectedValue);
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@DueDate", DateTime.Parse(txtDueDate.Text));
                    cmd.Parameters.AddWithValue("@MaxScore", int.Parse(txtMaxScore.Text));

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Clear form and refresh grid
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtDueDate.Text = "";
            txtMaxScore.Text = "100";
            gvAssignments.DataBind();
            
            Response.Write("<script>alert('Assignment created successfully!');</script>");
        }

        protected void gvAssignments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewSubmissions")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/View/Instructor/GradeAssignments.aspx?id={assignmentId}");
            }
        }
    }
}
