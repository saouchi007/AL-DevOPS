codeunit 81240 "MICA Flow Extract Rcv.Req.Ack"
{   //INT-3PL-008
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowBuffReceiveReqAck2: Record "MICA FlowBuff Receive Req.Ack2";
        MICAReceiptReceiveReqAck: XmlPort "MICA Receipt Receive Req.Ack.";
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
        MICAReceiptReceiveReqAck.SetSource(InStream);
        MICAReceiptReceiveReqAck.SetFlowEntry(Rec);

        Commit();
        if not MICAReceiptReceiveReqAck.Import() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, '')
        else begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ImportFinishedLbl, '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);

            MICAReceiptReceiveReqAck.GetBuffer(MICAFlowBuffReceiveReqAck2);
            MICAFlowBuffReceiveReqAck2.Validate("Flow Entry No.", Rec."Entry No.");
            MICAFlowBuffReceiveReqAck2.Insert(true);
            Rec.Modify(false);
        end;
        MICAFlowInformation.Update('', '');
    end;
}
