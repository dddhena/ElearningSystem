<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="ElearningApplication.View.Account.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 216px">
    <form id="form1" runat="server">
        <div style="margin-left: 2px">
        &nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" Text="☰" />
&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label1" runat="server" Text="DASHBOARD"></asp:Label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="notificatioicon" runat="server" Text="🔔"></asp:Label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:PlaceHolder ID="userprofileplaceholder" runat="server"></asp:PlaceHolder>
        </div>
        <asp:Panel ID="Panel1" runat="server" Height="479px" style="margin-top: 19px">
            <ajaxToolkit:Rating ID="Rating1" runat="server">
            </ajaxToolkit:Rating>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            <br />
            <ajaxToolkit:Rating ID="Rating2" runat="server" ReadOnly="True">
            </ajaxToolkit:Rating>
            <asp:Panel ID="Panel2" runat="server" Height="108px" style="margin-left: 26px" Width="814px" BackColor="Aqua">
                <asp:Label ID="Label2" runat="server" Text="📚 ENROLLED"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label3" runat="server" Text="✅ COMPLETED"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label4" runat="server" Text="⭐ AVG RATING"></asp:Label>
                <br />
                <asp:PlaceHolder ID="noofenrolledplaceholder" runat="server"></asp:PlaceHolder>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:PlaceHolder ID="numberofcompleted" runat="server"></asp:PlaceHolder>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:PlaceHolder ID="averagerating" runat="server"></asp:PlaceHolder>
            </asp:Panel>
            <br />
            <br />
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label5" runat="server" style="font-weight: 700" Text="MY COURSES"></asp:Label>
            <br />
            <asp:Localize ID="Localize1" runat="server"></asp:Localize>
            <asp:Panel ID="Panel3" runat="server" Height="191px" style="margin-left: 32px" Width="837px">
                <asp:Panel ID="Panel4" runat="server" BackColor="#66FFFF" Height="117px" style="margin-left: 100px" Width="667px">
                    <asp:PlaceHolder ID="mycoursename" runat="server"></asp:PlaceHolder>
                    <br />
                    <ajaxToolkit:LineChart ID="LineChart1" runat="server">
                    </ajaxToolkit:LineChart>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="progrelabel" runat="server" Text="   Progress "></asp:Label>
                    &nbsp;
                    <asp:Chart ID="Chart1" runat="server" Height="22px" style="margin-left: 122px" Width="28px">
                        <Series>
                            <asp:Series ChartType="Doughnut" Name="Series1">
                            </asp:Series>
                        </Series>
                        <ChartAreas>
                            <asp:ChartArea Name="ChartArea1">
                            </asp:ChartArea>
                        </ChartAreas>
                    </asp:Chart>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="Button2" runat="server" Text="CONTINUE" />
                    <br />
                    &nbsp;&nbsp;&nbsp;
                    <asp:Label ID="Label6" runat="server" Text="Instructor"></asp:Label>
                    &nbsp;&nbsp;
                    <asp:PlaceHolder ID="instructorname" runat="server"></asp:PlaceHolder>
                </asp:Panel>
                <br />
            </asp:Panel>
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
            <ajaxToolkit:BarChart ID="BarChart1" runat="server">
            </ajaxToolkit:BarChart>
        </asp:Panel>
    </form>
</body>
</html>
