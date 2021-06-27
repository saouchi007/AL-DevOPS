codeunit 80961 "MICA Flow Send Whs. Shipments"
{
    //INT-3PL-001: Pick request (out)
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowSetup: Record "MICA Flow Setup";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        FoundWarehouseShipmentLine: Record "Warehouse Shipment Line";
        TempBlob: Codeunit "Temp Blob";
        ExpMICAPickRequest: XmlPort "MICA Pick Request";
        QueryMICAWhseShipmentFlowEntry: Query "MICA Whse Shipment Flow Entry";
        TotalExported: Integer;
        OutStream: OutStream;
        FileName: Text[100];
        StartMsg: Label 'Start preparing data';
        EndMsg: Label 'Data Prepapration has been Completed';
        TotalExportedMsg: Label '%1 Records Exported of %2';
        UnableCreateFlowEntryErr: Label 'Unable to create Flow Entry';
        ExportFailErr: Label 'Export Failed (%1)';
        DocTypeFilterParamTxt: Label 'DOCTYPEFILTER', locked = true;
        DocTypeFilterMissingErr: Label 'Flow parameter %1 (type Text) is missing or invalid : must contain value SALES or TRANSFER or *.';
        DocTypeDiscardInfoTxt: Label 'Warehouse Shipment %1 was discarded because Source Document is %2.';
        NoDataFoundInfoTxt: Label 'There is nothing to send.';
        DocTypeFilterValue: Text;
        SendWhseDoc: Boolean;

    begin
        DocTypeFilterValue := MICAFlowSetup.GetFlowTextParam(rec.Code, DocTypeFilterParamTxt);
        if DocTypeFilterValue = '' then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, strsubstno(DocTypeFilterMissingErr, DocTypeFilterParamTxt), '');
            exit;
        end;

        QueryMICAWhseShipmentFlowEntry.SetRange(status, QueryMICAWhseShipmentFlowEntry.Status::Released);
        QueryMICAWhseShipmentFlowEntry.SetRange(Send_Status, QueryMICAWhseShipmentFlowEntry.Send_Status::" ");
        if QueryMICAWhseShipmentFlowEntry.Open() then
            if not QueryMICAWhseShipmentFlowEntry.Read() then begin
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, NoDataFoundInfoTxt, WarehouseShipmentHeader.getfilters());
                exit;
            end else
                repeat

                    WarehouseShipmentHeader.get(QueryMICAWhseShipmentFlowEntry.No_);

                    SendWhseDoc := false;
                    WarehouseShipmentLine.Reset();
                    WarehouseShipmentLine.setrange("No.", WarehouseShipmentHeader."No.");
                    WarehouseShipmentLine.FindFirst();//No if -> explicit report if empty doc
                    case UpperCase(DocTypeFilterValue) of
                        'SALES':
                            SendWhseDoc := (WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Sales Order");
                        'TRANSFER':
                            SendWhseDoc := (WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Outbound Transfer");
                        '*':
                            SendWhseDoc := true;
                        else
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, strsubstno(DocTypeFilterMissingErr, DocTypeFilterParamTxt), '');
                            exit;
                    end;

                    if SendWhseDoc then begin //Process document only according to Document Type filter

                        if not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, UnableCreateFlowEntryErr, GetLastErrorText());
                            exit;
                        end;
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, WarehouseShipmentHeader.RecordId(), StartMsg, '');

                        Clear(TempBlob);
                        TempBlob.CreateOutStream(OutStream);
                        Clear(ExpMICAPickRequest);
                        ExpMICAPickRequest.SetParam(MICAFlowEntry, WarehouseShipmentHeader);
                        ExpMICAPickRequest.SetDestination(OutStream);
                        if ExpMICAPickRequest.Export() then begin
                            ExpMICAPickRequest.GetParam(TotalExported, FileName);
                            MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", WarehouseShipmentHeader.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                            MICAFlowEntry.Description := FileName;
                            MICAFlowEntry.PrepareToSend(TempBlob);
                        end else
                            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailErr, GetLastErrorText()), GetLastErrorCode());
                        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, EndMsg, StrSubstNo(TotalExportedMsg, TotalExported, FoundWarehouseShipmentLine.TableCaption())));
                        MICAFlowInformation.Update('', '');

                        /*                    Clear(TempBlob);
                                            TempBlob.CreateOutStream(outStr);
                                            Clear(WhsShipmentExp);
                                            WhsShipmentExp.SetParam(FlowEntry, WhseShipHeader);
                                            WhsShipmentExp.SetDestination(outStr);
                                            if WhsShipmentExp.Export() then begin
                                                WhsShipmentExp.GetParam(TotalExported, FileName);
                                                FlowRecord.UpdateSendRecord(FlowEntry."Entry No.", WhseShipHeader.RecordId(), FlowEntry."Send Status"::Prepared);
                                                FlowEntry.Description := FileName;
                                                FlowEntry.PrepareToSend(TempBlob);*/
                    end else
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(DocTypeDiscardInfoTxt, WarehouseShipmentHeader."No.", format(WarehouseShipmentLine."Source Document")), '');

                until not QueryMICAWhseShipmentFlowEntry.Read();
    end;
}