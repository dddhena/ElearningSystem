using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace ElearningApplication.View.Course
{
    public partial class CreateCourse : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserId"] == null)
                {
                    Response.Redirect("~/View/Account/Login.aspx");
                }
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string title = txtTitle.Text.Trim();
                string description = txtDescription.Text.Trim();
                string category = ddlCategory.SelectedValue;
                string level = ddlLevel.SelectedValue;
                decimal price = 0;
                int instructorId = Convert.ToInt32(Session["UserId"]);


                string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

                try
                {
                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        string query = @"INSERT INTO Courses (Title, Description, InstructorId, Category, Level, Price, Status, CreatedAt) 
                                       VALUES (@Title, @Description, @InstructorId, @Category, @Level, @Price, 'Draft', GETDATE())";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@Description", description);
                            cmd.Parameters.AddWithValue("@InstructorId", instructorId);
                            cmd.Parameters.AddWithValue("@Category", category);
                            cmd.Parameters.AddWithValue("@Level", level);
                            cmd.Parameters.AddWithValue("@Price", price);

                            conn.Open();
                            int result = cmd.ExecuteNonQuery();

                            if (result > 0)
                            {
                                ShowMessage("Course created successfully as a draft!", true);
                                ClearForm();
                            }
                            else
                            {
                                ShowMessage("Failed to create course. Please try again.", false);
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

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";

            ddlCategory.SelectedIndex = 0;
            ddlLevel.SelectedIndex = 0;
        }
    }
}