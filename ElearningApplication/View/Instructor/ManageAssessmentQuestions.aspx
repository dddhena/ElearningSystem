<%@ Page Title="Manage Questions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageAssessmentQuestions.aspx.cs" Inherits="ElearningApplication.View.Instructor.ManageAssessmentQuestions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Questions for <asp:Label ID="lblAssessmentTitle" runat="server" Text=""></asp:Label></h2>
        <a href="ManageAssessments.aspx" class="btn btn-secondary mb-3">Back to Assessments</a>

        <div class="row">
            <div class="col-md-5">
                <div class="card">
                    <div class="card-header">
                        <h4>Add Question</h4>
                    </div>
                    <div class="card-body">
                        <asp:UpdatePanel ID="upnlQuestion" runat="server">
                            <ContentTemplate>
                                <div class="mb-3">
                                    <label>Question Type</label>
                                    <asp:DropDownList ID="ddlQuestionType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlQuestionType_SelectedIndexChanged">
                                        <asp:ListItem Text="Multiple Choice" Value="MultipleChoice" />
                                        <asp:ListItem Text="True/False" Value="TrueFalse" />
                                        <asp:ListItem Text="Short Answer" Value="ShortAnswer" />
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label>Question Text</label>
                                    <asp:TextBox ID="txtQuestionText" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" required="true"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label>Marks</label>
                                    <asp:TextBox ID="txtMarks" runat="server" CssClass="form-control" TextMode="Number" Text="1" required="true"></asp:TextBox>
                                </div>

                                <!-- Multiple Choice Options -->
                                <asp:Panel ID="pnlMultipleChoice" runat="server">
                                    <div class="mb-2"><label>Option A</label><asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control"></asp:TextBox></div>
                                    <div class="mb-2"><label>Option B</label><asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control"></asp:TextBox></div>
                                    <div class="mb-2"><label>Option C</label><asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control"></asp:TextBox></div>
                                    <div class="mb-2"><label>Option D</label><asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control"></asp:TextBox></div>
                                    <div class="mb-3">
                                        <label>Correct Option</label>
                                        <asp:DropDownList ID="ddlCorrectMC" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="A" Value="A" />
                                            <asp:ListItem Text="B" Value="B" />
                                            <asp:ListItem Text="C" Value="C" />
                                            <asp:ListItem Text="D" Value="D" />
                                        </asp:DropDownList>
                                    </div>
                                </asp:Panel>

                                <!-- True/False Options -->
                                <asp:Panel ID="pnlTrueFalse" runat="server" Visible="false">
                                    <div class="mb-3">
                                        <label>Correct Answer</label>
                                        <asp:DropDownList ID="ddlCorrectTF" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="True" Value="True" />
                                            <asp:ListItem Text="False" Value="False" />
                                        </asp:DropDownList>
                                    </div>
                                </asp:Panel>

                                <!-- Short Answer Options -->
                                <asp:Panel ID="pnlShortAnswer" runat="server" Visible="false">
                                    <div class="mb-3">
                                        <label>Correct Answer (Exact Match)</label>
                                        <asp:TextBox ID="txtCorrectSA" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </asp:Panel>

                                <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn btn-primary w-100" OnClick="btnAddQuestion_Click" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card">
                    <div class="card-header">
                        <h4>Questions List</h4>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped" DataKeyNames="QuestionId" DataSourceID="sqlQuestions">
                            <Columns>
                                <asp:BoundField DataField="QuestionType" HeaderText="Type" />
                                <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                                <asp:BoundField DataField="Marks" HeaderText="Marks" />
                                <asp:BoundField DataField="CorrectAnswer" HeaderText="Answer" />
                                <asp:CommandField ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-sm btn-danger" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="sqlQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:ElearningDb %>" 
                            SelectCommand="SELECT * FROM [AssessmentQuestions] WHERE ([AssessmentId] = @AssessmentId)"
                            DeleteCommand="DELETE FROM [AssessmentQuestions] WHERE [QuestionId] = @QuestionId">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="AssessmentId" QueryStringField="id" Type="Int32" />
                            </SelectParameters>
                            <DeleteParameters>
                                <asp:Parameter Name="QuestionId" Type="Int32" />
                            </DeleteParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
