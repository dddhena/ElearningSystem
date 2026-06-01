<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditCourse.aspx.cs" Inherits="ElearningApplication.View.Course.EditCourse" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Course - Elearning System</title>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css" />
</head>
<body>
    <form id="form1" runat="server">

        <h2>Edit Course</h2>
        <p>Drag the cards below to reorder the course sections, then edit each field.</p>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false">
            <div id="divMessage" runat="server">
                <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <ul id="sortable-fields" style="list-style:none; padding:0; margin:0;">

            <li class="ui-state-default" style="margin-bottom:10px; padding:10px; border:1px solid #ccc; background:#f9f9f9; cursor:move;">
                <strong>&#9776; Course Title</strong>
                <br />
                <asp:TextBox ID="txtTitle" runat="server" Width="100%" placeholder="e.g. Advanced Web Development"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                    ErrorMessage="* Course title is required" Display="Dynamic"></asp:RequiredFieldValidator>
            </li>

            <li class="ui-state-default" style="margin-bottom:10px; padding:10px; border:1px solid #ccc; background:#f9f9f9; cursor:move;">
                <strong>&#9776; Description</strong>
                <br />
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" Width="100%"
                    placeholder="What will students learn in this course?"></asp:TextBox>
            </li>

            <li class="ui-state-default" style="margin-bottom:10px; padding:10px; border:1px solid #ccc; background:#f9f9f9; cursor:move;">
                <strong>&#9776; Category</strong>
                <br />
                <asp:DropDownList ID="ddlCategory" runat="server" Width="100%">
                    <asp:ListItem Text="Programming" Value="Programming"></asp:ListItem>
                    <asp:ListItem Text="Design" Value="Design"></asp:ListItem>
                    <asp:ListItem Text="Business" Value="Business"></asp:ListItem>
                    <asp:ListItem Text="Marketing" Value="Marketing"></asp:ListItem>
                    <asp:ListItem Text="Health &amp; Fitness" Value="Health"></asp:ListItem>
                </asp:DropDownList>
            </li>

            <li class="ui-state-default" style="margin-bottom:10px; padding:10px; border:1px solid #ccc; background:#f9f9f9; cursor:move;">
                <strong>&#9776; Difficulty Level</strong>
                <br />
                <asp:DropDownList ID="ddlLevel" runat="server" Width="100%">
                    <asp:ListItem Text="Beginner" Value="Beginner"></asp:ListItem>
                    <asp:ListItem Text="Intermediate" Value="Intermediate"></asp:ListItem>
                    <asp:ListItem Text="Advanced" Value="Advanced"></asp:ListItem>
                </asp:DropDownList>
            </li>

            <li class="ui-state-default" style="margin-bottom:10px; padding:10px; border:1px solid #ccc; background:#f9f9f9; cursor:move;">
                <strong>&#9776; Price ($)</strong>
                <br />
                <asp:TextBox ID="txtPrice" runat="server" Width="100%" placeholder="0.00"></asp:TextBox>
            </li>

        </ul>

        <br />
        <a href="../Dashboard/InstructorDashboard.aspx">Cancel</a>
        &nbsp;&nbsp;
        <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" OnClick="btnUpdate_Click" />

    </form>

    <script>
        $(function () {
            $("#sortable-fields").sortable({
                handle: "strong",
                placeholder: "ui-state-highlight",
                update: function (event, ui) {
                    // Fields are reordered visually; values are still submitted by ASP.NET controls
                }
            });
            $("#sortable-fields").disableSelection();
        });
    </script>

</body>
</html>
