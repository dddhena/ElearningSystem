<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditCourse.aspx.cs" Inherits="ElearningApplication.View.Course.EditCourse" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Course - Elearning System</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #6366f1;
            --primary-glow: rgba(99, 102, 241, 0.4);
            --secondary: #a855f7;
            --bg: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border: rgba(226, 232, 240, 0.1);
            --error: #f43f5e;
            --success: #10b981;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            color: var(--text-main);
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .container {
            width: 100%;
            max-width: 650px;
            padding: 2rem;
            position: relative;
        }

        .container::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: var(--primary);
            filter: blur(100px);
            opacity: 0.2;
            z-index: -1;
        }

        .card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--border);
            border-radius: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            padding: 3rem;
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            margin-bottom: 2.5rem;
            text-align: center;
        }

        .header h1 {
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            background: linear-gradient(to right, #fff, #94a3b8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header p {
            color: var(--text-muted);
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 1.75rem;
        }

        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.6rem;
            color: var(--text-main);
            letter-spacing: 0.025em;
        }

        .form-control {
            width: 100%;
            padding: 0.875rem 1.25rem;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid var(--border);
            border-radius: 0.75rem;
            color: white;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--primary-glow);
            background: rgba(15, 23, 42, 0.8);
        }

        .btn-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.875rem 1.5rem;
            border-radius: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-align: center;
            text-decoration: none;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
            filter: brightness(1.1);
        }

        .btn-cancel {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-main);
            border: 1px solid var(--border);
        }

        .btn-cancel:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .message {
            padding: 1rem 1.25rem;
            border-radius: 0.75rem;
            margin-bottom: 2rem;
            font-size: 0.9375rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border: 1px solid transparent;
        }

        .message.success {
            background: rgba(16, 185, 129, 0.1);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.2);
        }

        .message.error {
            background: rgba(244, 63, 94, 0.1);
            color: #fb7185;
            border-color: rgba(244, 63, 94, 0.2);
        }

        .validation-error {
            color: var(--error);
            font-size: 0.8rem;
            margin-top: 0.5rem;
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Edit Course</h1>
                <p>Refine your content and update course information</p>
            </div>

            <form id="form1" runat="server">
                <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                    <div id="divMessage" runat="server">
                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtTitle">Course Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="e.g. Advanced Web Development"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                        ErrorMessage="Course title is required" Display="Dynamic" CssClass="validation-error"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="txtDescription">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" 
                        placeholder="What will students learn in this course?"></asp:TextBox>
                </div>

                <div class="row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                    <div class="form-group">
                        <label for="ddlCategory">Category</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Programming" Value="Programming"></asp:ListItem>
                            <asp:ListItem Text="Design" Value="Design"></asp:ListItem>
                            <asp:ListItem Text="Business" Value="Business"></asp:ListItem>
                            <asp:ListItem Text="Marketing" Value="Marketing"></asp:ListItem>
                            <asp:ListItem Text="Health & Fitness" Value="Health"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label for="ddlLevel">Difficulty Level</label>
                        <asp:DropDownList ID="ddlLevel" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Beginner" Value="Beginner"></asp:ListItem>
                            <asp:ListItem Text="Intermediate" Value="Intermediate"></asp:ListItem>
                            <asp:ListItem Text="Advanced" Value="Advanced"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtPrice">Price ($)</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                </div>

                <div class="btn-group">
                    <a href="../Dashboard/InstructorDashboard.aspx" class="btn btn-cancel">Cancel</a>
                    <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn btn-submit" OnClick="btnUpdate_Click" />
                </div>
            </form>
        </div>
    </div>
</body>
</html>

