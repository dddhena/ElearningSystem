using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ElearningApplication.View.Instructor
{
    public partial class AssessmentResults : System.Web.UI.Page
    {
        int _assessmentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out _assessmentId))
            {
                Response.Redirect("~/View/Instructor/ManageAssessments.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssessmentDetails();
                BindResults();
            }
        }

        private void LoadAssessmentDetails()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Title FROM Assessments WHERE AssessmentId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", _assessmentId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        lblAssessmentTitle.Text = result.ToString();
                    }
                }
            }
        }

        private void BindResults()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT sub.StartTime, sub.EndTime, sub.Status, sub.Score, 
                           u.FirstName + ' ' + u.LastName AS StudentName 
                    FROM AssessmentSubmissions sub
                    INNER JOIN Users u ON sub.UserId = u.UserId
                    WHERE sub.AssessmentId = @AssessmentId
                    ORDER BY sub.EndTime DESC";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    da.SelectCommand.Parameters.AddWithValue("@AssessmentId", _assessmentId);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvResults.DataSource = dt;
                    gvResults.DataBind();
                }
            }
        }
    }
}
