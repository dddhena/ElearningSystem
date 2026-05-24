using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.ProgressTracking
{
    public partial class StudentProgress : System.Web.UI.Page
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
                LoadStudentProgress();
            }
        }

        private void LoadStudentProgress()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    // 1. Calculate and Load General KPI metrics
                    // Enrolled Count
                    string enrolledQuery = "SELECT COUNT(*) FROM Enrollments WHERE UserId = @UserId";
                    int enrolledCount = 0;
                    using (SqlCommand cmd = new SqlCommand(enrolledQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        enrolledCount = (int)cmd.ExecuteScalar();
                        litEnrolledCount.Text = enrolledCount.ToString();
                    }

                    if (enrolledCount == 0)
                    {
                        pnlNoCourses.Visible = true;
                        rptStudentProgress.Visible = false;
                        return;
                    }

                    // Completed Count
                    string completedQuery = "SELECT COUNT(*) FROM Progress WHERE UserId = @UserId AND CompletionPercentage = 100";
                    using (SqlCommand cmd = new SqlCommand(completedQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        litCompletedCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Avg. Completion
                    string avgCompQuery = "SELECT AVG(CompletionPercentage) FROM Progress WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(avgCompQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        object result = cmd.ExecuteScalar();
                        litAvgCompletion.Text = (result != DBNull.Value) ? result.ToString() + "%" : "0%";
                    }

                    // Average Assessment Score
                    string avgScoreQuery = @"
                        SELECT AVG(CAST(ASUB.Score AS FLOAT) / CAST(A.TotalMarks AS FLOAT) * 100) 
                        FROM AssessmentSubmissions ASUB 
                        JOIN Assessments A ON ASUB.AssessmentId = A.AssessmentId 
                        WHERE ASUB.UserId = @UserId AND A.TotalMarks > 0";
                    using (SqlCommand cmd = new SqlCommand(avgScoreQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        object result = cmd.ExecuteScalar();
                        litAvgScore.Text = (result != DBNull.Value) ? $"{Convert.ToDouble(result):F0}%" : "N/A";
                    }

                    // 2. Fetch Detailed Student Progress List
                    string query = @"
                        SELECT C.CourseId, C.Title, C.Category, U.FirstName + ' ' + U.LastName as Instructor,
                               ISNULL(P.CompletionPercentage, 0) as CompletionPercentage,
                               ISNULL(P.ModulesCompleted, 0) as ModulesCompleted,
                               ISNULL(P.TotalModules, 0) as TotalModules,
                               ISNULL(P.LastActivity, GETDATE()) as LastActivity,
                               ISNULL(P.Status, 'NotStarted') as Status,
                               ISNULL(ES.Score, 0) as EngagementScore
                        FROM Enrollments E
                        JOIN Courses C ON E.CourseId = C.CourseId
                        JOIN Users U ON C.InstructorId = U.UserId
                        LEFT JOIN Progress P ON E.UserId = P.UserId AND E.CourseId = P.CourseId
                        LEFT JOIN EngagementScores ES ON E.UserId = ES.UserId AND E.CourseId = ES.CourseId
                        WHERE E.UserId = @UserId
                        ORDER BY E.EnrolledAt DESC";

                    DataTable progressTable = new DataTable();
                    progressTable.Columns.Add("CourseId", typeof(int));
                    progressTable.Columns.Add("Title", typeof(string));
                    progressTable.Columns.Add("Category", typeof(string));
                    progressTable.Columns.Add("Instructor", typeof(string));
                    progressTable.Columns.Add("CompletionPercentage", typeof(int));
                    progressTable.Columns.Add("ModulesCompleted", typeof(int));
                    progressTable.Columns.Add("TotalModules", typeof(int));
                    progressTable.Columns.Add("LastActivity", typeof(DateTime));
                    progressTable.Columns.Add("LessonsCompletedCount", typeof(int));
                    progressTable.Columns.Add("TotalSessions", typeof(int));
                    progressTable.Columns.Add("AttendedSessions", typeof(int));
                    progressTable.Columns.Add("AttendanceRate", typeof(int));
                    progressTable.Columns.Add("QuizzesSubmitted", typeof(int));
                    progressTable.Columns.Add("AvgQuizScore", typeof(int));
                    progressTable.Columns.Add("AssignmentsGraded", typeof(int));
                    progressTable.Columns.Add("AvgAssignmentGrade", typeof(int));
                    progressTable.Columns.Add("EngagementScore", typeof(int));

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                int courseId = Convert.ToInt32(reader["CourseId"]);
                                DataRow dr = progressTable.NewRow();
                                dr["CourseId"] = courseId;
                                dr["Title"] = reader["Title"];
                                dr["Category"] = reader["Category"];
                                dr["Instructor"] = reader["Instructor"];
                                dr["CompletionPercentage"] = reader["CompletionPercentage"];
                                dr["ModulesCompleted"] = reader["ModulesCompleted"];
                                dr["TotalModules"] = reader["TotalModules"];
                                dr["LastActivity"] = reader["LastActivity"];
                                dr["EngagementScore"] = reader["EngagementScore"];
                                progressTable.Rows.Add(dr);
                            }
                        }
                    }

                    // Populate detailed fields per course
                    foreach (DataRow row in progressTable.Rows)
                    {
                        int courseId = Convert.ToInt32(row["CourseId"]);

                        // 2a. Lessons Completed Count
                        string lessonCountQuery = @"
                            SELECT COUNT(*) 
                            FROM LessonProgress LP 
                            JOIN Lessons L ON LP.LessonId = L.LessonId 
                            JOIN Modules M ON L.ModuleId = M.ModuleId 
                            WHERE LP.UserId = @UserId AND M.CourseId = @CourseId AND LP.IsCompleted = 1";
                        using (SqlCommand cmd = new SqlCommand(lessonCountQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            row["LessonsCompletedCount"] = (int)cmd.ExecuteScalar();
                        }

                        // 2b. Attendance Rate
                        string totalSessionsQuery = "SELECT COUNT(*) FROM Attendances WHERE UserId = @UserId AND CourseId = @CourseId";
                        int totalSessions = 0;
                        using (SqlCommand cmd = new SqlCommand(totalSessionsQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            totalSessions = (int)cmd.ExecuteScalar();
                            row["TotalSessions"] = totalSessions;
                        }

                        string attendedSessionsQuery = "SELECT COUNT(*) FROM Attendances WHERE UserId = @UserId AND CourseId = @CourseId AND Status IN ('Present', 'Late')";
                        int attendedSessions = 0;
                        using (SqlCommand cmd = new SqlCommand(attendedSessionsQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            attendedSessions = (int)cmd.ExecuteScalar();
                            row["AttendedSessions"] = attendedSessions;
                        }

                        row["AttendanceRate"] = (totalSessions > 0) ? (attendedSessions * 100) / totalSessions : 100;

                        // 2c. Assessments Submissions & Averages
                        string quizCountQuery = @"
                            SELECT COUNT(*) 
                            FROM AssessmentSubmissions ASUB 
                            JOIN Assessments A ON ASUB.AssessmentId = A.AssessmentId 
                            WHERE ASUB.UserId = @UserId AND A.CourseId = @CourseId AND ASUB.Status = 'Submitted'";
                        using (SqlCommand cmd = new SqlCommand(quizCountQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            row["QuizzesSubmitted"] = (int)cmd.ExecuteScalar();
                        }

                        string quizAvgQuery = @"
                            SELECT AVG(CAST(ASUB.Score AS FLOAT) / CAST(A.TotalMarks AS FLOAT) * 100) 
                            FROM AssessmentSubmissions ASUB 
                            JOIN Assessments A ON ASUB.AssessmentId = A.AssessmentId 
                            WHERE ASUB.UserId = @UserId AND A.CourseId = @CourseId AND A.TotalMarks > 0";
                        using (SqlCommand cmd = new SqlCommand(quizAvgQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            object res = cmd.ExecuteScalar();
                            row["AvgQuizScore"] = (res != DBNull.Value) ? Convert.ToInt32(res) : 0;
                        }

                        // 2d. Assignments Submissions & Averages
                        string assignmentCountQuery = @"
                            SELECT COUNT(*) 
                            FROM AssignmentSubmissions ASUB 
                            JOIN Assignments A ON ASUB.AssignmentId = A.AssignmentId 
                            WHERE ASUB.UserId = @UserId AND A.CourseId = @CourseId AND ASUB.Status = 'Graded'";
                        using (SqlCommand cmd = new SqlCommand(assignmentCountQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            row["AssignmentsGraded"] = (int)cmd.ExecuteScalar();
                        }

                        string assignmentAvgQuery = @"
                            SELECT AVG(CAST(ASUB.Grade AS FLOAT) / CAST(A.MaxScore AS FLOAT) * 100) 
                            FROM AssignmentSubmissions ASUB 
                            JOIN Assignments A ON ASUB.AssignmentId = A.AssignmentId 
                            WHERE ASUB.UserId = @UserId AND A.CourseId = @CourseId AND ASUB.Status = 'Graded' AND A.MaxScore > 0";
                        using (SqlCommand cmd = new SqlCommand(assignmentAvgQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            object res = cmd.ExecuteScalar();
                            row["AvgAssignmentGrade"] = (res != DBNull.Value) ? Convert.ToInt32(res) : 0;
                        }
                    }

                    rptStudentProgress.DataSource = progressTable;
                    rptStudentProgress.DataBind();
                }
                catch (Exception ex)
                {
                    // If error, show general page error
                    Response.Write("<script>alert('Error loading student progress details: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
        }

        protected void rptStudentProgress_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Placeholder for optional item adjustments
        }

        protected void btnBackDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
        }

        public string GetProgressBarStyle(object percentObj)
        {
            int percentage = Convert.ToInt32(percentObj);
            string color = "var(--primary)";
            if (percentage >= 100) color = "var(--success)";
            else if (percentage >= 50) color = "var(--secondary)";
            else if (percentage > 0) color = "var(--warning)";
            
            return $"width: {percentage}%; background: {color}; height: 100%; transition: width 0.5s ease-out;";
        }
    }
}
