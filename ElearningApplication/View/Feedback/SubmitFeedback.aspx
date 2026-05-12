<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubmitFeedback.aspx.cs" Inherits="ElearningApplication.View.Feedback.SubmitFeedback" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Course Feedback</title>
    <style type="text/css">
        /* Star rating styles */
        .ratingStar, .emptyStar, .filledStar, .waitingStar {
            font-size: 0pt;
            width: 28px;
            height: 28px;
            display: inline-block;
            background-repeat: no-repeat;
            cursor: pointer;
        }
        
        .emptyStar {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" fill="lightgray" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
        }
        
        .filledStar {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" fill="gold" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
        }
        
        .waitingStar {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" fill="orange" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
        }
    </style>
</head>
<body style="height: 405px">
    <form id="form1" runat="server">
        <!-- Use standard ScriptManager instead -->
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div>
            <asp:Button ID="Button1" runat="server" style="font-weight: 700" Text="← BACK TO COURSE" Width="145px" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label1" runat="server" style="font-weight: 700" Text="⭐ COURSE FEEDBACK "></asp:Label>
        </div>
        
        <asp:Panel ID="Panel1" runat="server" Height="529px">
            <asp:Panel ID="Panel3" runat="server" Height="435px" style="margin-left: 97px" Width="701px">
                <asp:PlaceHolder ID="Coursenameforfeedback" runat="server"></asp:PlaceHolder>
                <br />
                <asp:Label ID="Label2" runat="server" Text="HOW WOULD YOU RATE THIS COURSE?"></asp:Label>
                
                <ajax:Rating ID="RatingStars" runat="server"
                    CurrentRating="0"
                    MaxRating="5"
                    StarCssClass="ratingStar"
                    WaitingStarCssClass="waitingStar"
                    EmptyStarCssClass="emptyStar"
                    FilledStarCssClass="filledStar"
                    OnChanged="RatingStars_Changed" />
                <br />
                <asp:Label ID="lblClickHint" runat="server" Font-Size="Small" ForeColor="Gray" Text="(Click to rate 1-5 stars)"></asp:Label>
                <br />
                <br />
                <asp:Label ID="Label3" runat="server" Text="YOUR REVIEW: "></asp:Label>
                <br />
                <asp:TextBox ID="txtReview" runat="server" TextMode="MultiLine" Rows="4" Width="90%" 
                    Text="This course was amazing! The instructor explains concepts very clearly. Highly recommended!"></asp:TextBox>
                <br />
                <asp:CheckBox ID="reviewsubmitCheckBox" runat="server" OnCheckedChanged="CheckBox1_CheckedChanged" Text="Submit anonymously" />
                <br />
                <asp:Button ID="submitreviewbtn" runat="server" OnClick="submitreviewbtn_Click" Text="Submit Feedback →" BackColor="#003300" ForeColor="White" />
            </asp:Panel>
        </asp:Panel>
    </form>
</body>
</html>