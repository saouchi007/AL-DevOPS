codeunit 81242 "MICA Set 3PL Error Whs.Receipt"
{    //INT-3PL-008
    //Set 3PL Error in Warehouse Receipt Header if no response from 3PL (for Receive Request) after defined delay

    trigger OnRun()
    var
        Location: Record Location;
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseSetup: Record "Warehouse Setup";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        TempMICAFlowResult: Record "MICA Flow Result" temporary;

        MICAFlowMgt: Codeunit "MICA Flow Mgt";
        MinAllowedSend: DateTime;
        PickAckErr: Label 'Acknowledgement file not received after delay %1.';
        PickAck2Err: Label 'Acknowledgement file expected before %1.';

    begin
        WarehouseSetup.Get();
        if WarehouseSetup."MICA 3PL Receipt Ack. MaxDelay" = 0 then
            exit;

        WarehouseReceiptHeader.SetRange("MICA Status", WarehouseReceiptHeader."MICA Status"::Released);
        WarehouseReceiptHeader.SetRange("MICA Send Ack. Received", false);

        if WarehouseReceiptHeader.findset(false, false) then
            repeat
                clear(TempMICAFlowResult);
                TempMICAFlowResult."Entry No." += 1;
                TempMICAFlowResult."MICA Send Last Flow Entry No." := WarehouseReceiptHeader."MICA Send Last Flow Entry No.";
                TempMICAFlowResult."MICA Rcv. Last Flow Entry No." := WarehouseReceiptHeader."MICA Rcv. Last Flow Entry No.";
                TempMICAFlowResult."MICA Record ID" := WarehouseReceiptHeader."MICA Record ID";
                if TempMICAFlowResult.insert() then;
                TempMICAFlowResult.CalcFields("MICA Send Last Flow Status", "MICA Send Last Error Count");
                if (TempMICAFlowResult."MICA Send Last Flow Status" = TempMICAFlowResult."MICA Send Last Flow Status"::Sent) and (TempMICAFlowResult."MICA Send Last Error Count" = 0) then
                    WarehouseReceiptHeader.Mark(true);
            until WarehouseReceiptHeader.next() = 0;

        WarehouseReceiptHeader.MarkedOnly(true);

        if WarehouseReceiptHeader.FindSet(false) then begin
            MinAllowedSend := CreateDateTime(Today(), Time() - WarehouseSetup."MICA 3PL Receipt Ack. MaxDelay" * 60 * 1000);
            repeat
                if Location.Get(WarehouseReceiptHeader."Location Code") and Location."MICA 3PL Integration" then begin
                    MICAFlowMgt.GetFlowEntry(WarehouseReceiptHeader."MICA Send Last Flow Entry No.", MICAFlowEntry);
                    if MICAFlowEntry."Sent Date Time" < MinAllowedSend then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, WarehouseReceiptHeader.RecordId(), StrSubstNo(PickAckErr, WarehouseSetup."MICA 3PL Receipt Ack. MaxDelay"),
                                                 StrSubstNo(PickAck2Err, MICAFlowEntry."Sent Date Time" - WarehouseSetup."MICA 3PL Receipt Ack. MaxDelay" * 60 * 1000));

                end;
            until WarehouseReceiptHeader.Next() = 0;
        end;
    end;
}