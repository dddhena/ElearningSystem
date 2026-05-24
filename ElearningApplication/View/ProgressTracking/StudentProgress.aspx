<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentProgress.aspx.cs" Inherits="ElearningApplication.View.ProgressTracking.StudentProgress" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Learning Journey & Progress</title>
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
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-2px);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 20px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            gap: 16px;
            position: relative;
            overflow: hidden;
        }

        .stat-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: transparent;
        }

        .stat-card.primary::after { background: var(--primary); }
        .stat-card.success::after { background: var(--success); }
        .stat-card.warning::after { background: var(--warning); }
        .stat-card.secondary::after { background: var(--secondary); }

        .stat-icon {
            font-size: 28px;
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .stat-card.primary .stat-icon { background: #e0e7ff; color: var(--primary); }
        .stat-card.success .stat-icon { background: #d1fae5; color: var(--success); }
        .stat-card.warning .stat-icon { background: #fef3c7; color: var(--warning); }
        .stat-card.secondary .stat-icon { background: #e0f2fe; color: var(--secondary); }

        .stat-info h3 {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .stat-info p {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-main);
        }

        /* Main Section */
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .courses-container {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .course-row {
            background: var(--card-bg);
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .course-row:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08);
        }

        .course-header {
            padding: 24px;
            display: grid;
            grid-template-columns: 2fr 1fr 1.5fr 1fr;
            align-items: center;
            gap: 20px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(to right, #fafafa, #ffffff);
        }

        @media (max-width: 900px) {
            .course-header {
                grid-template-columns: 1fr;
                gap: 15px;
            }
        }

        .course-info h2 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 6px;
        }

        .course-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13px;
            color: var(--text-muted);
        }

        .badge-cat {
            background: #f1f5f9;
            color: #475569;
            padding: 2px 8px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
        }

        .progress-block {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .progress-labels {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            font-weight: 600;
        }

        .progress-bar-outer {
            height: 10px;
            background: #f1f5f9;
            border-radius: 5px;
            overflow: hidden;
            width: 100%;
        }

        .progress-bar-inner {
            height: 100%;
            border-radius: 5px;
            transition: width 0.6s ease-out;
        }

        .engagement-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f0fdf4;
            color: #166534;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            border: 1px solid #dcfce7;
        }

        .btn-certificate {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            color: white;
            padding: 10px 18px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(180, 83, 9, 0.2);
            transition: all 0.2s ease;
        }

        .btn-certificate:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 14px rgba(180, 83, 9, 0.3);
        }

        .course-body {
            padding: 24px;
            background: #ffffff;
            display: grid;
            grid-template-columns: 1.5fr 1fr 1.5fr;
            gap: 30px;
        }

        @media (max-width: 900px) {
            .course-body {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        .sub-panel {
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
            background: #fafafa;
        }

        .sub-panel h3 {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 8px;
        }

        .info-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
        }

        .info-label {
            color: var(--text-muted);
        }

        .info-val {
            font-weight: 600;
            color: var(--text-main);
        }

        .empty-state {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 60px 40px;
            text-align: center;
            border: 1px dashed var(--border);
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 8px;
        }

        .empty-state p {
            color: var(--text-muted);
            font-size: 14px;
            max-width: 400px;
            margin: 0 auto;
        }

        .attendance-badge {
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .att-present { background: #d1fae5; color: #065f46; }
        .att-absent { background: #fee2e2; color: #991b1b; }
        .att-late { background: #fef3c7; color: #92400e; }
        .att-excused { background: #e0f2fe; color: #0369a1; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <!-- Header -->
            <div class="header">
                <div class="header-title">
                    <h1>My Learning Journey & Progress</h1>
                    <p>Track your course completions, grades, attendances, and certificates of accomplishment</p>
                </div>
                <asp:LinkButton ID="btnBackDashboard" runat="server" OnClick="btnBackDashboard_Click" CssClass="btn-back">
                    <span>←</span> Back to Dashboard
                </asp:LinkButton>
            </div>

            <!-- Stats Overview -->
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-icon">📚</div>
                    <div class="stat-info">
                        <h3>Enrolled Courses</h3>
                        <p><asp:Literal ID="litEnrolledCount" runat="server">0</asp:Literal></p>
                    </div>
                </div>
                <div class="stat-card success">
                    <div class="stat-icon">🏆</div>
                    <div class="stat-info">
                        <h3>Completed Courses</h3>
                        <p><asp:Literal ID="litCompletedCount" runat="server">0</asp:Literal></p>
                    </div>
                </div>
                <div class="stat-card warning">
                    <div class="stat-icon">📈</div>
                    <div class="stat-info">
                        <h3>Avg. Completion</h3>
                        <p><asp:Literal ID="litAvgCompletion" runat="server">0%</asp:Literal></p>
                    </div>
                </div>
                <div class="stat-card secondary">
                    <div class="stat-icon">⚡</div>
                    <div class="stat-info">
                        <h3>Average Score</h3>
                        <p><asp:Literal ID="litAvgScore" runat="server">0%</asp:Literal></p>
                    </div>
                </div>
            </div>

            <!-- Section Title -->
            <div class="section-title">
                <span>📊</span> Course Progress Details
            </div>

            <!-- Enrolled Courses List -->
            <div class="courses-container">
                <asp:Repeater ID="rptStudentProgress" runat="server" OnItemDataBound="rptStudentProgress_ItemDataBound">
                    <ItemTemplate>
                        <div class="course-row">
                            <!-- Course Summary Header -->
                            <div class="course-header">
                                <div class="course-info">
                                    <h2><%# Eval("Title") %></h2>
                                    <div class="course-meta">
                                        <span class="badge-cat"><%# Eval("Category") %></span>
                                        <span>Instructor: <strong><%# Eval("Instructor") %></strong></span>
                                    </div>
                                </div>

                                <div class="progress-block">
                                    <div class="progress-labels">
                                        <span>Completion</span>
                                        <span><%# Eval("CompletionPercentage") %>%</span>
                                    </div>
                                    <div class="progress-bar-outer">
                                        <div class="progress-bar-inner" style='<%# GetProgressBarStyle(Eval("CompletionPercentage")) %>'></div>
                                    </div>
                                </div>

                                <div style="text-align: center;">
                                    <div class="engagement-badge" title="Engagement score combines lessons, attendances, and forum activity">
                                        <span>⚡ Engagement:</span>
                                        <strong><%# Eval("EngagementScore") %>/100</strong>
                                    </div>
                                </div>

                                <div style="text-align: right;">
                                    <asp:HyperLink ID="lnkCert" runat="server" CssClass="btn-certificate" 
                                        Visible='<%# Convert.ToInt32(Eval("CompletionPercentage")) == 100 %>'
                                        NavigateUrl='<%# "~/View/ProgressTracking/Certificate.aspx?courseId=" + Eval("CourseId") %>'>
                                        🏆 Get Certificate
                                    </asp:HyperLink>
                                    <span style="font-size: 13px; color: var(--text-muted);" runat="server" visible='<%# Convert.ToInt32(Eval("CompletionPercentage")) < 100 %>'>
                                        🔒 Certificate at 100%
                                    </span>
                                </div>
                            </div>

                            <!-- Detailed Course Metrics Breakdown -->
                            <div class="course-body">
                                <!-- Lessons and Modules -->
                                <div class="sub-panel">
                                    <h3>📁 Syllabus Completion</h3>
                                    <ul class="info-list">
                                        <li class="info-item">
                                            <span class="info-label">Modules Completed</span>
                                            <span class="info-val"><%# Eval("ModulesCompleted") %> / <%# Eval("TotalModules") %></span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Lessons Completed</span>
                                            <span class="info-val"><%# Eval("LessonsCompletedCount") %></span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Last Studied</span>
                                            <span class="info-val"><%# Eval("LastActivity", "{0:MMM dd, yyyy}") %></span>
                                        </li>
                                    </ul>
                                </div>

                                <!-- Attendance -->
                                <div class="sub-panel">
                                    <h3>📅 Session Attendance</h3>
                                    <ul class="info-list">
                                        <li class="info-item">
                                            <span class="info-label">Total Live Sessions</span>
                                            <span class="info-val"><%# Eval("TotalSessions") %></span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Attended</span>
                                            <span class="info-val"><%# Eval("AttendedSessions") %></span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Attendance Rate</span>
                                            <span class="info-val" style="color: <%# Convert.ToInt32(Eval("AttendanceRate")) >= 80 ? "#10b981" : "#f59e0b" %>;">
                                                <%# Eval("AttendanceRate") %>%
                                            </span>
                                        </li>
                                    </ul>
                                </div>

                                <!-- Assessments & Assignments -->
                                <div class="sub-panel">
                                    <h3>📝 Grades & Achievements</h3>
                                    <ul class="info-list">
                                        <li class="info-item">
                                            <span class="info-label">Quizzes Submitted</span>
                                            <span class="info-val"><%# Eval("QuizzesSubmitted") %></span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Quiz Avg. Score</span>
                                            <span class="info-val"><%# Eval("AvgQuizScore") %>%</span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Assignments Graded</span>
                                            <span class="info-val"><%# Eval("AssignmentsGraded") %></span>
                                        </li>
                                        <li class="info-item">
                                            <span class="info-label">Assignment Avg. Grade</span>
                                            <span class="info-val"><%# Eval("AvgAssignmentGrade") %>%</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- Empty State -->
                <asp:Panel ID="pnlNoCourses" runat="server" CssClass="empty-state" Visible="false">
                    <div class="empty-icon">🎒</div>
                    <h3>No Enrollments Yet</h3>
                    <p>It looks like you aren't enrolled in any courses at the moment. Head back to the course list to get started on your learning journey!</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>
