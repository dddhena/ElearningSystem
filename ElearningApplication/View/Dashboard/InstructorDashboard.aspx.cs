using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Dashboard
{
    public partial class InstructorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadInstructorData();
            }
        }

        private void LoadInstructorData()
        {
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int instructorId = Convert.ToInt32(Session["UserId"]);

                    // 1. My Courses Count
                    string courseCountQuery = "SELECT COUNT(*) FROM Courses WHERE InstructorId = @InstructorId";
                    using (SqlCommand cmd = new SqlCommand(courseCountQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@InstructorId", instructorId);
                        txtMyCoursesCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // 2. Total Students Count (Enrollments for instructor's courses)
                    string studentCountQuery = @"SELECT COUNT(DISTINCT e.UserId) 
                                               FROM Enrollments e 
                                               INNER JOIN Courses c ON e.CourseId = c.CourseId 
                                               WHERE c.InstructorId = @InstructorId";
                    using (SqlCommand cmd = new SqlCommand(studentCountQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@InstructorId", instructorId);
                        txtStudentCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // 3. User Profile
                    string profileQuery = "SELECT FirstName FROM Users WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(profileQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", instructorId);
                        object name = cmd.ExecuteScalar();
                        if (name != null)
                        {
                            userprofileplaceholder.Controls.Add(new Literal { Text = $"<span style='font-weight:bold; color:white;'>Instructor: {name}</span>" });
                        }
                    }

                    // 4. Load Courses Grid
                    string coursesListQuery = "SELECT CourseId, Title, Category, CreatedAt FROM Courses WHERE InstructorId = @InstructorId";
                    using (SqlCommand cmd = new SqlCommand(coursesListQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@InstructorId", instructorId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvMyCourses.DataSource = dt;
                        gvMyCourses.DataBind();
                    }

                }
                catch (Exception ex)
                {
                    // Basic error handling
                    Label1.Text = "Error: " + ex.Message;
                }
            }
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
    }
}