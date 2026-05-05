using System;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;
using ElearningApplication.Models;
using ElearningApplication.Services;

namespace ElearningApplication.Hubs
{
    public class ChatHub : Hub
    {
        private readonly ChatService _chatService = new ChatService();

        public void SendMessage(int senderId, int? courseId, string content)
        {
            var message = new Message
            {
                SenderId = senderId,
                CourseId = courseId,
                Content = content,
                Timestamp = DateTime.Now,
                IsPinned = false,
                IsRead = false
            };

            // Save to database
            _chatService.SaveMessage(message);

            // Broadcast to all clients
            Clients.All.broadcastMessage(senderId, content, message.Timestamp.ToString("hh:mm tt"));
        }

        public void PinMessage(int messageId)
        {
            // Logic to pin message in DB and notify clients
            Clients.All.messagePinned(messageId);
        }
    }
}
