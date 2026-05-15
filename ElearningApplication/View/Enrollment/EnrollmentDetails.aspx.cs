using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Enrollment
{
    public partial class EnrollmentDetails : System.Web.UI.Page
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
                string courseId = Request.QueryString["courseId"];
                if (!string.IsNullOrEmpty(courseId))
                {
                    LoadCourseDetails(courseId);
                }
                else
                {
                    Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
                }
            }
        }

        private void LoadCourseDetails(string courseId)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = @"SELECT C.Title, ISNULL(P.CompletionPercentage, 0) as Progress
                                   FROM Courses C
                                   LEFT JOIN Progress P ON C.CourseId = P.CourseId AND P.UserId = @UserId
                                   WHERE C.CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                lblCourseTitle.Text = "📘 " + reader["Title"].ToString();
                                int progress = Convert.ToInt32(reader["Progress"]);
                                lblProgressText.Text = progress + "% complete";
                                pnlProgressBar.Width = new Unit(progress, UnitType.Percentage);
                                
                                if (progress > 0)
                                {
                                    lblNextLesson.Text = "Continue with your learning";
                                }
                            }
                        }
                    }

                    // Load Modules
                    string moduleQuery = "SELECT ModuleId, Title, OrderNumber, IsLocked FROM Modules WHERE CourseId = @CourseId ORDER BY OrderNumber";
                    using (SqlCommand cmd = new SqlCommand(moduleQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptModules.DataSource = dt;
                        rptModules.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    lblCourseTitle.Text = "Error: " + ex.Message;
                }
            }
        }

        protected void rptModules_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfModuleId = (HiddenField)e.Item.FindControl("hfModuleId");
                Repeater rptLessons = (Repeater)e.Item.FindControl("rptLessons");

                if (hfModuleId != null && rptLessons != null)
                {
                    int moduleId = Convert.ToInt32(hfModuleId.Value);
                    LoadLessons(moduleId, rptLessons);
                }
            }
        }

        private void LoadLessons(int moduleId, Repeater rptLessons)
        {
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT Title, OrderNumber FROM Lessons WHERE ModuleId = @ModuleId ORDER BY OrderNumber";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ModuleId", moduleId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptLessons.DataSource = dt;
                    rptLessons.DataBind();
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
        }

        protected void btnLiveChat_Click(object sender, EventArgs e)
        {
            string courseId = Request.QueryString["courseId"];
            Response.Redirect("~/View/Chat/LiveChat.aspx?courseId=" + courseId);
        }

        protected void btnAskQuestion_Click(object sender, EventArgs e)
        {
            string courseId = Request.QueryString["courseId"];
            Response.Redirect("~/View/QnA/AskQuestion.aspx?courseId=" + courseId);
        }

        protected void btnMyProgress_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Feedback/MyProgress.aspx");
        }
    }
}