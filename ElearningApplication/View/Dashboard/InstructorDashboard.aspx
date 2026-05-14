<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InstructorDashboard.aspx.cs" Inherits="ElearningApplication.View.Dashboard.InstructorDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Instructor Dashboard</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="divDashboardMessage" runat="server" visible="false" style="margin: 20px; padding: 15px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 5px;">
            <asp:Literal ID="litDashboardMessage" runat="server"></asp:Literal>
        </div>
        <div style="margin-left: 2px; padding: 10px; background-color: #007bff; color: white; display: flex; align-items: center;">
            <asp:LinkButton ID="btnHome" runat="server" OnClick="btnHome_Click" style="color: white; text-decoration: none; font-size: 20px; margin-right: 15px;">☰</asp:LinkButton>
            <asp:Label ID="Label1" runat="server" Text="INSTRUCTOR DASHBOARD" style="font-weight: bold; font-size: 18px; flex-grow: 1;"></asp:Label>
            <asp:PlaceHolder ID="userprofileplaceholder" runat="server"></asp:PlaceHolder>
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" style="margin-left: 15px; color: white; text-decoration: none;">Logout</asp:LinkButton>
        </div>

        <asp:Panel ID="PanelMain" runat="server" Height="800px" style="margin-top: 20px; margin-left: 20px;">
            <asp:Label ID="LabelStats" runat="server" Text="MY PERFORMANCE" style="font-weight: 700"></asp:Label>
            <br />
            <asp:Panel ID="StatsPanel" runat="server" Height="100px" Width="814px" BackColor="#F8F9FA" BorderStyle="Solid" BorderWidth="1px" BorderColor="#CCCCCC">
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblStudents" runat="server" Text="👥 TOTAL STUDENTS"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblCoursesCount" runat="server" Text="📚 MY COURSES"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblAvgRating" runat="server" Text="⭐ AVG RATING"></asp:Label>
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:Label ID="txtStudentCount" runat="server" Text="0" style="font-size: 24px; font-weight: bold;"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="txtMyCoursesCount" runat="server" Text="0" style="font-size: 24px; font-weight: bold;"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="txtRating" runat="server" Text="0.0" style="font-size: 24px; font-weight: bold;"></asp:Label>
            </asp:Panel>

            <br /><br />
            <asp:Label ID="LabelActions" runat="server" Text="QUICK ACTIONS" style="font-weight: 700"></asp:Label>
            <br />
            <asp:Panel ID="ActionsPanel" runat="server" Height="100px" Width="814px" BackColor="#E3F2FD" BorderStyle="Solid" BorderWidth="1px" BorderColor="#BBDEFB">
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCreateCourse" runat="server" Text="➕ CREATE COURSE" Width="180px" Height="40px" OnClick="btnCreateCourse_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnGradeAssignments" runat="server" Text="📝 GRADE ASSIGNMENTS" Width="180px" Height="40px" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnAnnounce" runat="server" Text="📢 POST ANNOUNCEMENT" Width="180px" Height="40px" />
            </asp:Panel>

            <br /><br />
            <asp:Label ID="LabelMyCourses" runat="server" Text="MY COURSES" style="font-weight: 700"></asp:Label>
            <br />
            <asp:GridView ID="gvMyCourses" runat="server" Width="814px" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="CourseId" HeaderText="ID" />
                    <asp:BoundField DataField="Title" HeaderText="Course Title" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="CreatedAt" HeaderText="Created At" DataFormatString="{0:d}" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkEdit" runat="server" 
                                NavigateUrl='<%# "~/View/Course/EditCourse.aspx?id=" + Eval("CourseId") %>' 
                                Text="✎ Edit" ForeColor="#007bff" style="text-decoration:none; font-weight:bold;"></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="White" ForeColor="#000066" />
                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                <RowStyle ForeColor="#000066" />
                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#007DBB" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#00547E" />
            </asp:GridView>
        </asp:Panel>
    </form>
</body>
</html>
