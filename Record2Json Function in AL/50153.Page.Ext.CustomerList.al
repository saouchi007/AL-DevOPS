/// <summary>
/// PageExtension CustomerList_Ext (ID 50153) extends Record Customer List.
/// </summary>
pageextension 50153 CustomerList_Ext extends "Customer List"
{
    trigger OnOpenPage()
    var
        Json: Codeunit JsonTools;
    begin
        //Rec.FindFirst();
        //Message('%1', Json.Rec2Json(Rec));
    end;
}