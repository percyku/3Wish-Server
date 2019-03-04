<%@ WebHandler Language="C#" Class="AchieveHopeV2" %>

using System;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public class AchieveHopeV2 : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

           //TEST UPLOAD
        string wish_sn = context.Request.Form["item1"];
        string wish_member_sn = context.Request.Form["item2"];
        string help_member_sn = context.Request.Form["item3"];
        string help_url =context.Request.Form["item4"];
        string help_note = context.Request.Form["item5"];
        string help_type = context.Request.Form["item6"];
       /* string wish_sn = "1005";
        string wish_member_sn = "3004";
        string help_member_sn = "3015";
        string help_url = "2,https://docs.google.com/uc?id=0B-RR6-bb-4NAU0YwUVk4RVNxd3c";
        string help_note = "安心上路";
        string help_type = "1";
        */
        string deviceId="";
        string title = "";
        string body = "";
        string click_action = "";
      

        if (help_type.Equals("1"))
        {
            body = "請點開進入圖片";
            click_action = "OPEN_ACTIVITY_1";
        }
        else{

            body = "請點開進入影片";
            click_action = "OPEN_ACTIVITY_2";

        }

        bool mState = false;
        string sResponseFromServer="";
        string selectCMD = "SELECT * FROM Member_Table;";
        string insertCMD = "insert into Help_Table(wish_sn,member_sn,help_url,help_note) values(@wish_sn,@member_sn,@help_url,@help_note)";
        SqlCommand cmd;
        SqlConnection con ;
        using ( con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString))
        {
            con.Open();

            using (cmd = new SqlCommand(selectCMD, con))
            {
                SqlDataReader reader = cmd.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        if (reader[0].ToString().Equals(wish_member_sn))
                        {
                            deviceId = reader[7].ToString();


                        }
                        if (reader[0].ToString().Equals(help_member_sn))
                        {
                            mState = true;
                            title="來自"+ reader[1].ToString()+"的祝福";
                            //  context.Response.Write("true");
                        }
                    }


                }
                finally
                {

                    reader.Close();
                    if (mState==true && !deviceId.ToString().Equals(""))
                    {

                       // context.Response.Write(deviceId+"\n");
                        try
                        {
                            //string applicationID = "AAAA2buE1Bs:APA91bHWejDqpKCIZY2PZF17p22GIJ0s4JH4UqxrVd1gVIRAhg0mdBAJHmKzq-xQdDXFF8s5-5OJaIHyFWzmJT_QYw-m12w21p2fPS4jnhtYMeA6g7tH8cuxiOPxEnp94GQYHLCYzPCZ";
                            //string senderId = "935153947675";
                            string applicationID = "AAAAJ6UIJqc:APA91bELKjNduw-mtelehyqIG8p_b2A-Ppb36O10u2tJgHdVTdMdVGNpqrWsQBbJvNBtAcoOfPau3J_7ykukyHqBb_F9zZy1KmuGxBZbnSbR0kywz6NfAKADTnhzXI9pmb74xz9nuT5h";
                            string senderId = "170272499367";
                            WebRequest tRequest = WebRequest.Create("https://fcm.googleapis.com/fcm/send");

                            tRequest.Method = "post";
                            tRequest.ContentType = "application/json";
                            var data = new
                            {
                                


                                //registration_ids = from s in registration_id
                                //                   select s,
                                 notification = new
                                {
                                    body = body,
                                    title = title,
                                    sound = "Enabled",
                                    click_action = click_action,
                                 
                                },
                                data = new
                                {
                                    url =help_url,
                                    note=help_note,
                                    type=help_type
                                },

                                to = deviceId


                            };

                            var serializer = new JavaScriptSerializer();
                            var json = serializer.Serialize(data);
                            Byte[] byteArray = Encoding.UTF8.GetBytes(json);
                            tRequest.Headers.Add(string.Format("Authorization: key={0}", applicationID));
                            tRequest.Headers.Add(string.Format("Sender: id={0}", senderId));
                            tRequest.ContentLength = byteArray.Length;
                            using (Stream dataStream = tRequest.GetRequestStream())
                            {
                                dataStream.Write(byteArray, 0, byteArray.Length);
                                using (WebResponse tResponse = tRequest.GetResponse())
                                {
                                    using (Stream dataStreamResponse = tResponse.GetResponseStream())
                                    {
                                        using (StreamReader tReader = new StreamReader(dataStreamResponse))
                                        {
                                            sResponseFromServer = tReader.ReadToEnd();

                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            sResponseFromServer = ex.Message;
                            context.Response.Write("3:" + sResponseFromServer);
                        }
                        finally
                        {
                            if (!sResponseFromServer.Equals(""))
                            {
                                cmd = new SqlCommand(insertCMD, con);
                                cmd.Connection = con;
                                //
                                //string insertCMD = "insert into Help_Table(wish_sn,member_sn,help_url,help_note) values(@wish_sn,@member_sn,@help_url,@help_note)";
                                cmd.Parameters.AddWithValue("@wish_sn",int.Parse(wish_sn) );
                                cmd.Parameters.AddWithValue("@member_sn", int.Parse(help_member_sn));
                                cmd.Parameters.AddWithValue("@help_url", help_url);
                                cmd.Parameters.AddWithValue("@help_note", help_note);
                                cmd.ExecuteNonQuery();
                                context.Response.Write("ok");
                            }

                        }
                    }
                    else
                    {
                        context.Response.Write("no");
                    }
                }

            }



        }




        cmd.Dispose();
        con.Close();
        con.Dispose();//歸還記憶體
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}