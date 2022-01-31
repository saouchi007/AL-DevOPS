/// <summary>
/// PageExtension CustomerList_Ext (ID 50126) extends Record Customer List.
/// </summary>
pageextension 50126 CustomerList_Ext extends "Customer List"
{
    trigger OnOpenPage()
    begin
        /*Rec.SetCurrentKey(Name, "No.");
        Rec.Ascending(false);
        Rec.SetFilter("Balance (LCY)", '>%1', 40000);
        Rec.SetFilter("Sales (LCY)", '>%1', 30000);*/
        //"SourceTableView" can not be extended  
        Rec.SetView(StrSubstNo('sorting(Name, "No.") order(ascending) where("Balance (LCY)" = filter(>= 40000), "Sales (LCY)" = filter(>= 30000))'));
    end;
}