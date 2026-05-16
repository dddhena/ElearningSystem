    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Live Chat</title>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; margin: 0; padding: 0; }
            .chat-container { max-width: 1000px; margin: 20px auto; background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); display: flex; height: 80vh; overflow: hidden; }
            .sidebar { width: 250px; border-right: 1px solid #ddd; display: flex; flex-direction: column; background: #f8f9fa; }
            .sidebar-header { padding: 20px; font-weight: bold; border-bottom: 1px solid #ddd; background: #6366f1; color: white; }
            .user-list { flex-grow: 1; overflow-y: auto; padding: 10px; }
            .user-item { padding: 10px; border-radius: 8px; margin-bottom: 5px; cursor: pointer; transition: background 0.2s; display: flex; align-items: center; gap: 10px; }
            .user-item:hover { background: #e9ecef; }
            .status-dot { width: 10px; height: 10px; border-radius: 50%; background: #22c55e; }
            
            .main-chat { flex-grow: 1; display: flex; flex-direction: column; }
            .chat-header { padding: 15px 25px; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; background: #fff; }
            .messages-area { flex-grow: 1; overflow-y: auto; padding: 20px; background: #fdfdfd; display: flex; flex-direction: column; gap: 10px; }
            
            .message { max-width: 70%; padding: 10px 15px; border-radius: 18px; position: relative; font-size: 0.95rem; line-height: 1.4; }
            .message.received { align-self: flex-start; background: #e9ecef; border-bottom-left-radius: 4px; }
            .message.sent { align-self: flex-end; background: #6366f1; color: white; border-bottom-right-radius: 4px; }
            .message-info { font-size: 0.7rem; margin-bottom: 4px; color: #666; }
            .sent .message-info { color: #e0e0e0; text-align: right; }
            
            .input-area { padding: 20px; border-top: 1px solid #ddd; display: flex; gap: 10px; background: #fff; }
            #txtMessage { flex-grow: 1; padding: 12px; border: 1px solid #ddd; border-radius: 25px; outline: none; transition: border 0.2s; }
            #txtMessage:focus { border-color: #6366f1; }
            #btnSend { background: #6366f1; color: white; border: none; padding: 10px 25px; border-radius: 25px; cursor: pointer; font-weight: bold; transition: background 0.2s; }
            #btnSend:hover { background: #4f46e5; }
            
            .back-btn { text-decoration: none; color: #6366f1; font-weight: bold; font-size: 0.9rem; }
        </style>
    </head>
    <body>
        <form id="form1" runat="server">
            <div class="chat-container">
                <div class="sidebar">
                    <div class="sidebar-header">Online Users</div>
                    <div class="user-list">
                        <asp:Repeater ID="rptOnlineUsers" runat="server">
                            <ItemTemplate>
                                <div class="user-item">
                                    <div class="status-dot"></div>
                                    <span><%# Eval("FirstName") %> <%# Eval("LastName") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                
                <div class="main-chat">
                    <div class="chat-header">
                        <asp:LinkButton ID="btnBack" runat="server" OnClick="Button1_Click" CssClass="back-btn">← Back to Course</asp:LinkButton>
                        <span style="font-weight: bold;"><asp:Literal ID="litCourseName" runat="server"></asp:Literal></span>
                        <div style="width: 100px;"></div>
                    </div>
                    
                    <div id="messagesArea" class="messages-area">
                        <!-- Messages will be loaded here via AJAX -->
                    </div>
                    
                    <div class="input-area">
                        <input type="text" id="txtMessage" placeholder="Type a message..." autocomplete="off" />
                        <button type="button" id="btnSend">Send</button>
                    </div>
                </div>
            </div>
            
            <asp:HiddenField ID="hfUserId" runat="server" />
            <asp:HiddenField ID="hfCourseId" runat="server" />
        </form>

        <script>
            var lastMessageId = 0;
            var courseId = $('#<%= hfCourseId.ClientID %>').val();
            var userId = $('#<%= hfUserId.ClientID %>').val();

            $(document).ready(function () {
                loadMessages();
                
                // Poll for new messages every 3 seconds
                setInterval(loadMessages, 3000);

                $('#btnSend').click(function () {
                    sendMessage();
                });

                $('#txtMessage').keypress(function (e) {
                    if (e.which == 13) {
                        sendMessage();
                        return false;
                    }
                });
            });

            function loadMessages() {
                $.ajax({
                    type: "POST",
                    url: "LiveChat.aspx/GetMessages",
                    data: JSON.stringify({ courseId: courseId, lastId: lastMessageId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var messages = response.d;
                        if (messages.length > 0) {
                            messages.forEach(function (msg) {
                                var isMe = msg.SenderId == userId;
                                var msgClass = isMe ? 'sent' : 'received';
                                var html = '<div class="message ' + msgClass + '">' +
                                           '<div class="message-info">' + (isMe ? 'Me' : msg.SenderName) + ' • ' + msg.Time + '</div>' +
                                           '<div>' + msg.Content + '</div>' +
                                           '</div>';
                                $('#messagesArea').append(html);
                                lastMessageId = msg.MessageId;
                            });
                            scrollToBottom();
                        }
                    }
                });
            }

            function sendMessage() {
                var content = $('#txtMessage').val().trim();
                if (content === "") return;

                $.ajax({
                    type: "POST",
                    url: "LiveChat.aspx/SendMessage",
                    data: JSON.stringify({ courseId: courseId, content: content }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function () {
                        $('#txtMessage').val('');
                        loadMessages(); // Fetch the message we just sent
                    }
                });
            }

            function scrollToBottom() {
                var area = document.getElementById('messagesArea');
                area.scrollTop = area.scrollHeight;
            }
        </script>
    </body>
    </html>