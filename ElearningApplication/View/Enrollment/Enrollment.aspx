<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Enrollment.aspx.cs" Inherits="ElearningApplication.View.Enrollment.Enrollment" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Course Enrollment</title>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #ddd;
            margin-bottom: 30px;
            padding-bottom: 15px;
        }

        header h1 {
            margin: 0;
            color: #2c3e50;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .course-card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            transition: transform 0.2s;
        }

        .course-card:hover {
            transform: translateY(-5px);
            border-color: #3498db;
        }

        .category-tag {
            background: #e1f5fe;
            color: #0288d1;
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: 600;
            align-self: flex-start;
            margin-bottom: 15px;
        }

        .course-title {
            font-weight: 700;
            font-size: 1.2rem;
            color: #2c3e50;
            margin-bottom: 10px;
            flex-grow: 1;
        }

        .instructor {
            font-size: 0.9rem;
            color: #7f8c8d;
            margin-bottom: 20px;
        }

        .enroll-btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 700;
            width: 100%;
            transition: background 0.2s;
        }

        .enroll-btn:hover {
            background-color: #2980b9;
        }

        .btn-finish {
            display: inline-block;
            background: #2c3e50;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <header>
                <div>
                    <h1>Available Courses</h1>
                    <p style="color: #7f8c8d; margin-top: 5px;">Pick a course to start your learning journey.</p>
                </div>
                <a href="../Dashboard/StudentDashboard.aspx" class="btn-finish">Go to Dashboard</a>
            </header>

            <div class="courses-grid">
                <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                    <ItemTemplate>
                        <div class="course-card">
                            <span class="category-tag"><%# Eval("Category") %></span>
                            <div class="course-title"><%# Eval("Title") %></div>
                            <div class="instructor">👤 <%# Eval("InstructorName") %></div>
                            <asp:Button ID="btnEnroll" runat="server" Text="Enroll Now" CssClass="enroll-btn" 
                                CommandName="Enroll" CommandArgument='<%# Eval("CourseId") %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Label ID="lblNoCourses" runat="server" Text="You have enrolled in all available courses!" Visible="false" 
                style="display: block; text-align: center; padding: 50px; font-size: 1.2rem; color: #7f8c8d;"></asp:Label>
        </div>
    </form>
</body>
</html>