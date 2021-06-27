codeunit 80181 "MICA New Rebates Line Mgt"
{
    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        SanaContext: Codeunit "SC - Execution Context";
        UpdateLineDiscount: Boolean;
        SkipCalculation: Boolean;
        Discount: Decimal;
    begin
        SalesSetup.Get();

        SkipCalculation := SalesSetup."MICA Disable Appl. Sales Disc." or not RunTrigger or Rec.IsTemporary()
                    or ((Rec."Quantity Shipped" = Rec."Quantity") and (Rec.Quantity <> 0))
                        or Rec."MICA Skip Rebates Calculation"
                            or (not SalesHeader.Get(Rec."Document Type", Rec."Document No."))
                                or (UPPERCASE(SanaContext.GetCurrentOperationName()) in [UPPERCASE('SaveOrder'), UPPERCASE('CalculateBasket')])
                                ;

        if SkipCalculation then
            exit;


        If (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) THEN
            EXIT;

        if (Rec."No." <> xRec."No.") then begin

            RemoveAdditionalItemDiscount(Rec);
            RemoveAppliedSalesLineDisc(Rec);

            CalcAdditionalRebates(Rec, SalesHeader);
            CalcPaymTermsLineDisc(Rec, SalesHeader);
            CalcExceptionalRebates(Rec, SalesHeader);

            Discount := CalcLineDiscount(Rec);
            if Discount <> 0 then begin
#if OnPremise
                Rec."Line Discount %" := Discount;
                Rec.ValidateLineDiscountPercent(true);
#else
                rec.validate("Line Discount %", Discount);
#endif
            end;
            exit;
        end;

        if (Rec.Quantity <> xRec.Quantity) then begin
            CalcAdditionalRebates(Rec, SalesHeader);
            UpdateLineDiscount := true;
        end;

        if (Rec."MICA Payment Terms Code" <> '') then begin
            CalcPaymTermsLineDisc(Rec, SalesHeader);
            UpdateLineDiscount := true;
        end;


        if UpdateLineDiscount then begin
            Discount := CalcLineDiscount(Rec);
            if Discount <> 0 then begin
#if OnPremise                                
                Rec."Line Discount %" := Discount;
                Rec.SuspendStatusCheck(true);
                Rec.ValidateLineDiscountPercent(true);
#else
                Rec.SuspendStatusCheck(true);
                Rec.validate("Line Discount %", Discount);
#endif

            end;
        end;


    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnBeforeValidateEvent', 'MICA Exceptional Disc. %', false, false)]
    local procedure OnBeforeValidateExceptionalDisc(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        TxtItemExcepDisc_Err: Label 'You cannot modify exceptional discount % on commited lines';
    begin
        if Rec."MICA Skip Rebates Calculation" and (Rec."MICA Exceptional Disc. %" <> xRec."MICA Exceptional Disc. %") then
            Error(TxtItemExcepDisc_Err);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnAfterAddDocumentLine', '', false, false)]
    local procedure OnAfterAddDocumentLine(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        UpdateLineDiscount: Boolean;
        Discount: Decimal;
    begin
        With SalesLine do begin
            if not SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then
                exit;

            if ("No." <> '') then begin
                CalcAdditionalRebates(SalesLine, SalesHeader);
                CalcPaymTermsLineDisc(SalesLine, SalesHeader);
                UpdateLineDiscount := true;
            end;


            if ("MICA Pay. Terms Line Disc. %" <> 0) then begin
                CalcPaymTermsLineDisc(SalesLine, SalesHeader);
                UpdateLineDiscount := true;
            end;



            if UpdateLineDiscount then begin
                Discount := CalcLineDiscount(SalesLine);
                if Discount <> 0 then begin
#if OnPremise                    
                    "Line Discount %" := Discount;
                    ValidateLineDiscountPercent(true);
#else
                    validate("Line Discount %", Discount);
#endif

                    Modify(false);
                end;
            end;
        end;

    end;



    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        SanaContext: Codeunit "SC - Execution Context";
        UpdateLineDiscount: Boolean;
        Discount: Decimal;
    begin
        SalesSetup.Get();
        If SalesSetup."MICA Disable Appl. Sales Disc." then
            exit;

        if not RunTrigger
            or Rec.IsTemporary()
                or Rec."MICA Skip Rebates Calculation"
                    or (not SalesHeader.Get(Rec."Document Type", Rec."Document No."))
                     or (UPPERCASE(SanaContext.GetCurrentOperationName()) in [UPPERCASE('SaveOrder'), UPPERCASE('CalculateBasket')]) then
            exit;

        If (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) THEN
            EXIT;

        if (Rec."No." <> '') then begin
            CalcAdditionalRebates(Rec, SalesHeader);
            CalcPaymTermsLineDisc(Rec, SalesHeader);
            UpdateLineDiscount := true;
        end;

        if Rec."MICA Exceptional Disc. %" <> 0 then begin
            CalcExceptionalRebates(Rec, SalesHeader);
            UpdateLineDiscount := true;
        end;

        if (Rec."MICA Pay. Terms Line Disc. %" <> 0) then begin
            CalcPaymTermsLineDisc(Rec, SalesHeader);
            UpdateLineDiscount := true;
        end;



        if UpdateLineDiscount then begin
            Discount := CalcLineDiscount(Rec);
            if Discount <> 0 then begin
#if OnPremise
                Rec."Line Discount %" := Discount;
                Rec.ValidateLineDiscountPercent(true);
#else
                Rec.validate("Line Discount %", Discount);
#endif

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        If SalesSetup."MICA Disable Appl. Sales Disc." then
            exit;
        if Rec.IsTemporary() then
            exit;

        RemoveAdditionalItemDiscount(Rec);
        RemoveAppliedSalesLineDisc(Rec);


    end;

    procedure CalcAdditionalRebates(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        AdditionalItemDiscountGroup: Record "MICA Add. Item Discount Group";
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        Customer: Record Customer;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        DateCaption: Text[30];
        IsHandled: Boolean;
    Begin
        WITH SalesLine DO Begin
            If (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) THEN
                EXIT;

            OnBeforeCalcAdditionalRebateLine(SalesLine, SalesHeader, IsHandled);
            if IsHandled then
                exit;

            If "Line No." <> 0 Then
                RemoveAdditionalItemDiscount(SalesLine);


            If Customer.Get(SalesHeader."Sell-to Customer No.") THEN;

            AdditionalItemDiscountGroup.Reset();
            AdditionalItemDiscountGroup.SetRange("Item No.", SalesLine."No.");
            If AdditionalItemDiscountGroup.FindSet() Then
                Repeat
                    SalesPriceCalcMgt.FindSalesLineDisc(TempSalesLineDisc, SalesHeader."Sell-to Customer No.", SalesHeader."Bill-to Contact No.",
                      Customer."Customer Disc. Group", '', "No.", AdditionalItemDiscountGroup."Item Discount Group Code", "Variant Code", "Unit of Measure Code",
                      SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), FALSE);
                    CalcBestLineDisc(TempSalesLineDisc, SalesLine);

                    InsertAdditionalItemDiscount(SalesLine, AdditionalItemDiscountGroup, TempSalesLineDisc."Line Discount %");
                    if TempSalesLineDisc."Line Discount %" <> 0 then
                        ManageAppliedSalesLineDisc(SalesLine, TempSalesLineDisc, 0);
                Until AdditionalItemDiscountGroup.Next() = 0;
            OnAfterCalcAdditionalRebateLine(SalesLine, SalesHeader);
        End;
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure OnAfterSalesInvLineInsert(SalesLine: Record "Sales Line"; var SalesInvLine: Record "Sales Invoice Line")
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
        PostedAppliedSalesLineDisc: Record "MICA Posted Applied SL Disc.";
        SalesShipmentLine: Record "Sales Shipment Line";
        OrderNo: code[20];
        OrderLineNo: Integer;
    begin

        if SalesInvLine.Quantity = 0 then
            exit;
        if SalesLine."Shipment No." <> '' then begin
            if SalesShipmentLine.GET(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then begin
                OrderNo := SalesShipmentLine."Order No.";
                OrderLineNo := SalesShipmentLine."Order Line No.";
            end
        end else begin
            OrderNo := SalesLine."Document No.";
            OrderLineNo := SalesLine."Line No.";
        end;

        WITH AppliedSalesLineDisc DO Begin
            Reset();
            SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            SetRange("Document Type", AppliedSalesLineDisc."Document Type"::Order);
            SetRange("Document No.", OrderNo);
            SetRange("Document Line No.", OrderLineNo);

            if FindSet(false, false) then
                repeat
                    PostedAppliedSalesLineDisc.Init();
                    PostedAppliedSalesLineDisc.TransferFields(AppliedSalesLineDisc);
                    PostedAppliedSalesLineDisc."Posted Document Type" := PostedAppliedSalesLineDisc."Posted Document Type"::Invoice;
                    PostedAppliedSalesLineDisc."Posted Document No." := SalesInvLine."Document No.";
                    PostedAppliedSalesLineDisc."Posted Document Line No." := SalesInvLine."Line No.";
                    PostedAppliedSalesLineDisc."MICA Status" := PostedAppliedSalesLineDisc."MICA Status"::Closed;
                    PostedAppliedSalesLineDisc."Entry No." := 0;
                    PostedAppliedSalesLineDisc.Insert();
                    AppliedSalesLineDisc.Delete();
                until AppliedSalesLineDisc.Next() = 0;


        End;
    end;

    procedure CalcPaymTermsLineDisc(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        SalesAgreement: Record "MICA Sales Agreement";
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
        IsHandled: Boolean;
    Begin
        WITH SalesLine DO Begin
            If ("Document Type" <> "Document Type"::Order) THEN
                EXIT;

            OnBeforeCalcPaymentTermsRebateLine(SalesLine, SalesHeader, IsHandled);
            if IsHandled then
                exit;

            If Type = Type::Item THEN
                If SalesLine."MICA Payment Terms Code" <> '' Then Begin
                    SalesAgreement.setrange("No.", SalesLine."MICA Sales Agreement No.");
                    If SalesAgreement.FindFirst() Then
                        if SalesAgreement."Payment Terms Discount %" <> 0 then begin
                            "MICA Pay. Terms Line Disc. %" := SalesAgreement."Payment Terms Discount %";
                            ManageAppliedSalesLineDisc(SalesLine, TempSalesLineDisc, 1);
                        end else
                            FindAndRemoveAppliedSalesLineDiscByType(SalesLine, AppliedSalesLineDisc.Type::"Payment Term Disc.");

                End;

            OnAfterCalcPaymentTermsRebateLine(SalesLine, SalesHeader);
        End;
    End;

    procedure CalcExceptionalRebates(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        IsHandled: Boolean;
    Begin
        WITH SalesLine DO Begin
            If ("Document Type" <> "Document Type"::Order) THEN
                EXIT;

            OnBeforeCalcExceptionalRebateLine(SalesLine, SalesHeader, IsHandled);
            if IsHandled then
                exit;

            If Type = Type::Item THEN
                if "MICA Exceptional Disc. %" <> 0 then
                    ManageAppliedSalesLineDisc(SalesLine, TempSalesLineDisc, 2)
                else
                    RemoveExceptionalRebates(SalesLine);

            OnAfterCalcExceptionalRebateLine(SalesLine, SalesHeader);
        End;
    End;


    procedure CalcLineDiscount(var SalesLine: Record "Sales Line"): Decimal
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
        Discount: Decimal;
    begin
        with SalesLine do begin
            AppliedSalesLineDisc.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            AppliedSalesLineDisc.SetRange("Document Type", "Document Type");
            AppliedSalesLineDisc.SetRange("Document No.", "Document No.");
            AppliedSalesLineDisc.SetRange("Document Line No.", "Line No.");

            if AppliedSalesLineDisc.FindSet(false) then begin
                repeat
                    Discount += AppliedSalesLineDisc."Sales Discount %";
                until AppliedSalesLineDisc.Next() = 0;
                exit(Discount);
            end;

        end;

    end;

    procedure ManageAppliedSalesLineDisc(SalesLine: Record "Sales Line"; TempLineDisc: Record "Sales Line Discount"; RebateType: Option Rebate,"Payment Terms",Exceptional)
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
        SalesSetup: Record "Sales & Receivables Setup";
    Begin
        SalesSetup.Get();
        If SalesSetup."MICA Disable Appl. Sales Disc." then
            exit;
        If SalesLine.Type <> SalesLine.Type::Item THEN
            EXIT;

        WITH AppliedSalesLineDisc DO Begin

            Reset();
            SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            SetRange("Rebates Type", RebateType);
            if RebateType = RebateType::Rebate then
                SetRange(Code, TempLineDisc.Code)
            else
                Setrange("Sales Code", SalesLine."Sell-to Customer No.");
            If NOT FindFirst() then
                InsertAppliedSalesLineDisc(SalesLine, TempLineDisc, RebateType)
            else
                UpdateAppliedSalesLineDisc(AppliedSalesLineDisc, SalesLine, TempLineDisc, RebateType);

        End;
    End;

    procedure InsertAppliedSalesLineDisc(SalesLine: Record "Sales Line"; TempLineDisc: Record "Sales Line Discount"; RebateType: Option Rebate,"Payment Terms",Exceptional)
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
        Item: Record item;
    Begin
        WITH AppliedSalesLineDisc DO Begin
            INIT();
            "Rebates Type" := RebateType;
            "Document Type" := SalesLine."Document Type".AsInteger();
            "Document No." := SalesLine."Document No.";
            "Document Line No." := SalesLine."Line No.";

            Case "Rebates Type" OF
                "Rebates Type"::Rebate:
                    Begin
                        "Sales Type" := TempLineDisc."Sales Type";
                        "Sales Code" := TempLineDisc."Sales Code";
                        Type := TempLineDisc.Type.AsInteger();
                        Code := TempLineDisc.Code;
                        "Unit of Measure Code" := TempLineDisc."Unit of Measure Code";
                        "Sales Discount %" := TempLineDisc."Line Discount %";
                        "Starting Date" := TempLineDisc."Starting Date";
                        "Ending Date" := TempLineDisc."Ending Date";
                    End;
                "Rebates Type"::"Payment Terms":
                    Begin
                        "Sales Type" := "Sales Type"::Customer;
                        "Sales Code" := SalesLine."Sell-to Customer No.";
                        Type := Type::"Payment Term Disc.";
                        "Sales Discount %" := SalesLine."MICA Pay. Terms Line Disc. %";
                    End;
                "Rebates Type"::Exceptional:
                    Begin
                        "Sales Type" := "Sales Type"::Customer;
                        "Sales Code" := SalesLine."Sell-to Customer No.";
                        Type := Type::"Exceptional Disc.";
                        "Sales Discount %" := SalesLine."MICA Exceptional Disc. %";
                    End;
            End;
            "Item No." := SalesLine."No.";
            "MICA Except. Rebate Reason" := SalesLine."MICA Except. Rebate Reason";
            If Item.Get(SalesLine."No.") then begin
                brand := item."MICA Brand";
                "Product Line" := CopyStr(item."Item Category Code", 1, MaxStrLen("Product Line"));
            end;
            Insert();
        End;
    End;

    procedure UpdateAppliedSalesLineDisc(var AppliedSalesLineDisc: Record "MICA New Applied SL Discount"; SalesLine: Record "Sales Line"; TempLineDisc: Record "Sales Line Discount"; RebateType: Option Rebate,"Payment Terms",Exceptional)
    var
        Item: Record item;
    Begin
        WITH AppliedSalesLineDisc do
            Case "Rebates Type" OF

                "Rebates Type"::Rebate:
                    if
                        ("Sales Type" <> TempLineDisc."Sales Type") or
                        ("Sales Code" <> TempLineDisc."Sales Code") or
                        (Type <> TempLineDisc.Type.AsInteger()) or
                        (Code <> TempLineDisc.Code) or
                        ("Unit of Measure Code" <> TempLineDisc."Unit of Measure Code") or
                        ("Sales Discount %" <> TempLineDisc."Line Discount %") or
                        ("Starting Date" <> TempLineDisc."Starting Date") or
                        ("Ending Date" <> TempLineDisc."Ending Date")
                    Then Begin
                        "Sales Type" := TempLineDisc."Sales Type";
                        "Sales Code" := TempLineDisc."Sales Code";
                        Type := TempLineDisc.Type.AsInteger();
                        Code := TempLineDisc.Code;
                        "Unit of Measure Code" := TempLineDisc."Unit of Measure Code";
                        "Sales Discount %" := TempLineDisc."Line Discount %";
                        "Starting Date" := TempLineDisc."Starting Date";
                        "Ending Date" := TempLineDisc."Ending Date";

                        "Item No." := SalesLine."No.";
                        "MICA Except. Rebate Reason" := SalesLine."MICA Except. Rebate Reason";
                        If Item.Get(SalesLine."No.") then begin
                            brand := item."MICA Brand";
                            "Product Line" := CopyStr(Item."Item Category Code", 1, MaxStrLen("Product Line"));
                        end;
                        Modify();
                    End;

                "Rebates Type"::"Payment Terms":
                    if
                        ("Sales Type" <> "Sales Type"::Customer) or
                        ("Sales Code" <> SalesLine."Sell-to Customer No.") or
                        (Type <> Type::"Payment Term Disc.") or
                        ("Sales Discount %" <> SalesLine."MICA Pay. Terms Line Disc. %")
                    Then Begin
                        "Sales Type" := "Sales Type"::Customer;
                        "Sales Code" := SalesLine."Sell-to Customer No.";
                        Type := Type::"Payment Term Disc.";
                        "Sales Discount %" := SalesLine."MICA Pay. Terms Line Disc. %";

                        "Item No." := SalesLine."No.";
                        "MICA Except. Rebate Reason" := SalesLine."MICA Except. Rebate Reason";
                        If Item.Get(SalesLine."No.") then begin
                            brand := item."MICA Brand";
                            "Product Line" := CopyStr(Item."Item Category Code", 1, MaxStrLen("Product Line"));
                        end;
                        Modify();
                    End;

                "Rebates Type"::Exceptional:
                    If
                        ("Sales Type" <> "Sales Type"::Customer) or
                        ("Sales Code" <> SalesLine."Sell-to Customer No.") or
                        (Type <> Type::"Exceptional Disc.") or
                        ("Sales Discount %" <> SalesLine."MICA Exceptional Disc. %") or
                        ("MICA Except. Rebate Reason" <> SalesLine."MICA Except. Rebate Reason")
                    Then Begin
                        "Sales Type" := "Sales Type"::Customer;
                        "Sales Code" := SalesLine."Sell-to Customer No.";
                        Type := Type::"Exceptional Disc.";
                        "Sales Discount %" := SalesLine."MICA Exceptional Disc. %";

                        "Item No." := SalesLine."No.";
                        "MICA Except. Rebate Reason" := SalesLine."MICA Except. Rebate Reason";
                        If Item.Get(SalesLine."No.") then begin
                            brand := item."MICA Brand";
                            "Product Line" := CopyStr(Item."Item Category Code", 1, MaxStrLen("Product Line"));
                        end;
                        Modify();
                    End;

            End;
    End;

    procedure RemoveAppliedSalesLineDisc(SalesLine: Record "Sales Line")
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            If not IsEmpty() then
                DeleteAll();
        End;
    End;

    procedure RemoveAppliedSalesLineDisc(SalesLine: Record "Sales Line"; var SalesLineDisc: record "Sales Line Discount")
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            SetRange(Code, SalesLineDisc.Code);
            If not IsEmpty() then
                DeleteAll();
        End;
    End;

    procedure FindAndRemoveAppliedSalesLineDiscByType(SalesLine: Record "Sales Line"; TypeToRemove: Option): Boolean
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            SetRange(Type, TypeToRemove);
            If not IsEmpty() then begin
                DeleteAll();
                exit(true);
            end;
            exit(false);
        End;
    End;

    procedure RemoveExceptionalRebates(SalesLine: Record "Sales Line")
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            SetRange("Rebates Type", "Rebates Type"::Exceptional);
            If not IsEmpty() then
                DeleteAll();
        End;
    End;

    procedure InsertAdditionalItemDiscount(SalesLine: Record "Sales Line"; AdditionalItemDiscountGroup: Record "MICA Add. Item Discount Group"; TempLineDisc: Decimal)
    var
        AdditionalItemDiscount: Record "MICA Additional Item Discount";
    Begin
        With AdditionalItemDiscount do
            If Get(SalesLine."Document No.", SalesLine."Line No.", AdditionalItemDiscountGroup."Item Discount Group Code") then begin
                if ("Discount %" <> TempLineDisc) or ("Item No." <> SalesLine."No.") then begin
                    "Discount %" := TempLineDisc;
                    "Item No." := SalesLine."No.";
                    Modify();
                end;
            end else Begin
                Init();
                "Document No." := SalesLine."Document No.";
                "Document Line No." := SalesLine."Line No.";
                "Add. Item Discount Group Code" := AdditionalItemDiscountGroup."Item Discount Group Code";
                "Discount %" := TempLineDisc;
                "Item No." := SalesLine."No.";
                Insert();
            End;


    End;

    procedure SalesHeaderStartDate(SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    Begin
        WITH SalesHeader DO
            If "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] Then Begin
                DateCaption := COPYSTR(FIELDCAPTION("Posting Date"), 1, 30);
                EXIT("Posting Date")
            End Else Begin
                DateCaption := COPYSTR(FIELDCAPTION("Order Date"), 1, 30);
                EXIT("Order Date");
            End;
    End;

    procedure CalcBestLineDisc(var SalesLineDisc: record "Sales Line Discount"; SalesLine: record "Sales Line")
    var
        BestSalesLineDisc: record "Sales Line Discount";
    Begin
        WITH SalesLineDisc DO
            If FindSet() THEN
                Repeat
                    If IsInMinQty("Unit of Measure Code", "Minimum Quantity", SalesLine."Qty. per Unit of Measure", SalesLine.Quantity) then
                        Case TRUE OF
                            ((BestSalesLineDisc."Currency Code" = '') AND ("Currency Code" <> '')) OR
                          ((BestSalesLineDisc."Variant Code" = '') AND ("Variant Code" <> '')):
                                BestSalesLineDisc := SalesLineDisc;
                            ((BestSalesLineDisc."Currency Code" = '') OR ("Currency Code" <> '')) AND
                          ((BestSalesLineDisc."Variant Code" = '') OR ("Variant Code" <> '')):
                                // hotfix 340
                                // If BestSalesLineDisc."Line Discount %" < "Line Discount %" Then 
                                // hotfix 340
                                BestSalesLineDisc := SalesLineDisc;
                        End
                    else
                        RemoveAppliedSalesLineDisc(SalesLine, SalesLineDisc);
                Until Next() = 0;


        SalesLineDisc := BestSalesLineDisc;
    End;

    procedure RemoveAdditionalItemDiscount(SalesLine: Record "Sales Line")
    var
        AdditionalItemDiscount: Record "MICA Additional Item Discount";
    Begin
        WITH AdditionalItemDiscount DO Begin
            Reset();
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", 0);
            If Not IsEmpty() then
                DeleteAll();

            Reset();
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            If Not IsEmpty() then
                DeleteAll();

        End;
    End;


    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal; QtyPerUOM: Decimal; Qty: Decimal): Boolean
    Begin
        If UnitofMeasureCode = '' THEN
            EXIT(MinQty <= QtyPerUOM * Qty);
        EXIT(MinQty <= Qty);
    End;

    procedure FindItemRebatesPerCustomer(Item: Record "Item"; Cust: Record "Customer"; StartDate: date; var SalesLineDisc: record "Sales Line Discount" temporary): Decimal
    var
        AdditionalItemDiscountGroup: Record "MICA Add. Item Discount Group";
        ContBusRel: Record "Contact Business Relation";
        SalesAgreement: Record "MICA Sales Agreement";
        TempSalesLine: Record "Sales Line" temporary;
        TempSalesLineDisc: record "Sales Line Discount" temporary;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        BillToContactNo: code[20];
        StartingDate: date;
        TotalDiscount: Decimal;
    begin


        //Look for bill-to contact no

        IF Cust."Primary Contact No." <> '' THEN
            BillToContactNo := Cust."Primary Contact No."
        ELSE BEGIN
            ContBusRel.RESET();
            ContBusRel.SETCURRENTKEY("Link to Table", "No.");
            ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
            ContBusRel.SETRANGE("No.", Cust."Bill-to Customer No.");
            IF ContBusRel.FINDFIRST() THEN
                BillToContactNo := ContBusRel."Contact No."
            ELSE
                BillToContactNo := '';
        END;

        if StartDate <> 0D then
            StartingDate := StartDate
        else
            StartingDate := WorkDate();


        // Additionnal Item Rebates
        AdditionalItemDiscountGroup.Reset();
        AdditionalItemDiscountGroup.SetRange("Item No.", Item."No.");
        If AdditionalItemDiscountGroup.FindSet() Then begin
            TempSalesLine."No." := Item."No.";
            TempSalesLine.Quantity := 0;
            TempSalesLine."Qty. per Unit of Measure" := 1;
            Repeat
                SalesPriceCalcMgt.FindSalesLineDisc(TempSalesLineDisc, Cust."No.", BillToContactNo,
                    Cust."Customer Disc. Group", '', Item."No.", AdditionalItemDiscountGroup."Item Discount Group Code", TempSalesLine."Variant Code", Item."Base Unit of Measure",
                    Cust."Currency Code", StartingDate, FALSE);
                CalcBestLineDisc(TempSalesLineDisc, TempSalesLine);

                TotalDiscount += TempSalesLineDisc."Line Discount %";

                if TempSalesLineDisc."Line Discount %" <> 0 then begin
                    SalesLineDisc.Init();
                    SalesLineDisc := TempSalesLineDisc;
                    SalesLineDisc.Insert();
                end;

            Until AdditionalItemDiscountGroup.Next() = 0;
        end;

        //Payment Terms Rebates
        if GetSalesAgreement(Item, Cust, SalesAgreement) <> '' then
            if SalesAgreement."Payment Terms Discount %" <> 0 then begin
                SalesLineDisc.Init();
                SalesLineDisc.Code := SalesAgreement."Payment Terms Code";
                SalesLineDisc."Line Discount %" := SalesAgreement."Payment Terms Discount %";
                SalesLineDisc.Insert();
                TotalDiscount += SalesLineDisc."Line Discount %";
            end;

        exit(TotalDiscount);

    end;

    local procedure GetSalesAgreement(Item: Record Item; Customer: Record Customer; var SalesAgreement: Record "MICA Sales Agreement"): Code[20]
    begin
        With Item do begin
            SalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
            if "Item Category Code" <> '' THEN begin

                SalesAgreement.SetRange("Customer No.", Customer."No.");
                SalesAgreement.SetRange("Item Category Code", "Item Category Code");
                SalesAgreement.SetRange(DefaultLP, true);
                if SalesAgreement.findfirst() then
                    if (WorkDate() >= SalesAgreement."Start Date") AND (WorkDate() <= SalesAgreement."End Date") then
                        exit(SalesAgreement."No.");

                SalesAgreement.SetRange("Item Category Code");
                SalesAgreement.SetRange(DefaultLP);
                SalesAgreement.SetRange(Default, true);
                if SalesAgreement.findfirst() then
                    if (WorkDate() >= SalesAgreement."Start Date") AND (WorkDate() <= SalesAgreement."end Date") then
                        exit(SalesAgreement."No.");
            end else begin
                SalesAgreement.SetRange("Customer No.", Customer."No.");
                SalesAgreement.SetRange(Default, true);
                if SalesAgreement.findfirst() then
                    if (WorkDate() >= SalesAgreement."Start Date") AND (WorkDate() <= SalesAgreement."end Date") then
                        exit(SalesAgreement."No.");
            end;
        end;
    end;

    procedure CopyRebatesInformationFromSalesLine(FromSalesLine: Record "Sales Line"; var TempAppliedSLDisc: Record "MICA New Applied SL Discount"; var TempAddItemDisc: Record "MICA Additional Item Discount")
    var
        AppliedSLDisc: Record "MICA New Applied SL Discount";
        PostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
        AddItemDisc: Record "MICA Additional Item Discount";
        EntryNo: integer;
    begin
        With FromSalesLine do begin
            AppliedSLDisc.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            AppliedSLDisc.SetRange("Document Type", "Document Type");
            AppliedSLDisc.SetRange("Document No.", "Document No.");
            AppliedSLDisc.SetRange("Document Line No.", "Line No.");

            if AppliedSLDisc.FindSet() then
                repeat
                    EntryNo += 1;
                    TempAppliedSLDisc.Init();
                    TempAppliedSLDisc := AppliedSLDisc;
                    TempAppliedSLDisc."Entry No." := EntryNo;
                    TempAppliedSLDisc.Insert();
                until AppliedSLDisc.Next() = 0;

            PostedAppliedSLDisc.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            PostedAppliedSLDisc.SetRange("Document Type", "Document Type");
            PostedAppliedSLDisc.SetRange("Document No.", "Document No.");
            PostedAppliedSLDisc.SetRange("Document Line No.", "Line No.");
            if PostedAppliedSLDisc.FindSet() then
                repeat
                    EntryNo += 1;
                    TempAppliedSLDisc.Init();
                    TempAppliedSLDisc."Entry No." := EntryNo;
                    TempAppliedSLDisc."Rebates Type" := PostedAppliedSLDisc."Rebates Type";
                    TempAppliedSLDisc."Item No." := PostedAppliedSLDisc."Item No.";
                    TempAppliedSLDisc."Document Type" := PostedAppliedSLDisc."Document Type";
                    TempAppliedSLDisc."Document No." := PostedAppliedSLDisc."Document No.";
                    TempAppliedSLDisc."Document Line No." := PostedAppliedSLDisc."Document Line No.";
                    TempAppliedSLDisc."Sales Discount %" := PostedAppliedSLDisc."Sales Discount %";
                    TempAppliedSLDisc."Sales Code" := PostedAppliedSLDisc."Sales Code";
                    TempAppliedSLDisc."Product Line" := PostedAppliedSLDisc."Product Line";
                    TempAppliedSLDisc."Starting Date" := PostedAppliedSLDisc."Starting Date";
                    TempAppliedSLDisc."Ending Date" := PostedAppliedSLDisc."Ending Date";
                    TempAppliedSLDisc."Unit of Measure Code" := PostedAppliedSLDisc."Unit of Measure Code";
                    TempAppliedSLDisc.Type := PostedAppliedSLDisc.Type;
                    TempAppliedSLDisc.Brand := PostedAppliedSLDisc.Brand;
                    TempAppliedSLDisc.Code := PostedAppliedSLDisc.Code;
                    TempAppliedSLDisc."Sales Type" := PostedAppliedSLDisc."Sales Type";
                    TempAppliedSLDisc."MICA Except. Rebate Reason" := PostedAppliedSLDisc."MICA Except. Rebate Reason";
                    TempAppliedSLDisc."MICA Source Document No." := PostedAppliedSLDisc."MICA Source Document No.";
                    TempAppliedSLDisc."MICA Source Doc. Line No." := PostedAppliedSLDisc."MICA Source Doc. Line No.";
                    TempAppliedSLDisc.Insert();
                until PostedAppliedSLDisc.Next() = 0;


            AddItemDisc.SetRange("Document No.", "Document No.");
            AddItemDisc.SetRange("Document Line No.", "Line No.");
            if AddItemDisc.FindSet() then
                repeat
                    TempAddItemDisc.Init();
                    TempAddItemDisc := AddItemDisc;
                    TempAddItemDisc.Insert();
                until AddItemDisc.Next() = 0;

        end;
    end;

    procedure CopyRebatesInformationFromSalesInvLine(FromSalesInvLine: Record "Sales Invoice Line"; ToSalesLine: Record "Sales Line")
    var
        AppliedSLDisc: Record "MICA New Applied SL Discount";
        PostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
    begin
        With FromSalesInvLine do begin
            PostedAppliedSLDisc.SetCurrentKey("Posted Document Type", "Posted Document No.", "Posted Document Line No.");
            PostedAppliedSLDisc.SetRange("Posted Document Type", PostedAppliedSLDisc."Posted Document Type"::Invoice);
            PostedAppliedSLDisc.SetRange("Posted Document No.", "Document No.");
            PostedAppliedSLDisc.SetRange("Posted Document Line No.", "Line No.");
            if PostedAppliedSLDisc.FindSet() then
                repeat
                    Clear(AppliedSLDisc);
                    AppliedSLDisc."Rebates Type" := PostedAppliedSLDisc."Rebates Type";
                    AppliedSLDisc."Item No." := PostedAppliedSLDisc."Item No.";
                    AppliedSLDisc."Document Type" := ToSalesLine."Document Type".AsInteger();
                    AppliedSLDisc."Document No." := ToSalesLine."Document No.";
                    AppliedSLDisc."Document Line No." := ToSalesLine."Line No.";
                    AppliedSLDisc."Sales Discount %" := PostedAppliedSLDisc."Sales Discount %";
                    AppliedSLDisc."Sales Code" := PostedAppliedSLDisc."Sales Code";
                    AppliedSLDisc."Product Line" := PostedAppliedSLDisc."Product Line";
                    AppliedSLDisc."Starting Date" := PostedAppliedSLDisc."Starting Date";
                    AppliedSLDisc."Ending Date" := PostedAppliedSLDisc."Ending Date";
                    AppliedSLDisc."Unit of Measure Code" := PostedAppliedSLDisc."Unit of Measure Code";
                    AppliedSLDisc.Type := PostedAppliedSLDisc.Type;
                    AppliedSLDisc.Brand := PostedAppliedSLDisc.Brand;
                    AppliedSLDisc.Code := PostedAppliedSLDisc.Code;
                    AppliedSLDisc."Sales Type" := PostedAppliedSLDisc."Sales Type";
                    AppliedSLDisc."MICA Except. Rebate Reason" := PostedAppliedSLDisc."MICA Except. Rebate Reason";
                    AppliedSLDisc."MICA Source Document No." := PostedAppliedSLDisc."Posted Document No.";
                    AppliedSLDisc."MICA Source Doc. Line No." := PostedAppliedSLDisc."Posted Document Line No.";
                    AppliedSLDisc.Insert();
                until PostedAppliedSLDisc.Next() = 0;

        end;
    end;

    procedure CopyRebatesInformationToSalesLine(ToSalesLine: Record "Sales Line"; var TempAppliedSLDisc: Record "MICA New Applied SL Discount"; var TempAddItemDisc: Record "MICA Additional Item Discount")
    var
        AppliedSLDisc: Record "MICA New Applied SL Discount";
        AddItemDisc: Record "MICA Additional Item Discount";
    begin
        With ToSalesLine do begin
            AppliedSLDisc.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
            AppliedSLDisc.Setrange("Document Type", "Document Type");
            AppliedSLDisc.Setrange("Document No.", "Document No.");
            AppliedSLDisc.Setrange("Document Line No.", "Line No.");

            if TempAppliedSLDisc.FindSet() then
                repeat
                    clear(AppliedSLDisc);
                    AppliedSLDisc.TransferFields(TempAppliedSLDisc);
                    AppliedSLDisc."Entry No." := 0; // Entry No autoincrement
                    AppliedSLDisc."Document Type" := "Document Type".AsInteger();
                    AppliedSLDisc."Document No." := "Document No.";
                    AppliedSLDisc."Document Line No." := "Line No.";
                    if not AppliedSLDisc.Insert() then;
                until TempAppliedSLDisc.Next() = 0;

            if TempAddItemDisc.FindSet() then
                repeat
                    clear(AddItemDisc);
                    AddItemDisc.TransferFields(TempAddItemDisc);
                    AddItemDisc."Document No." := "Document No.";
                    AddItemDisc."Document Line No." := "Line No.";
                    if not AddItemDisc.Insert(true) then;
                until TempAddItemDisc.Next() = 0;

        end;
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCalcAdditionalRebateLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnAfterCalcAdditionalRebateLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCalcPaymentTermsRebateLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnAfterCalcPaymentTermsRebateLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCalcExceptionalRebateLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnAfterCalcExceptionalRebateLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLinesToDoc', '', false, false)]
    local procedure AfterCopyRebateLinesFromInvoiceToCreditMemoOnReverse(var FromSalesInvoiceLine: Record "Sales Invoice Line"; var ToSalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        FromSalesInvoiceLine2: Record "Sales Invoice Line";
        ValueEntry: Record "Value Entry";
        ItemLedgerEntryNo: Integer;
    begin
        if ToSalesHeader."Document Type" <> ToSalesHeader."Document Type"::"Credit Memo" then
            exit;
        FromSalesInvoiceLine2.CopyFilters(FromSalesInvoiceLine);
        if FromSalesInvoiceLine2.FindSet() then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", ToSalesHeader."Document Type");
            SalesLine.SetRange("Document No.", ToSalesHeader."No.");
            SalesLine.SetRange("Copied From Posted Doc.", true);
            repeat
                ItemLedgerEntryNo := 0;
                FromSalesInvoiceLine2.FilterPstdDocLineValueEntries(ValueEntry);
                if ValueEntry.FindFirst() then
                    ItemLedgerEntryNo := ValueEntry."Item Ledger Entry No.";
                if ItemLedgerEntryNo <> 0 then begin
                    SalesLine.SetRange("Appl.-from Item Entry", ItemLedgerEntryNo);
                    if SalesLine.FindFirst() then
                        CopyRebatesInformationFromSalesInvLine(FromSalesInvoiceLine2, SalesLine);
                    SalesLine.SetRange("Appl.-from Item Entry");
                end;

            until FromSalesInvoiceLine2.Next() = 0;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesCrMemoLineInsert', '', false, false)]
    local procedure InsertPostedCrMemoLineSLDiscountLines(SalesLine: Record "Sales Line"; var SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        AppliedSalesLineDisc: Record "MICA New Applied SL Discount";
        PostedAppliedSalesLineDisc: Record "MICA Posted Applied SL Disc.";
        OrderNo: code[20];
        OrderLineNo: Integer;
    begin

        if SalesCrMemoLine.Quantity = 0 then
            exit;
        /*if SalesLine."Return Receipt No." <> '' then begin
            if ReturnReceiptLine.GET(SalesLine."Return Receipt No.", SalesLine."Shipment Line No.") then begin
                OrderNo := ReturnReceiptLine."ord";
                OrderLineNo := ReturnReceiptLine."Order Line No.";
            end
        end else begin*/
        OrderNo := SalesLine."Document No.";
        OrderLineNo := SalesLine."Line No.";
        //end;

        WITH AppliedSalesLineDisc DO Begin
            Reset();
            case SalesLine."Document Type" of
                SalesLine."Document Type"::Order:
                    SetRange("Document Type", AppliedSalesLineDisc."Document Type"::Order);
                SalesLine."Document Type"::"Credit Memo":
                    SetRange("Document Type", AppliedSalesLineDisc."Document Type"::"Credit Memo");
            end;
            SetRange("Document No.", OrderNo);
            SetRange("Document Line No.", OrderLineNo);

            if FindSet(false, false) then
                repeat
                    PostedAppliedSalesLineDisc.Init();
                    PostedAppliedSalesLineDisc.TransferFields(AppliedSalesLineDisc);
                    PostedAppliedSalesLineDisc."Posted Document Type" := PostedAppliedSalesLineDisc."Posted Document Type"::"Credit Memo";
                    PostedAppliedSalesLineDisc."Posted Document No." := SalesCrMemoLine."Document No.";
                    PostedAppliedSalesLineDisc."Posted Document Line No." := SalesCrMemoLine."Line No.";
                    PostedAppliedSalesLineDisc."MICA Status" := PostedAppliedSalesLineDisc."MICA Status"::Closed;
                    PostedAppliedSalesLineDisc."Entry No." := 0;
                    PostedAppliedSalesLineDisc.Insert();
                    AppliedSalesLineDisc.Delete();
                until AppliedSalesLineDisc.Next() = 0;


        End;
    end;




}