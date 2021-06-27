codeunit 81822 "MICA SplitSalesLine"
{
    //3PL-010: Whse. Shipment. 3PL Confirmation
    //based on Table 36 procedure: RecreateSalesLines

    var
        SalesLine: Record "Sales Line";
        //ReservEntry: Record "Reservation Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
        TempMICANewAppliedSLDiscount: Record "MICA New Applied SL Discount" temporary;
        TempMICAAdditionalItemDiscount: Record "MICA Additional Item Discount" temporary;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        MICASplitLineManagement: Codeunit "MICA Split Line Management";
        ToLargeQtyErr: label 'New Line Quantity to large. Maximum allowed Quantity is %1';

    procedure SplitSalesLineUI(var OrigSalesLine: Record "Sales Line"; KeepCommitment: Boolean; ReallocateQuantity: Boolean; NewLineQty: Decimal)
    var
        ErrorText: Text;
    begin
        OrigSalesLine.TestField(Type, SalesLine.Type::Item);
        OrigSalesLine.TestField("No.");
        if (OrigSalesLine."Outstanding Quantity" = 0) or (NewLineQty = 0) then
            exit;
        if NewLineQty > OrigSalesLine."Outstanding Quantity" then begin
            ErrorText := StrSubstNo(ToLargeQtyErr, OrigSalesLine."Outstanding Quantity");
            error(ErrorText);
        end;
        if KeepCommitment then
            OrigSalesLine.TestField("MICA Splitted Line");

        AddSalesLine(OrigSalesLine, KeepCommitment, ReallocateQuantity, NewLineQty);

        if KeepCommitment then begin
            SalesLine."MICA Splitted Line" := false;
            MICASplitLineManagement.SplitLine(SalesLine, not KeepCommitment, false, false);
        end;
    end;

    procedure SplitSalesLine(var OrigSalesLine: Record "Sales Line")
    var
        KeepCommitment: Boolean;
        NewLineQty: Decimal;
    begin
        OrigSalesLine.TestField(Type, SalesLine.Type::Item);
        OrigSalesLine.TestField("No.");
        if OrigSalesLine."Outstanding Quantity" = 0 then
            exit;
        if OrigSalesLine."MICA Inv. Discrepancy" then
            KeepCommitment := false
        else
            KeepCommitment := true;
        NewLineQty := OrigSalesLine."Outstanding Quantity";
        AddSalesLine(OrigSalesLine, KeepCommitment, true, NewLineQty);

        if KeepCommitment then begin
            SalesLine."MICA Splitted Line" := false;
            MICASplitLineManagement.SplitLine(SalesLine, not KeepCommitment, false, false);
        end;

    end;

    procedure AddSalesLineAndSplit(var OrigSalesLine: Record "Sales Line"; KeepCommitment: Boolean; NewLineQty: Decimal)
    begin
        AddSalesLine(OrigSalesLine, KeepCommitment, false, NewLineQty);

        if KeepCommitment then begin
            SalesLine."MICA Splitted Line" := false;
            MICASplitLineManagement.SplitLine(SalesLine, not KeepCommitment, false, false);
        end;
    end;

    procedure AddSalesLine(var OrigSalesLine: Record "Sales Line"; KeepCommitment: Boolean; ReallocateQuantity: Boolean; NewLineQty: Decimal)
    var
        TempSalesLine: Record "Sales Line" temporary;
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)" temporary;
        TempInteger: Record Integer temporary;
        TempAssembletoOrderLink: Record "Assemble-to-Order Link" temporary;
        AssembletoOrderLink: Record "Assemble-to-Order Link";
        MICANewRebatesLineMgt: Codeunit "MICA New Rebates Line Mgt";
        ExtendedTextAdded: Boolean;
        LastLineNo: Integer;
    begin
        //SalesLine.LOCKTABLE();
        //ItemChargeAssgntSales.LOCKTABLE();
        //ReservEntry.LOCKTABLE();
        SalesLine.SETRANGE("Document Type", OrigSalesLine."Document Type");
        SalesLine.SETRANGE("Document No.", OrigSalesLine."Document No.");
        SalesLine.FindLast();
        LastLineNo := SalesLine."Line No.";
        SalesLine.Reset();
        SalesLine.Get(OrigSalesLine."Document Type", OrigSalesLine."Document No.", OrigSalesLine."Line No.");

        TempMICAAdditionalItemDiscount.DeleteAll();
        TempMICANewAppliedSLDiscount.DeleteAll();
        Clear(TempMICAAdditionalItemDiscount);
        Clear(TempMICANewAppliedSLDiscount);
        MICANewRebatesLineMgt.CopyRebatesInformationFromSalesLine(OrigSalesLine, TempMICANewAppliedSLDiscount, TempMICAAdditionalItemDiscount);

        TempReservationEntry.DELETEALL();
        RecreateReservEntryReqLine(TempSalesLine, TempAssembletoOrderLink, AssembletoOrderLink);
        TransferItemChargeAssgntSalesToTemp(OrigSalesLine, ItemChargeAssignmentSales, TempItemChargeAssignmentSales);
        TempSalesLine.FINDSET();
        ExtendedTextAdded := FALSE;
        SalesLine.BlockDynamicTracking(TRUE);
        IF TempSalesLine."Attached to Line No." = 0 THEN BEGIN
            CreateSalesLine(TempSalesLine, KeepCommitment, ReallocateQuantity, LastLineNo, OrigSalesLine, NewLineQty);
            ExtendedTextAdded := FALSE;
            IF SalesLine.Type = SalesLine.Type::Item THEN
                RecreateSalesLinesFillItemChargeAssignment(SalesLine, TempSalesLine, TempItemChargeAssignmentSales);

            IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN BEGIN
                TempInteger.INIT();
                TempInteger.Number := SalesLine."Line No.";
                TempInteger.INSERT();
            END;
        END ELSE
            IF NOT ExtendedTextAdded THEN BEGIN
                TransferExtendedText.SalesCheckIfAnyExtText(SalesLine, TRUE);
                TransferExtendedText.InsertSalesExtText(SalesLine);
                SalesLine.FINDLAST();
                ExtendedTextAdded := TRUE;
            END;
        //CopyReservEntryFromTemp(TempReservEntry, TempSalesLine, SalesLine."Line No.");
        //RecreateReqLine(TempSalesLine, SalesLine."Line No.", FALSE);
        //SynchronizeForReservations(SalesLine, TempSalesLine);
        IF TempAssembletoOrderLink.AsmExistsForSalesLine(TempSalesLine) THEN BEGIN
            AssembletoOrderLink := TempAssembletoOrderLink;
            AssembletoOrderLink."Document Line No." := SalesLine."Line No.";
            AssembletoOrderLink.INSERT();
            AssembletoOrderLink.UpdateAsmFromSalesLineATOExist(SalesLine);
            TempAssembletoOrderLink.DELETE();
        END;
        CreateItemChargeAssgntSales(TempItemChargeAssignmentSales, TempSalesLine, TempInteger);

        TempSalesLine.SETRANGE(Type);
        TempSalesLine.DELETEALL();
        ClearItemAssgntSalesFilter(TempItemChargeAssignmentSales);
        TempItemChargeAssignmentSales.DELETEALL();
    end;

    LOCAL procedure RecreateReservEntryReqLine(VAR TempSalesLine: Record "Sales Line"; VAR TempAssembletoOrderLink: Record "Assemble-to-Order Link"; VAR AssembletoOrderLink: Record "Assemble-to-Order Link")
    begin
        TempSalesLine := SalesLine;

        IF SalesLine.Nonstock THEN BEGIN
            SalesLine.Nonstock := FALSE;
            SalesLine.MODIFY();
        END;

        IF AssembletoOrderLink.AsmExistsForSalesLine(TempSalesLine) THEN BEGIN
            TempAssembletoOrderLink := AssembletoOrderLink;
            TempAssembletoOrderLink.INSERT();
            AssembletoOrderLink.DELETE();
        END;

        TempSalesLine.INSERT();
        //CopyReservEntryToTemp(TempReservEntry, SalesLine);
        //RecreateReqLine(SalesLine, 0, TRUE);
    end;

    LOCAL procedure CreateSalesLine(VAR TempSalesLine: Record "Sales Line"; KeepCommitment: Boolean; ReallocateQuantity: Boolean; LastLineNo: Integer; var OrigSalesLine: Record "Sales Line"; NewLineQty: Decimal)
    var
        MICACommitSplitLineSetup: Record "MICA Commit/Split Line Setup";
        MICANewRebatesLineMgt: Codeunit "MICA New Rebates Line Mgt";
    begin
        SalesLine.SetHideValidationDialog(true);
        SalesLine.INIT();
        SalesLine."Line No." := LastLineNo + 10000;
        SalesLine.VALIDATE(Type, TempSalesLine.Type);
        SalesLine.VALIDATE("No.", TempSalesLine."No.");
        SalesLine.VALIDATE("Unit of Measure Code", TempSalesLine."Unit of Measure Code");
        SalesLine.VALIDATE("Variant Code", TempSalesLine."Variant Code");

        SalesLine."Location Code" := TempSalesLine."Location Code";
        SalesLine."Bin Code" := TempSalesLine."Bin Code";
        SalesLine."Planned Shipment Date" := TempSalesLine."Planned Shipment Date";
        SalesLine."Planned Delivery Date" := TempSalesLine."Planned Delivery Date";
        SalesLine."Shipment Date" := TempSalesLine."Shipment Date";
        SalesLine."Shipping Time" := TempSalesLine."Shipping Time";
        SalesLine."Outbound Whse. Handling Time" := TempSalesLine."Outbound Whse. Handling Time";
        SalesLine."Requested Delivery Date" := TempSalesLine."Requested Delivery Date";
        SalesLine."Promised Delivery Date" := TempSalesLine."Promised Delivery Date";

        IF TempSalesLine.Quantity <> 0 THEN //BEGIN
            SalesLine.Quantity := TempSalesLine.Quantity;
        //SalesLine."Qty. to Assemble to Order" := TempSalesLine."Qty. to Assemble to Order";
        //END;
        SalesLine."Purchase Order No." := TempSalesLine."Purchase Order No.";
        SalesLine."Purch. Order Line No." := TempSalesLine."Purch. Order Line No.";
        SalesLine."Drop Shipment" := SalesLine."Purch. Order Line No." <> 0;
        if not KeepCommitment then begin
            MICACommitSplitLineSetup.Get();
            SalesLine."MICA Splitted Line" := TRUE;
            SalesLine."MICA Split Source line No." := OrigSalesLine."Line No.";
            SalesLine.Reserve := SalesLine.Reserve::Never;
            SalesLine."Shipment Date" := 0D;
            SalesLine.VALIDATE("Shipment Date", MICACommitSplitLineSetup."Back Order Default Ship. Date");
            SalesLine."Planned Shipment Date" := 0D;
            SalesLine."Planned Delivery Date" := 0D;
            SalesLine."MICA Status" := SalesLine."MICA Status"::"Waiting Allocation";
        end else
            SalesLine."Shipment Date" := TempSalesLine."Shipment Date";
        SalesLine."MICA Splitted Line" := TempSalesLine."MICA Splitted Line";
        SalesLine."MICA Skip Rebates Calculation" := true;
        SalesLine."MICA 3PL Whse Shpt. Comment" := OrigSalesLine."MICA 3PL Whse Shpt. Comment";
        SalesLine."MICA Transport Instruction" := OrigSalesLine."MICA Transport Instruction";
        SalesLine."MICA Source Line Commit Date" := OrigSalesLine."MICA Source Line Commit Date";
        SalesLine.Validate("MICA Prev. Planned Del. Date", OrigSalesLine."MICA Prev. Planned Del. Date");

        SalesLine.INSERT(true);




        OrigSalesLine.SetHideValidationDialog(true);
        OrigSalesLine."MICA Skip Rebates Calculation" := true;
        if not ReallocateQuantity then begin
            OrigSalesLine.Quantity := OrigSalesLine.Quantity - NewLineQty;

            OrigSalesLine.Modify();  //to make xRec = Rec
            OrigSalesLine.Validate(Quantity);
            if OrigSalesLine.Quantity = 0 then begin
                OrigSalesLine."MICA Delete Without Realloc." := true;
                OrigSalesLine.Modify();
            end;
        end else
            OrigSalesLine.Validate(Quantity, OrigSalesLine.Quantity - NewLineQty);

        OrigSalesLine."Line Discount %" := TempSalesLine."Line Discount %";
        OrigSalesLine."Line Discount Amount" := TempSalesLine."Line Discount Amount";
        OrigSalesLine."MICA Exceptional Disc. %" := TempSalesLine."MICA Exceptional Disc. %";
        OrigSalesLine."MICA Except. Rebate Reason" := TempSalesLine."MICA Except. Rebate Reason";
        OrigSalesLine.Validate("Unit Price", TempSalesLine."Unit Price");

        if OrigSalesLine.Quantity = 0 then
            OrigSalesLine.Delete(true)
        else
            OrigSalesLine.Modify(true);

        SalesLine.VALIDATE(Quantity, NewLineQty);
        //SalesLine.VALIDATE("Qty. to Assemble to Order");
        SalesLine."Line Discount %" := TempSalesLine."Line Discount %";
        SalesLine."Line Discount Amount" := TempSalesLine."Line Discount Amount";
        SalesLine."MICA Exceptional Disc. %" := TempSalesLine."MICA Exceptional Disc. %";
        SalesLine."MICA Except. Rebate Reason" := TempSalesLine."MICA Except. Rebate Reason";
        SalesLine.Validate("Unit Price", TempSalesLine."Unit Price");
        SalesLine.validate("MICA Source Line Commit Date", OrigSalesLine."MICA Source Line Commit Date");
        if not KeepCommitment then
            SalesLine."MICA Status" := SalesLine."MICA Status"::"Waiting Allocation";
        SalesLine.Modify(true);

        if SalesLine."MICA Skip Rebates Calculation" then
            if not TempMICANewAppliedSLDiscount.IsEmpty() then
                MICANewRebatesLineMgt.CopyRebatesInformationToSalesLine(SalesLine, TempMICANewAppliedSLDiscount, TempMICAAdditionalItemDiscount);
    end;

    LOCAL procedure ClearItemAssgntSalesFilter(VAR TempItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)")
    begin
        TempItemChargeAssignmentSales.SETRANGE("Document Line No.");
        TempItemChargeAssignmentSales.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssignmentSales.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssignmentSales.SETRANGE("Applies-to Doc. Line No.");
    end;

    LOCAL procedure CreateItemChargeAssgntSales(VAR TempItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)"; VAR TempSalesLine: Record "Sales Line"; VAR TempInteger: Record Integer)
    var
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
    begin
        ClearItemAssgntSalesFilter(TempItemChargeAssignmentSales);
        TempSalesLine.SETRANGE(Type, SalesLine.Type::"Charge (Item)");
        IF TempSalesLine.FINDSET() THEN
            REPEAT
                TempItemChargeAssignmentSales.SETRANGE("Document Line No.", TempSalesLine."Line No.");
                IF TempItemChargeAssignmentSales.FINDSET() THEN BEGIN
                    REPEAT
                        TempInteger.FINDFIRST();
                        ItemChargeAssignmentSales.INIT();
                        ItemChargeAssignmentSales := TempItemChargeAssignmentSales;
                        ItemChargeAssignmentSales."Document Line No." := TempInteger.Number;
                        ItemChargeAssignmentSales.VALIDATE("Unit Cost", 0);
                        ItemChargeAssignmentSales.INSERT();
                    UNTIL TempItemChargeAssignmentSales.NEXT() = 0;
                    TempInteger.DELETE();
                END;
            UNTIL TempSalesLine.NEXT() = 0;
        ClearItemAssgntSalesFilter(TempItemChargeAssignmentSales);
        TempItemChargeAssignmentSales.DELETEALL();
    end;

    LOCAL procedure RecreateSalesLinesFillItemChargeAssignment(SalesLine: Record "Sales Line"; TempSalesLine: Record "Sales Line"; VAR TempItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)")
    begin
        ClearItemAssgntSalesFilter(TempItemChargeAssignmentSales);
        TempItemChargeAssignmentSales.SETRANGE("Applies-to Doc. Type", TempSalesLine."Document Type");
        TempItemChargeAssignmentSales.SETRANGE("Applies-to Doc. No.", TempSalesLine."Document No.");
        TempItemChargeAssignmentSales.SETRANGE("Applies-to Doc. Line No.", TempSalesLine."Line No.");
        IF TempItemChargeAssignmentSales.FINDSET() THEN
            REPEAT
                IF NOT TempItemChargeAssignmentSales.MARK() THEN BEGIN
                    TempItemChargeAssignmentSales."Applies-to Doc. Line No." := SalesLine."Line No.";
                    TempItemChargeAssignmentSales.Description := SalesLine.Description;
                    TempItemChargeAssignmentSales.MODIFY();
                    TempItemChargeAssignmentSales.MARK(TRUE);
                END;
            UNTIL TempItemChargeAssignmentSales.NEXT() = 0;
    end;

    LOCAL procedure TransferItemChargeAssgntSalesToTemp(OrigSalesLine: Record "Sales Line"; VAR ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)"; VAR TempItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)")
    begin
        ItemChargeAssignmentSales.SETRANGE("Document Type", OrigSalesLine."Document Type");
        ItemChargeAssignmentSales.SETRANGE("Document No.", OrigSalesLine."No.");
        ItemChargeAssignmentSales.SetRange("Document Line No.", OrigSalesLine."Line No.");
        IF ItemChargeAssignmentSales.FINDSET() THEN
            REPEAT
                TempItemChargeAssignmentSales.INIT();
                TempItemChargeAssignmentSales := ItemChargeAssignmentSales;
                TempItemChargeAssignmentSales.INSERT();
            UNTIL ItemChargeAssignmentSales.NEXT() = 0;
        //ItemChargeAssgntSales.DELETEALL();
    end;
}
