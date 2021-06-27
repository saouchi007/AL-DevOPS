codeunit 82761 "MICA Sugg.Imp. Pric.Reb. Chng."
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnBeforeSalesLinePriceExists', '', false, false)]
    local procedure MyProcedure(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var TempSalesPrice: Record "Sales Price"; Currency: Record Currency;
    CurrencyFactor: Decimal; StartingDate: Date; Qty: Decimal; QtyPerUOM: Decimal; ShowAll: Boolean; var InHandled: Boolean)
    var
        Customer: Record Customer;
    begin
        if SalesLine."MICA Is Selected" then begin
            InHandled := true;
            Customer.Get(SalesHeader."Sell-to Customer No.");
            SalesPriceCalcMgt.FindSalesPrice(
                      TempSalesPrice, SalesHeader."Sell-to Customer No.", SalesHeader."Bill-to Contact No.",
                      Customer."Customer Price Group", '', SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
                      SalesHeader."Currency Code", WorkDate(), ShowAll);
        end;
    end;

    // Suggest Price on Worksheet
    procedure FindSalesPrice(NewSalesLine: Record "Sales Line"; var NewSalesPrice: Decimal): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        Clear(SalesPriceCalcMgt);

        SalesHeader.Get(SalesHeader."Document Type"::Order, NewSalesLine."Document No.");
        NewSalesLine.Validate("MICA Is Selected", true);
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, NewSalesLine, 0);

        NewSalesPrice := NewSalesLine."Unit Price";
        exit(NewSalesPrice <> 0);
    end;

    procedure CheckLinesStatusReserveOnHandInTransit(NewSalesLine: Record "Sales Line"; PriceRecalcWindow: Date): Boolean
    begin
        case NewSalesLine."MICA Status" of
            NewSalesLine."MICA Status"::"Reserve InTransit", NewSalesLine."MICA Status"::"Reserve OnHand":
                exit((NewSalesLine."Shipment Date" >= PriceRecalcWindow));
            else
                exit(true);
        end;
    end;

    procedure CheckSalesOrderDateForSuggestion(SalesOrderNo: Code[20]; SOPriceRecalcExclWind: Date): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then
            exit(false);

        exit((SalesHeader."Order Date" > Today()) or (SalesHeader."Order Date" < SOPriceRecalcExclWind));
    end;

    procedure CheckAndFillPriceRecalcWorksheet(NewSalesLine: Record "Sales Line"; NewSalesPrice: Decimal)
    var
        MICAPriceRecalcWorksheet: Record "MICA Price Recalc. Worksheet";
        ErrorText: Text;
        PriceAlreadyExistsErr: Label 'Price: %1 already exists for Order No.: %2 and Line No.: %3!';
    begin
        if not CheckIfPriceExists(NewSalesLine, NewSalesPrice) then begin
            ErrorText := StrSubstNo(PriceAlreadyExistsErr, NewSalesPrice, NewSalesLine."Document No.", NewSalesLine."Line No.");
            Error(ErrorText);
        end;

        if not MICAPriceRecalcWorksheet.Get(NewSalesLine."Document No.", NewSalesLine."Line No.") then
            ImportPriceRecalcWorksheet(MICAPriceRecalcWorksheet, NewSalesLine, NewSalesPrice, true)
        else
            ImportPriceRecalcWorksheet(MICAPriceRecalcWorksheet, NewSalesLine, NewSalesPrice, false);
    end;

    local procedure CheckIfPriceExists(NewSalesLine: Record "Sales Line"; NewSalesPrice: Decimal): Boolean
    var
        MICAPriceRecalcWorksheet: Record "MICA Price Recalc. Worksheet";
    begin
        MICAPriceRecalcWorksheet.SetRange("Order No.", NewSalesLine."Document No.");
        MICAPriceRecalcWorksheet.SetRange("Line No.", NewSalesLine."Line No.");
        MICAPriceRecalcWorksheet.SetRange("New Unit Price", NewSalesPrice);
        exit(MICAPriceRecalcWorksheet.IsEmpty());
    end;

    local procedure ImportPriceRecalcWorksheet(var MICAPriceRecalcWorksheet: Record "MICA Price Recalc. Worksheet"; NewSalesLine: Record "Sales Line"; NewSalesPrice: Decimal; InsertOrModify: Boolean)
    begin
        if InsertOrModify then begin
            MICAPriceRecalcWorksheet.Init();
            MICAPriceRecalcWorksheet.Validate("Order No.", NewSalesLine."Document No.");
            MICAPriceRecalcWorksheet."Line No." := NewSalesLine."Line No.";
            MICAPriceRecalcWorksheet.Insert();

            MICAPriceRecalcWorksheet."Promised Delivery Date" := NewSalesLine."Promised Delivery Date";
            MICAPriceRecalcWorksheet.Validate("Item No.", NewSalesLine."No.");
            MICAPriceRecalcWorksheet."Location Code" := NewSalesLine."Location Code";
            MICAPriceRecalcWorksheet."MICA Status" := NewSalesLine."MICA Status";
            MICAPriceRecalcWorksheet.Quantity := NewSalesLine.Quantity;
            MICAPriceRecalcWorksheet."Unit Price" := NewSalesLine."Unit Price";
            MICAPriceRecalcWorksheet."New Unit Price" := NewSalesPrice;
            MICAPriceRecalcWorksheet.Modify();
        end else begin
            MICAPriceRecalcWorksheet."Unit Price" := NewSalesLine."Unit Price";
            MICAPriceRecalcWorksheet."New Unit Price" := NewSalesPrice;
            MICAPriceRecalcWorksheet.Modify();
        end;
    end;

    // Suggest Rebate on Worksheet
    procedure FindSalesDiscount(NewSalesLine: Record "Sales Line"; SalesType: Integer; var NewSalesLineDiscont: Decimal): Boolean
    begin
        exit(FindValidAppliedRebateLineDiscount(NewSalesLine, NewSalesLineDiscont, TypeOfChanges::Suggest));
    end;

    local procedure FindValidAppliedRebateLineDiscount(NewSalesLine: Record "Sales Line"; var NewSalesLineDiscont: Decimal; TypeOfChanges: Integer): Boolean
    var
        MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
        Customer: Record Customer;
        ItemDiscountGroupFilter: Text;
        IsItemDiscountGroupValid: Boolean;
    begin
        if CheckIfRebateAppliedSalesLineDiscExists(MICANewAppliedSLDiscount, NewSalesLine) then begin
            FindAdditionalItemDiscountDetail(NewSalesLine, '', NewSalesLineDiscont, TypeOfChanges);
            exit(NewSalesLineDiscont <> 0);
        end else begin
            MICANewAppliedSLDiscount.Reset();
            MICANewAppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            MICANewAppliedSLDiscount.SetRange("Document Type", MICANewAppliedSLDiscount."Document Type"::Order);
            MICANewAppliedSLDiscount.SetRange("Document No.", NewSalesLine."Document No.");
            MICANewAppliedSLDiscount.SetRange("Document Line No.", NewSalesLine."Line No.");
            MICANewAppliedSLDiscount.SetRange("Item No.", NewSalesLine."No.");
            MICANewAppliedSLDiscount.SetFilter("Sales Discount %", '<>%1', 0);
            if MICANewAppliedSLDiscount.IsEmpty() then
                exit(false);

            Customer.Get(NewSalesLine."Sell-to Customer No.");
            if MICANewAppliedSLDiscount.FindSet() then
                repeat
                    case MICANewAppliedSLDiscount."Rebates Type" of
                        MICANewAppliedSLDiscount."Rebates Type"::Rebate:
                            begin
                                IsItemDiscountGroupValid := ((MICANewAppliedSLDiscount."Sales Type" = MICANewAppliedSLDiscount."Sales Type"::"All Customers") and (MICANewAppliedSLDiscount."Sales Code" = '')) or
                                                                ((MICANewAppliedSLDiscount."Sales Type" = MICANewAppliedSLDiscount."Sales Type"::"Customer Disc. Group") and (MICANewAppliedSLDiscount."Sales Code" = Customer."Customer Disc. Group")) or
                                                                ((MICANewAppliedSLDiscount."Sales Type" = MICANewAppliedSLDiscount."Sales Type"::Customer) and (MICANewAppliedSLDiscount."Sales Code" = Customer."No."));

                                if TypeOfChanges = 0 then
                                    if WorkDate() > MICANewAppliedSLDiscount."Ending Date" then begin
                                        if not IsValidEndingDate(MICANewAppliedSLDiscount."Ending Date") then
                                            exit(false);
                                    end else
                                        if IsItemDiscountGroupValid then
                                            SumValues(NewSalesLineDiscont, MICANewAppliedSLDiscount."Sales Discount %");

                                if MICANewAppliedSLDiscount.Type = MICANewAppliedSLDiscount.Type::"Item Disc. Group" then
                                    if IsItemDiscountGroupValid then
                                        TextFilter(ItemDiscountGroupFilter, MICANewAppliedSLDiscount.Code);
                            end;
                        MICANewAppliedSLDiscount."Rebates Type"::Exceptional, MICANewAppliedSLDiscount."Rebates Type"::"Payment Terms":
                            if TypeOfChanges = 0 then
                                if MICANewAppliedSLDiscount."Ending Date" = 0D then
                                    SumValues(NewSalesLineDiscont, MICANewAppliedSLDiscount."Sales Discount %");
                    end;
                until MICANewAppliedSLDiscount.Next() = 0;

            FindAdditionalItemDiscountDetail(NewSalesLine, ItemDiscountGroupFilter, NewSalesLineDiscont, TypeOfChanges);
            exit(NewSalesLineDiscont <> 0);
        end;
    end;

    local procedure CheckIfRebateAppliedSalesLineDiscExists(var MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount"; NewSalesLine: Record "Sales Line"): Boolean
    begin
        MICANewAppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
        MICANewAppliedSLDiscount.SetRange("Document Type", MICANewAppliedSLDiscount."Document Type"::Order);
        MICANewAppliedSLDiscount.SetRange("Document No.", NewSalesLine."Document No.");
        MICANewAppliedSLDiscount.SetRange("Document Line No.", NewSalesLine."Line No.");
        MICANewAppliedSLDiscount.SetFilter("Sales Discount %", '<>%1', 0);
        exit(MICANewAppliedSLDiscount.IsEmpty());
    end;

    local procedure IsValidEndingDate(NewCurrentEndingDate: Date): Boolean
    var
        NewEndingDate: Date;
        FindDateFromCurrentEndingDate: Date;
    begin
        if NewCurrentEndingDate = 0D then
            exit(false);

        FindDateFromCurrentEndingDate := CalcDate('<+' + Format(SORebateRecalcExclWindow) + '>', NewCurrentEndingDate);
        NewEndingDate := CalcDate('<+CM>', FindDateFromCurrentEndingDate);
        exit(NewEndingDate < Today());
    end;

    local procedure FindAdditionalItemDiscountDetail(NewSalesLine: Record "Sales Line"; ItemDiscGrpFilter: Text; var NewSalesLineDiscont: Decimal; TypeOfChanges: Integer)
    var
        NewMICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
        SalesLineDiscount: Record "Sales Line Discount";
        Customer: Record Customer;
        AdditionalItemDiscGroupsFilter: Text;
        IsItemDiscountGroupValid: Boolean;
    begin
        if TypeOfChanges = 1 then
            DeleteNotValidAppSalesLineDisc(NewMICANewAppliedSLDiscount, NewSalesLine);

        FindAdditionalItemDiscountGroups(NewSalesLine, ItemDiscGrpFilter, AdditionalItemDiscGroupsFilter);

        SalesLineDiscount.SetCurrentKey(Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Item Disc. Group");
        if AdditionalItemDiscGroupsFilter = '' then
            SalesLineDiscount.SetRange(Code, '')
        else
            SalesLineDiscount.SetFilter(Code, AdditionalItemDiscGroupsFilter);
        SalesLineDiscount.SetFilter("Starting Date", '..%1', Today());
        SalesLineDiscount.SetFilter("Ending Date", '%1|%2..', 0D, Today());
        SalesLineDiscount.SetFilter("Line Discount %", '<>%1', 0);
        if SalesLineDiscount.IsEmpty() then
            exit;

        Customer.Get(NewSalesLine."Sell-to Customer No.");
        if SalesLineDiscount.FindSet() then
            repeat
                IsItemDiscountGroupValid := ((SalesLineDiscount."Sales Type" = SalesLineDiscount."Sales Type"::"All Customers") and (SalesLineDiscount."Sales Code" = '')) or
                                            ((SalesLineDiscount."Sales Type" = SalesLineDiscount."Sales Type"::"Customer Disc. Group") and (SalesLineDiscount."Sales Code" = Customer."Customer Disc. Group")) or
                                            ((SalesLineDiscount."Sales Type" = SalesLineDiscount."Sales Type"::Customer) and (SalesLineDiscount."Sales Code" = NewSalesLine."Sell-to Customer No."));

                if IsItemDiscountGroupValid then
                    if TypeOfChanges = 0 then
                        SumValues(NewSalesLineDiscont, SalesLineDiscount."Line Discount %")
                    else
                        CreateNewAppliedSalesLineDiscount(NewSalesLine, SalesLineDiscount);
            until SalesLineDiscount.Next() = 0;
    end;

    local procedure FindAdditionalItemDiscountGroups(NewSalesLine: Record "Sales Line"; ItemDiscGrpFilter: Text; var AdditionalItemDiscGroupsFilter: Text)
    var
        MICAAdditionalItemDiscountGroup: Record "MICA Add. Item Discount Group";
    begin
        MICAAdditionalItemDiscountGroup.SetCurrentKey("Item No.", "Item Discount Group Code");
        MICAAdditionalItemDiscountGroup.SetRange("Item No.", NewSalesLine."No.");
        if MICAAdditionalItemDiscountGroup.FindSet() then
            repeat
                if StrPos(ItemDiscGrpFilter, MICAAdditionalItemDiscountGroup."Item Discount Group Code") = 0 then
                    TextFilter(AdditionalItemDiscGroupsFilter, MICAAdditionalItemDiscountGroup."Item Discount Group Code");
            until MICAAdditionalItemDiscountGroup.Next() = 0;
    end;

    local procedure SumValues(var OutputParameter: Decimal; InputParameter: Decimal)
    begin
        if OutputParameter = 0 then
            OutputParameter := InputParameter
        else
            OutputParameter += InputParameter;
    end;

    local procedure TextFilter(var OutputParameter: Text; InputParameter: Code[20])
    var
        OutputParameterSubLbl: Label '%1|%2', Comment = '%1%2';
    begin
        if OutputParameter = '' then
            OutputParameter := InputParameter
        else
            OutputParameter := StrSubstNo(OutputParameterSubLbl, OutputParameter, InputParameter);
    end;

    local procedure CreateNewAppliedSalesLineDiscount(NewSalesLine: Record "Sales Line"; SalesLineDiscount: Record "Sales Line Discount")
    var
        NewMICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
    begin
        NewMICANewAppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
        NewMICANewAppliedSLDiscount.SetRange("Document Type", NewMICANewAppliedSLDiscount."Document Type"::Order);
        NewMICANewAppliedSLDiscount.SetRange("Document No.", NewSalesLine."Document No.");
        NewMICANewAppliedSLDiscount.SetRange("Document Line No.", NewSalesLine."Line No.");
        NewMICANewAppliedSLDiscount.SetRange(Type, NewMICANewAppliedSLDiscount.Type::"Item Disc. Group");
        NewMICANewAppliedSLDiscount.SetRange("Item No.", NewSalesLine."No.");
        NewMICANewAppliedSLDiscount.SetRange(Code, SalesLineDiscount.Code);
        NewMICANewAppliedSLDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type");
        NewMICANewAppliedSLDiscount.SetRange("Sales Code", SalesLineDiscount."Sales Code");
        if not NewMICANewAppliedSLDiscount.IsEmpty() then
            exit;

        FillAppliedSalesLineDiscount(NewMICANewAppliedSLDiscount, NewSalesLine, SalesLineDiscount);
    end;

    local procedure FillAppliedSalesLineDiscount(var NewMICANewAppliedSLDiscount: Record "MICA New Applied SL Discount"; NewSalesLine: Record "Sales Line"; SalesLineDiscount: Record "Sales Line Discount")
    var
        Item: Record Item;
    begin
        NewMICANewAppliedSLDiscount.Init();
        NewMICANewAppliedSLDiscount.Validate("Rebates Type", NewMICANewAppliedSLDiscount."Rebates Type"::Rebate);
        NewMICANewAppliedSLDiscount.Validate("Document Type", NewMICANewAppliedSLDiscount."Document Type"::Order);
        NewMICANewAppliedSLDiscount.Validate("Document No.", NewSalesLine."Document No.");
        NewMICANewAppliedSLDiscount.Validate("Document Line No.", NewSalesLine."Line No.");
        NewMICANewAppliedSLDiscount.Validate("Sales Type", SalesLineDiscount."Sales Type");
        NewMICANewAppliedSLDiscount.Validate("Sales Code", SalesLineDiscount."Sales Code");
        NewMICANewAppliedSLDiscount.Validate(Type, SalesLineDiscount.Type);
        NewMICANewAppliedSLDiscount.Validate(Code, SalesLineDiscount.Code);
        NewMICANewAppliedSLDiscount.Validate("Item No.", NewSalesLine."No.");
        if Item.Get(NewSalesLine."No.") then begin
            NewMICANewAppliedSLDiscount.Validate("Product Line", CopyStr(Item."Item Category Code", 1, MaxStrLen(NewMICANewAppliedSLDiscount."Product Line")));
            NewMICANewAppliedSLDiscount.Validate(Brand, Item."MICA Brand");
        end;
        NewMICANewAppliedSLDiscount.Validate("Unit of Measure Code", SalesLineDiscount."Unit of Measure Code");
        NewMICANewAppliedSLDiscount.Validate("Sales Discount %", SalesLineDiscount."Line Discount %");
        NewMICANewAppliedSLDiscount.Validate("Starting Date", SalesLineDiscount."Starting Date");
        NewMICANewAppliedSLDiscount.Validate("Ending Date", SalesLineDiscount."Ending Date");
        NewMICANewAppliedSLDiscount.Insert(true);
    end;

    local procedure DeleteNotValidAppSalesLineDisc(NewMICANewAppliedSLDiscount: Record "MICA New Applied SL Discount"; NewSalesLine: Record "Sales Line")
    var
        MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
    begin
        NewMICANewAppliedSLDiscount.Reset();
        NewMICANewAppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
        NewMICANewAppliedSLDiscount.SetRange("Document Type", NewMICANewAppliedSLDiscount."Document Type"::Order);
        NewMICANewAppliedSLDiscount.SetRange("Document No.", NewSalesLine."Document No.");
        NewMICANewAppliedSLDiscount.SetRange("Document Line No.", NewSalesLine."Line No.");
        NewMICANewAppliedSLDiscount.SetRange("Rebates Type", NewMICANewAppliedSLDiscount."Rebates Type"::Rebate);
        NewMICANewAppliedSLDiscount.SetRange("Item No.", NewSalesLine."No.");
        if NewMICANewAppliedSLDiscount.FindSet() then
            repeat
                MICANewAppliedSLDiscount := NewMICANewAppliedSLDiscount;
                if IsValidEndingDate(MICANewAppliedSLDiscount."Ending Date") then
                    MICANewAppliedSLDiscount.Delete();
            until NewMICANewAppliedSLDiscount.Next() = 0;
    end;

    procedure FillRebateRecalcWorksheet(NewSalesLine: Record "Sales Line"; NewSalesLineDiscount: Decimal)
    var
        MICARebateRecalcWorksheet: Record "MICA Rebate Recalc. Worksheet";
        ErrorText: Text;
        RebateAlreadyExistsErr: Label 'Rebate: %1 already exists for Order No.: %2 and Line No.: %3!';
    begin
        if not CheckIfRebateExists(NewSalesLine, NewSalesLineDiscount) then begin
            ErrorText := StrSubstNo(RebateAlreadyExistsErr, NewSalesLineDiscount, NewSalesLine."Document No.", NewSalesLine."Line No.");
            Error(ErrorText);
        end;

        if not MICARebateRecalcWorksheet.Get(NewSalesLine."Document No.", NewSalesLine."Line No.") then
            ImportRebateRecalcWorksheet(MICARebateRecalcWorksheet, NewSalesLine, NewSalesLineDiscount, true)
        else
            ImportRebateRecalcWorksheet(MICARebateRecalcWorksheet, NewSalesLine, NewSalesLineDiscount, false);
    end;

    local procedure CheckIfRebateExists(NewSalesLine: Record "Sales Line"; NewSalesLineDiscount: Decimal): Boolean
    var
        MICARebateRecalcWorksheet: Record "MICA Rebate Recalc. Worksheet";
    begin
        MICARebateRecalcWorksheet.SetRange("Order No.", NewSalesLine."Document No.");
        MICARebateRecalcWorksheet.SetRange("Line No.", NewSalesLine."Line No.");
        MICARebateRecalcWorksheet.SetRange("New Discount %", NewSalesLineDiscount);
        exit(MICARebateRecalcWorksheet.IsEmpty());
    end;

    local procedure ImportRebateRecalcWorksheet(var MICARebateRecalcWorksheet: Record "MICA Rebate Recalc. Worksheet"; NewSalesLine: Record "Sales Line"; NewSalesLineDiscount: Decimal; InsertOrModify: Boolean)
    begin
        if InsertOrModify then begin
            MICARebateRecalcWorksheet.Init();
            MICARebateRecalcWorksheet.Validate("Order No.", NewSalesLine."Document No.");
            MICARebateRecalcWorksheet."Line No." := NewSalesLine."Line No.";
            MICARebateRecalcWorksheet.Insert();

            MICARebateRecalcWorksheet."Promised Delivery Date" := NewSalesLine."Promised Delivery Date";
            MICARebateRecalcWorksheet.Validate("Item No.", NewSalesLine."No.");
            MICARebateRecalcWorksheet."Location Code" := NewSalesLine."Location Code";
            MICARebateRecalcWorksheet."MICA Status" := NewSalesLine."MICA Status";
            MICARebateRecalcWorksheet.Quantity := NewSalesLine.Quantity;
            MICARebateRecalcWorksheet."Discount %" := NewSalesLine."Line Discount %";
            MICARebateRecalcWorksheet."New Discount %" := NewSalesLineDiscount;
            MICARebateRecalcWorksheet.Modify();
        end else begin
            MICARebateRecalcWorksheet."Discount %" := NewSalesLine."Line Discount %";
            MICARebateRecalcWorksheet."New Discount %" := NewSalesLineDiscount;
            MICARebateRecalcWorksheet.Modify();
        end;
    end;

    procedure CheckAndProcessSalesStatus(var NewToSalesStatus: Text; PriceOrRebate: Integer)
    var
        MICATableValue: Record "MICA Table Value";
    begin
        MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::SalesLineStatus);

        if Page.RunModal(0, MICATableValue) = Action::LookupOK then begin
            CheckSalesStatus(MICATableValue.Code, PriceOrRebate);
            CheckIfExistAndToLowerCase(MICATableValue.Description, NewToSalesStatus);
            if NewToSalesStatus = '' then
                NewToSalesStatus := MICATableValue.Description
            else
                NewToSalesStatus := StrSubstNo('%1|%2', NewToSalesStatus, MICATableValue.Description)
        end;
    end;

    local procedure CheckSalesStatus(NewToSalesStatus: Code[20]; PriceOrRebate: Integer)
    var
        MICATableValue: Record "MICA Table Value";
        StatusCantBeRecalcPriceErr: Label 'This Status cannot be selected for price recalculation.';
        StatusCantBeRecalcRebateErr: Label 'This Status cannot be selected for rebate recalculation.';
    begin
        if not MICATableValue.Get(MICATableValue."Table Type"::SalesLineStatus, NewToSalesStatus) then
            exit;

        if not MICATableValue."Allow Recalc." then
            case PriceOrRebate of
                0:
                    Error(StatusCantBeRecalcPriceErr);
                1:
                    Error(StatusCantBeRecalcRebateErr);
            end;
    end;

    local procedure CheckIfExistAndToLowerCase(TableValueDescription: Text[200]; NewToSalesStatus: Text)
    var
        ErrorText: Text;
        StatusExistErr: Label 'Status %1 has already been selected';
    begin
        if NewToSalesStatus <> '' then
            if StrPos(NewToSalesStatus, TableValueDescription) > 0 then begin
                ErrorText := StrSubstNo(StatusExistErr, TableValueDescription);
                Error(ErrorText);
            end;
    end;

    // Implement Price
    procedure UpdatePriceSalesOrderLines(MICAPriceRecalcWorksheet: Record "MICA Price Recalc. Worksheet"): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        OldStatus: Enum "Sales Document Status";
    begin
        Clear(ReleaseSalesDocument);

        if not PrepareRecordsForUpdate(SalesHeader, SalesLine, MICAPriceRecalcWorksheet."Order No.", MICAPriceRecalcWorksheet."Line No.", MICAPriceRecalcWorksheet."New Unit Price", OldStatus, 0) then
            exit(false);

        SalesHeader.TestStatusOpen();

        if MICAPriceRecalcWorksheet."New Unit Price" <> 0 then
            case SalesHeader.Status of
                SalesHeader.Status::Open:
                    begin
                        ValidateSalesLine(SalesLine, MICAPriceRecalcWorksheet."New Unit Price", MICAPriceRecalcWorksheet."Customer Price Group", 0);

                        if ModifySalesLine(SalesHeader, SalesLine, OldStatus) then
                            exit(true);

                        exit(false);
                    end;
            end;
    end;

    procedure PrepareRecordsForUpdate(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; NewOrderNo: Code[20]; NewLineNo: Integer; NewPriceDiscount: Decimal; var OldStatus: Enum "Sales Document Status"; PriceOrDiscount: Integer): Boolean
    begin
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, NewOrderNo) then
            exit(false);

        if not SalesLine.Get(SalesLine."Document Type"::Order, SalesHeader."No.", NewLineNo) then
            exit(false);

        case PriceOrDiscount of
            0:
                if SalesLine."Unit Price" = NewPriceDiscount then
                    exit(false);
            1:
                if SalesLine."Line Discount %" = NewPriceDiscount then
                    exit(false);
        end;

        case SalesHeader.Status of
            SalesHeader.Status::Open:
                begin
                    OldStatus := SalesHeader.Status;
                    exit(true);
                end;
            SalesHeader.Status::Released:
                begin
                    OldStatus := SalesHeader.Status;
                    ReleaseSalesDocument.PerformManualReopen(SalesHeader);
                end;
            SalesHeader.Status::"Pending Approval", SalesHeader.Status::"Pending Prepayment":
                begin
                    OldStatus := SalesHeader.Status;
                    SalesHeader.Validate(Status, SalesHeader.Status::Open);
                    SalesHeader.Modify();
                end;
        end;

        exit(true);
    end;

    procedure ValidateSalesLine(var NewSalesLine: Record "Sales Line"; NewPriceDiscount: Decimal; NewCustPriceDiscGroup: Code[20]; PriceOrDiscount: Integer)
    var
        OldLineDiscount: Decimal;
    begin
        case PriceOrDiscount of
            0:
                begin
                    OldLineDiscount := NewSalesLine."Line Discount %";
                    if NewSalesLine."Customer Price Group" <> NewCustPriceDiscGroup then
                        NewSalesLine.Validate("Customer Price Group", NewCustPriceDiscGroup);

                    if NewSalesLine."Unit Price" <> NewPriceDiscount then
                        NewSalesLine.Validate("Unit Price", NewPriceDiscount);

                    if NewSalesLine."Line Discount %" <> OldLineDiscount then
                        NewSalesLine.Validate("Line Discount %", OldLineDiscount);
                end;
            1:
                begin
                    if NewSalesLine."Customer Disc. Group" <> NewCustPriceDiscGroup then
                        NewSalesLine.Validate("Customer Disc. Group", NewCustPriceDiscGroup);

                    if NewSalesLine."Line Discount %" <> NewPriceDiscount then
                        NewSalesLine.Validate("Line Discount %", NewPriceDiscount);
                end;
        end;
    end;

    procedure ModifySalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var OldStatus: Enum "Sales Document Status"): Boolean
    begin
        if not SalesLine.Modify() then begin
            CheckIfSalesHeaderWasReopened(SalesHeader, OldStatus);
            exit(false);
        end else begin
            CheckIfSalesHeaderWasReopened(SalesHeader, OldStatus);
            exit(true);
        end;
    end;

    local procedure CheckIfSalesHeaderWasReopened(var NewSalesHeader: Record "Sales Header"; var OldStatus: Enum "Sales Document Status")
    begin
        case OldStatus of
            OldStatus::Open:
                exit;
            OldStatus::Released:
                ReleaseSalesDocOpen(NewSalesHeader);
            OldStatus::"Pending Approval":
                begin
                    NewSalesHeader.Validate(Status, NewSalesHeader.Status::"Pending Approval");
                    NewSalesHeader.Modify();
                end;
        end;
    end;

    procedure InsertPriceRecalcEntry(MICAPriceRecalcWorksheet: Record "MICA Price Recalc. Worksheet")
    var
        MICAPriceRecalcEntry: Record "MICA Price Recalc. Entry";
    begin
        MICAPriceRecalcEntry.Init();
        MICAPriceRecalcEntry."Entry No." := GetEntryNo(0); //value 0 as parameter for getting Entry No for Price Worksheet
        MICAPriceRecalcEntry.Insert();

        MICAPriceRecalcEntry."Order No." := MICAPriceRecalcWorksheet."Order No.";
        MICAPriceRecalcEntry."Order Date" := MICAPriceRecalcWorksheet."Order Date";
        MICAPriceRecalcEntry."Order No." := MICAPriceRecalcWorksheet."Order No.";
        MICAPriceRecalcEntry."Customer No." := MICAPriceRecalcWorksheet."Customer No.";
        MICAPriceRecalcEntry."Customer Name" := MICAPriceRecalcWorksheet."Customer Name";
        MICAPriceRecalcEntry."Customer Price Group" := MICAPriceRecalcWorksheet."Customer Price Group";
        MICAPriceRecalcEntry."Line No." := MICAPriceRecalcWorksheet."Line No.";
        MICAPriceRecalcEntry."Item No." := MICAPriceRecalcWorksheet."Item No.";
        MICAPriceRecalcEntry.Description := MICAPriceRecalcWorksheet.Description;
        MICAPriceRecalcEntry."Location Code" := MICAPriceRecalcWorksheet."Location Code";
        MICAPriceRecalcEntry."MICA Status" := MICAPriceRecalcWorksheet."MICA Status";
        MICAPriceRecalcEntry.Quantity := MICAPriceRecalcWorksheet.Quantity;
        MICAPriceRecalcEntry."Unit Price" := MICAPriceRecalcWorksheet."Unit Price";
        MICAPriceRecalcEntry."New Unit Price" := MICAPriceRecalcWorksheet."New Unit Price";
        MICAPriceRecalcEntry."Recalculation Date" := WorkDate();
        MICAPriceRecalcEntry.Modify();
    end;

    local procedure GetEntryNo(PriceOrDiscount: Integer): Integer
    var
        MICAPriceRecalcEntry: Record "MICA Price Recalc. Entry";
        MICAPriceRecalcEntry2: Record "MICA Price Recalc. Entry";
        MICARebateRecalcEntry: Record "MICA Rebate Recalc. Entry";
        MICARebateRecalcEntry2: Record "MICA Rebate Recalc. Entry";
    begin
        case PriceOrDiscount of
            0:
                if MICAPriceRecalcEntry.IsEmpty() then
                    exit(1)
                else
                    if MICAPriceRecalcEntry2.FindLast() then
                        exit(MICAPriceRecalcEntry2."Entry No." + 1);
            1:
                if MICARebateRecalcEntry.IsEmpty() then
                    exit(1)
                else
                    if MICARebateRecalcEntry2.FindLast() then
                        exit(MICARebateRecalcEntry2."Entry No." + 1);
        end;
    end;

    // Implement Rebate
    procedure UpdateRebateSalesOrderLines(MICARebateRecalcWorksheet: Record "MICA Rebate Recalc. Worksheet"): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        OldStatus: Enum "Sales Document Status";
    begin
        Clear(ReleaseSalesDocument);

        if not PrepareRecordsForUpdate(SalesHeader, SalesLine, MICARebateRecalcWorksheet."Order No.", MICARebateRecalcWorksheet."Line No.", MICARebateRecalcWorksheet."New Discount %", OldStatus, 1) then
            exit(false);

        SalesHeader.TestStatusOpen();

        if MICARebateRecalcWorksheet."New Discount %" <> 0 then
            case SalesHeader.Status of
                SalesHeader.Status::Open:
                    begin
                        ValidateSalesLine(SalesLine, MICARebateRecalcWorksheet."New Discount %", MICARebateRecalcWorksheet."Customer Discount Group", 1);
                        FindValidAppliedRebateLineDiscount(SalesLine, MICARebateRecalcWorksheet."New Discount %", TypeOfChanges::Implement);

                        if ModifySalesLine(SalesHeader, SalesLine, OldStatus) then
                            exit(true);

                        exit(false);
                    end;
            end;
    end;

    procedure InsertRebateRecalcEntry(MICARebateRecalcWorksheet: Record "MICA Rebate Recalc. Worksheet")
    var
        MICARebateRecalcEntry: Record "MICA Rebate Recalc. Entry";
    begin
        MICARebateRecalcEntry.Init();
        MICARebateRecalcEntry."Entry No." := GetEntryNo(1); //value 1 as parameter for getting Entry No for Rebate Worksheet
        MICARebateRecalcEntry.Insert();

        MICARebateRecalcEntry."Order No." := MICARebateRecalcWorksheet."Order No.";
        MICARebateRecalcEntry."Order Date" := MICARebateRecalcWorksheet."Order Date";
        MICARebateRecalcEntry."Order No." := MICARebateRecalcWorksheet."Order No.";
        MICARebateRecalcEntry."Customer No." := MICARebateRecalcWorksheet."Customer No.";
        MICARebateRecalcEntry."Customer Name" := MICARebateRecalcWorksheet."Customer Name";
        MICARebateRecalcEntry."Customer Discount Group" := MICARebateRecalcWorksheet."Customer Discount Group";
        MICARebateRecalcEntry."Line No." := MICARebateRecalcWorksheet."Line No.";
        MICARebateRecalcEntry."Item No." := MICARebateRecalcWorksheet."Item No.";
        MICARebateRecalcEntry.Description := MICARebateRecalcWorksheet.Description;
        MICARebateRecalcEntry."Location Code" := MICARebateRecalcWorksheet."Location Code";
        MICARebateRecalcEntry."MICA Status" := MICARebateRecalcWorksheet."MICA Status";
        MICARebateRecalcEntry.Quantity := MICARebateRecalcWorksheet.Quantity;
        MICARebateRecalcEntry."Discount %" := MICARebateRecalcWorksheet."Discount %";
        MICARebateRecalcEntry."New Discount %" := MICARebateRecalcWorksheet."New Discount %";
        MICARebateRecalcEntry."Recalculation Date" := WorkDate();
        MICARebateRecalcEntry.Modify();
    end;

    local procedure ReleaseSalesDocOpen(var FromSalesOrder: Record "Sales Header")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Workflow: Record Workflow;
        WorkflowEnableSave: Boolean;
    begin
        if not (FromSalesOrder.Status = FromSalesOrder.Status::Open) then
            exit;

        Clear(ReleaseSalesDocument);
        SalesReceivablesSetup.Get();
        WorkflowEnableSave := false;
        if Workflow.Get(SalesReceivablesSetup."MICA Approval Workflow") then begin
            WorkflowEnableSave := Workflow.Enabled;
            if Workflow.Enabled then begin
                Workflow.Validate(Enabled, false);
                Workflow.Modify(true);
            end;
        end;
        ReleaseSalesDocument.ReleaseSalesHeader(FromSalesOrder, false);
        if WorkflowEnableSave then begin
            Workflow.Validate(Enabled, true);
            Workflow.Modify(true);
        end;
    end;

    procedure CheckAllSalesLineStatuses(): Text
    var
        MICATableValue: Record "MICA Table Value";
        SalesLineStatusesFilter: Text;
        CannotFilterAnyStatusErr: Label 'There are no statuses allowed for the suggestion.';
    begin
        SalesLineStatusesFilter := '';

        MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::SalesLineStatus);
        MICATableValue.SetRange("Allow Recalc.", true);
        if MICATableValue.IsEmpty() then
            Error(CannotFilterAnyStatusErr);

        if MICATableValue.FindSet() then
            repeat
                if SalesLineStatusesFilter = '' then
                    SalesLineStatusesFilter := MICATableValue.Description
                else
                    SalesLineStatusesFilter += '|' + MICATableValue.Description;
            until MICATableValue.Next() = 0;

        if SalesLineStatusesFilter <> '' then
            exit(SalesLineStatusesFilter);
    end;

    procedure SetSORebateRecalcExclWindow(NewSORebateRecalcExclWindow: DateFormula)
    begin
        SORebateRecalcExclWindow := NewSORebateRecalcExclWindow;
    end;

    var
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        SORebateRecalcExclWindow: DateFormula;
        TypeOfChanges: Option Suggest,Implement;
}