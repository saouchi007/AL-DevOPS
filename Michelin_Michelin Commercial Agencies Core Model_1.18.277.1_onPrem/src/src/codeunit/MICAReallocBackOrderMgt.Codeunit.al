codeunit 80340 "MICA Realloc. BackOrder Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        Rec.CalcFields("Reserved Quantity");
        if (Rec.Type = Rec.Type::Item) and ((Rec."MICA Splitted Line" = true) or (Rec."MICA Status" = Rec."MICA Status"::Open)) and not (Rec."MICA Delete From Split Line") and (Rec."Outstanding Quantity" <> 0) and not (Rec."MICA Delete Without Realloc.") then
            CommitItemsInsideCommitmentPeriod(Rec."No.", Rec."Location Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterModifyQuantitySalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        Rec.CalcFields("Reserved Quantity");
        if (Rec.Type = Rec.Type::Item) and (Rec.Quantity < xRec.Quantity) and (Rec.Reserve = Rec.Reserve::Always) and not (Rec."MICA Delete From Split Line") and (Rec."Reserved Quantity" > 0) and (rec.Quantity <> 0) then
            CommitItemsInsideCommitmentPeriod(Rec."No.", Rec."Location Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnBeforeValidateEvent', 'Receipt Date', false, false)]
    local procedure OnBeforeValidateReceiptDateTransferLine(var Rec: Record "Transfer Line")
    begin
        UpdateTheTOLineReceiptDate(Rec);
    end;

    procedure EndingDateCommitmentPeriod(): Date
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        exit(CalcDate(SalesReceivablesSetup."MICA Commitment Period", WorkDate()));
    end;

    procedure "CommitItemsInsideCommitmentPeriod"(ItemCode: Code[20]; LocationCode: Code[10])
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        ForStatusSalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Item: Record Item;
        Workflow: Record Workflow;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        MICASplitLineManagement: Codeunit "MICA Split Line Management";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesHdrStatusSave: Enum "Sales Document Status";
        SaveStatus: Integer;
        WorkflowEnableSave: Boolean;
        AllIsAlreadyReallocate: Boolean;
    begin
        SalesLine.SetCurrentKey("Document Type", "Type", "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if ItemCode <> '' then begin
            if Item.Get(ItemCode) then
                if Item.Blocked then
                    exit;
            SalesLine.SetRange("No.", ItemCode);
        end;

        if LocationCode <> '' then
            SalesLine.SetRange("Location Code", LocationCode);
        SalesLine.SetFilter("Requested Delivery Date", '<=%1', EndingDateCommitmentPeriod());
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        SalesLine.SetRange("Reserved Quantity", 0);
        SalesLine.SetRange("MICA Splitted Line", true);

        if SalesLine.FindSet() then
            repeat
                TempSalesLine.TransferFields(SalesLine);
                TempSalesLine.Insert();
            until SalesLine.Next() = 0;
        SalesLine.Reset();
        Clear(SalesLine);
        TempSalesLine.SetCurrentKey("MICA Source Line Commit Date");
        if TempSalesLine.FindSet() then
            repeat
                Item.Get(TempSalesLine."No.");
                if (Item.Reserve = Item.Reserve::Always) and (TempSalesLine."Outstanding Quantity" <> TempSalesLine."Reserved Quantity") and not Item.Blocked then
                    if TempSalesLine."Reserved Quantity" <> TempSalesLine."Outstanding Quantity" then
                        if SalesHeader.Get(TempSalesLine."Document Type", TempSalesLine."Document No.") then begin
                            SalesHdrStatusSave := SalesHeader.Status;
                            if SalesHeader.Status <> SalesHeader.Status::Open then
                                if SalesHdrStatusSave = SalesHeader.Status::Released then
                                    ReleaseSalesDocument.Reopen(SalesHeader)
                                else begin
                                    SalesHeader.Status := SalesHeader.Status::Open;
                                    SalesHeader.Modify();
                                end;
                            TempSalesLine.Validate(Reserve, TempSalesLine.Reserve::Always);
                            TempSalesLine.Validate("MICA Splitted Line", false);
                            SaveStatus := TempSalesLine."MICA Status";
                            if TempSalesLine."MICA Status" = TempSalesLine."MICA Status"::"Waiting Allocation" then
                                if SalesHeader."Shipment Date" >= WorkDate() then
                                    TempSalesLine.UpdateDates()
                                else
                                    TempSalesLine.Validate("Shipment Date", WorkDate());
                            MICASplitLineManagement.SplitLine(TempSalesLine, true, false, false);
                            if (ItemCode <> '') and (LocationCode <> '') then
                                if ForStatusSalesLine.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.") then
                                    if SaveStatus = ForStatusSalesLine."MICA Status" then
                                        AllIsAlreadyReallocate := true;
                            if SalesHdrStatusSave <> SalesHeader.Status::Open then
                                if SalesHdrStatusSave = SalesHeader.Status::Released then begin
                                    SalesReceivablesSetup.Get();
                                    WorkflowEnableSave := false;
                                    if Workflow.Get(SalesReceivablesSetup."MICA Approval Workflow") then begin
                                        WorkflowEnableSave := Workflow.Enabled;
                                        if Workflow.Enabled = true then begin
                                            Workflow.Validate(Enabled, false);
                                            Workflow.Modify(true);
                                        end;
                                    end;
                                    ReleaseSalesDocument.ReleaseSalesHeader(SalesHeader, false);
                                    if WorkflowEnableSave = true then begin
                                        Workflow.Validate(Enabled, true);
                                        Workflow.Modify(true);
                                    end;
                                end else begin
                                    SalesHeader.Status := SalesHdrStatusSave;
                                    SalesHeader.Modify();
                                end;
                        end;
            until (TempSalesLine.Next() = 0) or AllIsAlreadyReallocate;
    end;

    procedure CommitmentOnTransferOrderHeader(TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Derived From Line No.", 0);
        if TransferLine.FindSet() then
            repeat
                CommitItemsInsideCommitmentPeriod(TransferLine."Item No.", TransferLine."Transfer-to Code");
            until TransferLine.Next() = 0;
    end;

    procedure UpdateTheTOLineReceiptDate(var TransferLine: Record "Transfer Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        //Reserved Quantity Inbnd.
        ReservationEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntry.SetRange("Source ID", TransferLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", TransferLine."Line No.");
        ReservationEntry.SetRange("Source Type", 5741);
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Source Prod. Order Line", TransferLine."Derived From Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        if ReservationEntry.FindSet() then
            repeat
                UpdateReservEntryDate(ReservationEntry, TransferLine."Receipt Date", true);
            until ReservationEntry.Next() = 0;

        //Reserved Quantity Shipped
        ReservationEntry.SetRange("Source ID", TransferLine."Document No.");
        ReservationEntry.SetFilter("Source Ref. No.", '<>%1', 0);
        ReservationEntry.SetRange("Source Type", 5741);
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Source Prod. Order Line", TransferLine."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        if ReservationEntry.FindSet() then
            repeat
                UpdateReservEntryDate(ReservationEntry, TransferLine."Receipt Date", false);
            until ReservationEntry.Next() = 0;
    end;

    local procedure UpdateReservEntryDate(ReservationEntry: Record "Reservation Entry"; ReceiptDate: Date; IsReservedQuantityInbound: Boolean)
    var
        UpdateReservationEntry: Record "Reservation Entry";
        FoundReservationEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
    begin
        FoundReservationEntry.SetRange("Entry No.", ReservationEntry."Entry No.");
        //ReservEntry3.SetRange("Source Ref. No.", ReservEntry."Source Ref. No.");
        FoundReservationEntry.SetRange("Source Type", 37);
        //ReservEntry3.SetRange("Source Subtype", 1);
        //ReservEntry3.SetRange("Source Prod. Order Line", ReservEntry."Source Prod. Order Line");
        //ReservEntry3.SetRange("Reservation Status", ReservEntry."Reservation Status"::Reservation);
        if FoundReservationEntry.FindFirst() then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", FoundReservationEntry."Source Subtype");
            SalesLine.SetRange("Document No.", FoundReservationEntry."Source ID");
            SalesLine.SetRange("Line No.", FoundReservationEntry."Source Ref. No.");
            if SalesLine.FindFirst() then begin
                UpdateShipmentDate(SalesLine, ReceiptDate);
                if IsReservedQuantityInbound and (ReceiptDate > SalesLine."Shipment Date") then
                    Error(ReceiptDateOverShipmentDateErr);
                SalesLine.Modify();
            end;
            UpdateReservationEntry.SetRange("Entry No.", ReservationEntry."Entry No.");
            if UpdateReservationEntry.FindSet(true) then
                repeat
                    UpdateReservationEntry.Validate("Shipment Date", SalesLine."Shipment Date");
                    UpdateReservationEntry.Validate("Expected Receipt Date", ReceiptDate);
                    UpdateReservationEntry.Modify();
                until UpdateReservationEntry.Next() = 0;
        end;
    end;

    local procedure UpdateShipmentDate(var SalesLine: Record "Sales Line"; ReceiptDate: Date)
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        ShippingAgentServices: Record "Shipping Agent Services";
        ShiptoAddress: Record "Ship-to Address";
        Location: Record Location;
        MICANextTruckManagement: Codeunit "MICA Next Truck Management";
        MICAWhseSalesReleasebyShp: Codeunit "MICA Whse.-Sales Release byShp";
        NewShipmentDate: Date;
        PlannedShipmentDate: Date;
        PlannedDeliveryDate: Date;
        RequestedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        Location.Get(SalesLine."Location Code");
        Customer.Get(SalesHeader."Sell-to Customer No.");
        if ShippingAgentServices.Get(SalesHeader."Shipping Agent Code", SalesHeader."Shipping Agent Service Code") then
            ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code"
        else
            ShippingAgentBaseCalendar := '';
        if SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Standard Order" then begin
            if ShiptoAddress.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
                ShipToBaseCalendar := ShiptoAddress."MICA Base Calendar Code"
            else
                ShipToBaseCalendar := Customer."Base Calendar Code";
            LocationBaseCalendar := Location."Base Calendar Code";
        end else
            if SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Express Order" then begin
                if ShiptoAddress.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
                    ShipToBaseCalendar := ShiptoAddress."MICA Base Cal. Code Exp. Order"
                else
                    ShipToBaseCalendar := Customer."MICA Base Cal. Code Exp. Order";
                LocationBaseCalendar := Location."MICA Base Cal. Code Exp. Order";
            end;
        MICANextTruckManagement.CalculateDateLineTransit(ReceiptDate, SalesHeader."Outbound Whse. Handling Time", LocationBaseCalendar, SalesHeader."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, NewShipmentDate, PlannedShipmentDate, PlannedDeliveryDate);
        if NewShipmentDate < SalesLine."Requested Delivery Date" then begin
            RequestedDeliveryDate := SalesLine."Requested Delivery Date";
            MICANextTruckManagement.CalculateDateLineOnHand(RequestedDeliveryDate, SalesLine."Outbound Whse. Handling Time", LocationBaseCalendar, SalesLine."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, NewShipmentDate, SalesLine."Planned Shipment Date", PlannedDeliveryDate);
            PlannedDeliveryDate := SalesLine."Promised Delivery Date";
        end;
        SalesLine."Shipment Date" := NewShipmentDate;
        if SalesLine."Planned Delivery Date" <> PlannedDeliveryDate then
            SalesLine."MICA Prev. Planned Del. Date" := SalesLine."Planned Delivery Date";
        if (SalesLine."Promised Delivery Date" <> 0D) and (PlannedDeliveryDate < SalesLine."Promised Delivery Date") then begin
            SalesLine."Planned Delivery Date" := SalesLine."Promised Delivery Date";
            RequestedDeliveryDate := SalesLine."Promised Delivery Date";
            MICANextTruckManagement.CalculateDateLineOnHand(RequestedDeliveryDate, SalesLine."Outbound Whse. Handling Time", LocationBaseCalendar, SalesLine."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, SalesLine."Shipment Date", PlannedShipmentDate, PlannedDeliveryDate);
            PlannedDeliveryDate := SalesLine."Promised Delivery Date";
        end;
        SalesLine."Planned Delivery Date" := PlannedDeliveryDate;
        SalesLine."Planned Shipment Date" := PlannedShipmentDate;
        if SalesLine."Promised Delivery Date" = 0D then
            SalesLine."Promised Delivery Date" := SalesLine."Planned Delivery Date";
        if SalesLine."Planned Delivery Date" <> 0D then
            SalesLine.Validate("MICA Delivery Date Modified", Today());
        if SalesHeader.Status = SalesHeader.Status::Released then
            MICAWhseSalesReleasebyShp.CreateAllWhseRqst(SalesHeader);
    end;

    procedure UpdateTOLineWithInTransitDelay()
    var
        TransferHeader: Record "Transfer Header";
        TempTransferHeader: Record "Transfer Header" temporary;
        Location: Record Location;
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        NewSRD: Date;
        ReferenceDateForNewSRDCalculation: Date;
        JobRunDateTime: DateTime;
        DateTimeDelay: DateTime;
    begin
        JobRunDateTime := CurrentDateTime();
        DateTimeDelay := CreateDateTime(Today(), 210000T);
        OnBeforeUpdateTOLineWithInTransitDelay(JobRunDateTime, DateTimeDelay);

        with TransferHeader do begin
            SetCurrentKey("MICA SRD");
            if JobRunDateTime < DateTimeDelay then begin
                // In this case, job is running before 9 PM
                SetFilter("MICA SRD", '<%1&<>%2', Today(), 0D);
                ReferenceDateForNewSRDCalculation := CalcDate('<-1D>', Today());
            end else begin
                // In this case, job is running after 9 PM
                SetFilter("MICA SRD", '<=%1&<>%2', Today(), 0D);
                ReferenceDateForNewSRDCalculation := Today();
            end;
            if FindSet() then begin
                repeat
                    Location.get("Transfer-to Code");
                    if Format(Location."MICA SRD Default Delay") <> '' then begin
                        NewSRD := CalcDate(Location."MICA SRD Default Delay", ReferenceDateForNewSRDCalculation);
                        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::Location, '', '', Location."Base Calendar Code");
                        while CalendarManagement.IsNonworkingDay(NewSRD, CustomizedCalendarChange) do
                            NewSRD := CalcDate('<+1D>', NewSRD);
                        UpdateTOHdrWithInTransitDelayFillBuffer(TempTransferHeader, TransferHeader, NewSRD);
                    end;
                until Next() = 0;
                UpdateTOHdrWithInTransitDelayUpdateLines(TempTransferHeader);
            end;
        end;
    end;

    local procedure UpdateTOHdrWithInTransitDelayFillBuffer(var ToTempTransferHeader: Record "Transfer Header" temporary; FromTransferHeader: Record "Transfer Header"; FromNewSRD: Date)
    begin
        with ToTempTransferHeader do begin
            Init();
            "No." := FromTransferHeader."No.";
            "MICA SRD" := FromNewSRD;
            Insert();
        end;
    end;

    local procedure UpdateTOHdrWithInTransitDelayUpdateLines(var FromTempTransferHeader: Record "Transfer Header" temporary)
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        TransHdrReopened: Boolean;
    begin
        with FromTempTransferHeader do
            if FindSet() then
                repeat
                    TransHdrReopened := false;
                    if TransferHeader.Get("No.") then begin
                        TransferHeader.SetHideValidationMsg(true);
                        if TransferHeader.Status = TransferHeader.Status::Released then begin
                            ReleaseTransferDocument.Reopen(TransferHeader);
                            TransHdrReopened := true;
                        end;
                        TransferHeader.Validate("MICA SRD", "MICA SRD");
                        TransferHeader.Modify(true);
                        TransferLine.SetRange("Document No.", TransferHeader."No.");
                        TransferLine.SetRange("Derived From Line No.", 0);
                        if TransferLine.FindSet(true, false) then
                            repeat
                                TransferLine.Validate("MICA SRD", "MICA SRD");
                                if TransferLine."MICA Initial SRD" = 0D then
                                    TransferLine.Validate("MICA Initial SRD", TransferLine."MICA SRD");
                                TransferLine.Modify(false);
                            until TransferLine.Next() = 0;
                        if TransHdrReopened then
                            Codeunit.Run(Codeunit::"Release Transfer Document", TransferHeader);
                    end;
                until Next() = 0;
        /*        CustomizedCalChg: Record "Customized Calendar Change";
                TransLn: Record "Transfer Line";
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
                Loc: Record Location;
                CalMgt: Codeunit "Calendar Management";
                NewReceiptDate: Date;
            begin
                SalesReceivablesSetup.Get();
                TransLn.SetFilter("Outstanding Quantity", '<>%1', 0);
                TransLn.SetFilter("Receipt Date", '<=', WorkDate());
                if TransLn.FindSet() then
                    repeat
                        NewReceiptDate := CalcDate(SalesReceivablesSetup."MICA In-transit default delay", TransLn."Receipt Date");
                        CustomizedCalChg.SetSource(CustomizedCalChg."Source Type"::Location, '', '', Loc."Base Calendar Code");
                        while CalMgt.IsNonworkingDay(NewReceiptDate, CustomizedCalChg) do
                            NewReceiptDate := CalcDate('<+1D>', NewReceiptDate);
                        TransLn.Validate("Receipt Date", NewReceiptDate);
                    until TransLn.Next() = 0;*/
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateTOLineWithInTransitDelay(var JobRunDateTime: DateTime; var DateTimeDelay: DateTime)
    begin
    end;


    var
        ReceiptDateOverShipmentDateErr: Label 'Receipt Date is over Shipment Date';
}
