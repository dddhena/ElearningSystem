<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttendanceTracking.aspx.cs" Inherits="ElearningApplication.View.ProgressTracking.AttendanceTracking" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendance Tracking & Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --secondary: #0ea5e9;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --background: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --indigo-light: #e0e7ff;
            --success-light: #d1fae5;
            --warning-light: #fef3c7;
            --danger-light: #fee2e2;
            --info-light: #e0f2fe;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background-color: var(--background);
            color: var(--text-main);
            min-height: 100vh;
            padding: 30px 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Header Styling */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
            padding: 24px 32px;
            border-radius: 20px;
            color: white;
            box-shadow: 0 10px 25px -5px rgba(49, 46, 129, 0.1);
        }

        .header-title h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
            background: linear-gradient(to right, #ffffff, #c7d2fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-title p {
            font-size: 14px;
            color: #a5b4fc;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 10px 18px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-2px);
        }

        /* Card and Panel Layouts */
        .card {
            background: var(--card-bg);
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 24px;
            margin-bottom: 24px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
        }

        /* Filter Row */
        .filter-row {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }

        .form-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
        }

        .form-select {
            padding: 10px 16px;
            font-size: 14px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background-color: white;
            color: var(--text-main);
            min-width: 250px;
            font-weight: 500;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-select:focus {
            border-color: var(--primary);
        }

        .form-input {
            padding: 10px 16px;
            font-size: 14px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background-color: white;
            color: var(--text-main);
            outline: none;
            font-weight: 500;
            transition: border-color 0.2s;
        }

        .form-input:focus {
            border-color: var(--primary);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .stat-box {
            border-radius: 16px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 16px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .stat-box.rate { background: var(--indigo-light); color: var(--primary); }
        .stat-box.present { background: var(--success-light); color: var(--success); }
        .stat-box.late { background: var(--warning-light); color: var(--warning); }
        .stat-box.absent { background: var(--danger-light); color: var(--danger); }
        .stat-box.excused { background: var(--info-light); color: var(--secondary); }

        .stat-icon {
            font-size: 28px;
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .stat-info h3 {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-muted);
            font-weight: 600;
            margin-bottom: 4px;
        }

        .stat-info p {
            font-size: 20px;
            font-weight: 700;
            color: var(--text-main);
        }

        /* Table Styling */
        .table-container {
            overflow-x: auto;
            width: 100%;
        }

        .m-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 14px;
        }

        .m-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            padding: 14px 18px;
            font-weight: 600;
            border-bottom: 2px solid var(--border);
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        .m-table td {
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
            vertical-align: middle;
        }

        .m-table tr:hover td {
            background-color: #fafafa;
        }

        /* Status Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .badge-present { background-color: var(--success-light); color: #065f46; }
        .badge-absent { background-color: var(--danger-light); color: #991b1b; }
        .badge-late { background-color: var(--warning-light); color: #92400e; }
        .badge-excused { background-color: var(--info-light); color: #0369a1; }

        /* Action Buttons */
        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: #f1f5f9;
            color: #475569;
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            background-color: #e2e8f0;
        }

        /* Instructor Tabs */
        .tabs-header {
            display: flex;
            border-bottom: 1px solid var(--border);
            margin-bottom: 24px;
            gap: 12px;
        }

        .tab-btn {
            padding: 12px 20px;
            background: none;
            border: none;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            position: relative;
            outline: none;
        }

        .tab-btn.active {
            color: var(--primary);
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 3px;
            background-color: var(--primary);
            border-top-left-radius: 3px;
            border-top-right-radius: 3px;
        }

        /* Alerts and Empty states */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-muted);
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }

        .empty-state h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 4px;
        }

        .alert-box {
            padding: 12px 18px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
        }

        .alert-success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
        .alert-danger { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

        /* Grid inputs inside editor */
        .table-input {
            width: 100%;
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid var(--border);
            font-size: 13px;
            font-family: inherit;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="container">
            <!-- Header section -->
            <div class="header">
                <div class="header-title">
                    <h1>📅 Attendance Tracking</h1>
                    <p>
                        <asp:Label ID="lblRoleDescription" runat="server">View and track course session attendance details</asp:Label>
                    </p>
                </div>
                <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="btn-back">
                    ← Back to Dashboard
                </asp:LinkButton>
            </div>

            <!-- Messages Alert -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                <div id="divMsgClass" runat="server" class="alert-box">
                    <asp:Literal ID="litMsg" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <!-- STUDENT PANEL VIEW -->
            <asp:Panel ID="pnlStudentView" runat="server" Visible="false">
                <div class="card">
                    <div class="card-title">
                        <span>🔍</span> Select Course & View Stats
                    </div>
                    <div class="filter-row">
                        <span class="form-label">Course:</span>
                        <asp:DropDownList ID="ddlStudentCourses" runat="server" AutoPostBack="true" 
                            OnSelectedIndexChanged="ddlStudentCourses_SelectedIndexChanged" CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <!-- Student Stats Cards -->
                    <div class="stats-grid">
                        <div class="stat-box rate">
                            <div class="stat-icon">📈</div>
                            <div class="stat-info">
                                <h3>Attendance Rate</h3>
                                <p><asp:Label ID="lblStudentRate" runat="server">0%</asp:Label></p>
                            </div>
                        </div>
                        <div class="stat-box present">
                            <div class="stat-icon">✔️</div>
                            <div class="stat-info">
                                <h3>Present</h3>
                                <p><asp:Label ID="lblStudentPresent" runat="server">0</asp:Label></p>
                            </div>
                        </div>
                        <div class="stat-box late">
                            <div class="stat-icon">🕒</div>
                            <div class="stat-info">
                                <h3>Late</h3>
                                <p><asp:Label ID="lblStudentLate" runat="server">0</asp:Label></p>
                            </div>
                        </div>
                        <div class="stat-box absent">
                            <div class="stat-icon">❌</div>
                            <div class="stat-info">
                                <h3>Absent</h3>
                                <p><asp:Label ID="lblStudentAbsent" runat="server">0</asp:Label></p>
                            </div>
                        </div>
                        <div class="stat-box excused">
                            <div class="stat-icon">✉️</div>
                            <div class="stat-info">
                                <h3>Excused</h3>
                                <p><asp:Label ID="lblStudentExcused" runat="server">0</asp:Label></p>
                            </div>
                        </div>
                    </div>

                    <!-- Attendance Details Table -->
                    <div class="table-container">
                        <asp:GridView ID="gvStudentSessions" runat="server" AutoGenerateColumns="False" 
                            CssClass="m-table" GridLines="None" EmptyDataText="No attendance records found for this course.">
                            <Columns>
                                <asp:BoundField DataField="SessionTitle" HeaderText="Session Title" />
                                <asp:BoundField DataField="JoinTime" HeaderText="Session Date/Time" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />
                                <asp:TemplateField HeaderText="Duration">
                                    <ItemTemplate>
                                        <%# Eval("DurationMinutes").ToString() + " mins" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='<%# GetStatusBadgeClass(Eval("Status")) %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>

            <!-- INSTRUCTOR & ADMIN PANEL VIEW -->
            <asp:Panel ID="pnlInstructorView" runat="server" Visible="false">
                
                <!-- Filter bar at the top -->
                <div class="card">
                    <div class="card-title">
                        <span>📚</span> Select Course
                    </div>
                    <div class="filter-row">
                        <span class="form-label">Course:</span>
                        <asp:DropDownList ID="ddlInstructorCourses" runat="server" AutoPostBack="true" 
                            OnSelectedIndexChanged="ddlInstructorCourses_SelectedIndexChanged" CssClass="form-select">
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Tabs header -->
                <div class="tabs-header">
                    <asp:LinkButton ID="btnTabSessions" runat="server" CssClass="tab-btn active" OnClick="btnTabSessions_Click">Sessions & Marking</asp:LinkButton>
                    <asp:LinkButton ID="btnTabReports" runat="server" CssClass="tab-btn" OnClick="btnTabReports_Click">Student Reports</asp:LinkButton>
                </div>

                <!-- VIEW 1: SESSIONS & MARKING PANEL -->
                <asp:Panel ID="pnlSessionsTab" runat="server" Visible="true">
                    
                    <!-- Form to add new session -->
                    <div class="card">
                        <div class="card-title">
                            <span>➕</span> Create New Attendance Session
                        </div>
                        <div class="filter-row">
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <span class="form-label">Session Title:</span>
                                <asp:TextBox ID="txtNewSessionTitle" runat="server" Placeholder="e.g. Lecture 1: SQL Basics" CssClass="form-input" style="width: 250px;"></asp:TextBox>
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <span class="form-label">Date & Time:</span>
                                <asp:TextBox ID="txtNewSessionDate" runat="server" type="datetime-local" CssClass="form-input" style="width: 220px;"></asp:TextBox>
                            </div>
                            <div style="margin-top: 22px;">
                                <asp:Button ID="btnCreateSession" runat="server" Text="Create Session" OnClick="btnCreateSession_Click" CssClass="btn-action btn-primary" />
                            </div>
                        </div>
                    </div>

                    <!-- List of existing sessions -->
                    <div class="card">
                        <div class="card-title">
                            <span>📅</span> Existing Sessions for Course
                        </div>
                        <div class="table-container">
                            <asp:GridView ID="gvInstructorSessions" runat="server" AutoGenerateColumns="False" 
                                CssClass="m-table" GridLines="None" EmptyDataText="No sessions created for this course yet."
                                OnRowCommand="gvInstructorSessions_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="SessionTitle" HeaderText="Session Title" />
                                    <asp:BoundField DataField="JoinTime" HeaderText="Session Date/Time" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />
                                    <asp:BoundField DataField="TotalStudents" HeaderText="Enrolled" />
                                    <asp:BoundField DataField="PresentCount" HeaderText="Present / Late" />
                                    <asp:BoundField DataField="AbsentCount" HeaderText="Absent" />
                                    <asp:BoundField DataField="ExcusedCount" HeaderText="Excused" />
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEditAttendance" runat="server" 
                                                CommandName="EditAttendance" 
                                                CommandArgument='<%# Container.DataItemIndex %>' 
                                                CssClass="btn-action btn-primary" style="font-size:12px; padding:6px 10px;">
                                                📝 Mark Attendance
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </asp:Panel>

                <!-- VIEW 2: MARK/EDIT SESSION ATTENDANCE PANEL (DETAILS EDITOR) -->
                <asp:Panel ID="pnlMarkAttendanceDetail" runat="server" Visible="false" CssClass="card">
                    <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <span>✍️</span> Marking Attendance: <asp:Label ID="lblEditSessionTitle" runat="server" Font-Bold="true"></asp:Label>
                            <span style="font-size:14px; font-weight:normal; color:var(--text-muted); margin-left:10px;">
                                (<asp:Label ID="lblEditSessionDate" runat="server"></asp:Label>)
                            </span>
                        </div>
                        <asp:LinkButton ID="btnBackToSessions" runat="server" CssClass="btn-action btn-secondary" OnClick="btnBackToSessions_Click">
                            Back to Sessions
                        </asp:LinkButton>
                    </div>

                    <!-- Students attendance list for this session -->
                    <div class="table-container" style="margin-bottom: 20px;">
                        <asp:GridView ID="gvMarkAttendance" runat="server" AutoGenerateColumns="False" 
                            CssClass="m-table" GridLines="None" DataKeyNames="AttendanceId">
                            <Columns>
                                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email Address" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" style="min-width:120px; padding:6px 10px; font-size:13px;">
                                            <asp:ListItem Value="Present">Present</asp:ListItem>
                                            <asp:ListItem Value="Absent">Absent</asp:ListItem>
                                            <asp:ListItem Value="Late">Late</asp:ListItem>
                                            <asp:ListItem Value="Excused">Excused</asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Join Time">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtJoinTime" runat="server" Text='<%# Bind("JoinTime", "{0:yyyy-MM-dd HH:mm}") %>' CssClass="table-input" style="width:140px;"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Leave Time">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtLeaveTime" runat="server" Text='<%# Bind("LeaveTime", "{0:yyyy-MM-dd HH:mm}") %>' CssClass="table-input" style="width:140px;" Placeholder="Optional"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Duration (Mins)">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtDuration" runat="server" Text='<%# Bind("DurationMinutes") %>' CssClass="table-input" style="width:70px;" type="number"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <div style="display:flex; justify-content:flex-end; gap:12px;">
                        <asp:Button ID="btnSaveAttendance" runat="server" Text="💾 Save Attendance Logs" OnClick="btnSaveAttendance_Click" CssClass="btn-action btn-primary" style="padding:10px 20px;" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnBackToSessions_Click" CssClass="btn-action btn-secondary" style="padding:10px 20px;" />
                    </div>
                </asp:Panel>

                <!-- VIEW 3: STUDENT REPORTS PANEL -->
                <asp:Panel ID="pnlReportsTab" runat="server" Visible="false" CssClass="card">
                    <div class="card-title">
                        <span>📊</span> Student Attendance Performance Report
                    </div>
                    <div class="table-container">
                        <asp:GridView ID="gvStudentReports" runat="server" AutoGenerateColumns="False" 
                            CssClass="m-table" GridLines="None" EmptyDataText="No students enrolled in this course."
                            OnRowCommand="gvStudentReports_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="FullName" HeaderText="Student Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="TotalSessions" HeaderText="Total Sessions" />
                                <asp:BoundField DataField="AttendedCount" HeaderText="Sessions Attended" />
                                <asp:TemplateField HeaderText="Attendance Rate">
                                    <ItemTemplate>
                                        <span style='<%# "font-weight:bold; color:" + (Convert.ToInt32(Eval("Rate")) >= 80 ? "#10b981" : "#f59e0b") %>'>
                                            <%# Eval("Rate") %>%
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnViewStudentDetail" runat="server" 
                                            CommandName="ViewDetail" 
                                            CommandArgument='<%# Eval("UserId") %>' 
                                            CssClass="btn-action btn-secondary" style="font-size:12px; padding:6px 10px;">
                                            🔍 Detailed Log
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <!-- Single student detail modal/view overlay (shown only when clicking ViewDetail) -->
                    <asp:Panel ID="pnlSingleStudentDetail" runat="server" Visible="false" style="margin-top:25px; border-top:1px dashed var(--border); padding-top:20px;">
                        <h4 style="margin-bottom:15px; font-size:16px;">
                            Detailed Logs for student: <asp:Label ID="lblSelectedStudentName" runat="server" Font-Bold="true"></asp:Label>
                            <asp:LinkButton ID="btnCloseStudentDetail" runat="server" OnClick="btnCloseStudentDetail_Click" style="font-size:12px; color:red; margin-left:15px; text-decoration:none;">[Hide Details]</asp:LinkButton>
                        </h4>
                        <div class="table-container">
                            <asp:GridView ID="gvSingleStudentDetail" runat="server" AutoGenerateColumns="False" 
                                CssClass="m-table" GridLines="None" EmptyDataText="No attendance logs found.">
                                <Columns>
                                    <asp:BoundField DataField="SessionTitle" HeaderText="Session Title" />
                                    <asp:BoundField DataField="JoinTime" HeaderText="Join Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                    <asp:BoundField DataField="LeaveTime" HeaderText="Leave Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                    <asp:BoundField DataField="DurationMinutes" HeaderText="Duration (Mins)" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='<%# GetStatusBadgeClass(Eval("Status")) %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </asp:Panel>
                </asp:Panel>

            </asp:Panel>
        </div>
    </form>
</body>
</html>
