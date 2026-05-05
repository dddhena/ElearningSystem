using System;

namespace ElearningApplication.Models
{
    public class Message
    {
        public int MessageId { get; set; }
        public int SenderId { get; set; }
        public int? CourseId { get; set; } // Nullable until course functionality added
        public string Content { get; set; }
        public DateTime Timestamp { get; set; }
        public bool IsPinned { get; set; }
        public bool IsRead { get; set; }
    }
}
