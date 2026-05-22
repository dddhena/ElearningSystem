<%@ Page Title="Take Assessment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TakeAssessment.aspx.cs" Inherits="ElearningApplication.View.Assignment_and_assessment.TakeAssessment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2><asp:Label ID="lblTitle" runat="server"></asp:Label></h2>
        <div class="card mb-4">
            <div class="card-body">
                <p><strong>Description:</strong> <asp:Label ID="lblDescription" runat="server"></asp:Label></p>
                <p><strong>Duration:</strong> <asp:Label ID="lblDuration" runat="server"></asp:Label> minutes</p>
            </div>
        </div>

        <asp:Panel ID="pnlQuestions" runat="server">
            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="card mb-3">
                        <div class="card-header">
                            <strong>Question <%# Container.ItemIndex + 1 %>:</strong> <%# Eval("QuestionText") %> 
                            <span class="float-end">(Marks: <%# Eval("Marks") %>)</span>
                            <asp:HiddenField ID="hfQuestionId" runat="server" Value='<%# Eval("QuestionId") %>' />
                            <asp:HiddenField ID="hfQuestionType" runat="server" Value='<%# Eval("QuestionType") %>' />
                        </div>
                        <div class="card-body">
                            <!-- Multiple Choice -->
                            <asp:RadioButtonList ID="rblMultipleChoice" runat="server" Visible="false">
                                <asp:ListItem Text='<%# Eval("OptionA") %>' Value="A"></asp:ListItem>
                                <asp:ListItem Text='<%# Eval("OptionB") %>' Value="B"></asp:ListItem>
                                <asp:ListItem Text='<%# Eval("OptionC") %>' Value="C"></asp:ListItem>
                                <asp:ListItem Text='<%# Eval("OptionD") %>' Value="D"></asp:ListItem>
                            </asp:RadioButtonList>

                            <!-- True/False -->
                            <asp:RadioButtonList ID="rblTrueFalse" runat="server" Visible="false">
                                <asp:ListItem Text="True" Value="True"></asp:ListItem>
                                <asp:ListItem Text="False" Value="False"></asp:ListItem>
                            </asp:RadioButtonList>

                            <!-- Short Answer -->
                            <asp:TextBox ID="txtShortAnswer" runat="server" CssClass="form-control" Visible="false"></asp:TextBox>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Assessment" CssClass="btn btn-success btn-lg mt-3 mb-5" OnClick="btnSubmit_Click" OnClientClick="return confirm('Are you sure you want to submit? You cannot change your answers after submitting.');" />
        </asp:Panel>

        <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="alert alert-success text-center">
            <h3>Assessment Submitted Successfully!</h3>
            <p>Your Score: <strong><asp:Label ID="lblScore" runat="server"></asp:Label></strong></p>
            <a href="AssessmentsList.aspx" class="btn btn-primary mt-2">Back to Assessments</a>
        </asp:Panel>
    </div>
</asp:Content>
