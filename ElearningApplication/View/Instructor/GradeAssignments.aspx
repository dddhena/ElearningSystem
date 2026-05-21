<%@ Page Title="Grade Assignments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GradeAssignments.aspx.cs" Inherits="ElearningApplication.View.Instructor.GradeAssignments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Submissions for <asp:Label ID="lblAssignmentTitle" runat="server" Text=""></asp:Label></h2>
        <a href="ManageAssignments.aspx" class="btn btn-secondary mb-3">Back to Assignments</a>

        <div class="row">
            <div class="col-md-12">
                <asp:GridView ID="gvSubmissions" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped" DataKeyNames="SubmissionId" OnRowCommand="gvSubmissions_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student" />
                        <asp:BoundField DataField="SubmissionDate" HeaderText="Submitted At" DataFormatString="{0:g}" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Files">
                            <ItemTemplate>
                                <asp:Repeater ID="rptFiles" runat="server" DataSource='<%# GetSubmissionFiles(Convert.ToInt32(Eval("SubmissionId"))) %>'>
                                    <ItemTemplate>
                                        <a href='<%# ResolveUrl(Eval("FilePath").ToString()) %>' target="_blank"><%# Eval("FileName") %></a><br />
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Grade" HeaderText="Grade" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnGrade" runat="server" CommandName="Grade" CommandArgument='<%# Eval("SubmissionId") %>' CssClass="btn btn-sm btn-primary">Grade/Feedback</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No submissions yet.
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <!-- Grade Panel (Hidden by default) -->
        <asp:Panel ID="pnlGrade" runat="server" Visible="false" CssClass="card mt-4 p-3 border-primary">
            <h4>Grade Submission ID: <asp:Label ID="lblCurrentSubmissionId" runat="server"></asp:Label></h4>
            <div class="mb-3">
                <label>Grade (Max: <asp:Label ID="lblMaxScore" runat="server"></asp:Label>)</label>
                <asp:TextBox ID="txtGrade" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
            </div>
            <div class="mb-3">
                <label>Feedback</label>
                <asp:TextBox ID="txtFeedback" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
            </div>
            <asp:Button ID="btnSaveGrade" runat="server" Text="Save Grade" CssClass="btn btn-success" OnClick="btnSaveGrade_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary ms-2" OnClick="btnCancel_Click" />
        </asp:Panel>
    </div>
</asp:Content>
