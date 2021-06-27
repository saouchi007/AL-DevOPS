codeunit 81421 "MICA Transport Event Set SRD"
{   //EDD-ITG-003: GIT – Transport Event Integration

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Location: Record Location;
        ReferenceDate: Date;
    begin
        Location.SetRange("MICA 3PL Integration", true);
        if Location.FindSet(false) then begin
            if Time() >= 210000T then
                ReferenceDate := Today()
            else
                ReferenceDate := Today() - 1;

            repeat
                TransferLine.SetRange("Transfer-from Code", Location.Code);  //?????
                TransferLine.SetFilter("MICA SRD", '<%1', ReferenceDate);
                if TransferLine.FindSet(true) then
                    repeat
                        TransferLine.Validate("MICA SRD", CalcDate(Location."MICA SRD Default Delay", TransferLine."MICA SRD"));
                        TransferLine.Modify();
                        TransferHeader.Get(TransferLine."Document No.");
                        if TransferHeader."MICA SRD" <> TransferLine."MICA SRD" then begin
                            TransferHeader."MICA SRD" := TransferLine."MICA SRD";
                            TransferHeader.Modify();
                        end;
                    until TransferLine.Next() = 0;
            until Location.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterValidateEvent', 'MICA SRD', false, false)]
    local procedure TransferHeaderOnUpdateTransLinesSRD(var Rec: Record "Transfer Header"; CurrFieldNo: Integer)
    var
        TransferLine: Record "Transfer Line";
    begin
        if CurrFieldNo = 0 then
            exit;
        TransferLine.SetRange("Document No.", Rec."No.");
        if TransferLine.FindSet(true, false) then
            repeat
                TransferLine.Validate("MICA SRD", Rec."MICA SRD");
                if TransferLine."MICA Initial SRD" = 0D then
                    TransferLine.Validate("MICA Initial SRD", TransferLine."MICA SRD");
                TransferLine.Modify(false);
            until TransferLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterValidateEvent', 'MICA ETA', false, false)]
    local procedure TransferHeaderOnUpdateTransLinesETA(var Rec: Record "Transfer Header"; CurrFieldNo: Integer)
    var
        TransferLine: Record "Transfer Line";
    begin
        if CurrFieldNo = 0 then
            exit;
        TransferLine.SetRange("Document No.", Rec."No.");
        if TransferLine.FindSet(true, false) then
            repeat
                TransferLine.Validate("MICA ETA", Rec."MICA ETA");
                if TransferLine."MICA Initial ETA" = 0D then
                    TransferLine.Validate("MICA Initial ETA", TransferLine."MICA ETA");
                TransferLine.Validate("MICA SRD", Rec."MICA SRD");
                if TransferLine."MICA Initial SRD" = 0D then
                    TransferLine.Validate("MICA Initial SRD", TransferLine."MICA SRD");
                TransferLine.Modify(false);
            until TransferLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterGetTransHeader', '', false, false)]
    local procedure TransferLineOnAfterGetTransHeader(TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line")
    begin
        with TransferLine do begin
            "MICA SRD" := TransferHeader."MICA SRD";
            "MICA Initial SRD" := TransferHeader."MICA Initial SRD";
            "MICA ETA" := TransferHeader."MICA ETA";
            "MICA Initial ETA" := TransferHeader."MICA Initial ETA";
        end;
    end;
}