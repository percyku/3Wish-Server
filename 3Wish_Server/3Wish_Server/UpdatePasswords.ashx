<%@ WebHandler Language="C#" Class="UpdatePasswords" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class UpdatePasswords : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string email = context.Request.Form["item1"];
        string password = context.Request.Form["item2"];
        string new_Password = context.Request.Form["item3"];
        string send_id = context.Request.Form["item4"];
        String selectCMD = "SELECT * FROM Member_Table WHERE (email = '" + email + "') AND (password = '" + password + "')";
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand(selectCMD, con);
        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();
        if (reader.Read())
        {
            int intid = Convert.ToInt32(reader[0].ToString());
            reader.Close();
            reader.Dispose();
            string queryCMD = "UPDATE Member_Table SET  password = @new_Password,"  + "send_id = @send_id" + " WHERE sn = " + intid;

            SqlConnection con3 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            con3.Open();
            SqlCommand cmd3 = new SqlCommand(queryCMD, con3);
            cmd3.Connection = con3;
            cmd3.Parameters.AddWithValue("@new_Password", new_Password);
            cmd3.Parameters.AddWithValue("@send_id", send_id);
            cmd3.ExecuteNonQuery();
            cmd3.Dispose();
            con3.Close();
            con3.Dispose();//歸還記憶體
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