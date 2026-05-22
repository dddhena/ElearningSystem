<%@ Page Title="Assessment Results" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssessmentResults.aspx.cs" Inherits="ElearningApplication.View.Instructor.AssessmentResults" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Results for <asp:Label ID="lblAssessmentTitle" runat="server" Text=""></asp:Label></h2>
        <a href="ManageAssessments.aspx" class="btn btn-secondary mb-3">Back to Assessments</a>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4>Student Submissions</h4>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped" EmptyDataText="No students have submitted this assessment yet.">
                            <Columns>
                                <asp:BoundField DataField="StudentName" HeaderText="Student" />
                                <asp:BoundField DataField="StartTime" HeaderText="Started At" DataFormatString="{0:g}" />
                                <asp:BoundField DataField="EndTime" HeaderText="Submitted At" DataFormatString="{0:g}" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                <asp:BoundField DataField="Score" HeaderText="Score" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
