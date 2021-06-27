codeunit 80870 "MICA Flow Send Sample ACK"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        XmlMICAMyExampleACKPostProcess: XmlPort "MICA MyExample ACK PostProcess";
        XmlMICAMyExampleACKPostCreated: XmlPort "MICA MyExample ACK PostCreated";
        XmlMICAMyExampleACKPostLoaded: XmlPort "MICA MyExample ACK PostLoaded";
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportFailLbl: Label 'Export Failed (%1)';
        ExportedRecordCount: Integer;
        OutStream: OutStream;
        CopyOutStream: OutStream;
        InStream: InStream;
    begin
        if MICAFlow.Get(Rec.GetFlowACKCode()) then begin
            If not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
                Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow Entry', '');
                exit;
            end;
            MICAFlowEntry.Description += 'ACK.xml';
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, 'Start Preparing Data', ''));
            TempBlob.CreateOutStream(OutStream);
            MICAFlowEntry.Validate("ACK from Flow Entry ID", Rec."Entry No.");
            MICAFlowEntry.Modify(true);

            case Rec."Receive Status" of
                Rec."Receive Status"::Received:
                    begin
                        Clear(XmlMICAMyExampleACKPostCreated);
                        XmlMICAMyExampleACKPostCreated.SetFlowEntry(MICAFlowEntry."Entry No.");
                        XmlMICAMyExampleACKPostCreated.SetDestination(OutStream);
                        if not XmlMICAMyExampleACKPostCreated.Export() then begin
                            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
                            exit;
                        end;
                        ExportedRecordCount := 1;
                    end;
                Rec."Receive Status"::Loaded:
                    begin
                        Rec.CalcFields("Error Count");
                        if Rec."Error Count" = 0 then begin //Loaded
                            Clear(XmlMICAMyExampleACKPostLoaded);
                            XmlMICAMyExampleACKPostLoaded.SetFlowEntry(MICAFlowEntry."Entry No.");
                            XmlMICAMyExampleACKPostLoaded.SetDestination(OutStream);
                            if not XmlMICAMyExampleACKPostLoaded.Export() then begin
                                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
                                exit;
                            end;
                            ExportedRecordCount := 1;
                        end
                        else begin
                            Clear(XmlMICAMyExampleACKPostProcess);
                            XmlMICAMyExampleACKPostProcess.SetFlowEntry(MICAFlowEntry."Entry No.");
                            MICAFlowBufferSampleData.SetRange("Flow Entry No.", Rec."Entry No.");
                            XmlMICAMyExampleACKPostProcess.SetTableView(MICAFlowBufferSampleData);
                            XmlMICAMyExampleACKPostProcess.SetDestination(OutStream);
                            if not XmlMICAMyExampleACKPostProcess.Export() then begin
                                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
                                exit;
                            end;
                            ExportedRecordCount := XmlMICAMyExampleACKPostProcess.GetRecordCount();
                        end;
                    end;
                Rec."Receive Status"::Processed:
                    begin
                        Clear(XmlMICAMyExampleACKPostProcess);
                        XmlMICAMyExampleACKPostProcess.SetFlowEntry(MICAFlowEntry."Entry No.");
                        MICAFlowBufferSampleData.SetRange("Flow Entry No.", Rec."Entry No.");
                        XmlMICAMyExampleACKPostProcess.SetTableView(MICAFlowBufferSampleData);
                        XmlMICAMyExampleACKPostProcess.SetDestination(OutStream);
                        if not XmlMICAMyExampleACKPostProcess.Export() then begin
                            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
                            exit;
                        end;
                        ExportedRecordCount := XmlMICAMyExampleACKPostProcess.GetRecordCount();
                    end;
            end;
            // Update Blob with exported data
            clear(CopyOutStream);
            clear(InStream);
            TempBlob.CreateInStream(InStream);
            MICAFlowEntry.Blob.CreateOutStream(CopyOutStream);
            CopyStream(CopyOutStream, InStream);
            MICAFlowEntry.Validate(Blob);
            MICAFlowEntry.Modify(true);

            MICAFlowEntry.CalcFields("Error Count");
            If ExportedRecordCount > 0 then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
                MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
            end else
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

            MICAFlowInformation.Update('', '');
        end;
    end;

    var
        MICAFlowBufferSampleData: Record "MICA Flow Buffer Sample Data";
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
}