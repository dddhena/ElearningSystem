using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace ElearningApplication.View.Instructor
{
    public partial class GradeAssignments : System.Web.UI.Page
    {
        int _assignmentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out _assignmentId))
            {
                Response.Redirect("~/View/Instructor/ManageAssignments.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignmentDetails();
                BindSubmissions();
            }
        }

        private void LoadAssignmentDetails()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Title, MaxScore FROM Assignments WHERE AssignmentId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", _assignmentId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblAssignmentTitle.Text = reader["Title"].ToString();
                            lblMaxScore.Text = reader["MaxScore"].ToString();
                        }
                    }
                }
            }
        }

        private void BindSubmissions()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT sub.SubmissionId, sub.SubmissionDate, sub.Status, sub.Grade, 
                           u.FirstName + ' ' + u.LastName AS StudentName 
                    FROM AssignmentSubmissions sub
                    INNER JOIN Users u ON sub.UserId = u.UserId
                    WHERE sub.AssignmentId = @AssignmentId
                    ORDER BY sub.SubmissionDate DESC";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    da.SelectCommand.Parameters.AddWithValue("@AssignmentId", _assignmentId);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvSubmissions.DataSource = dt;
                    gvSubmissions.DataBind();
                }
            }
        }

        public DataTable GetSubmissionFiles(int submissionId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT FileName, FilePath FROM AssignmentSubmissionFiles WHERE SubmissionId = @SubmissionId";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    da.SelectCommand.Parameters.AddWithValue("@SubmissionId", submissionId);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        protected void gvSubmissions_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Grade")
            {
                int submissionId = Convert.ToInt32(e.CommandArgument);
                lblCurrentSubmissionId.Text = submissionId.ToString();
                
                // Fetch existing grade/feedback
                string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT Grade, Feedback FROM AssignmentSubmissions WHERE SubmissionId = @Id";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", submissionId);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtGrade.Text = reader["Grade"] != DBNull.Value ? reader["Grade"].ToString() : "";
                                txtFeedback.Text = reader["Feedback"].ToString();
                            }
                        }
                    }
                }
                pnlGrade.Visible = true;
            }
        }

        protected void btnSaveGrade_Click(object sender, EventArgs e)
        {
            int submissionId = int.Parse(lblCurrentSubmissionId.Text);
            int? grade = string.IsNullOrEmpty(txtGrade.Text) ? (int?)null : int.Parse(txtGrade.Text);
            string feedback = txtFeedback.Text;

            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE AssignmentSubmissions SET Grade = @Grade, Feedback = @Feedback, Status = 'Graded' WHERE SubmissionId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Grade", (object)grade ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Feedback", feedback);
                    cmd.Parameters.AddWithValue("@Id", submissionId);
                    
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            pnlGrade.Visible = false;
            BindSubmissions();
            Response.Write("<script>alert('Grade saved successfully!');</script>");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlGrade.Visible = false;
        }
    }
}
