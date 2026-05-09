<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ElearningApplication.View.Account.Login1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
        <asp:Panel ID="Panel1" runat="server" Height="666px">
            <asp:Login ID="Loginpage" runat="server" Height="441px" TitleText="E-LEARNING" UserNameLabelText="Email Address" Width="998px">
            </asp:Login>
        </asp:Panel>
    </form>
</body>
</html>
