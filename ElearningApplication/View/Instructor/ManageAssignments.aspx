<%@ Page Title="Manage Assignments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageAssignments.aspx.cs" Inherits="ElearningApplication.View.Instructor.ManageAssignments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Manage Assignments</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h4>Add New Assignment</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label>Course</label>
                            <asp:DropDownList ID="ddlCourses" runat="server" CssClass="form-control" DataSourceID="sqlCourses" DataTextField="Title" DataValueField="CourseId">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="sqlCourses" runat="server" ConnectionString="<%$ ConnectionStrings:ElearningDb %>" SelectCommand="SELECT [CourseId], [Title] FROM [Courses] WHERE ([InstructorId] = @InstructorId)">
                                <SelectParameters>
                                    <asp:SessionParameter Name="InstructorId" SessionField="UserId" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                        <div class="mb-3">
                            <label>Title</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Due Date</label>
                            <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="DateTimeLocal" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Max Score</label>
                            <asp:TextBox ID="txtMaxScore" runat="server" CssClass="form-control" TextMode="Number" Text="100" required="true"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnAdd" runat="server" Text="Add Assignment" CssClass="btn btn-primary w-100" OnClick="btnAdd_Click" />
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4>Existing Assignments</h4>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="AssignmentId" DataSourceID="sqlAssignments" EmptyDataText="No assignments found." OnRowCommand="gvAssignments_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="CourseTitle" HeaderText="Course" SortExpression="CourseTitle" />
                                <asp:BoundField DataField="Title" HeaderText="Title" SortExpression="Title" />
                                <asp:BoundField DataField="DueDate" HeaderText="Due Date" SortExpression="DueDate" DataFormatString="{0:g}" />
                                <asp:BoundField DataField="MaxScore" HeaderText="Max Score" SortExpression="MaxScore" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnViewSubmissions" runat="server" CommandName="ViewSubmissions" CommandArgument='<%# Eval("AssignmentId") %>' CssClass="btn btn-sm btn-info">View Submissions</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="sqlAssignments" runat="server" ConnectionString="<%$ ConnectionStrings:ElearningDb %>" SelectCommand="SELECT a.[AssignmentId], a.[Title], a.[DueDate], a.[MaxScore], c.[Title] as CourseTitle FROM [Assignments] a INNER JOIN [Courses] c ON a.[CourseId] = c.[CourseId] WHERE c.[InstructorId] = @InstructorId ORDER BY a.[DueDate] DESC">
                            <SelectParameters>
                                <asp:SessionParameter Name="InstructorId" SessionField="UserId" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
