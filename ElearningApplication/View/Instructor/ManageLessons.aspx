<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageLessons.aspx.cs" Inherits="ElearningApplication.View.Instructor.ManageLessons" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Lessons - Instructor Panel</title>
    <style type="text/css">
        body { font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4; }
        .container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #333; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #007bff; color: white; padding: 10px; }
        .grid-view td { padding: 10px; border: 1px solid #ddd; }
        .btn { padding: 8px 15px; cursor: pointer; }
        .btn-add { background-color: #28a745; color: white; border: none; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Manage Course Lessons</h2>
            <hr />

            <div class="form-group">
                <label>Select Course:</label>
                <asp:DropDownList ID="ddlCourses" runat="server" AutoPostBack="True" 
                    DataSourceID="sqlCourses" DataTextField="Title" DataValueField="CourseId">
                </asp:DropDownList>
                <asp:HyperLink ID="lnkManageModules" runat="server" CssClass="btn" 
                    NavigateUrl='<%# "ManageModules.aspx?courseId=" + ddlCourses.SelectedValue %>'
                    style="background-color: #6c757d; color: white; text-decoration: none; margin-left: 10px;">
                    Manage Modules for this Course
                </asp:HyperLink>
                <asp:SqlDataSource ID="sqlCourses" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ElearningDb %>" 
                    SelectCommand="SELECT [CourseId], [Title] FROM [Courses] WHERE ([InstructorId] = @InstructorId)">
                    <SelectParameters>
                        <asp:SessionParameter Name="InstructorId" SessionField="UserId" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="form-group">
                <label>Select Module:</label>
                <asp:DropDownList ID="ddlModules" runat="server" AutoPostBack="True" 
                    DataSourceID="sqlModules" DataTextField="Title" DataValueField="ModuleId">
                </asp:DropDownList>
                <asp:SqlDataSource ID="sqlModules" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ElearningDb %>" 
                    SelectCommand="SELECT [ModuleId], [Title] FROM [Modules] WHERE ([CourseId] = @CourseId) ORDER BY [OrderNumber]">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlCourses" Name="CourseId" PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <hr />
            <h3>Lessons</h3>
            <asp:GridView ID="gvLessons" runat="server" AutoGenerateColumns="False" DataKeyNames="LessonId" 
                DataSourceID="sqlLessons" CssClass="grid-view" EmptyDataText="No lessons found in this module." OnSelectedIndexChanged="gvLessons_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="OrderNumber" HeaderText="Order" SortExpression="OrderNumber" />
                    <asp:BoundField DataField="Title" HeaderText="Lesson Title" SortExpression="Title" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration (min)" SortExpression="Duration" />
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="sqlLessons" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ElearningDb %>" 
                DeleteCommand="DELETE FROM [Lessons] WHERE [LessonId] = @LessonId" 
                InsertCommand="INSERT INTO [Lessons] ([ModuleId], [Title], [Content], [VideoUrl], [Duration], [OrderNumber]) VALUES (@ModuleId, @Title, @Content, @VideoUrl, @Duration, @OrderNumber)" 
                SelectCommand="SELECT * FROM [Lessons] WHERE ([ModuleId] = @ModuleId) ORDER BY [OrderNumber]" 
                UpdateCommand="UPDATE [Lessons] SET [Title] = @Title, [Content] = @Content, [VideoUrl] = @VideoUrl, [Duration] = @Duration, [OrderNumber] = @OrderNumber WHERE [LessonId] = @LessonId">
                <DeleteParameters>
                    <asp:Parameter Name="LessonId" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="ddlModules" Name="ModuleId" PropertyName="SelectedValue" Type="Int32" />
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="Content" Type="String" />
                    <asp:Parameter Name="VideoUrl" Type="String" />
                    <asp:Parameter Name="Duration" Type="Int32" />
                    <asp:Parameter Name="OrderNumber" Type="Int32" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlModules" Name="ModuleId" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="Content" Type="String" />
                    <asp:Parameter Name="VideoUrl" Type="String" />
                    <asp:Parameter Name="Duration" Type="Int32" />
                    <asp:Parameter Name="OrderNumber" Type="Int32" />
                    <asp:Parameter Name="LessonId" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <hr />
            <h3>Add New Lesson</h3>
            <table style="width: 100%;">
                <tr>
                    <td>Title:</td>
                    <td><asp:TextBox ID="txtTitle" runat="server" Width="300px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Content:</td>
                    <td><asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="5" Width="300px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Video URL:</td>
                    <td><asp:TextBox ID="txtVideoUrl" runat="server" Width="300px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Duration (min):</td>
                    <td><asp:TextBox ID="txtDuration" runat="server" Width="50px" Text="0"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Order:</td>
                    <td><asp:TextBox ID="txtOrder" runat="server" Width="50px" Text="1"></asp:TextBox></td>
                </tr>
                <tr>
                    <td></td>
                    <td><asp:Button ID="btnAdd" runat="server" Text="Add Lesson" CssClass="btn btn-add" OnClick="btnAdd_Click" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
