codeunit 81820 "MICA Flow Post Ship Confirmat."
{
    //3PL-010: Whse. Shipment. 3PL Confirmation
    TableNo = "MICA Flow Entry";

    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowInformation: Record "MICA Flow Information";
        MICASingleInstanceVariables: Codeunit "MICA SingleInstanceVariables";

    trigger OnRun()
    var
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        StartMsg: label 'Start postprocessing data';
    begin
        OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        SalesReceivablesSetup.Get();
        AssignQuantity(Rec);
        Commit();
        PostPrint(Rec);

        OpeningMICAFlowInformation.Update('', '');
    end;

    local procedure AssignQuantity(MICAFlowEntry: Record "MICA Flow Entry")
    var
        WhseShipmentRelease: Codeunit "Whse.-Shipment Release";
    begin
        WarehouseShipmentHeader.SetRange("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseShipmentLine.SetRange("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No."); //Impossible to post by lines in Whs. Shipment. FlowEntry must contain all Shipment lines
        if WarehouseShipmentHeader.FindSet(false) then begin
            repeat
                WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
                if WarehouseShipmentLine.FindSet(true) then begin
                    repeat
                        WarehouseShipmentLine.validate("Qty. to Ship", WarehouseShipmentLine."MICA 3PL Qty. To Ship");
                        WarehouseShipmentLine.Modify(true);
                        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseShipmentLine.RecordId(), 5); //" ",Created,Received,Loaded,Processed,PostProcessed;
                    until WarehouseShipmentLine.Next() = 0;
                    WhseShipmentRelease.Release(WarehouseShipmentHeader);
                    WarehouseShipmentHeader.Mark(true);
                end;
            until WarehouseShipmentHeader.Next() = 0;
            WarehouseShipmentLine.SetRange("No.");
        end;
        WarehouseShipmentHeader.SetRange("MICA Rcv. Last Flow Entry No.");
        WarehouseShipmentLine.SetRange("MICA Rcv. Last Flow Entry No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    LOCAL procedure OnAfterPostSalesDoc(VAR SalesHeader: Record "Sales Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        LocalMICASingleInstanceVariables: Codeunit "MICA SingleInstanceVariables";
    begin
        if LocalMICASingleInstanceVariables.Get_C81820PostPrint(false) then begin
            LocalMICASingleInstanceVariables.Set_C81820LastPostingNo(SalesInvHdrNo);
            LocalMICASingleInstanceVariables.Set_C81820LastShipingNo(SalesShptHdrNo);
        end;
    end;

    local procedure PostPrint(MICAFlowEntry: Record "MICA Flow Entry")
    var
        SalesHeader: Record "Sales Header";
        Location: record Location;
        FoundWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        Invoice: Boolean;
        PostShipmentErr: label 'Warehouse Shipment Posting Error. Shipment No. %1';
    begin
        WarehouseShipmentHeader.MarkedOnly(true);
        while WarehouseShipmentHeader.FindFirst() do begin
            Location.Get(WarehouseShipmentHeader."Location Code");
            WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
            if WarehouseShipmentLine.FindFirst() then
                if WarehouseShipmentLine."Source Type" = Database::"Sales Line" then begin
                    SalesHeader.GET(WarehouseShipmentLine."Source Subtype", WarehouseShipmentLine."Source No.");
                    if SalesHeader."MICA Shipment Post Option" = SalesHeader."MICA Shipment Post Option"::"Ship and Invoice" then
                        Invoice := true;
                    MICASingleInstanceVariables.Set_C81820PostPrint(true);
                    WhsePostShipment.SetPostingSettings(Invoice);
                    if not WhsePostShipment.Run(WarehouseShipmentLine) then begin
                        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(PostShipmentErr, WarehouseShipmentHeader."No."), GetLastErrorText()));
                        exit;
                    end;
                end else begin
                    Invoice := false;
                    WhsePostShipment.SetPostingSettings(Invoice);
                    WhsePostShipment.Run(WarehouseShipmentLine);
                end;
            WarehouseShipmentHeader.Mark(false);
            if WarehouseShptHasNoLines(WarehouseShipmentHeader) and FoundWarehouseShipmentHeader.Get(WarehouseShipmentHeader."No.") then
                FoundWarehouseShipmentHeader.Delete(false);
        end;
    end;

    local procedure WarehouseShptHasNoLines(WarehouseShipmentHeader: Record "Warehouse Shipment Header"): Boolean
    var
        FoundWarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FoundWarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
        exit(FoundWarehouseShipmentLine.IsEmpty());
    end;
}