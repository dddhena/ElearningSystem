using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ElearningApplication.View.Instructor
{
    public partial class ManageAssessments : System.Web.UI.Page
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
                string query = @"INSERT INTO Assessments (CourseId, Title, Description, DurationMinutes, TotalMarks, PassingMarks, Status) 
                                 VALUES (@CourseId, @Title, @Description, @DurationMinutes, @TotalMarks, @PassingMarks, @Status)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", ddlCourses.SelectedValue);
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@DurationMinutes", int.Parse(txtDuration.Text));
                    cmd.Parameters.AddWithValue("@TotalMarks", int.Parse(txtTotalMarks.Text));
                    cmd.Parameters.AddWithValue("@PassingMarks", int.Parse(txtPassingMarks.Text));
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            txtTitle.Text = "";
            txtDescription.Text = "";
            txtDuration.Text = "60";
            txtTotalMarks.Text = "100";
            txtPassingMarks.Text = "50";
            gvAssessments.DataBind();
            
            Response.Write("<script>alert('Assessment created successfully!');</script>");
        }

        protected void gvAssessments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ManageQuestions")
            {
                int assessmentId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/View/Instructor/ManageAssessmentQuestions.aspx?id={assessmentId}");
            }
            else if (e.CommandName == "ViewResults")
            {
                int assessmentId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/View/Instructor/AssessmentResults.aspx?id={assessmentId}");
            }
        }
    }
}
