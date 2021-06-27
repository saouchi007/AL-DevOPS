codeunit 81220 "MICA Flow Extract Pick Req.Ack"
{ //INT-3PL-007: Pick request acknowledgement (in)
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowBufferPickReqAck2: Record "MICA Flow Buffer Pick Req.Ack2";
        MICAShipmentPickReqAck: XmlPort "MICA Shipment Pick Req.Ack.";
        InStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2.';
        EmptyBlobLbl: Label 'Empty Blob : import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process.';
        ImportFinishedLbl: Label 'Data import finished';

    begin
        if Rec."Receive Status" <> Rec."Receive Status"::Received then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowEntryNoIsNotInStatusErr, Rec."Entry No.", Rec."Receive Status"::Received), '');
            exit;
        end;

        Rec.CalcFields(Blob);
        if not Rec.Blob.HasValue then begin
            MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Error, EmptyBlobLbl, ''));
            exit;
        end;

        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ImportStartedLbl, ''));

        Rec.Blob.CreateInStream(InStream);
        MICAShipmentPickReqAck.SetSource(InStream);
        MICAShipmentPickReqAck.SetFlowEntry(Rec);

        Commit();
        if not MICAShipmentPickReqAck.Import() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, '')
        else begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ImportFinishedLbl, '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);

            MICAShipmentPickReqAck.GetBuffer(MICAFlowBufferPickReqAck2);
            MICAFlowBufferPickReqAck2.Validate("Flow Entry No.", Rec."Entry No.");
            MICAFlowBufferPickReqAck2.Insert(true);
            Rec.Modify(false);
        end;
        MICAFlowInformation.Update('', '');
    end;
}