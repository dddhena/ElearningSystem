using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Chat
{
    public partial class LiveChat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPinnedMessages();
                LoadChatHistory();
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        private void LoadPinnedMessages()
        {
            var chatService = new Services.ChatService();
            var messages = chatService.GetChatHistory(null).FindAll(m => m.IsPinned);

            if (messages == null || messages.Count == 0)
            {
                // No pinned messages - ensure placeholder remains visible on client
                PinnedMessages.Text = string.Empty;
                // Add a small script to keep the placeholder visible (client toggles)
                var script = "<script>$(function(){ $('#pinnedContainer').hide(); $('#pinnedPlaceholder').show(); });</script>";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "pinnedPlaceholder", script);
                return;
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            foreach (var m in messages)
            {
                sb.AppendFormat("{0} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {1} <br />", HttpUtility.HtmlEncode(GetSenderName(m.SenderId)), HttpUtility.HtmlEncode(m.Content));
            }

            PinnedMessages.Text = sb.ToString();
            // Show container and hide placeholder on client
            var showScript = "<script>$(function(){ $('#pinnedPlaceholder').hide(); $('#pinnedContainer').show(); });</script>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "pinnedShow", showScript);
        }

        private void LoadChatHistory()
        {
            var chatService = new Services.ChatService();
            var messages = chatService.GetChatHistory(null);
            if (messages == null || messages.Count == 0)
            {
                // No messages - leave placeholder visible
                discussion.InnerHtml = string.Empty;
                var script = "<script>$(function(){ $('#messagesPlaceholder').show(); });</script>";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "messagesPlaceholder", script);
                return;
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            foreach (var m in messages)
            {
                sb.AppendFormat("<li><strong>{0}</strong>: {1} <small>{2}</small></li>", HttpUtility.HtmlEncode(GetSenderName(m.SenderId)), HttpUtility.HtmlEncode(m.Content), m.Timestamp.ToString("hh:mm tt"));
            }
            discussion.InnerHtml = sb.ToString();
            // Hide placeholder after populating
            var hideScript = "<script>$(function(){ $('#messagesPlaceholder').hide(); });</script>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "messagesHide", hideScript);
        }

        // Placeholder - replace with real user lookup
        private string GetSenderName(int senderId)
        {
            switch (senderId)
            {
                case 1: return "John";
                case 2: return "Alex";
                case 3: return "Beki";
                case 4: return "Tesfa";
                case 5: return "Sefan";
                default: return "User" + senderId;
            }
        }
    }
}