using System;
using System.Drawing;
using System.Web.UI.DataVisualization.Charting;

namespace ElearningApplication.View.Feedback
{
    public partial class MyProgress : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProgressChart();
            }
        }

        private void LoadProgressChart()
        {
            // Clear any existing data
            myCourseprogress.Series["Series1"].Points.Clear();

            // Get your actual progress value (example: from Session or Database)
            int progressValue = 72; // Replace with your actual progress (0-100)

            // Add ONE bar
            myCourseprogress.Series["Series1"].Points.AddY(progressValue);

            // Customize the single bar
            myCourseprogress.Series["Series1"].Points[0].Color = Color.SteelBlue;
            myCourseprogress.Series["Series1"].Points[0].AxisLabel = $"Progress: {progressValue}%";

            // Set Y-axis maximum to 100 for percentage display
            myCourseprogress.ChartAreas[0].AxisY.Maximum = 100;
            myCourseprogress.ChartAreas[0].AxisY.Minimum = 0;

            // Add a data point label on the bar
            myCourseprogress.Series["Series1"].Points[0].Label = $"{progressValue}%";
            myCourseprogress.Series["Series1"].Points[0].LabelForeColor = Color.White;
        }

        // OR if you're using Chart1_Load event:
        protected void Chart1_Load(object sender, EventArgs e)
        {
            LoadProgressChart();
        }

        protected void Chart1_Load1(object sender, EventArgs e)
        {

        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/View/Dashboard/StudentDashboard.aspx");
        }
    }
}