using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElearningApplication.View.Feedback
{
    public partial class SubmitFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ListView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        protected void submitreviewbtn_Click(object sender, EventArgs e)
        {

        }
        protected void RatingStars_Changed(object sender, AjaxControlToolkit.RatingEventArgs e)
        {
            // The rating value is automatically captured
            // You can access it using RatingStars.CurrentRating
            int rating = RatingStars.CurrentRating;

            // Optional: Store in Session for later use
            Session["SelectedRating"] = rating;
        }

    }
}