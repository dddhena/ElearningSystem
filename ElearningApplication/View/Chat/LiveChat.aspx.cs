using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace ElearningApplication.View
{
    public partial class LiveChat : System.Web.UI.Page
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
                hfUserId.Value = Session["UserId"].ToString();
                string courseIdStr = Request.QueryString["courseId"];
                if (!string.IsNullOrEmpty(courseIdStr))
                {
                    hfCourseId.Value = courseIdStr;
                    LoadCourseName(courseIdStr);
                    LoadOnlineUsers(courseIdStr);
                }
            }
        }

        private void LoadCourseName(string courseId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT Title FROM Courses WHERE CourseId = @CourseId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        litCourseName.Text = result.ToString();
                    }
                }
            }
        }

        private void LoadOnlineUsers(string courseId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Simple logic: users who enrolled in this course
                string query = @"SELECT DISTINCT U.FirstName, U.LastName 
                                FROM Users U 
                                JOIN Enrollments E ON U.UserId = E.UserId 
                                WHERE E.CourseId = @CourseId AND U.IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptOnlineUsers.DataSource = dt;
                    rptOnlineUsers.DataBind();
                }
            }
        }

        [WebMethod]
        public static List<ChatMessage> GetMessages(int courseId, int lastId)
        {
            List<ChatMessage> messages = new List<ChatMessage>();
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT M.MessageId, M.SenderId, M.Content, M.Timestamp, U.FirstName + ' ' + U.LastName as SenderName
                                FROM Messages M
                                JOIN Users U ON M.SenderId = U.UserId
                                WHERE M.CourseId = @CourseId AND M.MessageId > @LastId
                                ORDER BY M.Timestamp ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@LastId", lastId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            messages.Add(new ChatMessage
                            {
                                MessageId = (int)reader["MessageId"],
                                SenderId = (int)reader["SenderId"],
                                SenderName = reader["SenderName"].ToString(),
                                Content = reader["Content"].ToString(),
                                Time = Convert.ToDateTime(reader["Timestamp"]).ToString("HH:mm")
                            });
                        }
                    }
                }
            }
            return messages;
        }

        [WebMethod]
        public static bool SendMessage(int courseId, string content)
        {
            if (System.Web.HttpContext.Current.Session["UserId"] == null) return false;
            int userId = Convert.ToInt32(System.Web.HttpContext.Current.Session["UserId"]);

            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "INSERT INTO Messages (SenderId, CourseId, Content, Timestamp) VALUES (@SenderId, @CourseId, @Content, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SenderId", userId);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@Content", content);
                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string courseId = hfCourseId.Value;
            if (!string.IsNullOrEmpty(courseId))
                Response.Redirect("~/View/Enrollment/EnrollmentDetails.aspx?courseId=" + courseId);
            else
                Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
        }
    }

    public class ChatMessage
    {
        public int MessageId { get; set; }
        public int SenderId { get; set; }
        public string SenderName { get; set; }
        public string Content { get; set; }
        public string Time { get; set; }
    }
}