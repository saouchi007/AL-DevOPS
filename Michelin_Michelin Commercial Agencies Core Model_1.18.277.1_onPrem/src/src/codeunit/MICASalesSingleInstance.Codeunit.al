codeunit 81710 "MICA Sales Single Instance"
{
    SingleInstance = true;

    var
        TempSalesHeader: Record "Sales Header" temporary;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesHeader(var Rec: Record "Sales Header");
    begin
        //Keep track of header being deleted
        TempSalesHeader.Init();
        TempSalesHeader := Rec;
        if not TempSalesHeader.Insert() then;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesHeader(var Rec: Record "Sales Header");
    begin
        //Delete track of deleted header         
        if TempSalesHeader.Get(Rec."Document Type", rec."No.") then
            TempSalesHeader.Delete();
    end;

    procedure HeaderIsBeingDeleted(SalesLine: Record "Sales Line"): Boolean
    begin
        exit(TempSalesHeader.get(SalesLine."Document Type", SalesLine."Document No."));
    end;



}