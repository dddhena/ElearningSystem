<%@ Page Title="My Assessments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssessmentsList.aspx.cs" Inherits="ElearningApplication.View.Assignment_and_assessment.AssessmentsList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>My Assessments (Quizzes)</h2>
        
        <asp:GridView ID="gvAssessments" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped" EmptyDataText="No assessments found for your enrolled courses." OnRowCommand="gvAssessments_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                <asp:BoundField DataField="Title" HeaderText="Assessment" />
                <asp:BoundField DataField="DurationMinutes" HeaderText="Duration (m)" />
                <asp:BoundField DataField="TotalMarks" HeaderText="Max Marks" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnTake" runat="server" CommandName="TakeAssessment" CommandArgument='<%# Eval("AssessmentId") %>' CssClass="btn btn-sm btn-primary" Visible='<%# Eval("Status").ToString() == "Not Started" || Eval("Status").ToString() == "InProgress" %>'>Take Assessment</asp:LinkButton>
                        <asp:Label ID="lblCompleted" runat="server" CssClass="text-success" Visible='<%# Eval("Status").ToString() == "Submitted" || Eval("Status").ToString() == "Graded" %>'>Completed</asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
