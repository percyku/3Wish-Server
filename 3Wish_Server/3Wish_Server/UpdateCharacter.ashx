<%@ WebHandler Language="C#" Class="UpdateCharacter" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class UpdateCharacter : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string email = context.Request.Form["item1"];
        string character = context.Request.Form["item2"];
        string send_id = context.Request.Form["item3"];

        //string email="Asus@gmail.com";
        //string character="True";
        //string send_id="c2TjICFsbSE:12312337583745337537853758373-voBhzzUteqqLbMjaLdlFnzmVEwHMMjkY5OQWFvXm-KIYNJ5TC0KM8eGDd1o9yB5fW-LRlE8v7oUk-zQjcthaukdvq3p7eU5nOX4cwQd_QYxieKbNw-h8ja";
        //string send_id1="c2TjICFsbSE:APA91bF6hf9HKcjztLzhG-voBhzzUteqqLbMjaLdlFnzmVEwHMMjkY5OQWFvXm-KIYNJ5TC0KM8eGDd1o9yB5fW-LRlE8v7oUk-zQjcthaukdvq3p7eU5nOX4cwQd_QYxieKbNw-h8ja";
       //c2TjICFsbSE:12312337583745337537853758373-voBhzzUteqqLbMjaLdlFnzmVEwHMMjkY5OQWFvXm-KIYNJ5TC0KM8eGDd1o9yB5fW-LRlE8v7oUk-zQjcthaukdvq3p7eU5nOX4cwQd_QYxieKbNw-h8ja
       //fZ1gl701250:APA91bERAt5-NjrX4ZYbn9VDQ8Db5mgzxTKspYcQ0frFSAwPcujGGvPwUSD5nGDLT6KzJHyooaczGFp6BVzwapJGo4AqUDLaevpqjsAHr48NXSmhxlsAUyWrbNgxxNjIJq2CdvaGbiAn
                string selectCMD = "SELECT * FROM Member_Table WHERE email='" + email + "';";
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand(selectCMD, con);
        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.Read())
        {
            int intid = Convert.ToInt32(reader[0].ToString());
            reader.Close();
            reader.Dispose();
            string queryCMD = "UPDATE Member_Table SET  character = @character,"+"send_id = @send_id" + " WHERE sn = " + intid;
            SqlConnection con1 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            con1.Open();
            SqlCommand  cmd1 = new SqlCommand(queryCMD, con1);
             if (character.Equals("True"))
                cmd1.Parameters.AddWithValue("@character", true);
            else
                cmd1.Parameters.AddWithValue("@character", false);
            cmd1.Parameters.AddWithValue("@send_id", send_id);
            cmd1.ExecuteNonQuery();
            cmd1.Dispose();
            con1.Close();
            con1.Dispose();//歸還記憶體
            context.Response.Write(character);
        }

         else
        {
            reader.Close();
            reader.Dispose();
            context.Response.Write("no");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}