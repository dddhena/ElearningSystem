using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ElearningApplication.View.Assignment_and_assessment
{
    public partial class AssessmentsList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindAssessments();
            }
        }

        private void BindAssessments()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT a.AssessmentId, a.Title, a.DurationMinutes, a.TotalMarks, c.Title as CourseTitle,
                           ISNULL(sub.Status, 'Not Started') as Status, sub.Score
                    FROM Assessments a
                    INNER JOIN Courses c ON a.CourseId = c.CourseId
                    INNER JOIN Enrollments e ON c.CourseId = e.CourseId
                    LEFT JOIN AssessmentSubmissions sub ON a.AssessmentId = sub.AssessmentId AND sub.UserId = @UserId
                    WHERE e.UserId = @UserId AND e.Status = 'Active' AND a.Status = 'Published'
                    ORDER BY a.CreatedAt DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvAssessments.DataSource = dt;
                        gvAssessments.DataBind();
                    }
                }
            }
        }

        protected void gvAssessments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "TakeAssessment")
            {
                int assessmentId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/View/Assignment and assessment/TakeAssessment.aspx?id={assessmentId}");
            }
        }
    }
}
