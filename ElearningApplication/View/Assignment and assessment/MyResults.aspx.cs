using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ElearningApplication.View.Assignment_and_assessment
{
    public partial class MyResults : System.Web.UI.Page
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
                BindAssignmentGrades();
                BindAssessmentScores();
            }
        }

        private void BindAssignmentGrades()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT c.Title as CourseTitle, a.Title, a.MaxScore, sub.Grade, sub.Feedback
                    FROM AssignmentSubmissions sub
                    INNER JOIN Assignments a ON sub.AssignmentId = a.AssignmentId
                    INNER JOIN Courses c ON a.CourseId = c.CourseId
                    WHERE sub.UserId = @UserId AND sub.Status = 'Graded'
                    ORDER BY sub.SubmissionDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvAssignments.DataSource = dt;
                        gvAssignments.DataBind();
                    }
                }
            }
        }

        private void BindAssessmentScores()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT c.Title as CourseTitle, a.Title, a.TotalMarks, sub.Score, sub.EndTime
                    FROM AssessmentSubmissions sub
                    INNER JOIN Assessments a ON sub.AssessmentId = a.AssessmentId
                    INNER JOIN Courses c ON a.CourseId = c.CourseId
                    WHERE sub.UserId = @UserId AND (sub.Status = 'Submitted' OR sub.Status = 'Graded')
                    ORDER BY sub.EndTime DESC";
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
    }
}
