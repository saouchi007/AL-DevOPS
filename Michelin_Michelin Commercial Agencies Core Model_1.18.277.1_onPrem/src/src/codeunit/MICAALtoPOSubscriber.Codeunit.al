codeunit 81263 "MICA AL to PO Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'MICA DC14', false, false)]
    local procedure OnAfterValidateDC14PurchaseHeader(var Rec: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.ModifyAll("MICA DC14", Rec."MICA DC14");

    end;

}