codeunit 81222 "MICA Set 3PL Error Whs. Ship."
{   //INT-3PL-007: Pick request acknowledgement (in)
    //Set 3PL Error in Warehouse Shipment Header if no response from 3PL (for Pick Request) after defined delay

    trigger OnRun()
    var
        Location: Record Location;
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
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
        if WarehouseSetup."MICA 3PL Pick Ack. MaxDelay" = 0 then
            exit;
        WarehouseShipmentHeader.SetRange(Status, WarehouseShipmentHeader.Status::Released);
        WarehouseShipmentHeader.SetRange("MICA Send Ack. Received", false);


        if WarehouseShipmentHeader.findset(false, false) then
            repeat
                clear(TempMICAFlowResult);
                TempMICAFlowResult."Entry No." += 1;
                TempMICAFlowResult."MICA Send Last Flow Entry No." := WarehouseShipmentHeader."MICA Send Last Flow Entry No.";
                TempMICAFlowResult."MICA Rcv. Last Flow Entry No." := WarehouseShipmentHeader."MICA Rcv. Last Flow Entry No.";
                TempMICAFlowResult."MICA Record ID" := WarehouseShipmentHeader."MICA Record ID";
                if not TempMICAFlowResult.insert() then;
                TempMICAFlowResult.CalcFields("MICA Send Last Flow Status", "MICA Send Last Error Count");
                if (TempMICAFlowResult."MICA Send Last Flow Status" = TempMICAFlowResult."MICA Send Last Flow Status"::Sent) and (TempMICAFlowResult."MICA Send Last Error Count" = 0) then
                    WarehouseShipmentHeader.Mark(true);
            until WarehouseShipmentHeader.next() = 0;

        WarehouseShipmentHeader.MarkedOnly(true);
        if WarehouseShipmentHeader.FindSet(false, false) then begin
            MinAllowedSend := CreateDateTime(Today(), Time() - WarehouseSetup."MICA 3PL Pick Ack. MaxDelay" * 60 * 1000);
            repeat
                if Location.Get(WarehouseShipmentHeader."Location Code") and Location."MICA 3PL Integration" then begin
                    MICAFlowMgt.GetFlowEntry(WarehouseShipmentHeader."MICA Send Last Flow Entry No.", MICAFlowEntry);
                    if (MICAFlowEntry."Sent Date Time" < MinAllowedSend) then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, WarehouseShipmentHeader.RecordId(), StrSubstNo(PickAckErr, WarehouseSetup."MICA 3PL Pick Ack. MaxDelay"),
                                                 StrSubstNo(PickAck2Err, MICAFlowEntry."Sent Date Time" - WarehouseSetup."MICA 3PL Pick Ack. MaxDelay" * 60 * 1000));

                end;
            until WarehouseShipmentHeader.Next() = 0;
        end;
    end;
}