using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Dashboard
{
    public partial class StudentDashboard : System.Web.UI.Page
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
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    // 1. User Profile
                    string userQuery = "SELECT FirstName, LastName FROM Users WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string fullName = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                                userprofileplaceholder.Controls.Add(new Literal { Text = $"<span style='font-weight:bold; color:#333;'>{fullName}</span>" });
                            }
                        }
                    }

                    // 2. Stats
                    // Enrolled Count
                    string enrolledQuery = "SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(enrolledQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        int enrolledCount = (int)cmd.ExecuteScalar();
                        noofenrolledplaceholder.Controls.Add(new Literal { Text = $"<span style='font-size:20px; font-weight:bold; color:#000;'>{enrolledCount}</span>" });
                    }

                    // Completed Count
                    string completedQuery = "SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId AND Status = 'Completed'";
                    using (SqlCommand cmd = new SqlCommand(completedQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        int completedCount = (int)cmd.ExecuteScalar();
                        numberofcompleted.Controls.Add(new Literal { Text = $"<span style='font-size:20px; font-weight:bold; color:#000;'>{completedCount}</span>" });
                    }

                    // Average Progress (instead of Average Rating if no feedbacks exist yet)
                    string progressQuery = "SELECT AVG(CAST(CompletionPercentage AS FLOAT)) FROM Progress WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(progressQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        object result = cmd.ExecuteScalar();
                        double avgProgress = (result != DBNull.Value) ? Convert.ToDouble(result) : 0.0;
                        averagerating.Controls.Add(new Literal { Text = $"<span style='font-size:20px; font-weight:bold; color:#000;'>{avgProgress:F0}%</span>" });
                        
                        // Set rating based on progress (just for visual representation)
                        Rating2.CurrentRating = (int)Math.Min(5, Math.Round(avgProgress / 20.0));
                    }

                    // 3. Notifications (Dummy data for now)
                    lstNotifications.Items.Clear();
                    lstNotifications.Items.Add("Welcome to the new semester!");
                    lstNotifications.Items.Add("Your assignment 'Database Design' is due in 2 days.");
                    lstNotifications.Items.Add("New announcement from Prof. Smith: 'Midterm schedule updated'.");

                    // 4. All Enrolled Courses
                    string coursesQuery = @"
                        SELECT C.CourseId, C.Title, C.Category, U.FirstName + ' ' + U.LastName as Instructor, 
                               ISNULL(P.CompletionPercentage, 0) as Progress
                        FROM Enrollments E
                        JOIN Courses C ON E.CourseId = C.CourseId
                        JOIN Users U ON C.InstructorId = U.UserId
                        LEFT JOIN Progress P ON E.UserId = P.UserId AND E.CourseId = P.CourseId
                        WHERE E.UserId = @UserId
                        ORDER BY E.EnrolledAt DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(coursesQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            rptEnrolledCourses.DataSource = reader;
                            rptEnrolledCourses.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log error or show message
                    Label1.Text = "Error loading dashboard: " + ex.Message;
                }
            }
        }

        public void btnEnrollMore_Click(object sender, EventArgs e)

        {
            Response.Redirect("~/View/Enrollment/Enrollment.aspx");
        }

        public void btnContinue_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string courseId = btn.CommandArgument;
            // Redirect to the new enrollment details page
            Response.Redirect("~/View/Enrollment/EnrollmentDetails.aspx?courseId=" + courseId);
        }

        protected void btnLiveChat_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Chat/LiveChat.aspx");
        }

        protected void btnAskQuestion_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/QnA/AskQuestion.aspx");
        }

        protected void btnFeedback_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Feedback/SubmitFeedback.aspx");
        }

        protected void btnProgress_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Feedback/MyProgress.aspx");
        }

        protected void btnHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/View/Account/Login.aspx");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            // This is a legacy button from previous version, can be removed or redirected
            Response.Redirect("~/View/Enrollment/Enrollment.aspx");
        }

        public string GetProgressStyle(object progress)
        {
            return $"height: 100%; width: {progress}%; background: #6366f1; transition: width 0.5s ease-out;";
        }
    }
}
