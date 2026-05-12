using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Drawing;

namespace ElearningApplication.View.Account
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Button1_Click1(object sender, EventArgs e)
        {
            string firstNameValue = txtFirstName.Text.Trim();
            string lastNameValue  = txtLastName.Text.Trim();
            string emailValue     = txtEmail.Text.Trim();
            string passwordValue  = txtPassword.Text.Trim();

            // --- Validation ---
            if (string.IsNullOrEmpty(firstNameValue) ||
                string.IsNullOrEmpty(lastNameValue)  ||
                string.IsNullOrEmpty(emailValue)     ||
                string.IsNullOrEmpty(passwordValue))
            {
                lblMessage.ForeColor = Color.Red;
                lblMessage.Text = "⚠ All fields are required. Please fill in every field.";
                return;
            }

            // --- Database Insert ---
            string connString = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO Users (Email, PasswordHash, FirstName, LastName, Role, IsActive)
                                 VALUES (@Email, @Password, @FirstName, @LastName, @Role, 1)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email",     emailValue);
                    cmd.Parameters.AddWithValue("@Password",  passwordValue); // Hash in production!
                    cmd.Parameters.AddWithValue("@FirstName", firstNameValue);
                    cmd.Parameters.AddWithValue("@LastName",  lastNameValue);
                    cmd.Parameters.AddWithValue("@Role",      "Student");

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // Success — show message then redirect after 2 seconds
                        lblMessage.ForeColor = Color.Green;
                        lblMessage.Text = "✔ Registration successful! Redirecting to login...";

                        // Redirect to Login page
                        Response.AddHeader("Refresh", "2;URL=Login.aspx");
                    }
                    catch (SqlException ex)
                    {
                        // Error number 2627 = Unique constraint violation (duplicate email)
                        if (ex.Number == 2627 || ex.Number == 2601)
                        {
                            lblMessage.ForeColor = Color.Red;
                            lblMessage.Text = "✖ This email address is already registered. Please use a different email.";
                        }
                        else
                        {
                            lblMessage.ForeColor = Color.Red;
                            lblMessage.Text = "✖ Registration failed: " + ex.Message;
                        }
                    }
                }
            }
        }

        protected void TextBox1_TextChanged(object sender, EventArgs e) { }
        protected void TextBox2_TextChanged(object sender, EventArgs e) { }
    }
}
