<%@ Page Title="Submit Assignment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SubmitAssignment.aspx.cs" Inherits="ElearningApplication.View.Assignment_and_assessment.SubmitAssignment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Submit Assignment: <asp:Label ID="lblTitle" runat="server"></asp:Label></h2>
        <a href="AssignmentsList.aspx" class="btn btn-secondary mb-3">Back to List</a>

        <div class="card mb-4">
            <div class="card-body">
                <p><strong>Description:</strong> <asp:Label ID="lblDescription" runat="server"></asp:Label></p>
                <p><strong>Due Date:</strong> <asp:Label ID="lblDueDate" runat="server" CssClass="text-danger"></asp:Label></p>
                <p><strong>Max Score:</strong> <asp:Label ID="lblMaxScore" runat="server"></asp:Label></p>
            </div>
        </div>

        <asp:Panel ID="pnlSubmissionStatus" runat="server" Visible="false" CssClass="alert alert-info">
            <h5 class="alert-heading">Submission Status: <asp:Label ID="lblStatus" runat="server"></asp:Label></h5>
            <p><strong>Grade:</strong> <asp:Label ID="lblGrade" runat="server" Text="Not Graded"></asp:Label></p>
            <p><strong>Feedback:</strong> <asp:Label ID="lblFeedback" runat="server" Text="None"></asp:Label></p>
            <hr />
            <p><strong>Submitted Files:</strong></p>
            <asp:Repeater ID="rptFiles" runat="server">
                <ItemTemplate>
                    <a href='<%# ResolveUrl(Eval("FilePath").ToString()) %>' target="_blank"><%# Eval("FileName") %></a><br />
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

        <asp:Panel ID="pnlUpload" runat="server" CssClass="card mt-3">
            <div class="card-header">
                Upload Files
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label>Select files to upload (you can select multiple):</label>
                    <asp:FileUpload ID="fileUpload" runat="server" AllowMultiple="true" CssClass="form-control" />
                </div>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Assignment" CssClass="btn btn-success" OnClick="btnSubmit_Click" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
