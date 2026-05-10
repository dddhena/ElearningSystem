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

        protected void Loginpage_Authenticate(object sender, AuthenticateEventArgs e)
        {
            string email = Loginpage.UserName;
            string password = Loginpage.Password;

            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // NOTE: Password should be hashed in production!
                string query = "SELECT UserId, Role FROM Users WHERE Email = @Email AND PasswordHash = @Password AND IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            e.Authenticated = true;
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
                            e.Authenticated = false;
                        }
                    }
                }
            }
        }
    }
}