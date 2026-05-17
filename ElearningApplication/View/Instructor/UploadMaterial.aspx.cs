using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace ElearningApplication.View.Instructor
{
    public partial class UploadMaterial : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourses();
                if (Request.QueryString["courseId"] != null)
                {
                    ddlCourses.SelectedValue = Request.QueryString["courseId"];
                }
            }
        }

        private void LoadCourses()
        {
            int instructorId = Convert.ToInt32(Session["UserId"]);
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT CourseId, Title FROM Courses WHERE InstructorId = @InstructorId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@InstructorId", instructorId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlCourses.DataSource = reader;
                    ddlCourses.DataTextField = "Title";
                    ddlCourses.DataValueField = "CourseId";
                    ddlCourses.DataBind();
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;

            if (string.IsNullOrEmpty(ddlCourses.SelectedValue))
            {
                ShowMessage("Please select a course.", false);
                return;
            }

            if (string.IsNullOrEmpty(txtTitle.Text.Trim()))
            {
                ShowMessage("Please enter a material title.", false);
                return;
            }

            if (!fileUpload.HasFile)
            {
                ShowMessage("Please select a file to upload.", false);
                return;
            }

            try
            {
                int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
                string title = txtTitle.Text.Trim();
                int uploaderId = Convert.ToInt32(Session["UserId"]);

                string fileName = Path.GetFileName(fileUpload.PostedFile.FileName);
                string fileExtension = Path.GetExtension(fileName);
                long fileSize = fileUpload.PostedFile.ContentLength;
                
                // Ensure directory exists
                string uploadFolder = Server.MapPath("~/Uploads/Materials/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                // Generate a unique filename to prevent overwriting
                string uniqueFileName = Guid.NewGuid().ToString() + "_" + fileName;
                string savePath = Path.Combine(uploadFolder, uniqueFileName);
                
                // Save the file to the server
                fileUpload.SaveAs(savePath);

                // Relative path to store in DB
                string dbFilePath = "~/Uploads/Materials/" + uniqueFileName;

                // Save to Database
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO Materials (CourseId, Title, FileName, FilePath, FileSize, FileType, UploadedBy, UploadedAt, DownloadCount) 
                                     VALUES (@CourseId, @Title, @FileName, @FilePath, @FileSize, @FileType, @UploadedBy, GETDATE(), 0)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@FileName", fileName);
                        cmd.Parameters.AddWithValue("@FilePath", dbFilePath);
                        cmd.Parameters.AddWithValue("@FileSize", fileSize);
                        cmd.Parameters.AddWithValue("@FileType", fileExtension);
                        cmd.Parameters.AddWithValue("@UploadedBy", uploaderId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear form
                txtTitle.Text = "";
                ddlCourses.SelectedIndex = 0;
                
                ShowMessage("Material uploaded successfully!", true);
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            pnlMessage.CssClass = isSuccess ? "message success" : "message error";
        }
    }
}