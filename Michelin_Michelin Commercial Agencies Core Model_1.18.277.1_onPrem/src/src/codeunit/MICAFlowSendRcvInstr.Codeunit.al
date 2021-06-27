codeunit 80982 "MICA Flow Send Rcv. Instr."
{
    //INT-3PL-002

    TableNo = "MICA Flow";
    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowSetup: Record "MICA Flow Setup";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        QueryMICAWhseReceiptFlowEntry: Query "MICA Whse Receipt Flow Entry";
        DocTypeFilterParamTxt: Label 'DOCTYPEFILTER', Locked = true;
        DocTypeFilterMissingErr: Label 'Flow parameter %1 (type Text) is missing or invalid : must contain value IMPORT or INTERNAL_TRANSFER or DOMESTIC_RETURN or *';
        DocTypeDiscardInfoTxt: Label 'Warehouse Receipt %1 was discarded because Source Document is %2.';
        NoDataFoundInfoTxt: Label 'There is nothing to send.';
        DocTypeFilterValue: Text;
        SendWhseDoc: Boolean;

    begin
        DocTypeFilterValue := MICAFlowSetup.GetFlowTextParam(rec.Code, DocTypeFilterParamTxt);
        if DocTypeFilterValue = '' then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, strsubstno(DocTypeFilterMissingErr, DocTypeFilterParamTxt), '');
            exit;
        end;


        QueryMICAWhseReceiptFlowEntry.SetRange(MICA_Status, QueryMICAWhseReceiptFlowEntry.MICA_Status::Released);
        QueryMICAWhseReceiptFlowEntry.SetRange(Send_Status, QueryMICAWhseReceiptFlowEntry.Send_Status::" ");
        if QueryMICAWhseReceiptFlowEntry.Open() then
            if not QueryMICAWhseReceiptFlowEntry.Read() then begin
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, NoDataFoundInfoTxt, WarehouseReceiptHeader.getfilters());
                exit;
            end else
                repeat
                    WarehouseReceiptHeader.get(QueryMICAWhseReceiptFlowEntry.No_);

                    SendWhseDoc := false;
                    WarehouseReceiptLine.Reset();
                    WarehouseReceiptLine.setrange("No.", WarehouseReceiptHeader."No.");
                    WarehouseReceiptLine.FindFirst();//No if -> explicit report if empty doc
                    case UpperCase(DocTypeFilterValue) of
                        'IMPORT':
                            SendWhseDoc :=
                                (WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Inbound Transfer") and
                                (WarehouseReceiptLine."MICA ASN No." <> '');
                        'INTERNAL_TRANSFER':
                            SendWhseDoc :=
                                (WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Inbound Transfer") and
                                (WarehouseReceiptLine."MICA ASN No." = '');
                        'DOMESTIC_RETURN':
                            SendWhseDoc := (WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Sales Return Order");
                        '*':
                            SendWhseDoc := true;
                        else
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, strsubstno(DocTypeFilterMissingErr, DocTypeFilterParamTxt), '');
                            exit;
                    end;
                    if SendWhseDoc then
                        SendWarehouseReceipt(WarehouseReceiptHeader, Rec)
                    else
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(DocTypeDiscardInfoTxt, WarehouseReceiptHeader."No.", format(WarehouseReceiptLine."Source Document")), '');

                until not QueryMICAWhseReceiptFlowEntry.Read();
    end;

    local Procedure SendWarehouseReceipt(WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var MICAFlow: record "MICA Flow")
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        XmlMICAReceiveInstructions: XmlPort "MICA Receive Instructions";
        ExportedrecordCount: Integer;
        SetDestOutStream: OutStream;
        StartMsgLbl: Label 'Start preparing data';
        DataPrepLbl: Label 'Data Preparation executed.';
        ExportedRecordCountLbl: Label '%1 records exported';
        CreateFlowEntryErr: Label 'Unable to create Flow Entry';
        ExportFailLbl: Label 'Export Failed (%1)';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        OutStream: OutStream;
        InStream: InStream;
    begin
        if not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, WarehouseReceiptHeader.RecordId(), CreateFlowEntryErr, GetLastErrorText());
            exit;
        end;
        MICAFlowEntry.Description += '.xml';
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, WarehouseReceiptHeader.RecordId(), StartMsgLbl, ''));
        TempBlob.CreateOutStream(SetDestOutStream);
        Clear(XmlMICAReceiveInstructions);
        XmlMICAReceiveInstructions.SetFlowEntry(MICAFlowEntry."Entry No.");
        XmlMICAReceiveInstructions.SetReceiptHeader(WarehouseReceiptHeader);
        XmlMICAReceiveInstructions.SetDestination(SetDestOutStream);
        if not XmlMICAReceiveInstructions.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, WarehouseReceiptHeader.RecordId(), StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;
        ExportedrecordCount := XmlMICAReceiveInstructions.GetRecordCount();

        //Update Blob with exported data
        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Description := XmlMICAReceiveInstructions.GetFileName();
        MICAFlowEntry.Modify(true);
        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, WarehouseReceiptHeader.RecordId(), DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, WarehouseReceiptHeader.RecordId(), StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');
        MICAFlowInformation.Update('', '');
    end;
}