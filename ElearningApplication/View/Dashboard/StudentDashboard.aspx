<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="ElearningApplication.View.Dashboard.StudentDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Dashboard</title>
    <style>
        .starRating { font-size: 0; }
        .ratingStar {
            width: 20px;
            height: 20px;
            background-repeat: no-repeat;
            display: block;
            cursor: pointer;
        }
        /* Using data URIs for stars to avoid external dependencies */
        .filledStar { background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBmaWxsPSIjZmZjMTA3IiBkPSJNMTIgMS43MmwyLjc4IDUuNjNsNi4yMS45LTEuNSA0LjM4IDEuMDYgNi4xN0wxMiAxNS40MWwtNS41NSAyLjk0IDEuMDYtNi4xNy00LjUtNC4zOCA2LjIxLS45TDEyIDEuNzJ6Ii8+PC9zdmc+'); }
        .emptyStar { background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBmaWxsPSIjZTBlMGUwIiBkPSJNMTIgMS43MmwyLjc4IDUuNjNsNi4yMS45LTEuNSA0LjM4IDEuMDYgNi4xN0wxMiAxNS40MWwtNS41NSAyLjk0IDEuMDYtNi4xNy00LjUtNC4zOCA2LjIxLS45TDEyIDEuNzJ6Ii8+PC9zdmc+'); }
        .waitingStar { background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBmaWxsPSIjZmY5ODAwIiBkPSJNMTIgMS43MmwyLjc4IDUuNjNsNi4yMS45LTEuNSA0LjM4IDEuMDYgNi4xN0wxMiAxNS40MWwtNS41NSAyLjk0IDEuMDYtNi4xNy00LjUtNC4zOCA2LjIxLS45TDEyIDEuNzJ6Ii8+PC9zdmc+'); }
    </style>
</head>
<body style="height: 216px">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div style="margin-left: 2px; padding: 10px; background-color: #f8f9fa; border-bottom: 1px solid #dee2e6; display: flex; align-items: center;">
            <asp:LinkButton ID="btnHome" runat="server" OnClick="btnHome_Click" style="text-decoration:none; font-size: 20px; margin-right: 15px;">&#9776;</asp:LinkButton>
            <asp:Label ID="Label1" runat="server" Text="STUDENT DASHBOARD" style="font-weight: bold; font-size: 18px; flex-grow: 1;"></asp:Label>
            <asp:Label ID="notificatioicon" runat="server" Text="&#128276;" style="font-size: 20px; margin-right: 20px; cursor: pointer;"></asp:Label>
            <asp:PlaceHolder ID="userprofileplaceholder" runat="server"></asp:PlaceHolder>
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" style="margin-left: 15px; color: red; text-decoration: none; font-size: 14px;">Logout</asp:LinkButton>
        </div>
        <asp:Panel ID="Panel1" runat="server" Height="479px" style="margin-top: 19px">
            <ajaxToolkit:Rating ID="Rating1" runat="server"
                StarCssClass="ratingStar"
                WaitingStarCssClass="waitingStar"
                FilledStarCssClass="filledStar"
                EmptyStarCssClass="emptyStar">
            </ajaxToolkit:Rating>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            <br />
            <ajaxToolkit:Rating ID="Rating2" runat="server" ReadOnly="True"
                StarCssClass="ratingStar"
                WaitingStarCssClass="waitingStar"
                FilledStarCssClass="filledStar"
                EmptyStarCssClass="emptyStar">
            </ajaxToolkit:Rating>
            <asp:Panel ID="Panel2" runat="server" Height="108px" style="margin-left: 26px" Width="814px" BackColor="Aqua">
                <asp:Label ID="Label2" runat="server" Text="ENROLLED"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label3" runat="server" Text=" COMPLETED"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label4" runat="server" Text=" AVG RATING"></asp:Label>
                <br />
                <asp:PlaceHolder ID="noofenrolledplaceholder" runat="server"></asp:PlaceHolder>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:PlaceHolder ID="numberofcompleted" runat="server"></asp:PlaceHolder>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:PlaceHolder ID="averagerating" runat="server"></asp:PlaceHolder>
            </asp:Panel>
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label7" runat="server" Text="QUICK ACTIONS" style="font-weight: 700"></asp:Label>
            <br />
            <asp:Panel ID="QuickActionsPanel" runat="server" Height="50px" style="margin-left: 26px" Width="814px" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px">
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnLiveChat" runat="server" Text=" LIVE CHAT" OnClick="btnLiveChat_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnAskQuestion" runat="server" Text="ASK QUESTION" OnClick="btnAskQuestion_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnFeedback" runat="server" Text="FEEDBACK" OnClick="btnFeedback_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnProgress" runat="server" Text="MY PROGRESS" OnClick="btnProgress_Click" />
            </asp:Panel>
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label8" runat="server" Text="RECENT NOTIFICATIONS" style="font-weight: 700"></asp:Label>
            <br />
            <asp:ListBox ID="lstNotifications" runat="server" Height="70px" style="margin-left: 26px" Width="814px"></asp:ListBox>
            <br />
            <div style="padding: 20px 30px;">
                <h3 style="margin-bottom: 20px; font-weight: 700; color: #333; display: flex; align-items: center; gap: 10px;">
                    &#128218; MY ENROLLED COURSES
                    <asp:LinkButton ID="btnEnrollMore" runat="server" OnClick="btnEnrollMore_Click" style="font-size: 0.8rem; font-weight: 400; color: #6366f1; text-decoration: none; border: 1px solid #6366f1; padding: 4px 12px; border-radius: 20px;">+ Enroll in More</asp:LinkButton>
                </h3>

                
                <div id="enrolledCoursesGrid" runat="server" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">
                    <!-- Enrolled courses will be dynamically loaded here -->
                    <asp:Repeater ID="rptEnrolledCourses" runat="server">
                        <ItemTemplate>
                            <div style="background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; transition: transform 0.2s;">
                                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px;">
                                    <span style="background: #f1f5f9; color: #475569; font-size: 0.7rem; font-weight: 600; padding: 2px 8px; border-radius: 4px; text-transform: uppercase;">
                                        <%# Eval("Category") %>
                                    </span>
                                    <span style="font-size: 0.8rem; color: #10b981; font-weight: 600;"><%# Eval("Progress") %>%</span>
                                </div>
                                <h4 style="margin-bottom: 8px; color: #1e293b; font-size: 1.1rem;"><%# Eval("Title") %></h4>
                                <p style="font-size: 0.85rem; color: #64748b; margin-bottom: 15px;">By <%# Eval("Instructor") %></p>
                                
                                <div style="height: 6px; background: #f1f5f9; border-radius: 3px; margin-bottom: 20px; overflow: hidden;">
                                    <%# "<div style='" + GetProgressStyle(Eval("Progress")) + "'></div>" %>



                                </div>

                                
                                <asp:LinkButton ID="btnContinue" runat="server" CommandArgument='<%# Eval("CourseId") %>' OnClick="btnContinue_Click" 
                                    style="display: block; text-align: center; background: #6366f1; color: white; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 0.9rem; margin-bottom: 8px;">
                                    Continue Learning
                                </asp:LinkButton>
                                <a href="../Chat/LiveChat.aspx?CourseId=<%# Eval("CourseId") %>" 
                                   style="display: block; text-align: center; background: #22c55e; color: white; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 0.9rem;">
                                    Join Live Chat
                                </a>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
        </asp:Panel>
    </form>
</body>
</html>

