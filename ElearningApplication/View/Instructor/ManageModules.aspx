<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageModules.aspx.cs" Inherits="ElearningApplication.View.Instructor.ManageModules" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Modules - Instructor Panel</title>
    <style type="text/css">
        body { font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4; }
        .container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #333; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #6c757d; color: white; padding: 10px; }
        .grid-view td { padding: 10px; border: 1px solid #ddd; }
        .btn { padding: 8px 15px; cursor: pointer; }
        .btn-add { background-color: #17a2b8; color: white; border: none; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Manage Course Modules</h2>
            <hr />

            <div class="form-group">
                <label>Select Course:</label>
                <asp:DropDownList ID="ddlCourses" runat="server" AutoPostBack="True" 
                    DataSourceID="sqlCourses" DataTextField="Title" DataValueField="CourseId">
                </asp:DropDownList>
                <asp:HyperLink ID="lnkManageLessons" runat="server" CssClass="btn" 
                    NavigateUrl='<%# "ManageLessons.aspx?courseId=" + ddlCourses.SelectedValue %>'
                    style="background-color: #007bff; color: white; text-decoration: none; margin-left: 10px;">
                    Manage Lessons for this Course
                </asp:HyperLink>
                <asp:SqlDataSource ID="sqlCourses" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ElearningDb %>" 
                    SelectCommand="SELECT [CourseId], [Title] FROM [Courses] WHERE ([InstructorId] = @InstructorId)">
                    <SelectParameters>
                        <asp:SessionParameter Name="InstructorId" SessionField="UserId" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <hr />
            <h3>Modules</h3>
            <asp:GridView ID="gvModules" runat="server" AutoGenerateColumns="False" DataKeyNames="ModuleId" 
                DataSourceID="sqlModules" CssClass="grid-view" EmptyDataText="No modules found for this course.">
                <Columns>
                    <asp:BoundField DataField="OrderNumber" HeaderText="Order" SortExpression="OrderNumber" />
                    <asp:BoundField DataField="Title" HeaderText="Module Title" SortExpression="Title" />
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                    <asp:CheckBoxField DataField="IsLocked" HeaderText="Locked" SortExpression="IsLocked" />
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="sqlModules" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ElearningDb %>" 
                DeleteCommand="DELETE FROM [Modules] WHERE [ModuleId] = @ModuleId" 
                InsertCommand="INSERT INTO [Modules] ([CourseId], [Title], [Description], [OrderNumber], [IsLocked]) VALUES (@CourseId, @Title, @Description, @OrderNumber, @IsLocked)" 
                SelectCommand="SELECT * FROM [Modules] WHERE ([CourseId] = @CourseId) ORDER BY [OrderNumber]" 
                UpdateCommand="UPDATE [Modules] SET [Title] = @Title, [Description] = @Description, [OrderNumber] = @OrderNumber, [IsLocked] = @IsLocked WHERE [ModuleId] = @ModuleId">
                <DeleteParameters>
                    <asp:Parameter Name="ModuleId" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="ddlCourses" Name="CourseId" PropertyName="SelectedValue" Type="Int32" />
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="OrderNumber" Type="Int32" />
                    <asp:Parameter Name="IsLocked" Type="Boolean" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlCourses" Name="CourseId" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="OrderNumber" Type="Int32" />
                    <asp:Parameter Name="IsLocked" Type="Boolean" />
                    <asp:Parameter Name="ModuleId" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <hr />
            <h3>Add New Module</h3>
            <table style="width: 100%;">
                <tr>
                    <td>Title:</td>
                    <td><asp:TextBox ID="txtTitle" runat="server" Width="300px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Description:</td>
                    <td><asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" Width="300px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Order Number:</td>
                    <td><asp:TextBox ID="txtOrder" runat="server" Width="50px" Text="1"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Locked:</td>
                    <td><asp:CheckBox ID="chkIsLocked" runat="server" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td><asp:Button ID="btnAdd" runat="server" Text="Add Module" CssClass="btn btn-add" OnClick="btnAdd_Click" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
