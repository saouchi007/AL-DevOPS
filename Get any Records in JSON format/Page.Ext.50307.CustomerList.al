/// <summary>
/// PageExtension ISA_CustomerListExt (ID 50307) extends Record Customer List.
/// </summary>
pageextension 50307 ISA_CustomerListExt extends "Customer List"
{

    actions
    {
        addafter(PaymentRegistration)
        {
            action(DownloadJson)
            {
                ApplicationArea = All;
                Caption = 'Downlaod Json';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;


                trigger OnAction()
                var
                    ISA_DownloadJson: Codeunit ISA_DownloadJson;
                begin
                    ISA_DownloadJson.ISA_DownloadJson(Rec);
                end;
            }
        }
    }
}