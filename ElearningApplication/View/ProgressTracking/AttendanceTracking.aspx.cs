using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.ProgressTracking
{
    public partial class AttendanceTracking : System.Web.UI.Page
    {
        private string ConnString => ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Set default datetime to local time
                txtNewSessionDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");

                string role = Session["UserRole"]?.ToString() ?? "Student";
                if (role == "Student")
                {
                    pnlStudentView.Visible = true;
                    pnlInstructorView.Visible = false;
                    lblRoleDescription.Text = "Monitor your live session attendance history and overall performance stats";
                    LoadStudentCourses();
                    TriggerStudentLoad();
                }
                else // Instructor or Admin
                {
                    pnlStudentView.Visible = false;
                    pnlInstructorView.Visible = true;
                    lblRoleDescription.Text = role == "Admin" 
                        ? "Admin View: Review and manage attendance across all academic courses" 
                        : "Manage and mark live session attendance for your courses";
                    LoadInstructorCourses(role);
                    TriggerInstructorLoad();
                }
            }
        }

        #region Navigation & Messaging Helper

        protected void btnBack_Click(object sender, EventArgs e)
        {
            string role = Session["UserRole"]?.ToString() ?? "Student";
            if (role == "Student")
            {
                Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
            }
            else if (role == "Instructor")
            {
                Response.Redirect("~/View/Dashboard/InstructorDashboard.aspx");
            }
            else
            {
                Response.Redirect("~/View/Dashboard/AdminDashboard.aspx");
            }
        }

        private void ShowMessage(string text, bool isError)
        {
            pnlMessage.Visible = true;
            litMsg.Text = text;
            divMsgClass.Attributes["class"] = isError ? "alert-box alert-danger" : "alert-box alert-success";
        }

        private void HideMessage()
        {
            pnlMessage.Visible = false;
        }

        #endregion

        #region Student View Logic

        private void LoadStudentCourses()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            ddlStudentCourses.Items.Clear();

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                string query = @"SELECT c.CourseId, c.Title 
                                 FROM Enrollments e 
                                 JOIN Courses c ON e.CourseId = c.CourseId 
                                 WHERE e.UserId = @StudentId AND e.Status = 'Active'
                                 ORDER BY c.Title";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                ddlStudentCourses.Items.Add(new ListItem(reader["Title"].ToString(), reader["CourseId"].ToString()));
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading courses: " + ex.Message, true);
                    }
                }
            }

            if (ddlStudentCourses.Items.Count == 0)
            {
                ddlStudentCourses.Items.Add(new ListItem("No active courses enrolled", "0"));
            }
            
            // Check if courseId is passed in URL query
            if (!string.IsNullOrEmpty(Request.QueryString["courseId"]))
            {
                string queryCourseId = Request.QueryString["courseId"];
                ListItem item = ddlStudentCourses.Items.FindByValue(queryCourseId);
                if (item != null)
                {
                    ddlStudentCourses.SelectedValue = queryCourseId;
                }
            }
        }

        protected void ddlStudentCourses_SelectedIndexChanged(object sender, EventArgs e)
        {
            HideMessage();
            TriggerStudentLoad();
        }

        private void TriggerStudentLoad()
        {
            if (ddlStudentCourses.SelectedValue == "0" || string.IsNullOrEmpty(ddlStudentCourses.SelectedValue))
            {
                lblStudentRate.Text = "N/A";
                lblStudentPresent.Text = "0";
                lblStudentLate.Text = "0";
                lblStudentAbsent.Text = "0";
                lblStudentExcused.Text = "0";
                gvStudentSessions.DataSource = null;
                gvStudentSessions.DataBind();
                return;
            }

            int studentId = Convert.ToInt32(Session["UserId"]);
            int courseId = Convert.ToInt32(ddlStudentCourses.SelectedValue);

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                try
                {
                    conn.Open();

                    // 1. Calculate Stats
                    string statsQuery = @"SELECT Status, COUNT(*) as Count 
                                          FROM Attendances 
                                          WHERE UserId = @StudentId AND CourseId = @CourseId 
                                          GROUP BY Status";

                    int present = 0, late = 0, absent = 0, excused = 0, total = 0;
                    using (SqlCommand cmd = new SqlCommand(statsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string status = reader["Status"].ToString();
                                int count = Convert.ToInt32(reader["Count"]);
                                total += count;
                                
                                switch (status)
                                {
                                    case "Present": present = count; break;
                                    case "Late": late = count; break;
                                    case "Absent": absent = count; break;
                                    case "Excused": excused = count; break;
                                }
                            }
                        }
                    }

                    lblStudentPresent.Text = present.ToString();
                    lblStudentLate.Text = late.ToString();
                    lblStudentAbsent.Text = absent.ToString();
                    lblStudentExcused.Text = excused.ToString();

                    int attended = present + late;
                    if (total > 0)
                    {
                        int rate = (attended * 100) / total;
                        lblStudentRate.Text = rate.ToString() + "%";
                    }
                    else
                    {
                        lblStudentRate.Text = "100%"; // default if no session exists yet
                    }

                    // 2. Load Table List
                    string listQuery = @"SELECT SessionTitle, JoinTime, LeaveTime, DurationMinutes, Status 
                                         FROM Attendances 
                                         WHERE UserId = @StudentId AND CourseId = @CourseId 
                                         ORDER BY JoinTime DESC";
                    using (SqlCommand cmd = new SqlCommand(listQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvStudentSessions.DataSource = dt;
                        gvStudentSessions.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error retrieving student attendance data: " + ex.Message, true);
                }
            }
        }

        #endregion

        #region Instructor / Admin View Logic

        private void LoadInstructorCourses(string role)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            ddlInstructorCourses.Items.Clear();

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                string query;
                if (role == "Admin")
                {
                    query = "SELECT CourseId, Title FROM Courses WHERE Status = 'Published' ORDER BY Title";
                }
                else // Instructor
                {
                    query = "SELECT CourseId, Title FROM Courses WHERE InstructorId = @InstructorId AND Status = 'Published' ORDER BY Title";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (role != "Admin")
                    {
                        cmd.Parameters.AddWithValue("@InstructorId", userId);
                    }

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                ddlInstructorCourses.Items.Add(new ListItem(reader["Title"].ToString(), reader["CourseId"].ToString()));
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading course list: " + ex.Message, true);
                    }
                }
            }

            if (ddlInstructorCourses.Items.Count == 0)
            {
                ddlInstructorCourses.Items.Add(new ListItem("No active published courses found", "0"));
            }
        }

        protected void ddlInstructorCourses_SelectedIndexChanged(object sender, EventArgs e)
        {
            HideMessage();
            pnlMarkAttendanceDetail.Visible = false;
            pnlSessionsTab.Visible = btnTabSessions.CssClass.Contains("active");
            pnlReportsTab.Visible = btnTabReports.CssClass.Contains("active");
            pnlSingleStudentDetail.Visible = false;
            TriggerInstructorLoad();
        }

        private void TriggerInstructorLoad()
        {
            if (ddlInstructorCourses.SelectedValue == "0" || string.IsNullOrEmpty(ddlInstructorCourses.SelectedValue))
            {
                gvInstructorSessions.DataSource = null;
                gvInstructorSessions.DataBind();
                gvStudentReports.DataSource = null;
                gvStudentReports.DataBind();
                return;
            }

            int courseId = Convert.ToInt32(ddlInstructorCourses.SelectedValue);

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                try
                {
                    conn.Open();

                    // 1. Load Sessions View
                    string sessionsQuery = @"
                        SELECT SessionTitle, JoinTime, 
                               COUNT(UserId) as TotalStudents,
                               SUM(CASE WHEN Status IN ('Present', 'Late') THEN 1 ELSE 0 END) as PresentCount,
                               SUM(CASE WHEN Status = 'Absent' THEN 1 ELSE 0 END) as AbsentCount,
                               SUM(CASE WHEN Status = 'Excused' THEN 1 ELSE 0 END) as ExcusedCount
                        FROM Attendances 
                        WHERE CourseId = @CourseId 
                        GROUP BY SessionTitle, JoinTime
                        ORDER BY JoinTime DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(sessionsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvInstructorSessions.DataSource = dt;
                        gvInstructorSessions.DataBind();
                    }

                    // 2. Load Student Reports View
                    string reportsQuery = @"
                        SELECT u.UserId, u.FirstName + ' ' + u.LastName as FullName, u.Email,
                               COUNT(a.AttendanceId) as TotalSessions,
                               SUM(CASE WHEN a.Status IN ('Present', 'Late') THEN 1 ELSE 0 END) as AttendedCount,
                               CASE 
                                 WHEN COUNT(a.AttendanceId) > 0 
                                 THEN (SUM(CASE WHEN a.Status IN ('Present', 'Late') THEN 1 ELSE 0 END) * 100) / COUNT(a.AttendanceId)
                                 ELSE 100 
                               END as Rate
                        FROM Enrollments e
                        JOIN Users u ON e.UserId = u.UserId
                        LEFT JOIN Attendances a ON e.UserId = a.UserId AND e.CourseId = a.CourseId
                        WHERE e.CourseId = @CourseId AND e.Status = 'Active'
                        GROUP BY u.UserId, u.FirstName, u.LastName, u.Email
                        ORDER BY u.FirstName, u.LastName";

                    using (SqlCommand cmd = new SqlCommand(reportsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvStudentReports.DataSource = dt;
                        gvStudentReports.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading course attendance tracking info: " + ex.Message, true);
                }
            }
        }

        #endregion

        #region Tab Toggle Handlers

        protected void btnTabSessions_Click(object sender, EventArgs e)
        {
            HideMessage();
            btnTabSessions.CssClass = "tab-btn active";
            btnTabReports.CssClass = "tab-btn";
            pnlSessionsTab.Visible = true;
            pnlReportsTab.Visible = false;
            pnlMarkAttendanceDetail.Visible = false;
            TriggerInstructorLoad();
        }

        protected void btnTabReports_Click(object sender, EventArgs e)
        {
            HideMessage();
            btnTabSessions.CssClass = "tab-btn";
            btnTabReports.CssClass = "tab-btn active";
            pnlSessionsTab.Visible = false;
            pnlReportsTab.Visible = true;
            pnlMarkAttendanceDetail.Visible = false;
            pnlSingleStudentDetail.Visible = false;
            TriggerInstructorLoad();
        }

        #endregion

        #region Create Session Logic

        protected void btnCreateSession_Click(object sender, EventArgs e)
        {
            HideMessage();
            if (ddlInstructorCourses.SelectedValue == "0" || string.IsNullOrEmpty(ddlInstructorCourses.SelectedValue))
            {
                ShowMessage("Please select a valid course first.", true);
                return;
            }

            string sessionTitle = txtNewSessionTitle.Text.Trim();
            if (string.IsNullOrEmpty(sessionTitle))
            {
                ShowMessage("Session Title is required.", true);
                return;
            }

            DateTime sessionDate;
            if (!DateTime.TryParse(txtNewSessionDate.Text, out sessionDate))
            {
                ShowMessage("Please enter a valid session Date & Time.", true);
                return;
            }

            int courseId = Convert.ToInt32(ddlInstructorCourses.SelectedValue);

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                try
                {
                    conn.Open();

                    // Check if students are enrolled
                    string enrollCountQuery = "SELECT COUNT(*) FROM Enrollments WHERE CourseId = @CourseId AND Status = 'Active'";
                    int activeStudentCount = 0;
                    using (SqlCommand cmd = new SqlCommand(enrollCountQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        activeStudentCount = (int)cmd.ExecuteScalar();
                    }

                    if (activeStudentCount == 0)
                    {
                        ShowMessage("Cannot create session. No active students are enrolled in this course.", true);
                        return;
                    }

                    // Insert attendance row with default status 'Present' for each active student enrolled in the course
                    string insertQuery = @"
                        INSERT INTO Attendances (UserId, CourseId, SessionTitle, JoinTime, Status, DurationMinutes)
                        SELECT UserId, @CourseId, @SessionTitle, @JoinTime, 'Present', 0
                        FROM Enrollments 
                        WHERE CourseId = @CourseId AND Status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.Parameters.AddWithValue("@SessionTitle", sessionTitle);
                        cmd.Parameters.AddWithValue("@JoinTime", sessionDate);

                        cmd.ExecuteNonQuery();
                    }

                    txtNewSessionTitle.Text = "";
                    txtNewSessionDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
                    ShowMessage($"Attendance session '{sessionTitle}' created successfully! All active enrolled students populated with default 'Present' status.", false);
                    TriggerInstructorLoad();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error creating session: " + ex.Message, true);
                }
            }
        }

        #endregion

        #region Session Details Marking Editor

        protected void gvInstructorSessions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            HideMessage();
            if (e.CommandName == "EditAttendance")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvInstructorSessions.Rows[index];

                string sessionTitle = Server.HtmlDecode(row.Cells[0].Text);
                string sessionDateText = row.Cells[1].Text;

                DateTime sessionDate;
                if (!DateTime.TryParse(sessionDateText, out sessionDate))
                {
                    ShowMessage("Could not parse session date: " + sessionDateText, true);
                    return;
                }

                // Store in ViewState
                ViewState["SelectedSessionTitle"] = sessionTitle;
                ViewState["SelectedSessionDate"] = sessionDate;

                lblEditSessionTitle.Text = sessionTitle;
                lblEditSessionDate.Text = sessionDate.ToString("MMM dd, yyyy hh:mm tt");

                LoadSessionDetailsEditor(sessionTitle, sessionDate);
            }
        }

        private void LoadSessionDetailsEditor(string sessionTitle, DateTime sessionDate)
        {
            int courseId = Convert.ToInt32(ddlInstructorCourses.SelectedValue);

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                string query = @"
                    SELECT a.AttendanceId, a.UserId, u.FirstName + ' ' + u.LastName as StudentName, u.Email, 
                           a.Status, a.JoinTime, a.LeaveTime, a.DurationMinutes
                    FROM Attendances a
                    JOIN Users u ON a.UserId = u.UserId
                    WHERE a.CourseId = @CourseId AND a.SessionTitle = @SessionTitle AND a.JoinTime = @JoinTime
                    ORDER BY u.FirstName, u.LastName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@SessionTitle", sessionTitle);
                    cmd.Parameters.AddWithValue("@JoinTime", sessionDate);

                    try
                    {
                        conn.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        
                        gvMarkAttendance.DataSource = dt;
                        gvMarkAttendance.DataBind();

                        // Set values of dropdowns
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            string status = dt.Rows[i]["Status"].ToString();
                            DropDownList ddl = (DropDownList)gvMarkAttendance.Rows[i].FindControl("ddlStatus");
                            if (ddl != null && ddl.Items.FindByValue(status) != null)
                            {
                                ddl.SelectedValue = status;
                            }
                        }

                        pnlSessionsTab.Visible = false;
                        pnlReportsTab.Visible = false;
                        pnlMarkAttendanceDetail.Visible = true;
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading session details: " + ex.Message, true);
                    }
                }
            }
        }

        protected void btnBackToSessions_Click(object sender, EventArgs e)
        {
            HideMessage();
            pnlMarkAttendanceDetail.Visible = false;
            pnlSessionsTab.Visible = true;
            pnlReportsTab.Visible = false;
            TriggerInstructorLoad();
        }

        protected void btnSaveAttendance_Click(object sender, EventArgs e)
        {
            HideMessage();
            
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                try
                {
                    conn.Open();
                    
                    foreach (GridViewRow row in gvMarkAttendance.Rows)
                    {
                        int attendanceId = Convert.ToInt32(gvMarkAttendance.DataKeys[row.RowIndex].Value);
                        
                        DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
                        TextBox txtJoin = (TextBox)row.FindControl("txtJoinTime");
                        TextBox txtLeave = (TextBox)row.FindControl("txtLeaveTime");
                        TextBox txtDur = (TextBox)row.FindControl("txtDuration");

                        string status = ddlStatus.SelectedValue;
                        
                        DateTime joinTime;
                        object dbJoinTime = DBNull.Value;
                        if (DateTime.TryParse(txtJoin.Text.Trim(), out joinTime))
                        {
                            dbJoinTime = joinTime;
                        }
                        
                        DateTime leaveTime;
                        object dbLeaveTime = DBNull.Value;
                        if (DateTime.TryParse(txtLeave.Text.Trim(), out leaveTime))
                        {
                            dbLeaveTime = leaveTime;
                        }

                        int duration = 0;
                        int.TryParse(txtDur.Text.Trim(), out duration);

                        string updateQuery = @"
                            UPDATE Attendances 
                            SET Status = @Status, JoinTime = @JoinTime, LeaveTime = @LeaveTime, DurationMinutes = @DurationMinutes
                            WHERE AttendanceId = @AttendanceId";

                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Status", status);
                            cmd.Parameters.AddWithValue("@JoinTime", dbJoinTime);
                            cmd.Parameters.AddWithValue("@LeaveTime", dbLeaveTime);
                            cmd.Parameters.AddWithValue("@DurationMinutes", duration);
                            cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);

                            cmd.ExecuteNonQuery();
                        }
                    }

                    ShowMessage("Attendance logs updated and saved successfully!", false);
                    pnlMarkAttendanceDetail.Visible = false;
                    pnlSessionsTab.Visible = true;
                    TriggerInstructorLoad();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving attendance details: " + ex.Message, true);
                }
            }
        }

        #endregion

        #region Student Reports & Detailed Logs

        protected void gvStudentReports_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            HideMessage();
            if (e.CommandName == "ViewDetail")
            {
                int studentId = Convert.ToInt32(e.CommandArgument);
                int courseId = Convert.ToInt32(ddlInstructorCourses.SelectedValue);

                // Fetch student name
                string studentName = "";
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    string nameQuery = "SELECT FirstName + ' ' + LastName as Name FROM Users WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(nameQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", studentId);
                        try
                        {
                            conn.Open();
                            studentName = cmd.ExecuteScalar()?.ToString() ?? "Student";
                        }
                        catch { }
                    }
                }

                lblSelectedStudentName.Text = studentName;

                // Load logs
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    string listQuery = @"SELECT SessionTitle, JoinTime, LeaveTime, DurationMinutes, Status 
                                         FROM Attendances 
                                         WHERE UserId = @StudentId AND CourseId = @CourseId 
                                         ORDER BY JoinTime DESC";
                    using (SqlCommand cmd = new SqlCommand(listQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);

                        try
                        {
                            if (conn.State == ConnectionState.Closed) conn.Open();
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvSingleStudentDetail.DataSource = dt;
                            gvSingleStudentDetail.DataBind();
                            pnlSingleStudentDetail.Visible = true;
                        }
                        catch (Exception ex)
                        {
                            ShowMessage("Error retrieving student logs: " + ex.Message, true);
                        }
                    }
                }
            }
        }

        protected void btnCloseStudentDetail_Click(object sender, EventArgs e)
        {
            pnlSingleStudentDetail.Visible = false;
        }

        #endregion

        #region Helper Styles

        public string GetStatusBadgeClass(object statusObj)
        {
            if (statusObj == null) return "badge";
            string status = statusObj.ToString();
            switch (status)
            {
                case "Present": return "badge badge-present";
                case "Absent": return "badge badge-absent";
                case "Late": return "badge badge-late";
                case "Excused": return "badge badge-excused";
                default: return "badge";
            }
        }

        #endregion
    }
}
