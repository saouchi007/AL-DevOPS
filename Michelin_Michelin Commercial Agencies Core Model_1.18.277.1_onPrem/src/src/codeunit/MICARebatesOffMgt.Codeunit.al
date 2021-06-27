codeunit 80180 "MICA Rebates Off Mgt."
{
    // version OFFINVOICE
    var
        LineNo: Integer;



    procedure CalcAdditionalRebates(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        MICAAddItemDiscountGroup: Record "MICA Add. Item Discount Group";
        TempSalesLineDiscount: Record "Sales Line Discount" temporary;
        Customer: Record Customer;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        NewLineDisc: Decimal;
        DateCaption: Text[30];
    Begin
        WITH SalesLine DO Begin
            If (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) AND (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo") THEN
                EXIT;
            If "Line No." <> 0 Then Begin
                RemoveAdditionalItemDiscount(SalesLine);
                RemoveAppliedSalesLineDisc(SalesLine);
            End;

            // hotfix 340
            // If "Line Discount %" <> 0 THEN
            //    EXIT;
            // hotfix 340
            If Customer.Get(SalesHeader."Sell-to Customer No.") THEN;

            MICAAddItemDiscountGroup.Reset();
            MICAAddItemDiscountGroup.SetRange("Item No.", SalesLine."No.");
            If MICAAddItemDiscountGroup.FindSet() Then Begin
                InitLineNo();
                Repeat
                    if ItemDiscountGroupIsApplicable(SalesHeader, MICAAddItemDiscountGroup) then begin
                        SalesPriceCalcMgt.FindSalesLineDisc(TempSalesLineDiscount, SalesHeader."Sell-to Customer No.", SalesHeader."Bill-to Contact No.",
                        Customer."Customer Disc. Group", '', "No.", MICAAddItemDiscountGroup."Item Discount Group Code", "Variant Code", "Unit of Measure Code",
                        SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), FALSE);
                        CalcBestLineDisc(TempSalesLineDiscount, SalesLine);

                        NewLineDisc += TempSalesLineDiscount."Line Discount %";
                        InsertAdditionalItemDiscount(SalesLine, MICAAddItemDiscountGroup, TempSalesLineDiscount."Line Discount %");
                        InsertAppliedSalesLineDisc(SalesLine, TempSalesLineDiscount, 0);
                    end;
                Until MICAAddItemDiscountGroup.Next() = 0;
                SalesLine."Line Discount %" := NewLineDisc;
            End;
#if OnPremise
            SalesLine.ValidateLineDiscountPercent(True);
#else
            SalesLine.validate("Line Discount %");
#endif
        End;
    End;

    procedure CalcTotalSalesLineDisc(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        TempSalesLineDiscount: Record "Sales Line Discount" temporary;
    Begin
        WITH SalesLine DO Begin
            If ("Document Type" <> "Document Type"::Order) AND ("Document Type" <> "Document Type"::"Credit Memo") THEN
                EXIT;
            CalcPaymTermsLineDisc(SalesLine, SalesHeader);
            "Line Discount %" += "MICA Exceptional Disc. %";
            If "MICA Exceptional Disc. %" <> 0 THEN
                InsertAppliedSalesLineDisc(SalesLine, TempSalesLineDiscount, 2);
#if OnPremise
            ValidateLineDiscountPercent(True);
#else
            validate("Line Discount %");
#endif            
        End;
    End;

    procedure CalcPaymTermsLineDisc(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        SalesAgreement: Record "MICA Sales Agreement";
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
    Begin
        WITH SalesLine DO Begin
            If ("Document Type" <> "Document Type"::Order) AND ("Document Type" <> "Document Type"::"Credit Memo") THEN
                EXIT;
            If Type = Type::Item THEN
                If SalesLine."MICA Payment Terms Code" <> '' Then Begin
                    SalesAgreement.setrange("No.", SalesLine."MICA Sales Agreement No.");
                    If SalesAgreement.FindFirst() Then Begin
                        "Line Discount %" += SalesAgreement."Payment Terms Discount %";
                        "MICA Pay. Terms Line Disc. %" := SalesAgreement."Payment Terms Discount %";
                        InsertAppliedSalesLineDisc(SalesLine, TempSalesLineDisc, 1);
                    End;
                End;
#if OnPremise                
            ValidateLineDiscountPercent(True);
#else
            validate("Line Discount %");
#endif
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

    procedure InitPaymentTermsLineDisc(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        SalesAgreement: Record "MICA Sales Agreement";
    Begin
        If (SalesLine."Document Type" <> SalesLine."Document Type"::Order) AND (SalesLine."Document Type" <> SalesLine."Document Type"::"Credit Memo") THEN
            EXIT;
        SalesLine."MICA Pay. Terms Line Disc. %" := 0;
        If SalesLine."MICA Payment Terms Code" <> '' Then Begin
            SalesAgreement.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
            SalesAgreement.SetRange("Payment Terms Code", SalesLine."MICA Payment Terms Code");
            SalesAgreement.SetFilter("Start Date", '>= %1', SalesHeader."Posting Date");
            SalesAgreement.SetFilter("End Date", '<= %1', SalesHeader."Posting Date");
            If SalesAgreement.FindFirst() then
                If SalesLine."No." <> '' THEN
                    SalesLine."MICA Pay. Terms Line Disc. %" += SalesAgreement."Payment Terms Discount %";

            SalesLine.VALIDATE("MICA Pay. Terms Line Disc. %");
        End;
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

    procedure InsertAdditionalItemDiscount(SalesLine: Record "Sales Line"; AdditionalItemDiscountGroup: Record "MICA Add. Item Discount Group"; TempLineDisc: Decimal)
    var
        AdditionalItemDiscount: Record "MICA Additional Item Discount";
    Begin
        With AdditionalItemDiscount do
            If Get(SalesLine."Document No.", SalesLine."Line No.", AdditionalItemDiscountGroup."Item Discount Group Code") Then Begin
                "Discount %" := TempLineDisc;
                "Item No." := SalesLine."No.";
                Modify();
            End Else Begin
                Init();
                "Document No." := SalesLine."Document No.";
                "Document Line No." := SalesLine."Line No.";
                "Add. Item Discount Group Code" := AdditionalItemDiscountGroup."Item Discount Group Code";
                "Discount %" := TempLineDisc;
                "Item No." := SalesLine."No.";
                Insert();
            End;
        /*
        INIT();
        "Document No." := SalesLine."Document No.";
        "Document Line No." := SalesLine."Line No.";
        "Add. Item Discount Group Code" := AdditionalItemDiscountGroup."Item Discount Group Code";
        "Discount %" := TempLineDisc;
        "Item No." := SalesLine."No.";
        If NOT INSERT() THEN
            MODIFY();
        */

    End;

    procedure RemoveAppliedSalesLineDisc(SalesLine: Record "Sales Line")
    var
        AppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            setrange("Posted Document No.", '');
            If not IsEmpty() then
                DeleteAll();
        End;
    End;

    procedure RemoveAppliedSalesLineDisc2(SalesLine: Record "Sales Line")
    var
        AppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            Reset();
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetFilter("Document Line No.", '0|%1', SalesLine."Line No.");
            SetRange("Sales Discount %", 0);
            SetRange("Posted Document No.", '');
            If not IsEmpty() then
                DeleteAll();

        End;
    End;

    procedure InsertAppliedSalesLineDisc(SalesLine: Record "Sales Line"; TempLineDisc: Record "Sales Line Discount"; RebateType: Option Rebate,"Payment Terms",Exceptional)
    var
        AppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.";
        Item: Record item;
        SalesSetup: Record "Sales & Receivables Setup";
    Begin
        SalesSetup.Get();
        If SalesSetup."MICA Disable Appl. Sales Disc." then
            exit;
        If SalesLine.Type <> SalesLine.Type::Item THEN
            EXIT;

        WITH AppliedSalesLineDisc DO Begin

            Reset();
            SetCurrentKey("Rebates Type", "Document Type", "Document No.", "Document Line No.", Code);
            SetRange("Rebates Type", RebateType);
            SetRange("Document Type", SalesLine."Document Type");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            SetRange(Code, TempLineDisc.Code);
            If NOT FindFirst() Then Begin
                INIT();
                "Rebates Type" := RebateType;
                "Document Type" := SalesLine."Document Type".AsInteger();
                "Document No." := SalesLine."Document No.";
                "Document Line No." := SalesLine."Line No.";
                "Line No." := LineNo + 1;
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
                If Item.Get(SalesLine."No.") then
                    brand := item."MICA Brand";
                Insert();
                LineNo += 1;
            End Else
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
                            If Item.Get(SalesLine."No.") then
                                brand := item."MICA Brand";
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
                            If Item.Get(SalesLine."No.") then
                                brand := item."MICA Brand";

                            Modify();
                        End;

                    "Rebates Type"::Exceptional:
                        If
                            ("Sales Type" <> "Sales Type"::Customer) or
                            ("Sales Code" <> SalesLine."Sell-to Customer No.") or
                            (Type <> Type::"Exceptional Disc.") or
                            ("Sales Discount %" <> SalesLine."MICA Exceptional Disc. %")
                        Then Begin
                            "Sales Type" := "Sales Type"::Customer;
                            "Sales Code" := SalesLine."Sell-to Customer No.";
                            Type := Type::"Exceptional Disc.";
                            "Sales Discount %" := SalesLine."MICA Exceptional Disc. %";

                            "Item No." := SalesLine."No.";
                            If Item.Get(SalesLine."No.") then
                                brand := item."MICA Brand";

                            Modify();
                        End;
                End;

            RemoveAppliedSalesLineDisc2(SalesLine);
            //***
            //LogExecution(SalesLine);
            //***
        End;
    End;

    procedure UpdateAppliedlSalesLineDisc(Rec: Record "Sales Line")
    var
        AppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.";
        AppliedSalesLineDisc2: Record "MICA Applied Sales Line Disc.";
    Begin
        WITH AppliedSalesLineDisc DO Begin
            If Rec.Type <> Rec.Type::Item THEN
                EXIT;

            Reset();
            SetCurrentKey("Document Type", "Document No.", "Document Line No.");
            SetRange("Document Type", Rec."Document Type");
            SetRange("Document No.", Rec."Document No.");
            SetRange("Document Line No.", 0);
            SetRange("Item No.", Rec."No.");
            If FindSet() THEN
                Repeat
                    AppliedSalesLineDisc2.Get("Rebates Type", "Document Type", "Document No.", "Document Line No.", "Line No.");
                    AppliedSalesLineDisc2.Rename("Rebates Type", "Document Type", "Document No.", Rec."Line No.", "Line No.");
                Until Next() = 0;

            Reset();
            SetCurrentKey("Document Type", "Document No.", "Document Line No.");
            SetRange("Document Type", Rec."Document Type");
            SetRange("Document No.", Rec."Document No.");
            SetRange("Document Line No.", Rec."Line No.");
            SetRange("Item No.", Rec."No.");
            If IsEmpty() Then Begin
                AppliedSalesLineDisc2.Reset();
                AppliedSalesLineDisc2.SetCurrentkey("Document Type", "Document No.", "Document Line No.");
                AppliedSalesLineDisc2.SetRange("Document Type", Rec."Document Type");
                AppliedSalesLineDisc2.SetRange("Document No.", Rec."Document No.");
                AppliedSalesLineDisc2.SetRange("Document Line No.", 0);
                If Not AppliedSalesLineDisc2.IsEmpty() THEN
                    AppliedSalesLineDisc2.DeleteAll();
            End;
        End;
    End;

    procedure UpdateAdditionalItemDisc(SalesLine: Record "Sales Line")
    var
        AdditionalItemDiscount: Record "MICA Additional Item Discount";
        AddItemDiscount: Record "MICA Additional Item Discount";
    Begin
        WITH AdditionalItemDiscount DO Begin
            If SalesLine.Type <> SalesLine.Type::Item THEN
                EXIT;
            If SalesLine."No." = '' then
                exit;

            Reset();
            SetCurrentKey("Document No.", "Document Line No.", "Item No.");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", SalesLine."Line No.");
            SetRange("Item No.", SalesLine."No.");
            If Not IsEmpty() THEN
                DeleteAll();

            Reset();
            SetCurrentKey("Document No.", "Document Line No.", "Item No.");
            SetRange("Document No.", SalesLine."Document No.");
            SetRange("Document Line No.", 0);
            SetRange("Item No.", SalesLine."No.");
            If FindSet() THEN
                Repeat
                    AddItemDiscount.Get("Document No.", "Document Line No.", "Add. Item Discount Group Code");
                    AddItemDiscount.Rename("Document No.", SalesLine."Line No.", "Add. Item Discount Group Code");
                Until Next() = 0;
        End;
    End;

    procedure InitLineNo()
    var
        AppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.";
    Begin
        AppliedSalesLineDisc.Reset();
        AppliedSalesLineDisc.SetCurrentKey("Line No.");
        If AppliedSalesLineDisc.FindLast() THEN
            LineNo := AppliedSalesLineDisc."Line No."
        ELSE
            LineNo := 0;
    End;

    procedure CalcBestLineDisc(var SalesLineDisc: record "Sales Line Discount"; SalesLine: record "Sales Line")
    var
        BestSalesLineDisc: record "Sales Line Discount";
    Begin
        WITH SalesLineDisc DO
            If FindSet() THEN
                Repeat
                    If IsInMinQty("Unit of Measure Code", "Minimum Quantity", SalesLine."Qty. per Unit of Measure", SalesLine.Quantity) THEN
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
                        End;
                Until Next() = 0;


        SalesLineDisc := BestSalesLineDisc;
    End;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal; QtyPerUOM: Decimal; Qty: Decimal): Boolean
    Begin
        If UnitofMeasureCode = '' THEN
            EXIT(MinQty <= QtyPerUOM * Qty);
        EXIT(MinQty <= Qty);
    End;

    local procedure ItemDiscountGroupIsApplicable(SalesHeader: Record "Sales Header"; MICAAddItemDiscountGroup: Record "MICA Add. Item Discount Group"): Boolean
    var
        SalesLineDiscount: record "Sales Line Discount";
        MustCalculate: Boolean;
    //Trace: Text;
    begin

        With SalesLineDiscount do begin
            Reset();
            Setrange(Type, Type::"Item Disc. Group");
            Setrange(Code, MICAAddItemDiscountGroup."Item Discount Group Code");
            if Count() > 1 then
                Exit(true);

            If Not Findfirst() then
                Exit(false);

            case "Sales Type" of
                "Sales Type"::"Customer Disc. Group":
                    MustCalculate := ("Sales Code" = SalesHeader."Customer Disc. Group");
                "Sales Type"::"Customer":
                    MustCalculate := ("Sales Code" = SalesHeader."Bill-to Customer No.");
                else
                    MustCalculate := true;
            end;
            Exit(MustCalculate);

            /*
            Trace := StrSubstNo('%1\%2\%3\%4\\SalesHeader:\%5\%6\\Result:%7\%8',
                Type,
                Code,
                "Sales Type",
                "Sales Code",
                SalesHeader."Customer Disc. Group",
                SalesHeader."Bill-to Customer No.",
                "Line Discount %",
                MustCalculate);
            SendTraceTag('MICA', 'Rebaste Off', Verbosity::Warning, Trace);
            */

        end;
    end;

}