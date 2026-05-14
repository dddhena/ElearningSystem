using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Enrollment
{
    public partial class Enrollment : System.Web.UI.Page
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
                LoadAvailableCourses();
            }
        }

        private void LoadAvailableCourses()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    SELECT C.CourseId, C.Title, C.Category, 
                           U.FirstName + ' ' + U.LastName as InstructorName
                    FROM Courses C
                    JOIN Users U ON C.InstructorId = U.UserId
                    WHERE C.Status = 'Published'
                    AND C.CourseId NOT IN (SELECT CourseId FROM Enrollments WHERE UserId = @UserId)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptCourses.DataSource = dt;
                        rptCourses.DataBind();
                        lblNoCourses.Visible = false;
                    }
                    else
                    {
                        rptCourses.DataSource = null;
                        rptCourses.DataBind();
                        lblNoCourses.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                }
            }
        }

        public void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)

        {
            if (e.CommandName == "Enroll")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(Session["UserId"]);
                
                if (PerformEnrollment(userId, courseId))
                {
                    // Success! Show message and refresh list
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Enrolled Successfully!');", true);
                    LoadAvailableCourses();
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Enrollment failed. Please try again.');", true);
                }
            }
        }

        private bool PerformEnrollment(int userId, int courseId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    
                    // 1. Save to Enrollments table
                    string enrollQuery = "INSERT INTO Enrollments (UserId, CourseId, Status, EnrolledAt) VALUES (@UserId, @CourseId, 'Active', GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(enrollQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.ExecuteNonQuery();
                    }

                    // 2. Initialize Progress record
                    string progressQuery = @"
                        INSERT INTO Progress (UserId, CourseId, CompletionPercentage, TotalModules, Status) 
                        SELECT @UserId, @CourseId, 0, COUNT(*), 'NotStarted' 
                        FROM Modules WHERE CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(progressQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.ExecuteNonQuery();
                    }

                    return true;
                }
                catch (Exception)
                {
                    return false;
                }
            }
        }
    }
}