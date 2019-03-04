<%@ WebHandler Language="C#" Class="UpdateMemberDataV3" %>


using System;
using System.Web;
using System.Data.SqlClient;
public class UpdateMemberDataV3 : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string email = context.Request.Form["item1"];
        string new_Email = context.Request.Form["item2"];
        string name = context.Request.Form["item3"];
        string sex = context.Request.Form["item4"];
        string character = context.Request.Form["item5"];
        string image= context.Request.Form["item6"];
        string send_id = context.Request.Form["item7"];

       /* string email="Test@gmail.com";
        string new_Email="Test123@gmail.com";
        string name="123";
        string sex="True";
        string character ="True";
        string send_id="c2TjICFsbSE:APA91bF6hf9HKcjztLzhG-voBhzzUteqqLbMjaLdlFnzmVEwHMMjkY5OQWFvXm-KIYNJ5TC0KM8eGDd1o9yB5fW-LRlE8v7oUk-zQjcthaukdvq3p7eU5nOX4cwQd_QYxieKbNw-h8ja";
        */


        //先判斷是否有這筆使用者資料 (email)
        string selectCMD1 = "SELECT * FROM Member_Table WHERE email='" + email + "';";
        string selectCMD2 = "SELECT * FROM Member_Table WHERE email='" + new_Email + "';";
        SqlConnection con1 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
        con1.Open();
        SqlCommand cmd1 = new SqlCommand(selectCMD1, con1);
        SqlDataReader reader1 = cmd1.ExecuteReader();
        //有的話 (email)
        if (reader1.Read())
        {
            int intid = Convert.ToInt32(reader1[0].ToString());

            reader1.Close();
            reader1.Dispose();
            //第二次判斷new_Email的狀態
            SqlConnection con2 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            con2.Open();
            SqlCommand cmd2 = new SqlCommand(selectCMD2, con2);
            SqlDataReader reader2 = cmd2.ExecuteReader();
            //假如資料庫有new_Email的狀態
            if (reader2.Read())
            {
                reader2.Close();
                reader2.Dispose();
                //假如有新的email與舊的email一樣，表示email沒更新，直接修改會員內容
                if (email.Equals(new_Email))
                {
                    string queryCMD = "UPDATE Member_Table SET  email = @new_Email," + "name = @name," + "image = @image,"+ "sex = @sex," + "character = @character,"+ "send_id = @send_id" + " WHERE sn = " + intid;

                    SqlConnection con3 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
                    con3.Open();
                    SqlCommand cmd3 = new SqlCommand(queryCMD, con3);
                    cmd3.Connection = con3;
                    cmd3.Parameters.AddWithValue("@new_Email", new_Email);
                    cmd3.Parameters.AddWithValue("@name", name);
                    cmd3.Parameters.AddWithValue("@image", image);
                    if (sex.Equals("True"))
                        cmd3.Parameters.AddWithValue("@sex", true);
                    else
                        cmd3.Parameters.AddWithValue("@sex", false);

                    if (character.Equals("True"))
                        cmd3.Parameters.AddWithValue("@character", true);
                    else
                        cmd3.Parameters.AddWithValue("@character", false);
                    cmd3.Parameters.AddWithValue("@send_id", send_id);
                    cmd3.ExecuteNonQuery();
                    cmd3.Dispose();
                    con3.Close();
                    con3.Dispose();//歸還記憶體
                    context.Response.Write("ok");
                }
                //假如資料庫裡有new_Email又與舊的不同，表示使用者有更新email，但是是有註冊過的
                else
                {
                    context.Response.Write("註冊過了");

                }
            }
            //假如資料庫裡完全沒有new_Email，表示是全新的資料
            else
            {
                reader2.Close();
                reader2.Dispose();
                string queryCMD = "UPDATE Member_Table SET  email = @new_Email," + "name = @name,"  + "image = @image,"+ "sex = @sex," + "character = @character,"+ "send_id = @send_id" + " WHERE sn = " + intid;

                SqlConnection con3 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
                con3.Open();
                SqlCommand cmd3 = new SqlCommand(queryCMD, con3);
                cmd3.Connection = con3;
                cmd3.Parameters.AddWithValue("@new_Email", new_Email);
                cmd3.Parameters.AddWithValue("@name", name);
                cmd3.Parameters.AddWithValue("@image", image);

                if (sex.Equals("True"))
                    cmd3.Parameters.AddWithValue("@sex", true);
                else
                    cmd3.Parameters.AddWithValue("@sex", false);
                if (character.Equals("True"))
                    cmd3.Parameters.AddWithValue("@character", true);
                else
                    cmd3.Parameters.AddWithValue("@character", false);

                cmd3.Parameters.AddWithValue("@send_id", send_id);
                cmd3.ExecuteNonQuery();
                cmd3.Dispose();
                con3.Close();
                con3.Dispose();//歸還記憶體
                context.Response.Write("ok");
            }



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