using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ElearningApplication.View.Instructor
{
    public partial class ManageAssessmentQuestions : System.Web.UI.Page
    {
        int _assessmentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
            {
                Response.Redirect("~/View/Account/Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out _assessmentId))
            {
                Response.Redirect("~/View/Instructor/ManageAssessments.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssessmentTitle();
            }
        }

        private void LoadAssessmentTitle()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Title FROM Assessments WHERE AssessmentId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", _assessmentId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        lblAssessmentTitle.Text = result.ToString();
                    }
                }
            }
        }

        protected void ddlQuestionType_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlMultipleChoice.Visible = false;
            pnlTrueFalse.Visible = false;
            pnlShortAnswer.Visible = false;

            if (ddlQuestionType.SelectedValue == "MultipleChoice") pnlMultipleChoice.Visible = true;
            else if (ddlQuestionType.SelectedValue == "TrueFalse") pnlTrueFalse.Visible = true;
            else if (ddlQuestionType.SelectedValue == "ShortAnswer") pnlShortAnswer.Visible = true;
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string qType = ddlQuestionType.SelectedValue;
            string correctAnswer = "";
            string optA = null, optB = null, optC = null, optD = null;

            if (qType == "MultipleChoice")
            {
                optA = txtOptionA.Text;
                optB = txtOptionB.Text;
                optC = txtOptionC.Text;
                optD = txtOptionD.Text;
                correctAnswer = ddlCorrectMC.SelectedValue;
            }
            else if (qType == "TrueFalse")
            {
                correctAnswer = ddlCorrectTF.SelectedValue;
            }
            else if (qType == "ShortAnswer")
            {
                correctAnswer = txtCorrectSA.Text;
            }

            string connStr = ConfigurationManager.ConnectionStrings["ElearningDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO AssessmentQuestions 
                                (AssessmentId, QuestionText, QuestionType, OptionA, OptionB, OptionC, OptionD, CorrectAnswer, Marks) 
                                VALUES (@AssessmentId, @Text, @Type, @A, @B, @C, @D, @Correct, @Marks)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AssessmentId", _assessmentId);
                    cmd.Parameters.AddWithValue("@Text", txtQuestionText.Text);
                    cmd.Parameters.AddWithValue("@Type", qType);
                    cmd.Parameters.AddWithValue("@A", (object)optA ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@B", (object)optB ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@C", (object)optC ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@D", (object)optD ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Correct", correctAnswer);
                    cmd.Parameters.AddWithValue("@Marks", int.Parse(txtMarks.Text));

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Clear form
            txtQuestionText.Text = "";
            txtOptionA.Text = ""; txtOptionB.Text = ""; txtOptionC.Text = ""; txtOptionD.Text = "";
            txtCorrectSA.Text = "";
            gvQuestions.DataBind();
        }
    }
}
