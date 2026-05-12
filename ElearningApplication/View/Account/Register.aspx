<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs"
    Inherits="ElearningApplication.View.Account.Register" %>

    <!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title></title>
    </head>

    <body>
        <form id="form1" runat="server">
            <div>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                Register to Start</div>
            <p>
                &nbsp;&nbsp;</p>
            <asp:Label ID="Label1" runat="server" Text="First Name"></asp:Label>
            <asp:TextBox ID="txtFirstName" runat="server" OnTextChanged="TextBox1_TextChanged"
                style="margin-left: 179px" Width="212px"></asp:TextBox>
            &nbsp;&nbsp;
            <br />
            <asp:Label ID="Label2" runat="server" Text="Last Name"></asp:Label>
            &nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtLastName" runat="server" OnTextChanged="TextBox2_TextChanged" style="margin-left: 40px"
                Width="213px"></asp:TextBox>
            <br />
            <asp:Label ID="Label3" runat="server" Text="Email"></asp:Label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtEmail" runat="server" style="margin-left: 180px" Width="217px"></asp:TextBox>
            <br />
            <asp:Label ID="Label4" runat="server" Text="Password"></asp:Label>
            &nbsp;<asp:TextBox ID="txtPassword" runat="server" style="margin-left: 181px" TextMode="Password"
                Width="213px"></asp:TextBox>
            <br />
            <br />
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click1" Text="Submit" />
            <br />
            <br />
            <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="Red"
                style="margin-left: 260px; font-weight: bold;"></asp:Label>
        </form>
    </body>

    </html>