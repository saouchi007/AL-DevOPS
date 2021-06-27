codeunit 80030 "MICA ItemWithoutPrice"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure onAfterValidateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrfieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TxtItemSalesPrice_Err: Label 'Impossible to create a line without price';
    begin
        if rec.Type <> rec.type::Item then
            exit;

        if not SalesHeader.get(Rec."Document Type", rec."Document No.") then
            exit;

        if IsRebatePoolItem(Rec."No.") then
            exit;

        if not SalesPriceCalcMgt.SalesLinePriceExists(SalesHeader, Rec, false) then
            Error(TxtItemSalesPrice_Err);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DocumentNoVisibility, 'OnBeforeSalesDocumentNoIsVisible', '', false, false)]
    local procedure OnBeforeSalesDocumentNoIsVisible(DocType: Option; var IsVisible: Boolean; var IsHandled: Boolean)
    begin
        //DocType = Order
        if DocType = 1 then begin
            IsVisible := true;
            IsHandled := true;
        end;
    end;

    procedure IsRebatePoolItem(ItemNo: Code[20]): Boolean
    var
        MICARebatePoolItemSetup: Record "MICA Rebate Pool Item Setup";
    begin
        MICARebatePoolItemSetup.SetCurrentKey("Rebate Pool Item No.");
        MICARebatePoolItemSetup.SetRange("Rebate Pool Item No.", ItemNo);
        exit(not MICARebatePoolItemSetup.IsEmpty());
    end;
}