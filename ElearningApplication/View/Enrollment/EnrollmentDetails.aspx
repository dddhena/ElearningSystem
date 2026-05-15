<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EnrollmentDetails.aspx.cs" Inherits="ElearningApplication.View.Enrollment.EnrollmentDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="max-width: 1000px; margin: 20px auto; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 20px; border: 2px solid #333; border-radius: 8px;">
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" style="text-decoration: none; color: #333; font-weight: bold;">← BACK TO MY COURSES</asp:LinkButton>
                <asp:Label ID="lblCourseTitle" runat="server" Text="Loading Course..." style="font-size: 1.5rem; font-weight: bold;"></asp:Label>
            </div>

            <!-- COURSE PROGRESS -->
            <fieldset style="border: 1px dashed #999; padding: 20px; border-radius: 5px; margin-bottom: 25px;">
                <legend style="font-weight: bold; padding: 0 10px;">COURSE PROGRESS</legend>
                <div style="margin-bottom: 10px;">
                    Your Progress: <asp:Label ID="lblProgressText" runat="server" Text="0% complete" Font-Bold="true"></asp:Label>
                </div>
                <div style="height: 25px; width: 100%; background-color: #f1f1f1; border: 1px solid #ccc; border-radius: 12px; overflow: hidden; margin-bottom: 15px;">
                    <asp:Panel ID="pnlProgressBar" runat="server" style="height: 100%; background-color: #4CAF50; width: 0%; transition: width 0.5s;"></asp:Panel>
                </div>
                <div style="font-size: 1rem;">
                    Next: <asp:Label ID="lblNextLesson" runat="server" Text="Start with Module 1"></asp:Label>
                </div>
            </fieldset>

            <!-- MODULES -->
            <fieldset style="border: 1px dashed #999; padding: 20px; border-radius: 5px; margin-bottom: 25px;">
                <legend style="font-weight: bold; padding: 0 10px;">MODULES</legend>
                
                <asp:Repeater ID="rptModules" runat="server" OnItemDataBound="rptModules_ItemDataBound">
                    <ItemTemplate>
                        <div style='<%# Eval("IsLocked", "{0}") == "True" ? "opacity: 0.6; margin-bottom: 20px;" : "margin-bottom: 20px;" %>'>
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                <span style="font-weight: bold;">📁 MODULE <%# Eval("OrderNumber") %>: <%# Eval("Title") %></span>
                                <asp:Button ID="btnStart" runat="server" Text="START →" Visible='<%# Eval("IsLocked", "{0}") == "False" %>' 
                                    BackColor="#4CAF50" ForeColor="White" BorderStyle="None" Padding="5px 15px" style="border-radius: 4px; cursor: pointer;" />
                                <span ID="lblLocked" runat="server" style="color: #999; font-weight: bold;" Visible='<%# Eval("IsLocked", "{0}") == "True" %>'>[LOCKED 🔒]</span>
                            </div>
                            <div style="border: 1px solid #eee; padding: 15px; background-color: <%# Eval("IsLocked", "{0}") == "True" ? "#f5f5f5" : "#fafafa" %>; border-radius: 4px;">
                                <asp:HiddenField ID="hfModuleId" runat="server" Value='<%# Eval("ModuleId") %>' />
                                <asp:Repeater ID="rptLessons" runat="server">
                                    <HeaderTemplate><ul style="list-style-type: none; margin: 0; padding: 0;"></HeaderTemplate>
                                    <ItemTemplate>
                                        <li style="margin-bottom: 8px;">• Lesson <%# Eval("OrderNumber") %>: <%# Eval("Title") %></li>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblNoLessons" runat="server" Text="No lessons available in this module." Visible='<%# ((Repeater)Container.Parent).Items.Count == 0 %>' style="font-style: italic; color: #666;"></asp:Label>
                                        </ul>
                                    </FooterTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblLockedText" runat="server" Text="Complete previous modules to unlock" Visible='<%# Eval("IsLocked", "{0}") == "True" %>' style="font-style: italic; color: #666;"></asp:Label>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:Label ID="lblNoModules" runat="server" Text="No modules found for this course." Visible='<%# rptModules.Items.Count == 0 %>' style="display: block; text-align: center; padding: 20px; font-style: italic;"></asp:Label>
                    </FooterTemplate>
                </asp:Repeater>
            </fieldset>

            <!-- QUICK ACTIONS -->
            <fieldset style="border: 1px dashed #999; padding: 20px; border-radius: 5px;">
                <legend style="font-weight: bold; padding: 0 10px;">QUICK ACTIONS</legend>
                <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                    <asp:Button ID="btnLiveChat" runat="server" Text="LIVE CHAT" OnClick="btnLiveChat_Click" Width="180px" />
                    <asp:Button ID="btnAskQuestion" runat="server" Text="ASK QUESTION" OnClick="btnAskQuestion_Click" Width="180px" />
                    <asp:Button ID="btnMaterials" runat="server" Text="MATERIALS" Width="180px" />
                    <asp:Button ID="btnMyProgress" runat="server" Text="MY PROGRESS" OnClick="btnMyProgress_Click" Width="180px" />
                </div>
            </fieldset>

        </div>
    </form>
</body>
</html>
