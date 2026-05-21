using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Assignment_and_assessment
{
    public partial class TakeAssessment : System.Web.UI.Page
    {
        int _assessmentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out _assessmentId))
            {
                Response.Redirect("~/View/Assignment and assessment/AssessmentsList.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CheckSubmissionStatus();
            }
        }

        private void CheckSubmissionStatus()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Status, Score FROM AssessmentSubmissions WHERE AssessmentId = @AssessmentId AND UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AssessmentId", _assessmentId);
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string status = reader["Status"].ToString();
                            if (status == "Submitted" || status == "Graded")
                            {
                                pnlQuestions.Visible = false;
                                pnlResult.Visible = true;
                                lblScore.Text = reader["Score"].ToString();
                                return;
                            }
                        }
                    }
                }
            }

            LoadAssessmentDetails();
            LoadQuestions();
        }

        private void LoadAssessmentDetails()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Title, Description, DurationMinutes FROM Assessments WHERE AssessmentId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", _assessmentId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTitle.Text = reader["Title"].ToString();
                            lblDescription.Text = reader["Description"].ToString();
                            lblDuration.Text = reader["DurationMinutes"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadQuestions()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM AssessmentQuestions WHERE AssessmentId = @AssessmentId";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    da.SelectCommand.Parameters.AddWithValue("@AssessmentId", _assessmentId);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptQuestions.DataSource = dt;
                    rptQuestions.DataBind();
                }
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfQuestionType = (HiddenField)e.Item.FindControl("hfQuestionType");
                string qType = hfQuestionType.Value;

                if (qType == "MultipleChoice")
                {
                    e.Item.FindControl("rblMultipleChoice").Visible = true;
                }
                else if (qType == "TrueFalse")
                {
                    e.Item.FindControl("rblTrueFalse").Visible = true;
                }
                else if (qType == "ShortAnswer")
                {
                    e.Item.FindControl("txtShortAnswer").Visible = true;
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int totalScore = 0;
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();
                try
                {
                    // Create or Update Submission Record
                    int submissionId = 0;
                    string checkSubQuery = "SELECT SubmissionId FROM AssessmentSubmissions WHERE AssessmentId = @AssessmentId AND UserId = @UserId";
                    using (SqlCommand checkCmd = new SqlCommand(checkSubQuery, conn, transaction))
                    {
                        checkCmd.Parameters.AddWithValue("@AssessmentId", _assessmentId);
                        checkCmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                        object result = checkCmd.ExecuteScalar();
                        if (result != null)
                        {
                            submissionId = (int)result;
                        }
                        else
                        {
                            string insertSubQuery = "INSERT INTO AssessmentSubmissions (AssessmentId, UserId, Status) OUTPUT INSERTED.SubmissionId VALUES (@AssessmentId, @UserId, 'InProgress')";
                            using (SqlCommand insertCmd = new SqlCommand(insertSubQuery, conn, transaction))
                            {
                                insertCmd.Parameters.AddWithValue("@AssessmentId", _assessmentId);
                                insertCmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                                submissionId = (int)insertCmd.ExecuteScalar();
                            }
                        }
                    }

                    // Process each question
                    foreach (RepeaterItem item in rptQuestions.Items)
                    {
                        HiddenField hfQuestionId = (HiddenField)item.FindControl("hfQuestionId");
                        HiddenField hfQuestionType = (HiddenField)item.FindControl("hfQuestionType");
                        int questionId = int.Parse(hfQuestionId.Value);
                        string qType = hfQuestionType.Value;
                        string givenAnswer = "";

                        if (qType == "MultipleChoice")
                        {
                            givenAnswer = ((RadioButtonList)item.FindControl("rblMultipleChoice")).SelectedValue;
                        }
                        else if (qType == "TrueFalse")
                        {
                            givenAnswer = ((RadioButtonList)item.FindControl("rblTrueFalse")).SelectedValue;
                        }
                        else if (qType == "ShortAnswer")
                        {
                            givenAnswer = ((TextBox)item.FindControl("txtShortAnswer")).Text;
                        }

                        // Check Answer
                        int marksObtained = 0;
                        string checkAnsQuery = "SELECT CorrectAnswer, Marks FROM AssessmentQuestions WHERE QuestionId = @QuestionId";
                        using (SqlCommand checkAnsCmd = new SqlCommand(checkAnsQuery, conn, transaction))
                        {
                            checkAnsCmd.Parameters.AddWithValue("@QuestionId", questionId);
                            using (SqlDataReader reader = checkAnsCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    string correctAns = reader["CorrectAnswer"].ToString();
                                    int maxMarks = (int)reader["Marks"];
                                    if (givenAnswer.Trim().Equals(correctAns.Trim(), StringComparison.OrdinalIgnoreCase))
                                    {
                                        marksObtained = maxMarks;
                                        totalScore += marksObtained;
                                    }
                                }
                            }
                        }

                        // Save Student Answer
                        string insertAnsQuery = "INSERT INTO StudentAnswers (SubmissionId, QuestionId, GivenAnswer, MarksObtained) VALUES (@SubId, @QId, @Ans, @Marks)";
                        using (SqlCommand insertAnsCmd = new SqlCommand(insertAnsQuery, conn, transaction))
                        {
                            insertAnsCmd.Parameters.AddWithValue("@SubId", submissionId);
                            insertAnsCmd.Parameters.AddWithValue("@QId", questionId);
                            insertAnsCmd.Parameters.AddWithValue("@Ans", string.IsNullOrEmpty(givenAnswer) ? (object)DBNull.Value : givenAnswer);
                            insertAnsCmd.Parameters.AddWithValue("@Marks", marksObtained);
                            insertAnsCmd.ExecuteNonQuery();
                        }
                    }

                    // Update Submission Score
                    string updateSubQuery = "UPDATE AssessmentSubmissions SET EndTime = GETDATE(), Status = 'Submitted', Score = @Score WHERE SubmissionId = @SubId";
                    using (SqlCommand updateCmd = new SqlCommand(updateSubQuery, conn, transaction))
                    {
                        updateCmd.Parameters.AddWithValue("@Score", totalScore);
                        updateCmd.Parameters.AddWithValue("@SubId", submissionId);
                        updateCmd.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    
                    pnlQuestions.Visible = false;
                    pnlResult.Visible = true;
                    lblScore.Text = totalScore.ToString();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Response.Write("<script>alert('Error submitting assessment: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
        }
    }
}
