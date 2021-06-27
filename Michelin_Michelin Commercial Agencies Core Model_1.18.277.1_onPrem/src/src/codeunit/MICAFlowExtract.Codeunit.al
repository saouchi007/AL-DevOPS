codeunit 80861 "MICA Flow Extract"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        FindDataExch: Record "Data Exch.";
        DataExchLineDef: Record "Data Exch. Line Def";
        DataExchMapping: Record "Data Exch. Mapping";
        TempDataExchMapping: Record "Data Exch. Mapping" temporary;
        myField: Record Field;
        myFieldRef: FieldRef;
    begin
        if Rec."Receive Status" <> Rec."Receive Status"::Received then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowEntryNoIsNotInStatusErr, Rec."Entry No.", Rec."Receive Status"::Received), '')
        else
            if MICAFlow.Get(Rec."Flow Code") then
                if DataExchDef.Get(MICAFlow."Data Exch. Def. Code") then begin
                    Rec.CalcFields(Blob);
                    Rec.Blob.CREATEINSTREAM(SourceInStream);
                    DataExch.InsertRec(CopyStr(Rec.Description, 1, MaxStrLen(DataExch."File Name")), SourceInStream, DataExchDef.Code);
                    Rec."Data Exch. Entry No." := DataExch."Entry No.";
                    Rec.Modify(true);
                    if FindDataExch.Get(DataExch."Entry No.") then begin
                        DataExchLineDef.SetRange("Data Exch. Def Code", FindDataExch."Data Exch. Def Code");
                        if DataExchLineDef.FindSet() then
                            repeat
                                FindDataExch."Data Exch. Line Def Code" := DataExchLineDef.Code;
                                FindDataExch.CalcFields("File Content");
                                ImportDataToExch(FindDataExch);
                                DataExchMapping.SetRange("Data Exch. Def Code", FindDataExch."Data Exch. Def Code");
                                DataExchMapping.SetRange("Data Exch. Line Def Code", FindDataExch."Data Exch. Line Def Code");
                                if DataExchMapping.FindSet() then
                                    repeat
                                        TempDataExchMapping.TransferFields(DataExchMapping);
                                        TempDataExchMapping.Insert(false);
                                    until DataExchMapping.Next() = 0;
                            until DataExchLineDef.Next() = 0;
                    end;
                    if not TempDataExchMapping.IsEmpty() then
                        repeat
                            TempDataExchMapping.FindFirst();
                            FlowBufferRecordRef.Open(TempDataExchMapping."Table ID");
                            FlowCodeFieldRef := FlowBufferRecordRef.Field(1);
                            FlowCodeFieldRef.Value := Rec."Flow Code";
                            FlowEntryNoFieldRef := FlowBufferRecordRef.Field(2);
                            FlowEntryNoFieldRef.Value := Rec."Entry No.";
                            ProcessDataExch.ProcessAllLinesColumnMapping(DataExch, FlowBufferRecordRef);
                            if myField.Get(FlowBufferRecordRef.RecordId().TableNo(), 2) then begin
                                myFieldRef := FlowBufferRecordRef.FIELD(myField."No.");
                                myFieldRef.SetRange(Rec."Entry No.");
                                Rec.Validate("Buffer Count", Rec."Buffer Count" + FlowBufferRecordRef.Count());
                            end;
                            FlowBufferRecordRef.Close();
                            TempDataExchMapping.SetRange("Table ID", TempDataExchMapping."Table ID");
                            TempDataExchMapping.DeleteAll(false);
                            TempDataExchMapping.SetRange("Table ID");
                        until TempDataExchMapping.IsEmpty();
                    Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
                end else
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowEntryNoDataExchDefMissingErr, Rec."Entry No."), '')
    end;

    local procedure ImportDataToExch(DataExch: Record "Data Exch.");
    var
        LocDataExchDef: Record "Data Exch. Def";
        SourceLocInStream: InStream;
    begin
        DataExch."File Content".CreateInStream(SourceLocInStream);
        DataExch.SetRange("Entry No.", DataExch."Entry No.");
        LocDataExchDef.Get(DataExch."Data Exch. Def Code");
        if LocDataExchDef."Reading/Writing XMLport" <> 0 then
            Xmlport.Import(LocDataExchDef."Reading/Writing XMLport", SourceLocInStream, DataExch)
        else
            if LocDataExchDef."Reading/Writing Codeunit" <> 0 then
                Codeunit.Run(LocDataExchDef."Reading/Writing Codeunit", DataExch);
    end;


    var
        MICAFlow: Record "MICA FLow";
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
        ProcessDataExch: Codeunit "Process Data Exch.";
        FlowBufferRecordRef: RecordRef;
        FlowCodeFieldRef: FieldRef;
        FlowEntryNoFieldRef: FieldRef;
        SourceInStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2';
        FlowEntryNoDataExchDefMissingErr: Label 'Flow Entry No. %1 : Data Exch. Def. missing.';

}