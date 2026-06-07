<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseMaterials.aspx.cs"
    Inherits="ElearningApplication.View.Enrollment.CourseMaterials" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Course Materials</title>
    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.0.min.js") %>"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfCourseId" runat="server" />

        <div style="max-width: 900px; margin: 20px auto; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 20px; border: 2px solid #333; border-radius: 8px;">

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click"
                    style="text-decoration: none; color: #333; font-weight: bold;">&larr; BACK TO COURSE</asp:LinkButton>
                <asp:Label ID="lblCourseTitle" runat="server" Text="Course Materials"
                    style="font-size: 1.35rem; font-weight: bold;"></asp:Label>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 15px; padding: 10px; border-radius: 5px;">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <fieldset style="border: 1px dashed #999; padding: 20px; border-radius: 5px; margin-bottom: 25px;">
                <legend style="font-weight: bold; padding: 0 10px;">COURSE FILES</legend>

                <asp:Panel ID="pnlNoMaterials" runat="server" Visible="false"
                    style="text-align: center; padding: 30px; color: #666; font-style: italic;">
                    No materials have been uploaded for this course yet. Check back after your instructor adds files.
                </asp:Panel>

                <ul id="materials-list" style="list-style: none; padding: 0; margin: 0;">
                    <asp:Repeater ID="rptMaterials" runat="server" OnItemCommand="rptMaterials_ItemCommand">
                        <ItemTemplate>
                            <li class="material-card" data-material-id='<%# Eval("MaterialId") %>'
                                style="margin-bottom: 10px; padding: 10px; border: 1px solid #ccc; background: #f9f9f9;">
                                <span style="font-weight: bold;"><%# Eval("Title") %></span>
                                <br />
                                <span style="font-size: 0.9rem; color: #555;">
                                    <%# Eval("FileName") %> |
                                    <%# Eval("FileSizeDisplay") %> |
                                    Posted <%# Eval("UploadedAt", "{0:dd MMM yyyy}") %>
                                    by <%# Eval("UploadedByName") %>
                                </span>
                                <br />
                                <asp:LinkButton ID="btnDownload" runat="server" Text="Download"
                                    CommandName="Download" CommandArgument='<%# Eval("MaterialId") %>' />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>

            <fieldset style="border: 1px dashed #999; padding: 20px; border-radius: 5px;">
                <legend style="font-weight: bold; padding: 0 10px;">QUICK DOWNLOAD</legend>
                <p style="margin-top: 0; color: #555;">
                    Drag any file card into the box below to download it.
                </p>
                <div id="download-tray"
                    style="min-height: 100px; border: 2px dashed #999; padding: 20px; text-align: center; background-color: #f8faff;">
                    <strong>Drop a material card here</strong><br />
                    <span style="font-size: 0.85rem; color: #666;">Your download will start automatically</span>
                </div>
            </fieldset>

        </div>
    </form>
    <script src="<%= ResolveUrl("~/Scripts/CourseMaterials.js") %>"></script>
</body>
</html>
