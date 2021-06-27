codeunit 81261 "MICA Flow Extract AL to PO"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        BufferMICAALtoPOImport: XmlPort "MICA AL to PO Import";
        InStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2';
        EmptyBlobLbl: Label 'Empty Blob : Import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process.';
        ImportFinishedLbl: Label 'Data import finished: %1 record(s) buffered.';
    begin
        if Rec."Receive Status" <> Rec."Receive Status"::Received then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowEntryNoIsNotInStatusErr, Rec."Entry No.", Rec."Receive Status"::Received), '');
            exit;
        end;

        Rec.CalcFields(Blob);
        if not Rec.Blob.HasValue() then begin
            MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Error, EmptyBlobLbl, ''));
            exit;
        end;
        // >> REPLACED BY Flow.RemoveNameSpaces() implementation
        // else begin
        //    Blob.CreateInStream(CorrectInStr);
        //    while not CorrectInStr.EOS() do begin
        //        CorrectInStr.ReadText(StartXml, FileLength);
        //        CorrectXml := ReplaceString(CopyStr(StartXml,1,250), 'imp1:', '');
        //        CorrectXml := ReplaceString(CopyStr(CorrectXml,1,250), '<ProcessPurchaseOrder xmlns:imp1="http://www.openapplications.org/oagis/10" xmlns="http://www.openapplications.org/oagis/10">', '<ProcessPurchaseOrder>');
        //        FinalXml += CorrectXml;
        //    end;
        //    Clear(Blob);
        //    Blob.CreateOutStream(CorrectOutStr);
        //    CorrectOutStr.WriteText(FinalXml);
        //    Modify(true);
        //end;
        // << REPLACED BY Flow.RemoveNameSpaces() implementation

        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ImportStartedLbl, ''));

        Rec.Blob.CreateInStream(InStream);

        clear(BufferMICAALtoPOImport);
        BufferMICAALtoPOImport.SetSource(InStream);
        BufferMICAALtoPOImport.SetFlowEntry(Rec);
        Commit();
        if not BufferMICAALtoPOImport.Import() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, GetLastErrorText())
        else begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, BufferMICAALtoPOImport.GetRecordCount()), '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.validate("Buffer Count", BufferMICAALtoPOImport.GetRecordCount());
        end;
        MICAFlowInformation.Update('', '');
    end;

}