<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CourseList.aspx.cs" Inherits="ElearningApplication.View.Course.CourseList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Available Courses - Elearning System</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #6366f1;
            --secondary: #a855f7;
            --accent: #ec4899;
            --background: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --text: #f8fafc;
            --text-muted: #94a3b8;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            color: var(--text);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 50px;
        }

        .header h1 {
            font-size: 3rem;
            background: linear-gradient(to right, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .search-container {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-bottom: 40px;
            background: var(--card-bg);
            padding: 20px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
        }

        .search-input {
            padding: 12px 20px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(15, 23, 42, 0.5);
            color: white;
            width: 300px;
            outline: none;
            transition: 0.3s;
        }

        .search-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.3);
        }

        .filter-select {
            padding: 12px 20px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(15, 23, 42, 0.5);
            color: white;
            outline: none;
            cursor: pointer;
        }

        .btn-search {
            padding: 12px 30px;
            border-radius: 12px;
            border: none;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.4);
        }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
        }

        .course-card {
            background: var(--card-bg);
            border-radius: 24px;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: flex;
            flex-direction: column;
        }

        .course-card:hover {
            transform: translateY(-10px);
            border-color: rgba(255,255,255,0.2);
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        .card-image {
            height: 180px;
            background: linear-gradient(45deg, #312e81, #581c87);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .card-image i {
            font-size: 4rem;
            color: rgba(255,255,255,0.2);
        }

        .category-badge {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(5px);
            padding: 5px 15px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .card-content {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .course-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .course-desc {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.5;
        }

        .card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.05);
        }

        .price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #4ade80;
        }

        .level {
            font-size: 0.8rem;
            color: var(--text-muted);
            background: rgba(255,255,255,0.05);
            padding: 4px 10px;
            border-radius: 6px;
        }

        .btn-view {
            display: block;
            width: 100%;
            text-align: center;
            padding: 12px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            margin-top: 20px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-view:hover {
            background: var(--primary);
            border-color: var(--primary);
        }

        .no-results {
            text-align: center;
            grid-column: 1 / -1;
            padding: 100px;
            color: var(--text-muted);
            font-size: 1.2rem;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <header class="header">
                <h1>Explore Courses</h1>
                <p>Learn from the best and master your craft</p>
            </header>

            <div class="search-container">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search by title..."></asp:TextBox>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="filter-select">
                    <asp:ListItem Text="All Categories" Value=""></asp:ListItem>
                    <asp:ListItem Text="Programming" Value="Programming"></asp:ListItem>
                    <asp:ListItem Text="Design" Value="Design"></asp:ListItem>
                    <asp:ListItem Text="Business" Value="Business"></asp:ListItem>
                    <asp:ListItem Text="Marketing" Value="Marketing"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-search" OnClick="btnSearch_Click" />
            </div>

            <div class="course-grid">
                <asp:Repeater ID="rptCourses" runat="server">
                    <ItemTemplate>
                        <div class="course-card">
                            <div class="card-image">
                                <span class="category-badge"><%# Eval("Category") %></span>
                                <div style="font-size: 50px; opacity: 0.3;">🎓</div>
                            </div>
                            <div class="card-content">
                                <h3 class="course-title"><%# Eval("Title") %></h3>
                                <p class="course-desc"><%# Eval("Description") %></p>
                                <div class="card-footer">
                                    <span class="price"><%# string.Format("{0:C}", Eval("Price")) %></span>
                                    <span class="level"><%# Eval("Level") %></span>
                                </div>
                                <asp:HyperLink ID="lnkView" runat="server" 
                                    NavigateUrl='<%# "~/View/Enrollment/EnrollmentDetails.aspx?id=" + Eval("CourseId") %>' 
                                    CssClass="btn-view" Text="View Details"></asp:HyperLink>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="no-results">
                    <h2>No courses found</h2>
                    <p>Try adjusting your search or filters</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>
