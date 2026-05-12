<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateCourse.aspx.cs" Inherits="ElearningApplication.View.Course.CreateCourse" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create New Course - Elearning System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --error: #ef4444;
            --success: #22c55e;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--text-main);
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            width: 100%;
            max-width: 600px;
            padding: 2rem;
        }

        .card {
            background: var(--card-bg);
            border-radius: 1rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
        }

        .header {
            margin-bottom: 2rem;
            text-align: center;
        }

        .header h1 {
            font-size: 1.875rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--text-main);
        }

        .header p {
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-main);
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.2s;
            box-sizing: border-box;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 0.75rem 1.5rem;
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            background-color: var(--primary-hover);
        }

        .message {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
            display: none;
        }

        .message.success {
            background-color: #f0fdf4;
            color: var(--success);
            border: 1px solid #bbf7d0;
            display: block;
        }

        .message.error {
            background-color: #fef2f2;
            color: var(--error);
            border: 1px solid #fecaca;
            display: block;
        }

        .validation-error {
            color: var(--error);
            font-size: 0.75rem;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Create New Course</h1>
                <p>Fill in the details to launch your new course</p>
            </div>

            <form id="form1" runat="server">
                <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                    <div id="divMessage" runat="server">
                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtTitle">Course Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                        ErrorMessage="Title is required" Display="Dynamic" CssClass="validation-error"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="txtDescription">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" ></asp:TextBox>
                </div>

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

                <div class="form-group">
                    <label for="txtPrice">Price (birr)</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:CompareValidator ID="cvPrice" runat="server" ControlToValidate="txtPrice" 
                        Operator="DataTypeCheck" Type="Double" ErrorMessage="Please enter a valid price" 
                        Display="Dynamic" CssClass="validation-error"></asp:CompareValidator>
                </div>

                <asp:Button ID="btnCreate" runat="server" Text="Create Course" CssClass="btn-submit" OnClick="btnCreate_Click" BackColor="#CC66FF" />
                
                <div style="text-align: center; margin-top: 1.5rem;">
                    <a href="../Dashboard/InstructorDashboard.aspx" style="color: var(--text-muted); font-size: 0.875rem; text-decoration: none;">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

