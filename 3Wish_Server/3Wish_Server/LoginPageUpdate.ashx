<%@ WebHandler Language="C#" Class="LoginPageUpdate" %>

using System;
using System.Web;
using System.Data.SqlClient;


public class LoginPageUpdate : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";


       /* string email = context.Request.Form["item1"];
        string password = context.Request.Form["item2"];
        string send_id = context.Request.Form["item3"];*/
        string email = "percyku19@gmail.com";
        string password = "123456";
        string send_id = " 123123";
        //string send_id = " c2TjICFsbSE:APA91bF6hf9HKcjztLzhG-voBhzzUteqqLbMjaLdlFnzmVEwHMMjkY5OQWFvXm-KIYNJ5TC0KM8eGDd1o9yB5fW-LRlE8v7oUk-zQjcthaukdvq3p7eU5nOX4cwQd_QYxieKbNw-h8ja";
        //string send_id2 = " 3p5PqVQ9Ybr29QlLlxwQTsu60o0NfrUtw9U5tZnxV1pL2cK6rhzvXEIZ0yATz4zSMHu8bkfj__dGXEtDU8HLhKUxQRpJ1e21KxxWlR53tK6Y2jGWLZeBNzX";*/

        
        String selectCMD = "SELECT * FROM Member_Table WHERE (email = '" + email + "') AND (password = '" + password + "')";
        //string selectCMD = "SELECT * FROM Member_Table WHERE email='" + email + "';";

        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand(selectCMD, con);
        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.Read())
        {
            // Session["username"] = reader.GetString(0);
            // Session["usersn"] = reader.GetInt32(2);
            //Response.Redirect("home.aspx");
            String[] reasponStr=new String[] {reader[0].ToString(),reader[1].ToString(),reader[2].ToString(),reader[3].ToString(),reader[4].ToString(),reader[5].ToString(),reader[6].ToString() };
            int intid = Convert.ToInt32(reader[0].ToString());
            reader.Close();
            reader.Dispose();
            string queryCMD = "UPDATE Member_Table SET send_id = @send_id" + " WHERE sn = " + intid;
            SqlConnection con1 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
          
            SqlCommand  cmd1 = new SqlCommand(queryCMD, con1);
            con1.Open();
            cmd1.Parameters.AddWithValue("@send_id", send_id);
            cmd1.ExecuteNonQuery();
            cmd1.Dispose();
            con1.Close();
            con1.Dispose();//歸還記憶體
            context.Response.Write(reasponStr[0]+","+reasponStr[1]+","+reasponStr[2]+","+reasponStr[3]+","+reasponStr[4]+","+reasponStr[5]+","+reasponStr[6]);

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