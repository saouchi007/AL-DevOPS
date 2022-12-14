/// <summary>
/// PageExtension ISA_ItemList_Ext (ID 50306) extends Record Item List.
/// </summary>
pageextension 50306 ISA_ItemList_Ext extends "Item List"
{
    actions
    {
        addafter(AdjustInventory)
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