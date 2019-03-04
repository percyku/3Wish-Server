<%@ WebHandler Language="C#" Class="ForgetPasswords" %>


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Data;
using System.Data.SqlClient;
public class ForgetPasswords : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        // string email="percyku19@gmail.com ";
         string email = context.Request.Form["item1"];
         SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
         con.Open();
         string selectCMD = "SELECT * FROM Member_Table WHERE email='" + email + "';";
         SqlCommand cmd = new SqlCommand(selectCMD, con);
       
         SqlDataReader reader = cmd.ExecuteReader();
         if (reader.Read())
        {
            // Session["username"] = reader.GetString(0);
            // Session["usersn"] = reader.GetInt32(2);
            //Response.Redirect("home.aspx");
            int intid = Convert.ToInt32(reader[0].ToString());
            reader.Close();
            reader.Dispose();
            Random r = new Random();
            string newP = "000000";
            newP = genPass(6);
            byte[] new_MD5 = genCyp(newP);
           //update member new_MD5
            string from = "Your email";
            string from_pw = "Your passwords";
            string to = email;
            string subject = to + "的新密碼";
            string content = "<h1>" + to + "的新密碼" + newP + "</h1>";

            MailMessage m = new MailMessage(from, to, subject, content);
            m.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient();
            smtp.Host = "smtp.gmail.com";
            smtp.Port = 587;
            smtp.EnableSsl = true;
            NetworkCredential c = new NetworkCredential(from, from_pw);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = c;
            smtp.Send(m);

            string queryCMD = "UPDATE Member_Table SET  password = @password"  + " WHERE sn = " + intid;
            SqlConnection con1 = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(queryCMD, con1);
            cmd1.Connection = con1;
            cmd1.Parameters.AddWithValue("@password", newP);
            cmd1.ExecuteNonQuery();
            cmd1.Dispose();
            con1.Close();
            con1.Dispose();//歸還記憶體
            context.Response.Write("ok");

          
        
            context.Response.Write(newP);
      
        }
        else
        {
            reader.Close();
            reader.Dispose();
           


            context.Response.Write("not found");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }


    private String genPass(int len)
    {
        String s = "";
        String pool = "0123456789abcdefghijllmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        int PL = pool.Length;

        Random r = new Random();
        for (int i = 0; i < len;i++ )
        {
            int ii=r.Next(PL);
            String s1 = pool.Substring(ii, 1);
            s = s + s1;
        }
        
        return s;
    }
       private byte[] genCyp(string msg)
    {
        byte[] hc;
        MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
        UTF8Encoding en = new UTF8Encoding();
        hc = provider.ComputeHash(en.GetBytes(msg));
        return hc;//DB中要把密碼欄位改成binary
    }

}