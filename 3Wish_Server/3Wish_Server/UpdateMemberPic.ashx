<%@ WebHandler Language="C#" Class="UpdateMemberPic" %>

using System;
using System.Web;
using System.Data.SqlClient;


public class UpdateMemberPic : IHttpHandler {
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
         //string sn = context.Request.Form["item1"];
         //string image = context.Request.Form["item2"];
        string sn = "3004";
        string image ="18BDq24v4IrQjVZq9tC1n0kxTqXuL3_Sn";

        string selectCMD1 = "SELECT * FROM Member_Table WHERE sn='" + sn + "';";

        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        SqlCommand cmd1 = new SqlCommand(selectCMD1, con);
        con.Open();
        SqlDataReader reader1 = cmd1.ExecuteReader();
        //有的話 (email)
        if (reader1.Read())
        {
            reader1.Close();
            reader1.Dispose();
            //cmd1.Dispose();


            string queryCMD = "UPDATE Member_Table SET  image = @image" + " WHERE sn = " + sn;
            SqlCommand cmd2 = new SqlCommand(queryCMD, con);
            cmd2.Parameters.AddWithValue("@image", image);
            cmd2.ExecuteNonQuery();
            cmd2.Dispose();
            con.Close();
            con.Dispose();//歸還記憶體
            context.Response.Write("ok");

        }else
        {
            context.Response.Write("not find");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}