<%@ WebHandler Language="C#" Class="RegisterMemberV2" %>

using System;
using System.Web;
using System.Data.SqlClient;



public class RegisterMemberV2 : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
      /*  string email = context.Request.Form["item1"];
        string password = context.Request.Form["item2"];
        string name = context.Request.Form["item3"];
        string sex = context.Request.Form["item4"];
        string character = context.Request.Form["item5"];
        string send_id = context.Request.Form["item6"];*/
        int member_sn=1;
        string email="jod963855@gmail.com ";
        string password="1123123123";
        string name="123";
        string sex="true";
        string character="false";
        string send_id="c2TjICFsbSE:APA91bF6hf9HKcjztLzhG-voBhzzUteqqLbMjaLdlFnzmVEwHMMjkY5OQWFvXm-KIYNJ5TC0KM8eGDd1o9yB5fW-LRlE8v7oUk-zQjcthaukdvq3p7eU5nOX4cwQd_QYxieKbNw-h8ja";

        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        con.Open();
        string selectCMD = "SELECT email FROM Member_Table WHERE email='" + email + "';";
        string insertCMD = "insert into Member_Table(name,email,password,sex,character,send_id) output Inserted.sn  values(@name,@email,@password,@sex,@character,@send_id)";

        SqlCommand cmd = new SqlCommand(selectCMD, con);
        //cmd.Connection = con;
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.Read())
        {
            // Session["username"] = reader.GetString(0);
            // Session["usersn"] = reader.GetInt32(2);
            //Response.Redirect("home.aspx");
            reader.Close();
            reader.Dispose();
            context.Response.Write("註冊過了");
        }
        else
        {
            reader.Close();
            reader.Dispose();
            SqlConnection con1 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            con1.Open();
            SqlCommand  cmd1 = new SqlCommand(insertCMD, con1);
            cmd1.Connection = con;
            cmd1.Parameters.AddWithValue("@name", name);
            cmd1.Parameters.AddWithValue("@email", email);
            cmd1.Parameters.AddWithValue("@password", password);
            if (sex.Equals("true"))
                cmd1.Parameters.AddWithValue("@sex", true);
            else
                cmd1.Parameters.AddWithValue("@sex", false);

            if (character.Equals("true"))
                cmd1.Parameters.AddWithValue("@character", true);
            else
                cmd1.Parameters.AddWithValue("@character", false);


            cmd1.Parameters.AddWithValue("@send_id", send_id);

            //con1.Open();
            object returnObj = cmd1.ExecuteScalar();
            if (returnObj != null)
            {
               int.TryParse(returnObj.ToString(), out member_sn);
            }

            //cmd1.ExecuteNonQuery();
            cmd1.Dispose();
            con1.Close();
            con1.Dispose();//歸還記憶體


            context.Response.Write("ok,"+member_sn);
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}