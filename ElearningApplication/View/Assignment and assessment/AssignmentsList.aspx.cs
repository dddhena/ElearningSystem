using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ElearningApplication.View.Assignment_and_assessment
{
    public partial class AssignmentsList : System.Web.UI.Page
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
                BindAssignments();
            }
        }

        private void BindAssignments()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT a.AssignmentId, a.Title, a.DueDate, a.MaxScore, c.Title as CourseTitle,
                           ISNULL(sub.Status, 'Not Submitted') as Status, sub.Grade
                    FROM Assignments a
                    INNER JOIN Courses c ON a.CourseId = c.CourseId
                    INNER JOIN Enrollments e ON c.CourseId = e.CourseId
                    LEFT JOIN AssignmentSubmissions sub ON a.AssignmentId = sub.AssignmentId AND sub.UserId = @UserId
                    WHERE e.UserId = @UserId AND e.Status = 'Active'
                    ORDER BY a.DueDate ASC";
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

        protected void gvAssignments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int assignmentId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SubmitAssignment" || e.CommandName == "ViewSubmission")
            {
                Response.Redirect($"~/View/Assignment and assessment/SubmitAssignment.aspx?id={assignmentId}");
            }
        }
    }
}
