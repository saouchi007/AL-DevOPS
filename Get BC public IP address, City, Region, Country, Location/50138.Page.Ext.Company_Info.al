/// <summary>
/// PageExtension CompanyInfo_Ext (ID 50138) extends Record Company Information.
/// </summary>
pageextension 50138 CompanyInfo_Ext extends "Company Information"
{

    actions
    {
        addfirst(Processing)
        {
            action(GetIPinfo)
            {
                Caption = 'Get IP Info';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Image = CompanyInformation;

                trigger OnAction()
                var
                    Client: HttpClient;
                    RequestMsg: HttpRequestMessage;
                    ResponseMsg: HttpResponseMessage;
                    URL: Text;
                    IP: Text;
                begin
                    URL := 'https://ipinfo.io?token=eff835d123dd55';
                    //URL := 'http://ip-api.com/json';
                    RequestMsg.SetRequestUri(URL);
                    if not Client.Send(RequestMsg, ResponseMsg) then
                        Error('Call failed');
                    ResponseMsg.Content.ReadAs(IP);
                    Message(IP);
                end;
            }
            action(AllObjects)
            {
                Caption = 'View All objects';
                ToolTip = ' View all objects used by extensions';
                Image = ViewServiceOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                RunObject = page 9174;
            }
        }
    }


}