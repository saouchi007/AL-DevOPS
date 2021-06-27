codeunit 81400 "MICA Flow PostProcess RecvConf"
{
    //EDD-ITG-005: GIT – 3PL Receipt Confirmation Integration. Preprocess defined in INT-3PL-006: Received confirmation (in).
    TableNo = "MICA Flow Entry";

    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowInformation: Record "MICA Flow Information";

    trigger OnRun()
    var
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        MICAFlowBuffReceivedConfirm2: record "MICA FlowBuff ReceivedConfirm2";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        StartMsg: Label 'Start post-processing data';
        PostProcessingErr: Label 'Post-processing in error';
        DatapostProcessedMsg: Label 'Data Post-Processed';
        NumberOfPostProcessedRecordsMsg: Label '%1 records post-processed';
        RecordsPostProcessed: Integer;
    begin
        OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
        commit();
        MICAFlowBuffReceivedConfirm2.SetRange("Flow Entry No.", Rec."Entry No.");
        if MICAFlowBuffReceivedConfirm2.FindFirst() then begin
            WarehouseReceiptHeader.get(MICAFlowBuffReceivedConfirm2."Document ID");
            WarehouseReceiptLine.SetRange("No.", WarehouseReceiptHeader."No.");
            WhsePostReceipt.SetHideValidationDialog(true);
            if not WhsePostReceipt.Run(WarehouseReceiptLine) then
                Rec.AddInformation(OpeningMICAFlowInformation."Info Type"::Error, WarehouseReceiptHeader.RECORDID(), PostProcessingErr, GetLastErrorText())
            else begin
                MICAFlowRecord.UpdateReceiveRecord(Rec."Entry No.", WarehouseReceiptHeader.RecordId(), Rec."Receive Status"::PostProcessed);
                RecordsPostProcessed += 1;
            end;
        end;
        Rec.AddInformation(OpeningMICAFlowInformation."Info Type"::Information, DatapostProcessedMsg, StrSubstNo(NumberOfPostProcessedRecordsMsg, RecordsPostProcessed));
        OpeningMICAFlowInformation.Update('', '');
    end;
}

