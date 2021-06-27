codeunit 80020 "MICA Customer Data Event"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyShipToAdress(var Rec: Record "Ship-to Address")
    begin
        Rec."MICA Last Modification Date" := Today();
        Rec."MICA Last Mod. Date Time" := CurrentDateTime();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnAfterInsertShipToAdress(var Rec: Record "Ship-to Address")
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NewNoSeries: Code[20];
    begin
        IF Rec."MICA Internal Code" = '' THEN BEGIN
            SalesReceivablesSetup.GET();
            SalesReceivablesSetup.TESTFIELD("MICA Internal Code Nos.");
            NoSeriesManagement.InitSeries(SalesReceivablesSetup."MICA Internal Code Nos.", '', 0D, Rec."MICA Internal Code", NewNoSeries);
        END;
        if Customer.Get(REc."Customer No.") then
            Rec."MICA Express Order" := Customer."MICA Express Order";
    end;
}