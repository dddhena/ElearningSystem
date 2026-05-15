using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Account
{
    public partial class Login1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both email and password.";
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT UserId, Role FROM Users WHERE Email = @Email AND PasswordHash = @Password AND IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["UserId"] = reader["UserId"];
                                Session["UserRole"] = reader["Role"];
                                Session["UserEmail"] = email;

                                // Redirect based on role
                                string role = Session["UserRole"]?.ToString();
                                if (role == "Student")
                                {
                                    Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
                                }
                                else if (role == "Admin")
                                {
                                    Response.Redirect("~/View/Dashboard/AdminDashboard.aspx");
                                }
                                else if (role == "Instructor")
                                {
                                    Response.Redirect("~/View/Dashboard/InstructorDashboard.aspx");
                                }
                                else
                                {
                                    Response.Redirect("~/Default.aspx");
                                }
                            }
                            else
                            {
                                lblMessage.Text = "Invalid email or password.";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error: " + ex.Message;
                    }
                }
            }
        }
    }
}