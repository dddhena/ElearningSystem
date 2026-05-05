using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using ElearningApplication.Models;

namespace ElearningApplication.Services
{
    public class ChatService
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"]?.ConnectionString;

        public void SaveMessage(Message msg)
        {
            if (string.IsNullOrEmpty(connectionString))
            {
                System.Diagnostics.Debug.WriteLine("SaveMessage: missing connection string 'DefaultConnection'. Message not saved.");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "INSERT INTO Messages (SenderId, CourseId, Content, Timestamp, IsPinned, IsRead) VALUES (@SenderId, @CourseId, @Content, @Timestamp, @IsPinned, @IsRead)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SenderId", msg.SenderId);
                    cmd.Parameters.AddWithValue("@CourseId", (object)msg.CourseId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Content", msg.Content ?? string.Empty);
                    cmd.Parameters.AddWithValue("@Timestamp", msg.Timestamp);
                    cmd.Parameters.AddWithValue("@IsPinned", msg.IsPinned);
                    cmd.Parameters.AddWithValue("@IsRead", msg.IsRead);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException sqlEx)
            {
                // Log SQL exceptions for diagnosis
                System.Diagnostics.Debug.WriteLine($"SaveMessage SQL error: {sqlEx.Message}");
            }
            catch (Exception ex)
            {
                // Log any other exception
                System.Diagnostics.Debug.WriteLine($"SaveMessage error: {ex}");
            }
        }

        public List<Message> GetChatHistory(int? courseId)
        {
            var messages = new List<Message>();

            if (string.IsNullOrEmpty(connectionString))
            {
                System.Diagnostics.Debug.WriteLine("GetChatHistory: missing connection string 'DefaultConnection'. Returning empty list.");
                return messages;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Messages WHERE CourseId IS NULL OR CourseId = @CourseId ORDER BY Timestamp ASC";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@CourseId", (object)courseId ?? DBNull.Value);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            messages.Add(new Message
                            {
                                MessageId = reader.GetInt32(reader.GetOrdinal("MessageId")),
                                SenderId = reader.GetInt32(reader.GetOrdinal("SenderId")),
                                CourseId = reader.IsDBNull(reader.GetOrdinal("CourseId")) ? (int?)null : reader.GetInt32(reader.GetOrdinal("CourseId")),
                                Content = reader["Content"].ToString(),
                                Timestamp = reader.GetDateTime(reader.GetOrdinal("Timestamp")),
                                IsPinned = reader.GetBoolean(reader.GetOrdinal("IsPinned")),
                                IsRead = reader.GetBoolean(reader.GetOrdinal("IsRead"))
                            });
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                System.Diagnostics.Debug.WriteLine($"GetChatHistory SQL error: {sqlEx.Message}");
                // swallow and return empty list so page doesn't crash during debugging
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"GetChatHistory error: {ex}");
            }

            return messages;
        }
    }
}
