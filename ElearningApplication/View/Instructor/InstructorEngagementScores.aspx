<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InstructorEngagementScores.aspx.cs"
    Inherits="ElearningApplication.View.Instructor.InstructorEngagementScores" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Engagement Scores</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Student Engagement Scores</h2>
            <hr />

            <div class="form-group">
                <label>Select Course:</label>
                <asp:DropDownList ID="ddlCourses" runat="server" AutoPostBack="True" 
                    DataSourceID="sqlCourses" DataTextField="Title" DataValueField="CourseId"
                    OnSelectedIndexChanged="ddlCourses_SelectedIndexChanged">
                </asp:DropDownList>
                <asp:SqlDataSource ID="sqlCourses" runat="server"
                    ConnectionString="<%$ ConnectionStrings:ElearningDb %>"
                    SelectCommand="SELECT [CourseId], [Title] FROM [Courses] WHERE ([InstructorId] = @InstructorId)">
                    <SelectParameters>
                        <asp:SessionParameter Name="InstructorId" SessionField="UserId" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <hr />
            <h3>Engagement Scores</h3>
            <asp:GridView ID="gvEngagementScores" runat="server" AutoGenerateColumns="False" 
                DataSourceID="sqlEngagementScores" CssClass="grid-view" 
                EmptyDataText="No engagement data found for this course.">
                <Columns>
                    <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName" />
                    <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName" />
                    <asp:BoundField DataField="Score" HeaderText="Engagement Score" SortExpression="Score" />
                    <asp:BoundField DataField="MessagesSent" HeaderText="Messages Sent" SortExpression="MessagesSent" />
                    <asp:BoundField DataField="QuestionsAsked" HeaderText="Questions Asked" SortExpression="QuestionsAsked" />
                    <asp:BoundField DataField="FeedbacksGiven" HeaderText="Feedbacks Given" SortExpression="FeedbacksGiven" />
                    <asp:BoundField DataField="LessonsCompleted" HeaderText="Lessons Completed" SortExpression="LessonsCompleted" />
                    <asp:BoundField DataField="SessionsAttended" HeaderText="Sessions Attended" SortExpression="SessionsAttended" />
                    <asp:BoundField DataField="LastUpdated" HeaderText="Last Updated" SortExpression="LastUpdated" DataFormatString="{0:MMM dd, yyyy}" />
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="sqlEngagementScores" runat="server"
                ConnectionString="<%$ ConnectionStrings:ElearningDb %>"
                SelectCommand="SELECT u.FirstName, u.LastName, e.Score, e.MessagesSent, e.QuestionsAsked, e.FeedbacksGiven, e.LessonsCompleted, e.SessionsAttended, e.LastUpdated FROM EngagementScores e INNER JOIN Users u ON e.UserId = u.UserId WHERE (e.CourseId = @CourseId) ORDER BY e.Score DESC">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlCourses" Name="CourseId" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
