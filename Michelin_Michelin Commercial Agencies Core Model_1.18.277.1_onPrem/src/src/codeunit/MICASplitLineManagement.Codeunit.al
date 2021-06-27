codeunit 80140 "MICA Split Line Management"
{
    // version SPLITLINE

    trigger OnRun()
    begin
    end;

    var
        CommitmentSplitLineSetup: Record "MICA Commit/Split Line Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempSalesLine: Record "Sales Line" temporary;

        TempAppliedSLDisc: Record "MICA New Applied SL Discount" temporary;
        TempAddItemDisc: Record "MICA Additional Item Discount" temporary;
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        InitialShipmentDate: Date;
        //QtyNotAvailableErr: Label 'No quantity available on hand or in-transit for %1 %2.\(%3 = 0).';
        LineExistInWhseDocumentErr: Label 'Line %1 %2 can not be split exists because linked to a warehouse document.';
        NotSplittedLineQst: Label 'There is %1 line(s) not splitted : are-you sure ?';
        //OnNotSplittedLineMsg: Label '%1 line(s) are not splitted on %2 %3.';
        QtyOnHandNotEnoughErr: Label 'The quantity on hand is not enough for line %1. The quantity has been automatically changed from %2 to %3';
        NoMoreQuantityOnHandErr: Label 'There is no more quantity on hand for item %1. Your lines containing these item are deleted';
        CanNotReleaseCauseBackOrderErr: Label 'This order can not be released because you can not shipping in one time when there is a back order';
        SomeLinesAreNotCommittedErr: Label 'Order can not be released because some lines are not committed';
        QtyOnHandNotEnoughCommPeriodErr: Label 'Item %1 is out of commercialization period. Max quantity orderable is %2 %3.';

    procedure SplitLine(var Rec: Record "Sales Line"; FromReallocationBackOrder: Boolean; UseTempTable: Boolean; FromAPI: Boolean)
    var
        SalesLine: Record "Sales Line";
        ReservationEntry: Record "Reservation Entry";
        LinkedReservationEntry: Record "Reservation Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
        Item: Record Item;
        SearchSalesLn: Record "Sales Line";
        Loc: Record Location;
        MICAAPISalesLine: Record "MICA API Sales Line";
        SanaContext: Codeunit "SC - Execution Context";
        NewRebatesMgt: Codeunit "MICA New Rebates Line Mgt";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        MICA3rdParty: Codeunit "MICA 3rd Party";
        OrderedQty: Decimal;
        TotalReservedQty: Decimal;
        NotReservedQty: Decimal;
        QtyOnHand: Decimal;
        LineNo: Integer;
        SourceLineNo: Integer;
        SourceLineQtyBase: Decimal;
        IsExpressOrder: Boolean;
        CustomerTransport: Boolean;
        MessageForCommercializationPeriod: Boolean;
        PreviousPlannedDeliveryDate: Date;
        SourceCommitDateTime: DateTime;
        QtyOnHandIsZeroMsg: Label 'On-Hand quantity for the item is 0. Customer Pick-Up not possible';
        LineCountAdded: Integer;
        OriginalLineAlreadyUse: Boolean;
        IsOutDated: Boolean;
        Is3rdParty: Boolean;
    begin
        QtyOnHand := 0;
        MessageForCommercializationPeriod := false;
        CommitmentSplitLineSetup.GET();
        IF CommitmentSplitLineSetup."Back Order Default Ship. Date" = 0D THEN
            CommitmentSplitLineSetup."Back Order Default Ship. Date" := 20991231D;

        SalesReceivablesSetup.GET();
        SalesReceivablesSetup.TESTFIELD("Skip Manual Reservation", TRUE);

        SalesLine.COPY(Rec); //Backup current line
        LineNo := Rec."Line No.";
        OrderedQty := Rec.Quantity;
        InitialShipmentDate := Rec."Shipment Date";

        WITH Rec DO BEGIN

            TESTFIELD(Type, Type::Item);
            TESTFIELD("No.");
            TESTFIELD(Quantity);
            TESTFIELD("Quantity Shipped", 0);
            if ("MICA Splitted Line") and ("Shipment Date" = CommitmentSplitLineSetup."Back Order Default Ship. Date") then begin
                if Item.Get(SalesLine."No.") then
                    Reserve := Item.Reserve;
            end
            else
                TESTFIELD("MICA Splitted Line", FALSE);

            IsExpressOrder := OrderIsExpressOrder();
            CustomerTransport := IsCustomerTransportOrder();
            Is3rdParty := OrderIs3rdParty();

            //Check line in not in a warehouse shipment
            IF WhseValidateSourceLine.WhseLinesExist(DATABASE::"Sales Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, Quantity) THEN
                ERROR(LineExistInWhseDocumentErr, Rec."Document No.", Rec."Line No.");

            IF NOT (Reserve IN [Reserve::Always, Reserve::Optional]) THEN
                FIELDERROR(Reserve);

            //Force reseration on future in-transit (even after shipment date) to calculate possible reservations
            VALIDATE("Shipment Date", 20991231D);
            MODIFY(TRUE);

            //Reserve to the maximum qty. until 31/12/2099...
            if not "MICA Inv. Discrepancy" then
                AutoReserve();

            //Check if reservation possible...
            CALCFIELDS("Reserved Quantity");
            TotalReservedQty := "Reserved Quantity";
            IF (TotalReservedQty = 0) and (not CustomerTransport) and (not Is3rdParty) THEN BEGIN//Back Order
                                                                                                 //ERROR(ErrorQtyNotAvailable,"No.",Description,FIELDCAPTION("Reserved Quantity"));

                if Item.Get("No.") then
                    if Item.IsOverRangeOfCommercializationDate("Requested Delivery Date") and (QtyOnHand < OrderedQty) then begin
                        if GuiAllowed() then
                            Message(StrSubstNo(QtyOnHandNotEnoughCommPeriodErr, "No.", Format(QtyOnHand), "Unit of Measure Code"));
                        if (SanaContext.GetCurrentOperationName() <> 'CalculateBasket') then
                            Rec.Delete(true)
                        else
                            Rec.Delete(false);
                        exit;
                    end;

                "MICA Splitted Line" := TRUE;
                "MICA Skip Rebates Calculation" := true;
                "MICA Split Source line No." := Rec."Line No.";
                if "MICA Source Line Commit Date" = 0DT then
                    Validate("MICA Source Line Commit Date", CurrentDateTime());
                Reserve := Reserve::Never;
                "Shipment Date" := 0D;
                VALIDATE("Shipment Date", CommitmentSplitLineSetup."Back Order Default Ship. Date");
                if "Planned Delivery Date" <> 0D then
                    Validate("MICA Delivery Date Modified", Today());
                "Planned Shipment Date" := 0D;
                "Planned Delivery Date" := 0D;
                OnWaitingAllocation(Rec);
                if FromAPI then begin
                    Clear(MICAAPISalesLine);
                    MICAAPISalesLine.TransferFields(Rec);
                    MICAAPISalesLine.Insert();
                end else
                    if UseTempTable then begin
                        TempSalesLine.TransferFields(Rec);
                        TempSalesLine.Insert(true);
                    end else
                        Modify(TRUE);
                EXIT;
            END;
        END;

        //Save all reservation entries found (positive and negative)
        ReservationEntry.Reset();
        FilterReservEntryFromSalesLine(ReservationEntry, Rec);
        IF ReservationEntry.FindSet() THEN
            REPEAT
                AddToTempReservEntry(ReservationEntry, TempReservationEntry);
                LinkedReservationEntry.GET(ReservationEntry."Entry No.", NOT ReservationEntry.Positive);
                AddToTempReservEntry(LinkedReservationEntry, TempReservationEntry);
            UNTIL ReservationEntry.Next() = 0;
        ReserveSalesLine.DeleteLine(Rec);

        //Delete original sales lines
        SourceLineNo := Rec."Line No.";
        SourceCommitDateTime := Rec."MICA Source Line Commit Date";
        SourceLineQtyBase := rec."Quantity (Base)";
        if Rec."Planned Delivery Date" < CommitmentSplitLineSetup."Back Order Default Ship. Date" then
            PreviousPlannedDeliveryDate := Rec."Planned Delivery Date";
        Rec."MICA Delete From Split Line" := true;
        Rec.Modify();

        TempAppliedSLDisc.DeleteAll();
        TempAddItemDisc.DeleteAll();
        Clear(TempAppliedSLDisc);
        Clear(TempAddItemDisc);

        NewRebatesMgt.CopyRebatesInformationFromSalesLine(Rec, TempAppliedSLDisc, TempAddItemDisc);

        /*if SanaContext.GetCurrentOperationName() <> 'CalculateBasket' then
            Rec.Delete(true);
        else
            Rec.Delete(false);*/
        if FromAPI then
            Rec.Delete(true);



        SalesReceivablesSetup.Get();
        if (format(SalesReceivablesSetup."MICA Commitment Period") <> '') and
            (SalesLine."Requested Delivery Date" > CalcDate(SalesReceivablesSetup."MICA Commitment Period", WorkDate())) and
            (not CustomerTransport)
        then begin
            LineCountAdded += 1;
            if OriginalLineAlreadyUse then begin
                LineNo += 100;
                while SearchSalesLn.get(SalesLine."Document Type", SalesLine."Document No.", LineNo) do
                    LineNo += 100;
                AddNewLine(SalesLine, OrderedQty, 0D, FALSE, LineNo, 2, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, false, IsOutDated, Is3rdParty);
            end else begin
                OriginalLineAlreadyUse := true;
                AddNewLine(SalesLine, OrderedQty, 0D, FALSE, LineNo, 2, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, true, IsOutDated, Is3rdParty);
            end;
        end else begin
            if SalesLine."Requested Delivery Date" < WorkDate() then begin
                SalesLine."Shipment Date" := WorkDate();
                IsOutDated := true;
            end;
            NotReservedQty := OrderedQty;

            if Loc.Get(SalesLine."Location Code") then;
            //Create Sales Lines to Reserve Qty. On Hand
            if not Is3rdParty then
                QtyOnHand := CalcQtyReservedOnItemLedgerEntry(TempReservationEntry, Is3rdParty)
            else
                QtyOnHand := MICA3rdParty.GetOnHandQuantity(Loc, Rec);

            IF QtyOnHand > 0 THEN BEGIN
                LineCountAdded += 1;
                if OriginalLineAlreadyUse then begin
                    LineNo += 100;
                    while SearchSalesLn.get(SalesLine."Document Type", SalesLine."Document No.", LineNo) do
                        LineNo += 100;
                    AddNewLine(SalesLine, QtyOnHand, SalesLine."Shipment Date", TRUE, LineNo, 0, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, false, IsOutDated, Is3rdParty);
                end else begin
                    OriginalLineAlreadyUse := true;
                    AddNewLine(SalesLine, QtyOnHand, SalesLine."Shipment Date", TRUE, LineNo, 0, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, true, IsOutDated, Is3rdParty);
                end;
                NotReservedQty -= QtyOnHand;
            end else
                if CustomerTransport then begin
                    if GuiAllowed() then
                        Message(QtyOnHandIsZeroMsg);
                    if not OriginalLineAlreadyUse then
                        Rec.Delete(true);
                    exit;
                end;

            if Is3rdParty and (QtyOnHand <> OrderedQty) then begin
                if QtyOnHand > 0 then begin
                    if GuiAllowed() then
                        Message(QtyOnHandNotEnoughErr, SalesLine."Line No.", OrderedQty, QtyOnHand);
                end
                else
                    if GuiAllowed() then
                        Message(NoMoreQuantityOnHandErr, SalesLine."Line No.");
                if not OriginalLineAlreadyUse then
                    Rec.Delete(true);
                exit;
            end;

            if (IsExpressOrder or (Loc."MICA Commitment Type" = Loc."MICA Commitment Type"::"On-Hand")) and (QtyOnHand <> OrderedQty) then begin
                if QtyOnHand > 0 then begin
                    if GuiAllowed() then
                        Message(QtyOnHandNotEnoughErr, SalesLine."Line No.", OrderedQty, QtyOnHand);
                end
                else
                    if GuiAllowed() then
                        Message(NoMoreQuantityOnHandErr, SalesLine."Line No.");
                if not OriginalLineAlreadyUse then
                    Rec.Delete(true);
                exit
            end;

            //Check if the requested delivery date is later than the commercizalization period of the item
            if Item.Get(SalesLine."No.") then
                if Item.IsOverRangeOfCommercializationDate(SalesLine."Requested Delivery Date") and (QtyOnHand < OrderedQty) then begin
                    if GuiAllowed() and (QtyOnHand = 0) then
                        Message(StrSubstNo(QtyOnHandNotEnoughCommPeriodErr, SalesLine."No.", Format(QtyOnHand), SalesLine."Unit of Measure Code"));
                    if not OriginalLineAlreadyUse then
                        Rec.Delete(true);
                    exit;
                end;

            //Create Sales Lines to Reserve On Transfer Line
            if not CustomerTransport then
                WITH TempReservationEntry DO BEGIN
                    SETRANGE("Source Type", DATABASE::"Transfer Line");
                    IF FindSet() THEN
                        REPEAT
                            LineCountAdded += 1;
                            if OriginalLineAlreadyUse then begin
                                LineNo += 100;
                                while SearchSalesLn.get(SalesLine."Document Type", SalesLine."Document No.", LineNo) do
                                    LineNo += 100;
                                AddNewLine(SalesLine, Quantity, "Expected Receipt Date", TRUE, LineNo, 1, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, false, IsOutDated, Is3rdParty);
                            end else begin
                                OriginalLineAlreadyUse := true;
                                AddNewLine(SalesLine, Quantity, "Expected Receipt Date", TRUE, LineNo, 1, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, true, IsOutDated, Is3rdParty);
                            end;
                            NotReservedQty -= Quantity;
                        UNTIL Next() = 0;
                END;
            //Add a back order line for qty. not reservved
            //NotReservedQty := OrderedQty - TotalReservedQty;
            IF (NotReservedQty > 0) and (not CustomerTransport) THEN BEGIN
                LineCountAdded += 1;
                if OriginalLineAlreadyUse then begin
                    LineNo += 100;
                    while SearchSalesLn.get(SalesLine."Document Type", SalesLine."Document No.", LineNo) do
                        LineNo += 100;
                    AddNewLine(SalesLine, NotReservedQty, 0D, FALSE, LineNo, 2, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, false, IsOutDated, Is3rdParty);
                end else begin
                    OriginalLineAlreadyUse := true;
                    AddNewLine(SalesLine, NotReservedQty, 0D, FALSE, LineNo, 2, SourceLineNo, SourceCommitDateTime, SourceLineQtyBase, FromReallocationBackOrder, PreviousPlannedDeliveryDate, MessageForCommercializationPeriod, UseTempTable, LineCountAdded, FromAPI, true, IsOutDated, Is3rdParty);
                end;
            END;
        end;
    end;

    local procedure FilterReservEntryFromSalesLine(var ReservationEntry: Record "Reservation Entry"; Rec: Record "Sales Line")
    begin
        ReservationEntry.SetCurrentKey(
            "Source ID",
            "Source Ref. No.",
            "Source Type",
            "Source Subtype",
            "Source Batch Name",
            "Source Prod. Order Line",
            "Reservation Status",
            "Shipment Date",
            "Expected Receipt Date");
        ReservationEntry.SETRANGE("Source ID", Rec."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", Rec."Line No.");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source Subtype", Rec."Document Type");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
    end;

    local procedure AddToTempReservEntry(ReservationEntry: Record "Reservation Entry"; var TempReservEntry: Record "Reservation Entry" temporary)
    begin
        TempReservEntry.Init();
        ;
        TempReservEntry.TRANSFERFIELDS(ReservationEntry);
        TempReservEntry."Entry No." := ReservationEntry."Entry No.";
        TempReservEntry.Positive := ReservationEntry.Positive;
        TempReservEntry.Insert();
    end;

    local procedure CalcQtyReservedOnItemLedgerEntry(var TempReservEntry: Record "Reservation Entry" temporary; Is3rdParty: Boolean) Qty: Decimal
    begin
        //Calc sum of qty available on Inventory / On-Hand
        WITH TempReservEntry DO BEGIN
            if Is3rdParty then
                SetRange("Source Type", DATABASE::"Purchase Line")
            else
                SETRANGE("Source Type", DATABASE::"Item Ledger Entry");
            IF FindSet() THEN
                REPEAT
                    Qty += TempReservEntry.Quantity
                UNTIL Next() = 0;
            SETRANGE("Source Type");
        END;
    end;

    local procedure AddNewLine(
            SalesLine: Record "Sales Line";
            Qty: Decimal;
            ShipmentDate: Date;
            DoAutoReserve: Boolean;
            LineNo: Integer;
            LineType: Option QtyOnHand,InTransit,BackOrder;
             SourceLineNo: Integer;
             SourceCommitDateTime: DateTime;
             SourceLineQtyBase: Decimal;
             FromReallocationBackOrder: Boolean;
             PreviousPlannedDeliveryDate: Date;
             var MessageForCommercializationPeriod: Boolean;
             UseTempTable: Boolean;
             LineCountAdded: Integer;
             FromAPI: Boolean;
             DoModify: Boolean;
             IsOutDated: Boolean;
             is3rdParty: Boolean)
    var
        NewLine: Record "Sales Line";
        Location: Record Location;
        SalesHdr: Record "Sales Header";
        Cust: Record Customer;
        ShippingAgentServices: Record "Shipping Agent Services";
        ShiptoAddr: Record "Ship-to Address";
        Item: Record item;
        MICAAPISalesLine: Record "MICA API Sales Line";
        NewRebatesMgt: Codeunit "MICA New Rebates Line Mgt";
        MICA3rdParty: Codeunit "MICA 3rd Party";
        PlannedDeliveryDate: Date;
        RequestedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        ShippingAgentCode: Code[10];
        ShippingAgentServiceCode: Code[10];
        CutOff: Boolean;

    begin
        //Create a new line for each reservation line

        WITH NewLine DO BEGIN
            CLEAR(NewLine);
            "Document Type" := SalesLine."Document Type";
            "Document No." := SalesLine."Document No.";
            "Line No." := LineNo;

            VALIDATE(Type, SalesLine.Type);
            SetHasBeenShown();
            VALIDATE("No.", SalesLine."No.");
            VALIDATE("MICA Splitted Line", TRUE);

            NewLine."Location Code" := SalesLine."Location Code";//Due to Item."Item Location Code", to skip check after validate
            VALIDATE("Location Code", SalesLine."Location Code");
            if DoNotValidateField(SalesLine, LineCountAdded) then begin
                Quantity := Qty;
                "Unit of Measure Code" := SalesLine."Unit of Measure Code";
            end else begin
                VALIDATE(Quantity, Qty);
                VALIDATE("Unit of Measure Code", SalesLine."Unit of Measure Code");
            end;

            Validate("Shipping Agent Code", SalesLine."Shipping Agent Code");
            Validate("Shipping Agent Service Code", SalesLine."Shipping Agent Service Code");
            Validate("Outbound Whse. Handling Time", SalesLine."Outbound Whse. Handling Time");
            Validate("Shipping Time", SalesLine."Shipping Time");

            //>> O2C-034
            Validate("MICA Sales Agreement No.", SalesLine."MICA Sales Agreement No.");
            "MICA Priority Code" := SalesLine."MICA Priority Code";
            "Item Category Code" := SalesLine."Item Category Code";
            "MICA Due Date" := SalesLine."MICA Due Date";
            //<< O2C-034

            if DoNotValidateField(SalesLine, LineCountAdded) then
                "MICA Release Status Count" := SalesLine."MICA Release Status Count"
            else
                Validate("MICA Release Status Count", SalesLine."MICA Release Status Count");

            "MICA Exceptional Disc. %" := SalesLine."MICA Exceptional Disc. %";
            "MICA Except. Rebate Reason" := SalesLine."MICA Except. Rebate Reason";
            validate("MICA Prev. Planned Del. Date", SalesLine."MICA Prev. Planned Del. Date");

            IF LineType = LineType::BackOrder THEN
                Reserve := Reserve::Never;

            IF LineType = LineType::InTransit THEN BEGIN //Add handling time for In-Transit
                Location.GET("Location Code");
                ShipmentDate := CALCDATE(Location."Inbound Whse. Handling Time", ShipmentDate);
            END;

            CASE LineType OF

                LineType::QtyOnHand, LineType::InTransit:
                    BEGIN

                        if ShipmentDate = CommitmentSplitLineSetup."Back Order Default Ship. Date" then
                            if SalesHdr.Get(SalesLine."Document Type", SalesLine."Document No.") then
                                if SalesHdr."Shipment Date" < WorkDate() then
                                    ShipmentDate := WorkDate()
                                else
                                    ShipmentDate := SalesHdr."Shipment Date";

                        IF NOT CommitmentSplitLineSetup."Disable Latest Shipment Date" and not FromReallocationBackOrder THEN
                            IF (ShipmentDate < InitialShipmentDate) and (InitialShipmentDate <> CommitmentSplitLineSetup."Back Order Default Ship. Date") THEN //
                                ShipmentDate := InitialShipmentDate;     //

                        SalesReceivablesSetup.Get();
                        if (format(SalesReceivablesSetup."MICA Commitment Period") <> '') and ("Requested Delivery Date" > CalcDate(SalesReceivablesSetup."MICA Commitment Period", WorkDate())) then begin
                            Reserve := Reserve::Optional;
                            "Shipment Date" := 0D;
                            VALIDATE("Shipment Date", CommitmentSplitLineSetup."Back Order Default Ship. Date");
                            "Planned Shipment Date" := 0D;
                            "Planned Delivery Date" := 0D;
                            "Requested Delivery Date" := SalesLine."Requested Delivery Date";
                            LineType := LineType::BackOrder;
                        end else begin
                            "Shipment Date" := 0D;
                            VALIDATE("Shipment Date", ShipmentDate); //Force calculation
                            "Planned Shipment Date" := CalcPlannedShptDate(FIELDNO("Shipment Date"));
                            "Planned Delivery Date" := CalcPlannedDeliveryDate(FIELDNO("Shipment Date"));
                            if SalesHdr.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                                Location.Get(SalesLine."Location Code");
                                Cust.Get(SalesLine."Sell-to Customer No.");
                                ShippingAgentCode := NewLine."Shipping Agent Code";
                                ShippingAgentServiceCode := NewLine."Shipping Agent Service Code";
                                if SalesHdr."MICA Customer Transport" then begin
                                    ShippingAgentCode := Location."MICA Pick-Up Shipping Agent";
                                    ShippingAgentServiceCode := Location."MICA PickUp Ship Agent Service";
                                end;
                                if ShippingAgentServices.Get(ShippingAgentCode, ShippingAgentServiceCode) then
                                    ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code"
                                else
                                    ShippingAgentBaseCalendar := '';
                                if SalesHdr."MICA Order Type" = SalesHdr."MICA Order Type"::"Standard Order" then begin
                                    if ShiptoAddr.Get(SalesHdr."Sell-to Customer No.", SalesHdr."Ship-to Code") then
                                        ShipToBaseCalendar := ShiptoAddr."MICA Base Calendar Code"
                                    else
                                        ShipToBaseCalendar := Cust."Base Calendar Code";
                                    LocationBaseCalendar := Location."Base Calendar Code";
                                    if SalesHdr."MICA Customer Transport" then
                                        ShipToBaseCalendar := Location."MICA Pick-Up Calendar";
                                    CutOff := false;
                                    if (Time() > Location."MICA Regular Cut Off") and (Location."MICA Regular Cut Off" <> 0T) then
                                        CutOff := true;
                                end else
                                    if SalesHdr."MICA Order Type" = SalesHdr."MICA Order Type"::"Express Order" then begin
                                        if ShiptoAddr.Get(SalesHdr."Sell-to Customer No.", SalesHdr."Ship-to Code") then begin
                                            ShiptoAddr.TestField("MICA Express Order");
                                            ShipToBaseCalendar := ShiptoAddr."MICA Base Cal. Code Exp. Order";
                                        end else begin
                                            Cust.TestField("MICA Express Order");
                                            ShipToBaseCalendar := Cust."MICA Base Cal. Code Exp. Order";
                                        end;
                                        LocationBaseCalendar := Location."MICA Base Cal. Code Exp. Order";
                                        CutOff := false;
                                        if (Time() > Location."MICA Express Cut Off") and (Location."MICA Express Cut Off" <> 0T) then
                                            CutOff := true;
                                    end;
                                //RequestedDeliveryDate := MICANextTruckMgt.CalculateRequestedDeliveryDate(WorkDate(), LocationOutboundWhseHandling, LocationBaseCalendar, ShippingAgentShippingTime, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff);
                                RequestedDeliveryDate := SalesLine."Requested Delivery Date";
                                RecalculateDate(NewLine, RequestedDeliveryDate, ShipmentDate, LineType, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, IsOutDated);
                                if LineType = LineType::QtyOnHand then
                                    "Requested Delivery Date" := RequestedDeliveryDate;

                                IF "Promised Delivery Date" = 0D THEN
                                    if SalesLine."Promised Delivery Date" <> 0D then
                                        "Promised Delivery Date" := SalesLine."Promised Delivery Date"
                                    else
                                        VALIDATE("Promised Delivery Date", "Planned Delivery Date");

                                if "Planned Delivery Date" < "Promised Delivery Date" then begin
                                    RequestedDeliveryDate := "Promised Delivery Date";
                                    RecalculateDate(NewLine, RequestedDeliveryDate, ShipmentDate, LineType::QtyOnHand, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, IsOutDated);
                                end;
                            end;
                        end;
                    END;

                LineType::BackOrder:
                    BEGIN
                        "Shipment Date" := 0D;
                        VALIDATE("Shipment Date", CommitmentSplitLineSetup."Back Order Default Ship. Date");
                        "Planned Shipment Date" := 0D;
                        "Planned Delivery Date" := 0D;
                        "Requested Delivery Date" := SalesLine."Requested Delivery Date";
                    END;
            END;

            if DoNotValidateField(SalesLine, LineCountAdded) then begin
                "Unit Price" := SalesLine."Unit Price";
                "Line Discount %" := SalesLine."Line Discount %";
                UpdateAmounts();
            end else begin
                VALIDATE("Unit Price", SalesLine."Unit Price");
                VALIDATE("Line Discount %", SalesLine."Line Discount %");
            end;
            VALIDATE("MICA Splitted Line", TRUE);

            //Check if the requested delivery date is later than the commercizalization period of the item
            if Item.Get(SalesLine."No.") then
                if Item.IsOverRangeOfCommercializationDate(SalesLine."Requested Delivery Date") and (Qty < SalesLine."Quantity") then begin
                    if not MessageForCommercializationPeriod and GuiAllowed() then
                        Message(StrSubstNo(QtyOnHandNotEnoughCommPeriodErr, SalesLine."No.", Format(Qty), SalesLine."Unit of Measure Code"));
                    MessageForCommercializationPeriod := true;
                    VALIDATE("MICA Splitted Line", false);
                end;

            //if (LineType = LineType::QtyOnHand) and NewLine.OrderIsExpressOrder() and (Quantity <> SalesLine.Quantity) then
            //    Validate("MICA Splitted Line", false);
            if SalesHdr.Get("Document Type", "Document No.") and (SalesHdr."MICA Order Type" = SalesHdr."MICA Order Type"::"Express Order") then
                "MICA Split Src Exp Ord Qty (b)" := SourceLineQtyBase - Qty;
            "MICA Split Source line No." := SourceLineNo;
            "MICA Splitted Line" := TRUE;
            "MICA Skip Rebates Calculation" := true;
            "MICA Countermark" := SalesLine."MICA Countermark";
            "MICA 3PL Whse Shpt. Comment" := SalesLine."MICA 3PL Whse Shpt. Comment";
            "MICA Transport Instruction" := SalesLine."MICA Transport Instruction";
            if SourceCommitDateTime = 0DT then
                Validate("MICA Source Line Commit Date", CurrentDateTime())
            else
                Validate("MICA Source Line Commit Date", SourceCommitDateTime);
            CASE LineType OF
                LineType::QtyOnHand:
                    OnReservedOnHand(NewLine);
                LineType::InTransit:
                    OnReservedInTransit(NewLine);
                LineType::BackOrder:
                    OnWaitingAllocation(NewLine);
            end;
            if (PreviousPlannedDeliveryDate <> "Planned Delivery Date") and (PreviousPlannedDeliveryDate <> 0D) then
                Validate("MICA Prev. Planned Del. Date", PreviousPlannedDeliveryDate);

            if not UseTempTable or FromAPI then begin
                if FromAPI then begin
                    Clear(MICAAPISalesLine);
                    MICAAPISalesLine.TransferFields(NewLine);
                    MICAAPISalesLine.Insert();
                end else
                    if not DoModify then
                        Insert(TRUE)
                    else
                        Modify(true);
                if not TempAppliedSLDisc.IsEmpty() and not DoModify then
                    NewRebatesMgt.CopyRebatesInformationToSalesLine(NewLine, TempAppliedSLDisc, TempAddItemDisc);

                if DoNotValidateField(SalesLine, LineCountAdded) then begin
                    "Unit Price" := SalesLine."Unit Price";
                    "Line Discount %" := SalesLine."Line Discount %";
                    UpdateAmounts();
                end else begin
                    VALIDATE("Unit Price", SalesLine."Unit Price");
                    VALIDATE("Line Discount %", SalesLine."Line Discount %");
                end;
                if FromAPI then begin
                    Clear(MICAAPISalesLine);
                    MICAAPISalesLine.TransferFields(NewLine);
                    MICAAPISalesLine.Modify();
                end else
                    Modify();

            end else begin

                TempSalesLine.TransferFields(NewLine);
                TempSalesLine.Insert(true);
            end;

            IF DoAutoReserve and not UseTempTable and not FromAPI THEN
                if not is3rdParty then
                    AutoReserve() //Run reservation for each in-transit line
                else
                    MICA3rdParty.Reservation3rdParty(Location, NewLine);
        END;

    end;

    local procedure RecalculateDate(var SalesLine: Record "Sales Line"; var RequestedDeliveryDate: Date; ShipmentDate: Date; LineType: Option QtyOnHand,InTransit,BackOrder; LocationBaseCalendar: Code[10]; ShippingAgentBaseCalendar: Code[10]; ShipToBaseCalendar: Code[10]; CutOff: Boolean; IsOutDated: Boolean)
    var
        MICANextTruckMgt: Codeunit "MICA Next Truck Management";
    begin
        if LineType = LineType::QtyOnHand then begin
            if not IsOutDated then
                MICANextTruckMgt.CalculateDateLineOnHand(RequestedDeliveryDate, SalesLine."Outbound Whse. Handling Time", LocationBaseCalendar, SalesLine."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, SalesLine."Shipment Date", SalesLine."Planned Shipment Date", SalesLine."Planned Delivery Date")
            else
                MICANextTruckMgt.CalculateDateLineTransit(SalesLine."Shipment Date", SalesLine."Outbound Whse. Handling Time", LocationBaseCalendar, SalesLine."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, SalesLine."Shipment Date", SalesLine."Planned Shipment Date", SalesLine."Planned Delivery Date");
            if SalesLine."Shipment Date" < WorkDate() then begin
                SalesLine."Shipment Date" := ShipmentDate;
                RequestedDeliveryDate := MICANextTruckMgt.CalculateRequestedDeliveryDate(WorkDate(), SalesLine."Outbound Whse. Handling Time", LocationBaseCalendar, SalesLine."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff);
                SalesLine."Planned Shipment Date" := SalesLine.CalcPlannedShptDate(SalesLine.FIELDNO("Shipment Date"));
                SalesLine."Planned Delivery Date" := SalesLine.CalcPlannedDeliveryDate(SalesLine.FIELDNO("Shipment Date"));
            end;
        end else
            if LineType = LineType::InTransit then
                MICANextTruckMgt.CalculateDateLineTransit(SalesLine."Shipment Date", SalesLine."Outbound Whse. Handling Time", LocationBaseCalendar, SalesLine."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, SalesLine."Shipment Date", SalesLine."Planned Shipment Date", SalesLine."Planned Delivery Date");
        if (SalesLine."Planned Delivery Date" < SalesLine."Requested Delivery Date") and (LineType = LineType::InTransit) then
            SalesLine."Planned Delivery Date" := SalesLine."Requested Delivery Date";
    end;


    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure SalesLineOnBeforeValidateQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        WITH Rec DO BEGIN
            IF Type <> Type::Item THEN
                EXIT;
            IF NOT (CurrFieldNo IN [FIELDNO(Quantity)]) THEN
                EXIT;
            IF Quantity > xRec.Quantity THEN
                TESTFIELD("MICA Splitted Line", FALSE); //Can't add qty on a splitted line
        END;
    end;

    procedure GetTempSalesLine(var SalesLine: Record "Sales Line")
    begin
        Clear(TempSalesLine);
        if TempSalesLine.FindSet() then
            repeat
                SalesLine.TransferFields(TempSalesLine);
                SalesLine.Insert(true);
            until TempSalesLine.Next() = 0
    end;

    [EventSubscriber(ObjectType::Page, 42, 'OnQueryClosePageEvent', '', false, false)]
    local procedure OnQueryCloseSalesOrderPage(var Rec: Record "Sales Header"; var AllowClose: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if AllSalesOrderLinesAreCommitted(Rec, SalesLine) then
            exit;

        if not confirm(NotSplittedLineQst, FALSE, SalesLine.Count()) THEN
            AllowClose := FALSE;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', false, false)]
    local procedure OnAfterCheckSalesOrderApprovalPossible(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if not (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
            exit;
        if not AllSalesOrderLinesAreCommitted(SalesHeader, SalesLine) then
            Error(SomeLinesAreNotCommittedErr);
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnReleaseSalesOrder(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        SalesLine: Record "Sales Line";
        MICAShippingTimeMgt: Codeunit "MICA Shipping1TimeManagement";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            IF PreviewMode THEN
                EXIT;

            if not AllSalesOrderLinesAreCommitted(SalesHeader, SalesLine) then
                Error(SomeLinesAreNotCommittedErr);

            if SalesHeader."Shipping Advice" = SalesHeader."Shipping Advice"::Complete then begin
                // Some filters are already set by procedure AllSalesOrderLinesAreCommitted
                // SalesLn.SetRange("Document Type", SalesHeader."Document Type");
                // SalesLn.SetRange("Document No.", SalesHeader."No.");
                // SalesLn.SetRange(Type, SalesLn.Type::Item);
                // SalesLn.SetRange("Planned Delivery Date", 0D);
                SalesLine.SetRange(Quantity);
                SalesLine.SetRange(Reserve);
                SalesLine.SetRange("MICA Splitted Line");
                SalesLine.SetRange("Planned Delivery Date", 0D);
                if not SalesLine.IsEmpty() then
                    Error(CanNotReleaseCauseBackOrderErr);
                MICAShippingTimeMgt.Shipping1Time(SalesHeader, SalesLine);
            end;
        end;
    end;

    local procedure AllSalesOrderLinesAreCommitted(var FromSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"): Boolean
    begin

        ToSalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        ToSalesLine.SetRange("Document Type", FromSalesHeader."Document Type");
        ToSalesLine.SetRange("Document No.", FromSalesHeader."No.");
        ToSalesLine.SetRange(Type, ToSalesLine.Type::Item);
        ToSalesLine.SetFilter(Quantity, '>%1', 0);
        ToSalesLine.SetRange(Reserve, ToSalesLine.Reserve::Optional, ToSalesLine.Reserve::Always);
        ToSalesLine.SetRange("MICA Splitted Line", false);
        exit(ToSalesLine.IsEmpty());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValuesSalesLine(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then
            if Item."MICA Item Location Code" <> '' then
                if SalesLine."Location Code" <> Item."MICA Item Location Code" then begin
                    SalesLine."Location Code" := CopyStr(Item."MICA Item Location Code", 1, MaxStrLen(SalesLine."Location Code"));//Due to Item."Item Location Code", to skip check after validate
                    SalesLine.Validate("Location Code", Item."MICA Item Location Code");
                end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSalesLineByChangedFieldNo', '', false, false)]
    local procedure OnBeforeSalesLineByChangedFieldNoSalesHeaderTable(var SalesLine: Record "Sales Line"; ChangedFieldNo: Integer; var IsHandled: Boolean)
    begin
        IsHandled := false;
        if (ChangedFieldNo = SalesLine.FieldNo("Requested Delivery Date")) and (SalesLine."MICA Status" = SalesLine."MICA Status"::"Waiting Allocation") then
            IsHandled := true;
    end;

    [BusinessEvent(false)]
    local procedure OnReservedOnHand(var SalesLine: Record "Sales Line")
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnReservedInTransit(var SalesLine: Record "Sales Line")
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnWaitingAllocation(var SalesLine: Record "Sales Line")
    begin
    end;

    local procedure DoNotValidateField(SalesLine: record "Sales Line"; LineCountAdded: Integer): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        if SalesSetup."MICA Force Val. During WebShop" then
            exit(false);

        if (Strlen(SalesLine."Document No.") = 20) //SANA Order in Calculate Basket
        and (LineCountAdded > 1) then //Added line in split mgmt used only for Qty/Planned Delivery Date in XML
            exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnAutoReserveOneLineOnAfterUpdateSearchNextStep', '', false, false)]
    local procedure OnAutoReserveOneLineOnAfterUpdateSearchNextStep(var Item: Record Item; var Positive: Boolean; var Search: Text[1]; var NextStep: Integer; var InvSearch: Text[1]; InvNextStep: Integer);
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin

        SalesSetup.Get();
        if SalesSetup."MICA Use Std Reservation Mode" then
            exit;

        Search := '-';
        NextStep := 1;

    end;


}
