using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace ElearningApplication.View.Course
{
    public partial class CourseList : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;



        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCourses();
        }

        private void LoadCourses()
        {
            string searchTerm = txtSearch.Text.Trim();
            string category = ddlCategory.SelectedValue;

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = @"SELECT c.CourseId, c.Title, c.Description, c.Category, c.Level, c.Price, 
                                     u.FirstName + ' ' + u.LastName as InstructorName 
                                     FROM Courses c 
                                     JOIN Users u ON c.InstructorId = u.UserId 
                                     WHERE 1=1";
                    
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        query += " AND (Title LIKE @Search OR Description LIKE @Search)";
                    }
                    
                    if (!string.IsNullOrEmpty(category))
                    {
                        query += " AND Category = @Category";
                    }

                    query += " ORDER BY CreatedAt DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                        }
                        
                        if (!string.IsNullOrEmpty(category))
                        {
                            cmd.Parameters.AddWithValue("@Category", category);
                        }

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            rptCourses.DataSource = dt;
                            rptCourses.DataBind();

                            pnlNoResults.Visible = (dt.Rows.Count == 0);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // In a real app, log the error
                Response.Write("<script>alert('Error loading courses: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }
    }
}