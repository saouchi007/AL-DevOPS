codeunit 80980 "MICA Rcv Instruction Event"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure t7316OnBeforeDeleteEvent(VAR Rec: Record "Warehouse Receipt Header"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            rec.TESTFIELD("MICA Status", rec."MICA Status"::Open);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Header", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure t7316OnBeforeValidateEventNo(VAR Rec: Record "Warehouse Receipt Header")
    begin
        rec.TESTFIELD("MICA Status", rec."MICA Status"::Open);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Header", 'OnBeforeValidateEvent', 'Bin Code', false, false)]
    local procedure t7316OnBeforeValidateEventBinCode(VAR Rec: Record "Warehouse Receipt Header")
    begin
        rec.TESTFIELD("MICA Status", rec."MICA Status"::Open);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Header", 'OnBeforeValidateEvent', 'Zone Code', false, false)]
    local procedure t7316OnBeforeValidateEventZoneCode(VAR Rec: Record "Warehouse Receipt Header")
    begin
        rec.TESTFIELD("MICA Status", rec."MICA Status"::Open);
    end;

    /*[EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure t7317OnBeforeDeleteEvent(VAR Rec: Record "Warehouse Receipt Line"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            Rec.TestReleased();
    end;*/

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Line", 'OnBeforeValidateEvent', 'Bin Code', false, false)]
    local procedure t7317OnBeforeValidateEventBinCode(VAR Rec: Record "Warehouse Receipt Line")
    begin
        Rec.TestOpen();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Line", 'OnBeforeValidateEvent', 'Zone Code', false, false)]
    local procedure t7317OnBeforeValidateEventZoneCode(VAR Rec: Record "Warehouse Receipt Line")
    begin
        Rec.TestOpen();
    end;
}