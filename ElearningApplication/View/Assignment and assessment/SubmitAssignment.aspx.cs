using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace ElearningApplication.View.Assignment_and_assessment
{
    public partial class SubmitAssignment : System.Web.UI.Page
    {
        int _assignmentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out _assignmentId))
            {
                Response.Redirect("~/View/Assignment and assessment/AssignmentsList.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignmentDetails();
                LoadSubmissionStatus();
            }
        }

        private void LoadAssignmentDetails()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Title, Description, DueDate, MaxScore FROM Assignments WHERE AssignmentId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", _assignmentId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTitle.Text = reader["Title"].ToString();
                            lblDescription.Text = reader["Description"].ToString();
                            lblDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("g");
                            lblMaxScore.Text = reader["MaxScore"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadSubmissionStatus()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            int? submissionId = null;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT SubmissionId, Status, Grade, Feedback FROM AssignmentSubmissions WHERE AssignmentId = @AssignmentId AND UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AssignmentId", _assignmentId);
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            submissionId = (int)reader["SubmissionId"];
                            lblStatus.Text = reader["Status"].ToString();
                            if (reader["Grade"] != DBNull.Value) lblGrade.Text = reader["Grade"].ToString();
                            if (reader["Feedback"] != DBNull.Value) lblFeedback.Text = reader["Feedback"].ToString();
                            
                            pnlSubmissionStatus.Visible = true;
                            pnlUpload.Visible = false; // Disable re-upload once submitted
                        }
                    }
                }

                if (submissionId.HasValue)
                {
                    string fileQuery = "SELECT FileName, FilePath FROM AssignmentSubmissionFiles WHERE SubmissionId = @SubmissionId";
                    using (SqlDataAdapter da = new SqlDataAdapter(fileQuery, conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@SubmissionId", submissionId.Value);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptFiles.DataSource = dt;
                        rptFiles.DataBind();
                    }
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFiles)
            {
                Response.Write("<script>alert('Please select at least one file.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();
                try
                {
                    // Create submission record
                    int submissionId = 0;
                    string submitQuery = @"INSERT INTO AssignmentSubmissions (AssignmentId, UserId, Status) 
                                           OUTPUT INSERTED.SubmissionId 
                                           VALUES (@AssignmentId, @UserId, 'Submitted')";
                    using (SqlCommand cmd = new SqlCommand(submitQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@AssignmentId", _assignmentId);
                        cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                        submissionId = (int)cmd.ExecuteScalar();
                    }

                    // Save files and insert records
                    string uploadFolder = Server.MapPath("~/Uploads/Assignments/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    foreach (var file in fileUpload.PostedFiles)
                    {
                        string fileName = Path.GetFileName(file.FileName);
                        string uniqueFileName = Guid.NewGuid().ToString() + "_" + fileName;
                        string savePath = Path.Combine(uploadFolder, uniqueFileName);
                        string dbPath = "~/Uploads/Assignments/" + uniqueFileName;

                        file.SaveAs(savePath);

                        string fileQuery = "INSERT INTO AssignmentSubmissionFiles (SubmissionId, FileName, FilePath) VALUES (@SubId, @Name, @Path)";
                        using (SqlCommand cmd = new SqlCommand(fileQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@SubId", submissionId);
                            cmd.Parameters.AddWithValue("@Name", fileName);
                            cmd.Parameters.AddWithValue("@Path", dbPath);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();
                    LoadSubmissionStatus();
                    Response.Write("<script>alert('Assignment submitted successfully!');</script>");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
        }
    }
}
