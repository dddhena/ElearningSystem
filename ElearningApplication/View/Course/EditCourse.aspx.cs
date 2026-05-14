using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace ElearningApplication.View.Course
{
    public partial class EditCourse : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;



        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int courseId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadCourseData(courseId);
                }
                else
                {
                    Response.Redirect("../Dashboard/InstructorDashboard.aspx");
                }
            }
        }

        private void LoadCourseData(int courseId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "SELECT * FROM Courses WHERE CourseId = @CourseId AND InstructorId = @InstructorId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.Parameters.AddWithValue("@InstructorId", Session["UserId"]);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            txtTitle.Text = reader["Title"].ToString();
                            txtDescription.Text = reader["Description"].ToString();
                            ddlCategory.SelectedValue = reader["Category"].ToString();
                            ddlLevel.SelectedValue = reader["Level"].ToString();
                            txtPrice.Text = string.Format("{0:F2}", reader["Price"]);
                        }
                        else
                        {
                            Response.Redirect("../Dashboard/InstructorDashboard.aspx");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading course: " + ex.Message, false);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int courseId = Convert.ToInt32(Request.QueryString["id"]);
                string title = txtTitle.Text.Trim();
                string description = txtDescription.Text.Trim();
                string category = ddlCategory.SelectedValue;
                string level = ddlLevel.SelectedValue;
                decimal price = 0;
                decimal.TryParse(txtPrice.Text, out price);

                try
                {
                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        string query = @"UPDATE Courses 
                                       SET Title = @Title, 
                                           Description = @Description, 
                                           Category = @Category, 
                                           Level = @Level, 
                                           Price = @Price 
                                       WHERE CourseId = @CourseId AND InstructorId = @InstructorId";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@Description", description);
                            cmd.Parameters.AddWithValue("@Category", category);
                            cmd.Parameters.AddWithValue("@Level", level);
                            cmd.Parameters.AddWithValue("@Price", price);
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            cmd.Parameters.AddWithValue("@InstructorId", Convert.ToInt32(Session["UserId"]));

                            conn.Open();
                            int result = cmd.ExecuteNonQuery();

                            if (result > 0)
                            {
                                // Success - redirect back to dashboard after a short delay or immediately
                                // For now, let's just show the message and redirect
                                Session["UpdateMessage"] = "Course '" + title + "' updated successfully!";
                                Response.Redirect("../Dashboard/InstructorDashboard.aspx");
                            }
                            else
                            {
                                ShowMessage("No changes were made to the course.", false);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, false);
                }
            }
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            pnlMessage.Visible = true;
            litMessage.Text = msg;
            divMessage.Attributes["class"] = isSuccess ? "message success" : "message error";
        }
    }
}