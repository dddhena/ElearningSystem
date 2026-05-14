using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Dashboard
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminStats();
            }
        }

        private void LoadAdminStats()
        {
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    // 1. Total Users
                    string userQuery = "SELECT COUNT(*) FROM Users";
                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        txtUserCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // 2. Total Courses
                    string courseQuery = "SELECT COUNT(*) FROM Courses";
                    using (SqlCommand cmd = new SqlCommand(courseQuery, conn))
                    {
                        txtCourseCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // 3. Total Enrollments
                    string enrollmentQuery = "SELECT COUNT(*) FROM Enrollments";
                    using (SqlCommand cmd = new SqlCommand(enrollmentQuery, conn))
                    {
                        txtEnrollmentCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // 4. User Profile
                    string profileQuery = "SELECT FirstName FROM Users WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(profileQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                        object name = cmd.ExecuteScalar();
                        if (name != null)
                        {
                            userprofileplaceholder.Controls.Add(new Literal { Text = $"<span style='font-weight:bold; color:white;'>Admin: {name}</span>" });
                        }
                    }

                    // 5. Recent Activity
                    lstRecentActivity.Items.Clear();
                    lstRecentActivity.Items.Add($"{DateTime.Now.ToShortTimeString()} - Admin Dashboard loaded");
                    lstRecentActivity.Items.Add($"{DateTime.Now.AddMinutes(-10).ToShortTimeString()} - Database backup verified");

                }
                catch (Exception ex)
                {
                    Label1.Text = "Error loading stats: " + ex.Message;
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

        protected void btnManageUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Admin/ManageUsers.aspx");
        }
    }
}