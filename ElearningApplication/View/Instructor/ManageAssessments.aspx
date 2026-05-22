<%@ Page Title="Manage Assessments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageAssessments.aspx.cs" Inherits="ElearningApplication.View.Instructor.ManageAssessments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Manage Assessments (Quizzes)</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h4>Add New Assessment</h4>
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
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Duration (Minutes)</label>
                            <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" TextMode="Number" Text="60" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Total Marks</label>
                            <asp:TextBox ID="txtTotalMarks" runat="server" CssClass="form-control" TextMode="Number" Text="100" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Passing Marks</label>
                            <asp:TextBox ID="txtPassingMarks" runat="server" CssClass="form-control" TextMode="Number" Text="50" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label>Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Draft" Value="Draft" />
                                <asp:ListItem Text="Published" Value="Published" />
                                <asp:ListItem Text="Closed" Value="Closed" />
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnAdd" runat="server" Text="Create Assessment" CssClass="btn btn-primary w-100" OnClick="btnAdd_Click" />
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4>Existing Assessments</h4>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvAssessments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="AssessmentId" DataSourceID="sqlAssessments" OnRowCommand="gvAssessments_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="CourseTitle" HeaderText="Course" SortExpression="CourseTitle" />
                                <asp:BoundField DataField="Title" HeaderText="Title" SortExpression="Title" />
                                <asp:BoundField DataField="DurationMinutes" HeaderText="Duration (m)" SortExpression="DurationMinutes" />
                                <asp:BoundField DataField="TotalMarks" HeaderText="Max Marks" SortExpression="TotalMarks" />
                                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnManageQuestions" runat="server" CommandName="ManageQuestions" CommandArgument='<%# Eval("AssessmentId") %>' CssClass="btn btn-sm btn-info mb-1">Questions</asp:LinkButton>
                                        <asp:LinkButton ID="btnViewResults" runat="server" CommandName="ViewResults" CommandArgument='<%# Eval("AssessmentId") %>' CssClass="btn btn-sm btn-secondary mb-1">Results</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="sqlAssessments" runat="server" ConnectionString="<%$ ConnectionStrings:ElearningDb %>" SelectCommand="SELECT a.[AssessmentId], a.[Title], a.[DurationMinutes], a.[TotalMarks], a.[Status], c.[Title] as CourseTitle FROM [Assessments] a INNER JOIN [Courses] c ON a.[CourseId] = c.[CourseId] WHERE c.[InstructorId] = @InstructorId ORDER BY a.[CreatedAt] DESC">
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
