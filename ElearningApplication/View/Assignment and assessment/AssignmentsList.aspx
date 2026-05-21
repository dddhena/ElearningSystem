<%@ Page Title="My Assignments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssignmentsList.aspx.cs" Inherits="ElearningApplication.View.Assignment_and_assessment.AssignmentsList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>My Assignments</h2>
        
        <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped" EmptyDataText="No assignments found for your enrolled courses." OnRowCommand="gvAssignments_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                <asp:BoundField DataField="Title" HeaderText="Assignment" />
                <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:g}" />
                <asp:BoundField DataField="MaxScore" HeaderText="Max Score" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="Grade" HeaderText="Grade" />
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnSubmit" runat="server" CommandName="SubmitAssignment" CommandArgument='<%# Eval("AssignmentId") %>' CssClass="btn btn-sm btn-primary" Visible='<%# Eval("Status").ToString() == "Not Submitted" %>'>Submit</asp:LinkButton>
                        <asp:LinkButton ID="btnView" runat="server" CommandName="ViewSubmission" CommandArgument='<%# Eval("AssignmentId") %>' CssClass="btn btn-sm btn-info" Visible='<%# Eval("Status").ToString() != "Not Submitted" %>'>View</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
