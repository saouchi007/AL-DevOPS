codeunit 81401 "MICA Whse-Post Rcv. Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCodeOnBeforeWhseRcptHeaderModify', '', false, false)]
    local procedure OnBeforeWhseRcptHeaderModify(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseReceiptLine: record "Warehouse Receipt Line")
    begin
        WarehouseReceiptHeader.Validate("Assigned User ID", UserId());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeRun', '', false, false)]
    local procedure OnBeforeRun(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    begin
        with WarehouseReceiptLine do
            if FindSet(true, false) then
                repeat
                    Validate("Qty. to Receive (Base)", "Qty. Outstanding (Base)");
                    Modify(true);
                until Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostedWhseRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePostedWhseRcptHeaderInsert(var PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header"; WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        with PostedWhseReceiptHeader do begin
            "MICA Return Order With Collect" := WarehouseReceiptHeader."MICA Return Order With Collect";
            "MICA Container ID" := WarehouseReceiptHeader."MICA Container ID";
            "MICA ETA" := WarehouseReceiptHeader."MICA ETA";
            "MICA SRD" := WarehouseReceiptHeader."MICA SRD";
            "MICA Seal No." := WarehouseReceiptHeader."MICA Seal No.";
            "MICA Port of Arrival" := WarehouseReceiptHeader."MICA Port of Arrival";
            "MICA Carrier Doc. No." := WarehouseReceiptHeader."MICA Carrier Doc. No.";
            "MICA Maritime Air Company Name" := WarehouseReceiptHeader."MICA Maritime Air Company Name";
            "MICA Maritime Air Number" := WarehouseReceiptHeader."MICA Maritime Air Number";
            "MICA 3PL Update Status" := WarehouseReceiptHeader."MICA 3PL Update Status";
            "MICA Send Last Flow Entry No." := WarehouseReceiptHeader."MICA Send Last Flow Entry No.";
            "MICA Send Last Flow Status" := WarehouseReceiptHeader."MICA Send Last Flow Status";
            "MICA Send Ack. Received" := WarehouseReceiptHeader."MICA Send Ack. Received";
            "MICA Rcv. Last Flow Entry No." := WarehouseReceiptHeader."MICA Rcv. Last Flow Entry No.";
            "MICA Record ID" := WarehouseReceiptHeader."MICA Record ID";

            "MICA Send Ack. Received" := false;
        end;
    end;
}