using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace ElearningApplication.View.ProgressTracking
{
    public partial class Certificate : System.Web.UI.Page
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
                string courseIdStr = Request.QueryString["courseId"];
                if (string.IsNullOrEmpty(courseIdStr) || !int.TryParse(courseIdStr, out int courseId))
                {
                    Response.Redirect("~/View/ProgressTracking/StudentProgress.aspx");
                    return;
                }

                LoadCertificateDetails(courseId);
            }
        }

        private void LoadCertificateDetails(int courseId)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    // Verify completion percentage and fetch required details
                    string query = @"
                        SELECT 
                            U.FirstName + ' ' + U.LastName as StudentName,
                            C.Title as CourseTitle,
                            I.FirstName + ' ' + I.LastName as InstructorName,
                            ISNULL(P.CompletionPercentage, 0) as CompletionPercentage,
                            ISNULL(P.CompletedAt, ISNULL(P.LastActivity, GETDATE())) as CompletionDate
                        FROM Users U
                        CROSS JOIN Courses C
                        LEFT JOIN Progress P ON U.UserId = P.UserId AND C.CourseId = P.CourseId
                        JOIN Users I ON C.InstructorId = I.UserId
                        WHERE U.UserId = @UserId AND C.CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int completionPercentage = Convert.ToInt32(reader["CompletionPercentage"]);
                                if (completionPercentage < 100)
                                {
                                    // Block access if course is not 100% completed
                                    string alertScript = "alert('Access Denied: You must complete 100% of the course to earn a certificate.'); window.location.href='StudentProgress.aspx';";
                                    ClientScript.RegisterStartupScript(this.GetType(), "AccessDenied", alertScript, true);
                                    return;
                                }

                                litStudentName.Text = reader["StudentName"].ToString();
                                litCourseTitle.Text = reader["CourseTitle"].ToString();
                                litInstructorName.Text = reader["InstructorName"].ToString();

                                DateTime completionDate = Convert.ToDateTime(reader["CompletionDate"]);
                                litCompletionDate.Text = completionDate.ToString("MMMM dd, yyyy");

                                // Generate secure deterministic verification code
                                string verificationSource = $"{userId}-{courseId}-ElearningSecuritySalt-2026";
                                using (MD5 md5 = MD5.Create())
                                {
                                    byte[] inputBytes = Encoding.ASCII.GetBytes(verificationSource);
                                    byte[] hashBytes = md5.ComputeHash(inputBytes);
                                    StringBuilder sb = new StringBuilder();
                                    for (int i = 0; i < hashBytes.Length; i++)
                                    {
                                        sb.Append(hashBytes[i].ToString("X2"));
                                    }
                                    string hashStr = sb.ToString();
                                    litVerificationCode.Text = $"CERT-{hashStr.Substring(0, 4)}-{hashStr.Substring(4, 4)}-{hashStr.Substring(8, 4)}";
                                }
                            }
                            else
                            {
                                Response.Redirect("~/View/ProgressTracking/StudentProgress.aspx");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    string alertScript = $"alert('Error loading certificate: {ex.Message.Replace("'", "\\'")}'); window.location.href='StudentProgress.aspx';";
                    ClientScript.RegisterStartupScript(this.GetType(), "LoadError", alertScript, true);
                }
            }
        }

        protected void btnBackProgress_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/ProgressTracking/StudentProgress.aspx");
        }
    }
}
