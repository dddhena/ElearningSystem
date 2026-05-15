<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ElearningApplication.View.Account.Login1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center; margin-top: 50px;">
            <asp:Panel ID="Panel1" runat="server" Height="450px" Width="500px" style="margin: 0 auto; border: 1px solid #ccc; padding: 20px;">
                <h2 style="font-family: Arial;">E-LEARNING</h2>
                <br />
                <div style="text-align: left; margin-left: 50px;">
                    <asp:Label ID="lblEmail" runat="server" Text="Email Address"></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" Width="250px" style="margin-left: 20px;"></asp:TextBox>
                    <span style="color: red;">*</span>
                    <br /><br />
                    <asp:Label ID="lblPassword" runat="server" Text="Password"></asp:Label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="250px" style="margin-left: 42px;"></asp:TextBox>
                    <span style="color: red;">*</span>
                    <br /><br />
                    <asp:CheckBox ID="chkRemember" runat="server" Text="Remember me next time." />
                    <br /><br />
                    <asp:Button ID="btnLogin" runat="server" Text="Log In" OnClick="btnLogin_Click" Width="100px" style="margin-left: 100px;" />
                    <br /><br />
                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
                    <br /><br />
                    <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="Register.aspx">Don't have an account? Register here</asp:HyperLink>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
