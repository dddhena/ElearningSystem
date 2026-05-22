<%@ Page Title="My Results" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyResults.aspx.cs" Inherits="ElearningApplication.View.Assignment_and_assessment.MyResults" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>My Performance & Results</h2>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Assignment Grades</h4>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" EmptyDataText="No graded assignments yet.">
                            <Columns>
                                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                                <asp:BoundField DataField="Title" HeaderText="Assignment" />
                                <asp:BoundField DataField="MaxScore" HeaderText="Max" />
                                <asp:BoundField DataField="Grade" HeaderText="Grade" />
                                <asp:BoundField DataField="Feedback" HeaderText="Feedback" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">Assessment Scores</h4>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvAssessments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" EmptyDataText="No assessment results yet.">
                            <Columns>
                                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                                <asp:BoundField DataField="Title" HeaderText="Assessment" />
                                <asp:BoundField DataField="TotalMarks" HeaderText="Max" />
                                <asp:BoundField DataField="Score" HeaderText="Score" />
                                <asp:BoundField DataField="EndTime" HeaderText="Completed On" DataFormatString="{0:d}" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
