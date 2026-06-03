using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Enrollment
{
    public partial class CourseMaterials : System.Web.UI.Page
    {
        private readonly string _connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
        private int _courseId;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);

            if (!int.TryParse(Request.QueryString["courseId"], out _courseId) || _courseId <= 0)
            {
                Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
                return;
            }

            if (!IsEnrolled(_courseId, _userId))
            {
                ShowMessage("You are not enrolled in this course.", false);
                pnlNoMaterials.Visible = true;
                rptMaterials.Visible = false;
                return;
            }

            if (Request.QueryString["download"] != null)
            {
                if (int.TryParse(Request.QueryString["download"], out int materialId))
                {
                    ServeDownload(materialId);
                }
                return;
            }

            hfCourseId.Value = _courseId.ToString();
            form1.Attributes["data-course-id"] = _courseId.ToString();

            if (!IsPostBack)
            {
                LoadCourseTitle();
                BindMaterials();
            }
        }

        private bool IsEnrolled(int courseId, int userId)
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(
                "SELECT COUNT(*) FROM Enrollments WHERE CourseId = @CourseId AND UserId = @UserId AND Status = 'Active'", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private void LoadCourseTitle()
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand("SELECT Title FROM Courses WHERE CourseId = @CourseId", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", _courseId);
                conn.Open();
                var title = cmd.ExecuteScalar();
                if (title != null)
                {
                    lblCourseTitle.Text = title.ToString() + " — Materials";
                }
            }
        }

        private void BindMaterials()
        {
            var table = new DataTable();
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(@"
                SELECT M.MaterialId, M.Title, M.FileName, M.FilePath, M.FileSize, M.FileType, M.UploadedAt, M.DownloadCount,
                       U.FirstName + ' ' + U.LastName AS UploadedByName
                FROM Materials M
                INNER JOIN Users U ON M.UploadedBy = U.UserId
                WHERE M.CourseId = @CourseId
                ORDER BY M.UploadedAt DESC", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", _courseId);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    table.Load(reader);
                }
            }

            if (table.Rows.Count == 0)
            {
                pnlNoMaterials.Visible = true;
                rptMaterials.Visible = false;
                return;
            }

            pnlNoMaterials.Visible = false;
            rptMaterials.Visible = true;

            table.Columns.Add("FileSizeDisplay", typeof(string));
            foreach (DataRow row in table.Rows)
            {
                row["FileSizeDisplay"] = FormatFileSize(Convert.ToInt64(row["FileSize"]));
            }

            rptMaterials.DataSource = table;
            rptMaterials.DataBind();
        }

        private static string FormatFileSize(long bytes)
        {
            if (bytes < 1024)
            {
                return bytes + " B";
            }
            if (bytes < 1024 * 1024)
            {
                return (bytes / 1024.0).ToString("0.#") + " KB";
            }
            return (bytes / (1024.0 * 1024.0)).ToString("0.#") + " MB";
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Enrollment/EnrollmentDetails.aspx?courseId=" + _courseId);
        }

        protected void rptMaterials_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Download" && int.TryParse(e.CommandArgument.ToString(), out int materialId))
            {
                ServeDownload(materialId);
            }
        }

        private void ServeDownload(int materialId)
        {
            if (!IsEnrolled(_courseId, _userId))
            {
                ShowMessage("Access denied.", false);
                return;
            }

            string filePath = null;
            string fileName = null;

            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(
                "SELECT FilePath, FileName FROM Materials WHERE MaterialId = @MaterialId AND CourseId = @CourseId", conn))
            {
                cmd.Parameters.AddWithValue("@MaterialId", materialId);
                cmd.Parameters.AddWithValue("@CourseId", _courseId);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowMessage("File not found.", false);
                        BindMaterials();
                        return;
                    }

                    filePath = reader["FilePath"].ToString();
                    fileName = reader["FileName"].ToString();
                }
            }

            string physicalPath = Server.MapPath(filePath);
            if (!File.Exists(physicalPath))
            {
                ShowMessage("The file is missing on the server. Contact your instructor.", false);
                BindMaterials();
                return;
            }

            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(
                "UPDATE Materials SET DownloadCount = DownloadCount + 1 WHERE MaterialId = @MaterialId", conn))
            {
                cmd.Parameters.AddWithValue("@MaterialId", materialId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            Response.TransmitFile(physicalPath);
            Response.End();
        }

        private void ShowMessage(string text, bool success)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = text;
            pnlMessage.Style["background-color"] = success ? "#d4edda" : "#f8d7da";
            pnlMessage.Style["color"] = success ? "#155724" : "#721c24";
            pnlMessage.Style["border"] = success ? "1px solid #c3e6cb" : "1px solid #f5c6cb";
        }
    }
}
