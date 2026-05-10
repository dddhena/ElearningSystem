<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="ElearningApplication.View.Dashboard.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div style="margin-left: 2px; padding: 10px; background-color: #343a40; color: white; display: flex; align-items: center;">
            <asp:LinkButton ID="btnHome" runat="server" OnClick="btnHome_Click" style="color: white; text-decoration: none; font-size: 20px; margin-right: 15px;">☰</asp:LinkButton>
            <asp:Label ID="Label1" runat="server" Text="ADMIN CONTROL PANEL" style="font-weight: bold; font-size: 18px; flex-grow: 1;"></asp:Label>
            <asp:PlaceHolder ID="userprofileplaceholder" runat="server"></asp:PlaceHolder>
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" style="margin-left: 15px; color: #ff6a6a; text-decoration: none;">Logout</asp:LinkButton>
        </div>

        <asp:Panel ID="PanelMain" runat="server" Height="900px" style="margin-top: 20px; margin-left: 20px;">
            <asp:Label ID="LabelStats" runat="server" Text="SYSTEM STATISTICS" style="font-weight: 700"></asp:Label>
            <br />
            <asp:Panel ID="StatsPanel" runat="server" Height="100px" Width="814px" BackColor="#F8F9FA" BorderStyle="Solid" BorderWidth="1px" BorderColor="#CCCCCC">
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblUsers" runat="server" Text="👥 TOTAL USERS"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblCourses" runat="server" Text="📚 TOTAL COURSES"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblEnrollments" runat="server" Text="📝 TOTAL ENROLLMENTS"></asp:Label>
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:Label ID="txtUserCount" runat="server" Text="0" style="font-size: 24px; font-weight: bold;"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="txtCourseCount" runat="server" Text="0" style="font-size: 24px; font-weight: bold;"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="txtEnrollmentCount" runat="server" Text="0" style="font-size: 24px; font-weight: bold;"></asp:Label>
            </asp:Panel>

            <br /><br />
            <asp:Label ID="LabelManagement" runat="server" Text="MANAGEMENT TOOLS" style="font-weight: 700"></asp:Label>
            <br />
            <asp:Panel ID="ManagementPanel" runat="server" Height="150px" Width="814px" BackColor="#D1ECF1" BorderStyle="Solid" BorderWidth="1px" BorderColor="#BEE5EB">
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnManageUsers" runat="server" Text="👤 USERS" Width="150px" Height="40px" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnManageCourses" runat="server" Text="📖 COURSES" Width="150px" Height="40px" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnReports" runat="server" Text="📊 REPORTS" Width="150px" Height="40px" />
                <br /><br />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnSettings" runat="server" Text="⚙️ SETTINGS" Width="150px" Height="40px" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnAuditLog" runat="server" Text="📜 AUDIT LOGS" Width="150px" Height="40px" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnDatabase" runat="server" Text="🗄️ DATABASE" Width="150px" Height="40px" />
            </asp:Panel>

            <br /><br />
            <asp:Label ID="LabelActivity" runat="server" Text="RECENT ACTIVITY" style="font-weight: 700"></asp:Label>
            <br />
            <asp:ListBox ID="lstRecentActivity" runat="server" Height="150px" Width="814px"></asp:ListBox>

            <br /><br />
            <asp:Label ID="LabelGrowth" runat="server" Text="USER REGISTRATION TREND" style="font-weight: 700"></asp:Label>
            <br />
            <asp:Panel ID="ChartPanel" runat="server" Height="220px" Width="814px" BorderStyle="Solid" BorderWidth="1px" BorderColor="#EEEEEE">
                <ajaxToolkit:BarChart ID="UserGrowthChart" runat="server" Width="750px" Height="200px"></ajaxToolkit:BarChart>
            </asp:Panel>
        </asp:Panel>
    </form>
</body>
</html>
