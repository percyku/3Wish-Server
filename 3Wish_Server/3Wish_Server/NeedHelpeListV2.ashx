<%@ WebHandler Language="C#" Class="NeedHelpeListV2" %>

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;

public class NeedHelpeListV2 : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        //string member_sn = context.Request.Form["item1"];
        string member_sn ="3004";

        if (member_sn == null||member_sn.Equals(""))
        {
            context.Response.Write("not found");
            return;
        }
        //string member_sn ="3015";
        //string selectCMD = "SELECT * FROM Wish_Table RIGHT JOIN MEMBER_Table ON Wish_Table.member_sn=Member_Table.sn WHERE MEMBER_Table.sn!="+member_sn+" and Wish_Table.wish_state=1;";
        string selectCMD1 = "SELECT * FROM Member_Table WHERE sn='" + member_sn + "';";

        string selectCMD = "SELECT * FROM Wish_Table RIGHT JOIN MEMBER_Table ON Wish_Table.member_sn=Member_Table.sn WHERE Wish_Table.wish_state=1 and MEMBER_Table.sn!='" + member_sn + "';";
        //string selectCMD = "SELECT * FROM Wish_Table RIGHT JOIN MEMBER_Table ON Wish_Table.member_sn=Member_Table.sn WHERE Wish_Table.wish_sn='"+result+ "';";
        //Wish_Table.wish_state=1 and '" +  +

        //string selectCMD = "SELECT wish_sn,member_sn, FROM Wish_Table RIGHT JOIN MEMBER_Table ON Wish_Table.member_sn=Member_Table.sn ;";
        using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString))
        {
            List<NeedHelperMemberV2> needhelperMember = new List<NeedHelperMemberV2>();
            // var needhelperMember = new List<NeedHelperMember>();
            NeedHelperMemberV2[] needHelperMember1 = new NeedHelperMemberV2[] { };
            con.Open();

            SqlCommand command = new SqlCommand(selectCMD1, con);
            SqlDataReader reader = command.ExecuteReader();
            if (!reader.Read())
            {
                reader.Close();
                reader.Dispose();
                context.Response.Write("not found");
                    return;
            }

            reader.Close();
            reader.Dispose();
            using (command = new SqlCommand(selectCMD, con))
            {
                int i = 0;
                 reader = command.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        /*needHelperMember1[i] = new NeedHelperMember {
                                Hope_Sn=reader[0].ToString(),
                                 Hope_Email=reader[1].ToString(),
                                 Hope_Name=reader[2].ToString(),
                                 Hope_Sex=reader[3].ToString(),
                                 Hope_Image=reader[4].ToString(),
                                 Hope_lat=reader[5].ToString(),
                                 Hope_long=reader[6].ToString(),
                                 Hope_Content=reader[7].ToString(),
                                 Hope_Note=reader[8].ToString(),
                                 Hope_Type=reader[9].ToString(),
                                 Hope_Date=reader[11].ToString()
                           };*/
                        //i++;



                        needhelperMember.Add(new NeedHelperMemberV2()
                        {
                            Wish_Sn = reader[0].ToString(),
                            Wish_lat = reader[2].ToString(),
                            Wish_long = reader[3].ToString(),
                            Wish_Content = reader[4].ToString(),
                            Wish_Note = reader[5].ToString(),
                            Wish_Type = reader[6].ToString(),
                            Wish_Date = reader[8].ToString(),
                            Member_sn = reader[9].ToString(),
                            Wish_Name = reader[10].ToString(),
                            Wish_Image = reader[11].ToString(),
                            Wish_Email = reader[12].ToString(),
                            Wish_Sex = reader[14].ToString()

                        });


                    }
                }

                finally
                {
                    reader.Close();
                }

                var serializer = new JavaScriptSerializer().Serialize(needhelperMember);
                context.Response.Write(serializer);
                //context.Response.Write("[ ]");
            }
        }

    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}