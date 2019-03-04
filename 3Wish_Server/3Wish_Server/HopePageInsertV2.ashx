<%@ WebHandler Language="C#" Class="HopePageInsertV2" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class HopePageInsertV2 : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string wish_email =context.Request.Form["item1"];
        string wish_lat =context.Request.Form["item2"];
        string wish_long = context.Request.Form["item3"];
        string wish_content =context.Request.Form["item4"];
        string wish_note = context.Request.Form["item5"];
        string wish_type = context.Request.Form["item6"];

       
        /*string wish_email = "Samsung@gmail.com";
        string wish_lat ="24.900732846116778";
        string wish_long = "120.98492547869684";
        string wish_content = "我想去辦兵役，但是不知道詳鄉公所的週邊幻境如何";
        string wish_note = "";
        string wish_type = "1";*/



        int member_sn;
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        con.Open();
        string selectCMD = "SELECT * FROM Member_Table WHERE email='" + wish_email + "';";
        string insertCMD = "insert into Wish_Table(member_sn,wish_lat,wish_long,wish_content,wish_note,wish_type,wish_state) values(@member_sn,@wish_lat,@wish_long,@wish_content,@wish_note,@wish_type,@wish_state)";
        SqlCommand cmd = new SqlCommand(selectCMD, con);
        SqlDataReader reader = cmd.ExecuteReader();
        if (reader.Read())
        {
            member_sn  = Convert.ToInt32(reader[0].ToString()); 
           
            reader.Close();
            reader.Dispose();



            SqlConnection con1 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            con1.Open();
            SqlCommand  cmd1 = new SqlCommand(insertCMD, con1);
            cmd1.Connection = con;
            cmd1.Parameters.AddWithValue("@member_sn", member_sn);            
            cmd1.Parameters.AddWithValue("@wish_lat", wish_lat);
            cmd1.Parameters.AddWithValue("@wish_long", wish_long);
            cmd1.Parameters.AddWithValue("@wish_content", wish_content);
            cmd1.Parameters.AddWithValue("@wish_note", wish_note);
            cmd1.Parameters.AddWithValue("@wish_type", wish_type);
            cmd1.Parameters.AddWithValue("@wish_state", true);

            cmd1.ExecuteNonQuery();
            cmd1.Dispose();
            con1.Close();
            con1.Dispose();


            context.Response.Write("ok");
        }
        else
        {
            context.Response.Write("no");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}