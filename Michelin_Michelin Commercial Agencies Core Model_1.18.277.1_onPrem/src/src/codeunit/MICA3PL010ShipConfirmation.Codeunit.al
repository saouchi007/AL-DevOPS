codeunit 81921 "MICA 3PL010 Ship Confirmation"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure T36OnAfterValidateSelltoCustomerNo(VAR Rec: Record "Sales Header"; VAR xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
    begin
        if Rec."Sell-to Customer No." = '' then
            Rec."MICA Shipment Post Option" := Rec."MICA Shipment Post Option"::" "
        else begin
            Customer.Get(Rec."Sell-to Customer No.");
            if Customer."MICA Shipment Post Option" = Customer."MICA Shipment Post Option"::" " then begin
                SalesReceivablesSetup.Get();
                if SalesReceivablesSetup."MICA Shipment Post Option" = SalesReceivablesSetup."MICA Shipment Post Option"::" " then
                    Rec."MICA Shipment Post Option" := Rec."MICA Shipment Post Option"::Ship
                else
                    Rec."MICA Shipment Post Option" := SalesReceivablesSetup."MICA Shipment Post Option";
            end else
                Rec."MICA Shipment Post Option" := Customer."MICA Shipment Post Option";
        end;
    end;
}