<%@ WebHandler Language="C#" Class="LoginPage" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class LoginPage : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        //string email = context.Request.Form["item1"];
        //string password = context.Request.Form["item2"];
        string email ="percyku19@gmail.com";
        string password = "qwerty";

        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        con.Open();
        String sqlcmd = "SELECT * FROM Member_Table WHERE (email = '" + email + "') AND (password = '" + password + "')";
        SqlCommand cmd = new SqlCommand(sqlcmd, con);
        SqlDataReader reader = cmd.ExecuteReader();
        if (reader.Read())
        {
            // context.Response.Write(reader[1].ToString()+","+reader[1].ToString()+","+reader[2].ToString()+","+reader[3].ToString()+","+reader[4].ToString()+","+reader[4].ToString());
            //int id = reader.GetOrdinal("sn");
            context.Response.Write(reader[1].ToString()+""+reader[2].ToString()+","+reader[3].ToString()+","+reader[4].ToString()+","+reader[5].ToString()+","+reader[6].ToString());
        }
        else
            context.Response.Write("no");

        reader.Close();
        reader.Dispose();
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}