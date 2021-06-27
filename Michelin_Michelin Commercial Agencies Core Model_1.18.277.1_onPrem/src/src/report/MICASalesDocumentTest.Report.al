report 80120 "MICA Sales Document - Test"
{
    // version NAVW113.00
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rdl80120.MICASalesDocumentTest.rdlc';
    Caption = 'Sales Document - Test';
    UsageCategory = None;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(<> Quote));
            RequestFilterFields = "Document Type", "No.";
            RequestFilterHeading = 'Sales Document';
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_No_; "No.")
            {
            }
            dataitem(PageCounter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(FORMAT_TODAY_0_4_; Format(Today(), 0, 4))
                {
                }
                column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
                {
                }
                //column(CurrReport_PAGENO;CurrReport.PageNo())
                //{
                //}
                column(USERID; UserId())
                {
                }
                column(STRSUBSTNO_Text014_SalesHeaderFilter_; StrSubstNo(Text014_Txt, SalesHeaderFilter))
                {
                }
                column(SalesHeaderFilter; SalesHeaderFilter)
                {
                }
                column(ShipInvText; ShipInvText)
                {
                }
                column(ReceiveInvText; ReceiveInvText)
                {
                }
                column(Sales_Header___Sell_to_Customer_No__; "Sales Header"."Sell-to Customer No.")
                {
                }
                column(ShipToAddr_8_; ShipToAddr[8])
                {
                }
                column(ShipToAddr_7_; ShipToAddr[7])
                {
                }
                column(ShipToAddr_6_; ShipToAddr[6])
                {
                }
                column(ShipToAddr_5_; ShipToAddr[5])
                {
                }
                column(ShipToAddr_4_; ShipToAddr[4])
                {
                }
                column(ShipToAddr_3_; ShipToAddr[3])
                {
                }
                column(ShipToAddr_2_; ShipToAddr[2])
                {
                }
                column(ShipToAddr_1_; ShipToAddr[1])
                {
                }
                column(SellToAddr_8_; SellToAddr[8])
                {
                }
                column(SellToAddr_7_; SellToAddr[7])
                {
                }
                column(SellToAddr_6_; SellToAddr[6])
                {
                }
                column(SellToAddr_5_; SellToAddr[5])
                {
                }
                column(SellToAddr_4_; SellToAddr[4])
                {
                }
                column(SellToAddr_3_; SellToAddr[3])
                {
                }
                column(SellToAddr_2_; SellToAddr[2])
                {
                }
                column(SellToAddr_1_; SellToAddr[1])
                {
                }
                column(Sales_Header___Ship_to_Code_; "Sales Header"."Ship-to Code")
                {
                }
                column(FORMAT__Sales_Header___Document_Type____________Sales_Header___No__; Format("Sales Header"."Document Type") + ' ' + "Sales Header"."No.")
                {
                }
                column(ShipReceiveOnNextPostReq; ShipReceiveOnNextPostReqValue)
                {
                }
                column(ShowCostAssignment; ShowCostAssignment)
                {
                }
                column(InvOnNextPostReq; InvOnNextPostReqValue)
                {
                }
                column(Sales_Header___VAT_Base_Discount___; "Sales Header"."VAT Base Discount %")
                {
                }
                column(SalesDocumentType; Format("Sales Header"."Document Type", 0, 2))
                {
                }
                column(BillToAddr_8_; BillToAddr[8])
                {
                }
                column(BillToAddr_7_; BillToAddr[7])
                {
                }
                column(BillToAddr_6_; BillToAddr[6])
                {
                }
                column(BillToAddr_5_; BillToAddr[5])
                {
                }
                column(BillToAddr_4_; BillToAddr[4])
                {
                }
                column(BillToAddr_3_; BillToAddr[3])
                {
                }
                column(BillToAddr_2_; BillToAddr[2])
                {
                }
                column(BillToAddr_1_; BillToAddr[1])
                {
                }
                column(Sales_Header___Bill_to_Customer_No__; "Sales Header"."Bill-to Customer No.")
                {
                }
                column(Sales_Header___Salesperson_Code_; "Sales Header"."Salesperson Code")
                {
                }
                column(Sales_Header___Your_Reference_; "Sales Header"."Your Reference")
                {
                }
                column(Sales_Header___Customer_Posting_Group_; "Sales Header"."Customer Posting Group")
                {
                }
                column(Sales_Header___Posting_Date_; Format("Sales Header"."Posting Date"))
                {
                }
                column(Sales_Header___Document_Date_; Format("Sales Header"."Document Date"))
                {
                }
                column(Sales_Header___Prices_Including_VAT_; "Sales Header"."Prices Including VAT")
                {
                }
                column(SalesHdrPricesIncludingVATFmt; Format("Sales Header"."Prices Including VAT"))
                {
                }
                column(Sales_Header___Payment_Terms_Code_; "Sales Header"."Payment Terms Code")
                {
                }
                column(Sales_Header___Payment_Discount___; "Sales Header"."Payment Discount %")
                {
                }
                column(Sales_Header___Due_Date_; Format("Sales Header"."Due Date"))
                {
                }
                column(Sales_Header___Customer_Disc__Group_; "Sales Header"."Customer Disc. Group")
                {
                }
                column(Sales_Header___Pmt__Discount_Date_; Format("Sales Header"."Pmt. Discount Date"))
                {
                }
                column(Sales_Header___Invoice_Disc__Code_; "Sales Header"."Invoice Disc. Code")
                {
                }
                column(Sales_Header___Shipment_Method_Code_; "Sales Header"."Shipment Method Code")
                {
                }
                column(Sales_Header___Payment_Method_Code_; "Sales Header"."Payment Method Code")
                {
                }
                column(Sales_Header___Customer_Posting_Group__Control104; "Sales Header"."Customer Posting Group")
                {
                }
                column(Sales_Header___Posting_Date__Control105; Format("Sales Header"."Posting Date"))
                {
                }
                column(Sales_Header___Document_Date__Control106; Format("Sales Header"."Document Date"))
                {
                }
                column(Sales_Header___Order_Date_; Format("Sales Header"."Order Date"))
                {
                }
                column(Sales_Header___Shipment_Date_; Format("Sales Header"."Shipment Date"))
                {
                }
                column(Sales_Header___Prices_Including_VAT__Control194; "Sales Header"."Prices Including VAT")
                {
                }
                column(Sales_Header___Payment_Terms_Code__Control18; "Sales Header"."Payment Terms Code")
                {
                }
                column(Sales_Header___Due_Date__Control19; Format("Sales Header"."Due Date"))
                {
                }
                column(Sales_Header___Pmt__Discount_Date__Control22; Format("Sales Header"."Pmt. Discount Date"))
                {
                }
                column(Sales_Header___Payment_Discount____Control23; "Sales Header"."Payment Discount %")
                {
                }
                column(Sales_Header___Payment_Method_Code__Control26; "Sales Header"."Payment Method Code")
                {
                }
                column(Sales_Header___Shipment_Method_Code__Control37; "Sales Header"."Shipment Method Code")
                {
                }
                column(Sales_Header___Customer_Disc__Group__Control100; "Sales Header"."Customer Disc. Group")
                {
                }
                column(Sales_Header___Invoice_Disc__Code__Control102; "Sales Header"."Invoice Disc. Code")
                {
                }
                column(Sales_Header___Customer_Posting_Group__Control130; "Sales Header"."Customer Posting Group")
                {
                }
                column(Sales_Header___Posting_Date__Control131; Format("Sales Header"."Posting Date"))
                {
                }
                column(Sales_Header___Document_Date__Control132; Format("Sales Header"."Document Date"))
                {
                }
                column(Sales_Header___Prices_Including_VAT__Control196; "Sales Header"."Prices Including VAT")
                {
                }
                column(Sales_Header___Applies_to_Doc__Type_; "Sales Header"."Applies-to Doc. Type")
                {
                }
                column(Sales_Header___Applies_to_Doc__No__; "Sales Header"."Applies-to Doc. No.")
                {
                }
                column(Sales_Header___Customer_Posting_Group__Control136; "Sales Header"."Customer Posting Group")
                {
                }
                column(Sales_Header___Posting_Date__Control137; Format("Sales Header"."Posting Date"))
                {
                }
                column(Sales_Header___Document_Date__Control138; Format("Sales Header"."Document Date"))
                {
                }
                column(Sales_Header___Prices_Including_VAT__Control198; "Sales Header"."Prices Including VAT")
                {
                }
                column(PageCounter_Number; Number)
                {
                }
                column(Sales_Document___TestCaption; Sales_Document___TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Sales_Header___Sell_to_Customer_No__Caption; "Sales Header".FieldCaption("Sell-to Customer No."))
                {
                }
                column(Ship_toCaption; Ship_toCaptionLbl)
                {
                }
                column(Sell_toCaption; Sell_toCaptionLbl)
                {
                }
                column(Sales_Header___Ship_to_Code_Caption; "Sales Header".FieldCaption("Ship-to Code"))
                {
                }
                column(Bill_toCaption; Bill_toCaptionLbl)
                {
                }
                column(Sales_Header___Bill_to_Customer_No__Caption; "Sales Header".FieldCaption("Bill-to Customer No."))
                {
                }
                column(Sales_Header___Salesperson_Code_Caption; "Sales Header".FieldCaption("Salesperson Code"))
                {
                }
                column(Sales_Header___Your_Reference_Caption; "Sales Header".FieldCaption("Your Reference"))
                {
                }
                column(Sales_Header___Customer_Posting_Group_Caption; "Sales Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Sales_Header___Posting_Date_Caption; Sales_Header___Posting_Date_CaptionLbl)
                {
                }
                column(Sales_Header___Document_Date_Caption; Sales_Header___Document_Date_CaptionLbl)
                {
                }
                column(Sales_Header___Prices_Including_VAT_Caption; "Sales Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Sales_Header___Payment_Terms_Code_Caption; "Sales Header".FieldCaption("Payment Terms Code"))
                {
                }
                column(Sales_Header___Payment_Discount___Caption; "Sales Header".FieldCaption("Payment Discount %"))
                {
                }
                column(Sales_Header___Due_Date_Caption; Sales_Header___Due_Date_CaptionLbl)
                {
                }
                column(Sales_Header___Customer_Disc__Group_Caption; "Sales Header".FieldCaption("Customer Disc. Group"))
                {
                }
                column(Sales_Header___Pmt__Discount_Date_Caption; Sales_Header___Pmt__Discount_Date_CaptionLbl)
                {
                }
                column(Sales_Header___Invoice_Disc__Code_Caption; "Sales Header".FieldCaption("Invoice Disc. Code"))
                {
                }
                column(Sales_Header___Shipment_Method_Code_Caption; "Sales Header".FieldCaption("Shipment Method Code"))
                {
                }
                column(Sales_Header___Payment_Method_Code_Caption; "Sales Header".FieldCaption("Payment Method Code"))
                {
                }
                column(Sales_Header___Customer_Posting_Group__Control104Caption; "Sales Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Sales_Header___Posting_Date__Control105Caption; Sales_Header___Posting_Date__Control105CaptionLbl)
                {
                }
                column(Sales_Header___Document_Date__Control106Caption; Sales_Header___Document_Date__Control106CaptionLbl)
                {
                }
                column(Sales_Header___Order_Date_Caption; Sales_Header___Order_Date_CaptionLbl)
                {
                }
                column(Sales_Header___Shipment_Date_Caption; Sales_Header___Shipment_Date_CaptionLbl)
                {
                }
                column(Sales_Header___Prices_Including_VAT__Control194Caption; "Sales Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Sales_Header___Payment_Terms_Code__Control18Caption; "Sales Header".FieldCaption("Payment Terms Code"))
                {
                }
                column(Sales_Header___Payment_Discount____Control23Caption; "Sales Header".FieldCaption("Payment Discount %"))
                {
                }
                column(Sales_Header___Due_Date__Control19Caption; Sales_Header___Due_Date__Control19CaptionLbl)
                {
                }
                column(Sales_Header___Pmt__Discount_Date__Control22Caption; Sales_Header___Pmt__Discount_Date__Control22CaptionLbl)
                {
                }
                column(Sales_Header___Shipment_Method_Code__Control37Caption; "Sales Header".FieldCaption("Shipment Method Code"))
                {
                }
                column(Sales_Header___Payment_Method_Code__Control26Caption; "Sales Header".FieldCaption("Payment Method Code"))
                {
                }
                column(Sales_Header___Customer_Disc__Group__Control100Caption; "Sales Header".FieldCaption("Customer Disc. Group"))
                {
                }
                column(Sales_Header___Invoice_Disc__Code__Control102Caption; "Sales Header".FieldCaption("Invoice Disc. Code"))
                {
                }
                column(Sales_Header___Customer_Posting_Group__Control130Caption; "Sales Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Sales_Header___Posting_Date__Control131Caption; Sales_Header___Posting_Date__Control131CaptionLbl)
                {
                }
                column(Sales_Header___Document_Date__Control132Caption; Sales_Header___Document_Date__Control132CaptionLbl)
                {
                }
                column(Sales_Header___Prices_Including_VAT__Control196Caption; "Sales Header".FieldCaption("Prices Including VAT"))
                {
                }
                column(Sales_Header___Applies_to_Doc__Type_Caption; "Sales Header".FieldCaption("Applies-to Doc. Type"))
                {
                }
                column(Sales_Header___Applies_to_Doc__No__Caption; "Sales Header".FieldCaption("Applies-to Doc. No."))
                {
                }
                column(Sales_Header___Customer_Posting_Group__Control136Caption; "Sales Header".FieldCaption("Customer Posting Group"))
                {
                }
                column(Sales_Header___Posting_Date__Control137Caption; Sales_Header___Posting_Date__Control137CaptionLbl)
                {
                }
                column(Sales_Header___Document_Date__Control138Caption; Sales_Header___Document_Date__Control138CaptionLbl)
                {
                }
                column(Sales_Header___Prices_Including_VAT__Control198Caption; "Sales Header".FieldCaption("Prices Including VAT"))
                {
                }
                dataitem(DimensionLoop1; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(DimText; DimText)
                    {
                    }
                    column(DimensionLoop1_Number; Number)
                    {
                    }
                    column(DimText_Control162; DimText)
                    {
                    }
                    column(Header_DimensionsCaption; Header_DimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        DimText1Lbl: Label '%1 - %2', Comment = '%1%2', Locked = true;
                        DimText2Lbl: Label '%1; %2 - %3', Comment = '%1%2%3', Locked = true;
                    begin
                        if Number = 1 then begin
                            if not DimSetEntry1.FindSet() then
                                CurrReport.Break();
                        end else
                            if not Continue then
                                CurrReport.Break();

                        DimText := '';
                        Continue := false;
                        repeat
                            OldDimText := DimText;
                            if DimText = '' then
                                DimText := COPYSTR(StrSubstNo(DimText1Lbl, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code"), 1, MaxStrLen(DimText))
                            else
                                DimText :=
                                  COPYSTR(StrSubstNo(
                                    DimText2Lbl, DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code"), 1, MaxStrLen(DimText));
                            if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                            end;
                        until DimSetEntry1.Next() = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowDimValue then
                            CurrReport.Break();
                    end;
                }
                dataitem(HeaderErrorCounter; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(ErrorText_Number_; ErrorText[Number])
                    {
                    }
                    column(HeaderErrorCounter_Number; Number)
                    {
                    }
                    column(ErrorText_Number_Caption; ErrorText_Number_CaptionLbl)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        ErrorCounter := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, ErrorCounter);
                    end;
                }
                dataitem(CopyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                        column(Sales_Line_Document_Type; "Document Type")
                        {
                        }
                        column(Sales_Line_Document_No_; "Document No.")
                        {
                        }
                        column(Sales_Line_Line_No_; "Line No.")
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if Find('+') then
                                OrigMaxLineNo := "Line No.";
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(QtyToHandleCaption; QtyToHandleCaption)
                        {
                        }
                        column(Sales_Line__Type; "Sales Line".Type)
                        {
                        }
                        column(Sales_Line___No__; "Sales Line"."No.")
                        {
                        }
                        column(Sales_Line__Description; "Sales Line".Description)
                        {
                        }
                        column(Sales_Line__Quantity; "Sales Line".Quantity)
                        {
                        }
                        column(QtyToHandle; QtyToHandle)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Sales_Line___Qty__to_Invoice_; "Sales Line"."Qty. to Invoice")
                        {
                        }
                        column(Sales_Line___Unit_Price_; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(Sales_Line___Line_Discount___; "Sales Line"."Line Discount %")
                        {
                        }
                        column(Sales_Line___Line_Amount_; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line___Allow_Invoice_Disc__; "Sales Line"."Allow Invoice Disc.")
                        {
                        }
                        column(Sales_Line___VAT_Identifier_; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(SalesLineAllowInvoiceDiscFmt; Format("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(RoundLoop_RoundLoop_Number; Number)
                        {
                        }
                        column(Sales_Line___Inv__Discount_Amount_; "Sales Line"."Inv. Discount Amount")
                        {
                        }
                        column(TempSalesLine__Inv__Discount_Amount_; -TempSalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TempSalesLine__Line_Amount_; TempSalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SumLineAmount; SumLineAmount)
                        {
                        }
                        column(SumInvDiscountAmount; SumInvDiscountAmount)
                        {
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(TempSalesLine__Line_Amount_____Sales_Line___Inv__Discount_Amount_; TempSalesLine."Line Amount" - TempSalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATAmountLine_VATAmountText; TempVATAmountLine.VATAmountText())
                        {
                        }
                        column(TempSalesLine__Line_Amount____TempSalesLine__Inv__Discount_Amount_; TempSalesLine."Line Amount" - TempSalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TempSalesLine__Line_Amount____TempSalesLine__Inv__Discount_Amount____VATAmount; TempSalesLine."Line Amount" - TempSalesLine."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_Control191; TotalInclVATText)
                        {
                        }
                        column(VATAmountLine_VATAmountText_Control189; TempVATAmountLine.VATAmountText())
                        {
                        }
                        column(VATBaseAmount___VATAmount; VATBaseAmount + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount_Control188; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText_Control186; TotalExclVATText)
                        {
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line___No__Caption; "Sales Line".FieldCaption("No."))
                        {
                        }
                        column(Sales_Line__DescriptionCaption; "Sales Line".FieldCaption(Description))
                        {
                        }
                        column(Sales_Line___Qty__to_Invoice_Caption; "Sales Line".FieldCaption("Qty. to Invoice"))
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(Sales_Line___Line_Discount___Caption; Sales_Line___Line_Discount___CaptionLbl)
                        {
                        }
                        column(Sales_Line___Allow_Invoice_Disc__Caption; "Sales Line".FieldCaption("Allow Invoice Disc."))
                        {
                        }
                        column(Sales_Line___VAT_Identifier_Caption; "Sales Line".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(Sales_Line__TypeCaption; "Sales Line".FieldCaption(Type))
                        {
                        }
                        column(Sales_Line__QuantityCaption; "Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(TempSalesLine__Inv__Discount_Amount_Caption; TempSalesLine__Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(VATDiscountAmountCaption; VATDiscountAmountCaptionLbl)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_Control159; DimText)
                            {
                            }
                            column(DimensionLoop2_Number; Number)
                            {
                            }
                            column(DimText_Control161; DimText)
                            {
                            }
                            column(Line_DimensionsCaption; Line_DimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                DimText1Lbl: Label '%1 - %2', Comment = '%1%2', Locked = true;
                                DimText2Lbl: Label '%1; %2 - %3', Comment = '%1%2%3', Locked = true;
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                DimText := '';
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := COPYSTR(StrSubstNo(DimText1Lbl, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code"), 1, MAXSTRLEN(DimText))
                                    else
                                        DimText :=
                                          COPYSTR(StrSubstNo(
                                            DimText2Lbl, DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code"), 1, MaxStrLen(DimText));
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPostDataItem()
                            begin
                                SumLineAmount := SumLineAmount + TempSalesLine."Line Amount";
                                SumInvDiscountAmount := SumInvDiscountAmount + TempSalesLine."Inv. Discount Amount";
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowDimValue then
                                    CurrReport.Break();
                            end;
                        }
                        dataitem(LineErrorCounter; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
                            column(ErrorText_Number__Control97; ErrorText[Number])
                            {
                            }
                            column(LineErrorCounter_Number; Number)
                            {
                            }
                            column(ErrorText_Number__Control97Caption; ErrorText_Number__Control97CaptionLbl)
                            {
                            }

                            trigger OnPostDataItem()
                            begin
                                ErrorCounter := 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange(Number, 1, ErrorCounter);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            GenPostingSetup: Record "General Posting Setup";
                            TempDimSetEntry2: Record "Dimension Set Entry" temporary;
                            MICAForcedDim: Codeunit "MICA ForcedDimension";
                            TableID: array[10] of Integer;
                            No: array[10] of Code[20];
                            Fraction: Decimal;
                        begin
                            if Number = 1 then
                                TempSalesLine.Find('-')
                            else
                                TempSalesLine.Next();
                            "Sales Line" := TempSalesLine;

                            with "Sales Line" do begin
                                if not "Sales Header"."Prices Including VAT" and
                                   ("VAT Calculation Type" = "VAT Calculation Type"::"Full VAT")
                                then
                                    TempSalesLine."Line Amount" := 0;

                                DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                                DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
                                //>> MIC-FIN-002
                                IF GenPostingSetup.GET("Sales Line"."Gen. Bus. Posting Group", "Sales Line"."Gen. Prod. Posting Group") THEN begin
                                    MICAForcedDim.InitTempDimSetEntry(TempDimSetEntry2, "Dimension Set ID", GenPostingSetup."Sales Account");

                                    DimSetEntry2.RESEt();
                                    DimSetEntry2.SetRange("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry2));
                                END;
                                //<< MIC-FIN-002

                                if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]
                                then begin
                                    if "Document Type" = "Document Type"::"Credit Memo" then begin
                                        if ("Return Qty. to Receive" <> Quantity) and ("Return Receipt No." = '') then
                                            AddError(COPYSTR(StrSubstNo(Text015_Txt, FieldCaption("Return Qty. to Receive"), Quantity), 1, 250));
                                        if "Qty. to Invoice" <> Quantity then
                                            AddError(COPYSTR(StrSubstNo(Text015_Txt, FieldCaption("Qty. to Invoice"), Quantity), 1, 250));
                                    end;
                                    if "Qty. to Ship" <> 0 then
                                        AddError(COPYSTR(StrSubstNo(Text043_Txt, FieldCaption("Qty. to Ship")), 1, 250));
                                end else begin
                                    if "Document Type" = "Document Type"::Invoice then begin
                                        if ("Qty. to Ship" <> Quantity) and ("Shipment No." = '') then
                                            AddError(COPYSTR(StrSubstNo(Text015_Txt, FieldCaption("Qty. to Ship"), Quantity), 1, 250));
                                        if "Qty. to Invoice" <> Quantity then
                                            AddError(COPYSTR(StrSubstNo(Text015_Txt, FieldCaption("Qty. to Invoice"), Quantity), 1, 250));
                                    end;
                                    if "Return Qty. to Receive" <> 0 then
                                        AddError(COPYSTR(StrSubstNo(Text043_Txt, FieldCaption("Return Qty. to Receive")), 1, 250));
                                end;

                                if not "Sales Header".Ship then
                                    "Qty. to Ship" := 0;
                                if not "Sales Header".Receive then
                                    "Return Qty. to Receive" := 0;

                                if ("Document Type" = "Document Type"::Invoice) and ("Shipment No." <> '') then begin
                                    "Quantity Shipped" := Quantity;
                                    "Qty. to Ship" := 0;
                                end;

                                if ("Document Type" = "Document Type"::"Credit Memo") and ("Return Receipt No." <> '') then begin
                                    "Return Qty. Received" := Quantity;
                                    "Return Qty. to Receive" := 0;
                                end;

                                if "Sales Header".Invoice then begin
                                    if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
                                        MaxQtyToBeInvoiced := "Return Qty. to Receive" + "Return Qty. Received" - "Quantity Invoiced"
                                    else
                                        MaxQtyToBeInvoiced := "Qty. to Ship" + "Quantity Shipped" - "Quantity Invoiced";
                                    if Abs("Qty. to Invoice") > Abs(MaxQtyToBeInvoiced) then
                                        "Qty. to Invoice" := MaxQtyToBeInvoiced;
                                end else
                                    "Qty. to Invoice" := 0;

                                if "Gen. Prod. Posting Group" <> '' then begin
                                    if ("Sales Header"."Document Type" in
                                        ["Sales Header"."Document Type"::"Return Order",
                                         "Sales Header"."Document Type"::"Credit Memo"]) and
                                       ("Sales Header"."Applies-to Doc. Type" = "Sales Header"."Applies-to Doc. Type"::Invoice) and
                                       ("Sales Header"."Applies-to Doc. No." <> '')
                                    then begin
                                        CustLedgEntry.SetCurrentKey("Document No.");
                                        CustLedgEntry.SetRange("Customer No.", "Sales Header"."Bill-to Customer No.");
                                        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
                                        CustLedgEntry.SetRange("Document No.", "Sales Header"."Applies-to Doc. No.");
                                        if (not CustLedgEntry.FindLast()) and (not ApplNoError) then begin
                                            ApplNoError := true;
                                            AddError(
                                              COPYSTR(
                                                StrSubstNo(
                                                  Text016_Txt,
                                                  "Sales Header".FieldCaption("Applies-to Doc. No."), "Sales Header"."Applies-to Doc. No."), 1, 250));
                                        end;
                                    end;

                                    if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                                        AddError(
                                          COPYSTR(
                                            StrSubstNo(
                                              Text017_Txt,
                                              VATPostingSetup.TableCaption(), "VAT Bus. Posting Group", "VAT Prod. Posting Group"), 1, 250));
                                    if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT" then
                                        if ("Sales Header"."VAT Registration No." = '') and (not VATNoError) then begin
                                            VATNoError := true;
                                            AddError(
                                              CopyStr(
                                                StrSubstNo(
                                                  Text035_Txt, "Sales Header".FieldCaption("VAT Registration No.")), 1, 250));
                                        end;
                                end;

                                if Quantity <> 0 then begin
                                    if "No." = '' then
                                        AddError(Copystr(StrSubstNo(Text019_Txt, Type, FieldCaption("No.")), 1, 250));
                                    if Type.AsInteger() = 0 then
                                        AddError(Copystr(StrSubstNo(Text006_Txt, FieldCaption(Type)), 1, 250));
                                end else
                                    if Amount <> 0 then
                                        AddError(
                                          Copystr(StrSubstNo(Text020_Txt, FieldCaption(Amount), FieldCaption(Quantity)), 1, 250));

                                if "Drop Shipment" then begin
                                    if Type <> Type::Item then
                                        AddError(Copystr(Text021_Txt, 1, strlen(Text021_Txt)));
                                    if ("Qty. to Ship" <> 0) and ("Purch. Order Line No." = 0) then begin
                                        AddError(Copystr(StrSubstNo(Text022_Txt, "Line No."), 1, 250));
                                        AddError(Copystr(Text023_Txt, 1, strlen(Text023_Txt)));
                                    end;
                                end;

                                SalesLine := "Sales Line";
                                if not ("Document Type" in
                                        ["Document Type"::"Return Order", "Document Type"::"Credit Memo"])
                                then begin
                                    SalesLine."Qty. to Ship" := -SalesLine."Qty. to Ship";
                                    SalesLine."Qty. to Invoice" := -SalesLine."Qty. to Invoice";
                                end;

                                RemQtyToBeInvoiced := SalesLine."Qty. to Invoice";

                                case "Document Type" of
                                    "Document Type"::"Return Order", "Document Type"::"Credit Memo":
                                        CheckRcptLines("Sales Line");
                                    "Document Type"::Order, "Document Type"::Invoice:
                                        CheckShptLines("Sales Line");
                                end;

                                if (Type.AsInteger() >= Type::"G/L Account".AsInteger()) and ("Qty. to Invoice" <> 0) then begin
                                    if not GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") then
                                        AddError(
                                          Copystr(
                                            StrSubstNo(
                                              Text017_Txt,
                                              GenPostingSetup.TableCaption(), "Gen. Bus. Posting Group", "Gen. Prod. Posting Group"), 1, 250));
                                    if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                                        AddError(
                                          Copystr(
                                            StrSubstNo(
                                              Text017_Txt,
                                              VATPostingSetup.TableCaption(), "VAT Bus. Posting Group", "VAT Prod. Posting Group"), 1, 250));
                                end;

                                if "Prepayment %" > 0 then
                                    if not "Prepayment Line" and (Quantity > 0) then begin
                                        Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;
                                        if Fraction > 1 then
                                            Fraction := 1;

                                        case true of
                                            (Fraction * "Line Amount" < "Prepmt Amt to Deduct") and
                                          ("Prepmt Amt to Deduct" <> 0):
                                                AddError(
                                                  StrSubstNo(
                                                    Text053_Txt,
                                                    FieldCaption("Prepmt Amt to Deduct"),
                                                    Round(Fraction * "Line Amount", GLSetup."Amount Rounding Precision")));
                                            (1 - Fraction) * "Line Amount" <
                                          "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - "Prepmt Amt to Deduct":
                                                AddError(
                                                  StrSubstNo(
                                                    Text054_Txt,
                                                    FieldCaption("Prepmt Amt to Deduct"),
                                                    Round(
                                                      "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
                                                      GLSetup."Amount Rounding Precision")));
                                        end;
                                    end;
                                if not "Prepayment Line" and ("Prepmt. Line Amount" > 0) then
                                    if "Prepmt. Line Amount" > "Prepmt. Amt. Inv." then
                                        AddError(Copystr(StrSubstNo(Text046_Txt, FieldCaption("Prepmt. Line Amount")), 1, 250));

                                CheckType("Sales Line");

                                if "Line No." > OrigMaxLineNo then begin
                                    AddDimToTempLine("Sales Line");
                                    if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                                        AddError(DimMgt.GetDimCombErr());
                                    if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                                        AddError(DimMgt.GetDimValuePostingErr());
                                end else begin
                                    if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                                        AddError(DimMgt.GetDimCombErr());

                                    TableID[1] := DimMgt.TypeToTableID3(Type.AsInteger());
                                    No[1] := "No.";
                                    TableID[2] := DATABASE::Job;
                                    No[2] := "Job No.";
                                    if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                                        AddError(DimMgt.GetDimValuePostingErr());
                                end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATNoError := false;
                            ApplNoError := false;

                            MoreLines := TempSalesLine.Find('+');
                            while MoreLines and (TempSalesLine.Description = '') and (TempSalesLine."Description 2" = '') and
                                  (TempSalesLine."No." = '') and (TempSalesLine.Quantity = 0) and
                                  (TempSalesLine.Amount = 0)
                            do
                                MoreLines := TempSalesLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            TempSalesLine.SetRange("Line No.", 0, TempSalesLine."Line No.");
                            SetRange(Number, 1, TempSalesLine.Count());

                            SumLineAmount := 0;
                            SumInvDiscountAmount := 0;
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmountLine__VAT_Amount_; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base_; TempVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount_; TempVATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount_; TempVATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount_; TempVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control150; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control151; TempVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT___; TempVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLine__VAT_Identifier_; TempVATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control173; TempVATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control171; TempVATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control169; TempVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control175; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control176; TempVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control177; TempVATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control178; TempVATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control179; TempVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control181; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control182; TempVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control183; TempVATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control184; TempVATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control185; TempVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATCounter_Number; Number)
                        {
                        }
                        column(VATAmountLine__VAT_Amount__Control150Caption; VATAmountLine__VAT_Amount__Control150CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Base__Control151Caption; VATAmountLine__VAT_Base__Control151CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT___Caption; VATAmountLine__VAT___CaptionLbl)
                        {
                        }
                        column(VAT_Amount_SpecificationCaption; VAT_Amount_SpecificationCaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier_Caption; VATAmountLine__VAT_Identifier_CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Invoice_Discount_Amount__Control173Caption; VATAmountLine__Invoice_Discount_Amount__Control173CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Inv__Disc__Base_Amount__Control171Caption; VATAmountLine__Inv__Disc__Base_Amount__Control171CaptionLbl)
                        {
                        }
                        column(VATAmountLine__Line_Amount__Control169Caption; VATAmountLine__Line_Amount__Control169CaptionLbl)
                        {
                        }
                        column(ContinuedCaption; ContinuedCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control155; ContinuedCaption_Control155Lbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, TempVATAmountLine.Count());
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY_Control88; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control165; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT____Control167; TempVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLine__VAT_Identifier__Control241; TempVATAmountLine."VAT Identifier")
                        {
                        }
                        column(VALVATAmountLCY_Control242; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control243; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY_Control245; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY_Control246; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATCounterLCY_Number; Number)
                        {
                        }
                        column(VALVATAmountLCY_Control88Caption; VALVATAmountLCY_Control88CaptionLbl)
                        {
                        }
                        column(VALVATBaseLCY_Control165Caption; VALVATBaseLCY_Control165CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT____Control167Caption; VATAmountLine__VAT____Control167CaptionLbl)
                        {
                        }
                        column(VATAmountLine__VAT_Identifier__Control241Caption; VATAmountLine__VAT_Identifier__Control241CaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control87; ContinuedCaption_Control87Lbl)
                        {
                        }
                        column(ContinuedCaption_Control244; ContinuedCaption_Control244Lbl)
                        {
                        }
                        column(TotalCaption_Control247; TotalCaption_Control247Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              TempVATAmountLine.GetBaseLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY :=
                              TempVATAmountLine.GetAmountLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        var
                            CurrExchRate: Record "Currency Exchange Rate";
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            SetRange(Number, 1, TempVATAmountLine.Count());

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text050_Txt + Text051_Txt
                            else
                                VALSpecLCYHeader := Text050_Txt + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            CurrExchRate."Relational Exch. Rate Amount" := CurrExchRate."Exchange Rate Amount" / "Sales Header"."Currency Factor";
                            VALExchRate := CopyStr(StrSubstNo(Text052_Txt, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount"), 1, maxstrlen(VALExchRate));
                        end;
                    }
                    dataitem("Item Charge Assignment (Sales)"; "Item Charge Assignment (Sales)")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");
                        DataItemLinkReference = "Sales Line";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Document Line No.", "Line No.");
                        column(Item_Charge_Assignment__Sales___Qty__to_Assign_; "Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Amount_to_Assign_; "Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Item_Charge_No__; "Item Charge No.")
                        {
                        }
                        column(SalesLine2_Description; SalesLine2.Description)
                        {
                        }
                        column(SalesLine2_Quantity; SalesLine2.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Item_Charge_Assignment__Sales___Item_No__; "Item No.")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Qty__to_Assign__Control209; "Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Unit_Cost_; "Unit Cost")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Amount_to_Assign__Control216; "Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Qty__to_Assign__Control221; "Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Amount_to_Assign__Control222; "Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Qty__to_Assign__Control224; "Qty. to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Amount_to_Assign__Control225; "Amount to Assign")
                        {
                        }
                        column(Item_Charge_Assignment__Sales__Document_Type; "Document Type")
                        {
                        }
                        column(Item_Charge_Assignment__Sales__Document_No_; "Document No.")
                        {
                        }
                        column(Item_Charge_Assignment__Sales__Document_Line_No_; "Document Line No.")
                        {
                        }
                        column(Item_Charge_Assignment__Sales__Line_No_; "Line No.")
                        {
                        }
                        column(Item_Charge_SpecificationCaption; Item_Charge_SpecificationCaptionLbl)
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Item_Charge_No__Caption; FieldCaption("Item Charge No."))
                        {
                        }
                        column(SalesLine2_DescriptionCaption; SalesLine2_DescriptionCaptionLbl)
                        {
                        }
                        column(SalesLine2_QuantityCaption; SalesLine2_QuantityCaptionLbl)
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Item_No__Caption; FieldCaption("Item No."))
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Qty__to_Assign__Control209Caption; FieldCaption("Qty. to Assign"))
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Unit_Cost_Caption; FieldCaption("Unit Cost"))
                        {
                        }
                        column(Item_Charge_Assignment__Sales___Amount_to_Assign__Control216Caption; FieldCaption("Amount to Assign"))
                        {
                        }
                        column(ContinuedCaption_Control210; ContinuedCaption_Control210Lbl)
                        {
                        }
                        column(TotalCaption_Control220; TotalCaption_Control220Lbl)
                        {
                        }
                        column(ContinuedCaption_Control223; ContinuedCaption_Control223Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if SalesLine2.Get("Document Type", "Document No.", "Document Line No.") then;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowCostAssignment then
                                CurrReport.Break();
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(TempSalesLine);
                        Clear(SalesPost);
                        TempVATAmountLine.DeleteAll();
                        TempSalesLine.DeleteAll();
                        SalesPost.GetSalesLines("Sales Header", TempSalesLine, 1);
                        OnAfterSalesPostGetSalesLines("Sales Header", TempSalesLine);
                        TempSalesLine.CalcVATAmountLines(0, "Sales Header", TempSalesLine, TempVATAmountLine);
                        TempSalesLine.UpdateVATOnLines(0, "Sales Header", TempSalesLine, TempVATAmountLine);
                        VATAmount := TempVATAmountLine.GetTotalVATAmount();
                        VATBaseAmount := TempVATAmountLine.GetTotalVATBase();
                        VATDiscountAmount :=
                          TempVATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                FormatAddr.SalesHeaderSellTo(SellToAddr, "Sales Header");
                FormatAddr.SalesHeaderBillTo(BillToAddr, "Sales Header");
                FormatAddr.SalesHeaderShipTo(ShipToAddr, ShipToAddr, "Sales Header");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := Copystr(StrSubstNo(Text004_Txt, GLSetup."LCY Code"), 1, MaxStrLen(TotalText));
                    TotalExclVATText := Copystr(StrSubstNo(Text033_Txt, GLSetup."LCY Code"), 1, MaxStrLen(TotalExclVATText));
                    TotalInclVATText := Copystr(StrSubstNo(Text005_Txt, GLSetup."LCY Code"), 1, MaxStrLen(TotalInclVATText));
                end else begin
                    TotalText := Copystr(StrSubstNo(Text004_Txt, "Currency Code"), 1, MaxStrLen(TotalText));
                    TotalExclVATText := Copystr(StrSubstNo(Text033_Txt, "Currency Code"), 1, MaxStrLen(TotalExclVATText));
                    TotalInclVATText := Copystr(StrSubstNo(Text005_Txt, "Currency Code"), 1, MaxStrLen(TotalInclVATText));
                end;

                Invoice := InvOnNextPostReqValue;
                Ship := ShipReceiveOnNextPostReqValue;
                Receive := ShipReceiveOnNextPostReqValue;

                VerifySellToCust("Sales Header");
                VerifyBillToCust("Sales Header");

                SalesSetup.Get();

                VerifyPostingDate("Sales Header");

                if "Document Date" <> 0D then
                    if "Document Date" <> NormalDate("Document Date") then
                        AddError(Copystr(StrSubstNo(Text009_Txt, FieldCaption("Document Date")), 1, 250));

                case "Document Type" of
                    "Document Type"::Order:
                        Receive := false;
                    "Document Type"::Invoice:
                        begin
                            Ship := true;
                            Invoice := true;
                            Receive := false;
                        end;
                    "Document Type"::"Return Order":
                        Ship := false;
                    "Document Type"::"Credit Memo":
                        begin
                            Ship := false;
                            Invoice := true;
                            Receive := true;
                        end;
                end;

                if not (Ship or Invoice or Receive) then
                    AddError(
                      Copystr(
                        StrSubstNo(
                          Text034_Txt,
                          FieldCaption(Ship), FieldCaption(Invoice), FieldCaption(Receive)), 1, 250));

                if Invoice then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter(Quantity, '<>0');
                    if "Document Type" in ["Document Type"::Order, "Document Type"::"Return Order"] then
                        SalesLine.SetFilter("Qty. to Invoice", '<>0');
                    Invoice := SalesLine.Find('-');
                    if Invoice and (not Ship) and ("Document Type" = "Document Type"::Order) then begin
                        Invoice := false;
                        repeat
                            Invoice := (SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced") <> 0;
                        until Invoice or (SalesLine.Next() = 0);
                    end else
                        if Invoice and (not Receive) and ("Document Type" = "Document Type"::"Return Order") then begin
                            Invoice := false;
                            repeat
                                Invoice := (SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced") <> 0;
                            until Invoice or (SalesLine.Next() = 0);
                        end;
                end;

                if Ship then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter(Quantity, '<>0');
                    if "Document Type" = "Document Type"::Order then
                        SalesLine.SetFilter("Qty. to Ship", '<>0');
                    SalesLine.SetRange("Shipment No.", '');
                    Ship := SalesLine.Find('-');
                end;
                if Receive then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter(Quantity, '<>0');
                    if "Document Type" = "Document Type"::"Return Order" then
                        SalesLine.SetFilter("Return Qty. to Receive", '<>0');
                    SalesLine.SetRange("Return Receipt No.", '');
                    Receive := SalesLine.Find('-');
                end;

                if not (Ship or Invoice or Receive) then
                    AddError(Copystr(Text012_Txt, 1, StrLen(Text012_Txt)));

                if Invoice then
                    if not ("Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) then
                        if "Due Date" = 0D then
                            AddError(Copystr(StrSubstNo(Text006_Txt, FieldCaption("Due Date")), 1, 250));

                if Ship and ("Shipping No." = '') then // Order,Invoice
                    if ("Document Type" = "Document Type"::Order) or
                       (("Document Type" = "Document Type"::Invoice) and SalesSetup."Shipment on Invoice")
                    then
                        if "Shipping No. Series" = '' then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text006_Txt,
                                  FieldCaption("Shipping No. Series")), 1, 250));

                if Receive and ("Return Receipt No." = '') then // Return Order,Credit Memo
                    if ("Document Type" = "Document Type"::"Return Order") or
                       (("Document Type" = "Document Type"::"Credit Memo") and SalesSetup."Return Receipt on Credit Memo")
                    then
                        if "Return Receipt No. Series" = '' then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text006_Txt,
                                  FieldCaption("Return Receipt No. Series")), 1, 250));

                if Invoice and ("Posting No." = '') then
                    if "Document Type" in ["Document Type"::Order, "Document Type"::"Return Order"] then
                        if "Posting No. Series" = '' then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text006_Txt,
                                  FieldCaption("Posting No. Series")), 1, 250));

                SalesLine.Reset();
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetFilter("Purch. Order Line No.", '<>0');
                if Ship then
                    if SalesLine.Find('-') then
                        repeat
                            if PurchOrderHeader."No." <> SalesLine."Purchase Order No." then begin
                                PurchOrderHeader.Get(PurchOrderHeader."Document Type"::Order, SalesLine."Purchase Order No.");
                                if PurchOrderHeader."Pay-to Vendor No." = '' then
                                    AddError(
                                      Copystr(
                                        StrSubstNo(
                                          Text013_Txt,
                                          PurchOrderHeader.FieldCaption("Pay-to Vendor No.")), 1, 250));
                                if PurchOrderHeader."Receiving No." = '' then
                                    if PurchOrderHeader."Receiving No. Series" = '' then
                                        AddError(
                                          Copystr(
                                            StrSubstNo(
                                              Text013_Txt,
                                              PurchOrderHeader.FieldCaption("Receiving No. Series")), 1, 250));
                            end;
                        until SalesLine.Next() = 0;

                if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice] then
                    if SalesSetup."Ext. Doc. No. Mandatory" and ("External Document No." = '') then
                        AddError(Copystr(StrSubstNo(Text006_Txt, FieldCaption("External Document No.")), 1, 250));

                if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                    AddError(DimMgt.GetDimCombErr());

                TableID[1] := DATABASE::Customer;
                No[1] := "Bill-to Customer No.";
                TableID[3] := DATABASE::"Salesperson/Purchaser";
                No[3] := "Salesperson Code";
                TableID[4] := DATABASE::Campaign;
                No[4] := "Campaign No.";
                TableID[5] := DATABASE::"Responsibility Center";
                No[5] := "Responsibility Center";
                if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                    AddError(DimMgt.GetDimValuePostingErr());
            end;

            trigger OnPreDataItem()
            begin
                SalesHeader.Copy("Sales Header");
                SalesHeader.FilterGroup := 2;
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                if SalesHeader.FindFirst() then begin
                    case true of
                        ShipReceiveOnNextPostReqValue and InvOnNextPostReqValue:
                            ShipInvText := Text000_Txt;
                        ShipReceiveOnNextPostReqValue:
                            ShipInvText := Text001_Txt;
                        InvOnNextPostReqValue:
                            ShipInvText := Text002_Txt;
                    end;
                    ShipInvText := Copystr(StrSubstNo(Text003_Txt, ShipInvText), 1, maxstrlen(ShipInvText));
                end;
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Return Order");
                if SalesHeader.FindFirst() then begin
                    case true of
                        ShipReceiveOnNextPostReqValue and InvOnNextPostReqValue:
                            ReceiveInvText := Text018_Txt;
                        ShipReceiveOnNextPostReqValue:
                            ReceiveInvText := Text031_Txt;
                        InvOnNextPostReqValue:
                            ReceiveInvText := Text002_Txt;
                    end;
                    ReceiveInvText := Copystr(StrSubstNo(Text032_Txt, ReceiveInvText), 1, maxstrlen(ReceiveInvText));
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Order/Return Order Posting")
                    {
                        Caption = 'Order/Return Order Posting';
                        field(ShipReceiveOnNextPostReq; ShipReceiveOnNextPostReqValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ship/Receive';
                            ToolTip = 'Specifies whether you want to post the documents that are being tested as shipped/received, as invoiced or as shipped/received and invoiced. Select the check box next to each option that you want to select.';

                            trigger OnValidate()
                            begin
                                if not ShipReceiveOnNextPostReqValue then
                                    InvOnNextPostReqValue := true;
                            end;
                        }
                        field(InvOnNextPostReq; InvOnNextPostReqValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Invoice';
                            ToolTip = 'Specifies invoices to test before you post them, to check whether there are any posting dates missing, etc.';

                            trigger OnValidate()
                            begin
                                if not InvOnNextPostReqValue then
                                    ShipReceiveOnNextPostReqValue := true;
                            end;
                        }
                    }
                    field(ShowDim; ShowDimValue)
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Show Dimensions';
                        ToolTip = 'Specifies if you want dimensions information for the journal lines that you want to include in the report.';
                    }
                    field(ShowItemChargeAssignment; "ShowCostAssignment")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Item Charge Assgnt.';
                        ToolTip = 'Specifies if you want the test report to show the item charges that have been assigned to the sales document.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if not ShipReceiveOnNextPostReqValue and not InvOnNextPostReqValue then begin
                ShipReceiveOnNextPostReqValue := true;
                InvOnNextPostReqValue := true;
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
    end;

    trigger OnPreReport()
    begin
        SalesHeaderFilter := "Sales Header".GetFilters();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Res: Record Resource;
        SaleShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        PurchOrderHeader: Record "Purchase Header";
        //GenPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        FA: Record "Fixed Asset";
        FADeprBook: Record "FA Depreciation Book";
        InvtPeriod: Record "Inventory Period";
        FormatAddr: Codeunit "Format Address";
        DimMgt: Codeunit DimensionManagement;
        SalesPost: Codeunit "Sales-Post";
        Text000_Txt: Label 'Ship and Invoice';
        Text001_Txt: Label 'Ship';
        Text002_Txt: Label 'Invoice';
        Text003_Txt: Label 'Order Posting: %1';
        Text004_Txt: Label 'Total %1';
        Text005_Txt: Label 'Total %1 Incl. VAT';
        Text006_Txt: Label '%1 must be specified.';
        Text007_Txt: Label '%1 must be %2 for %3 %4.';
        Text008_Txt: Label '%1 %2 does not exist.';
        Text009_Txt: Label '%1 must not be a closing date.';
        Text010_Txt: Label '%1 is not within your allowed range of posting dates.';
        Text012_Txt: Label 'There is nothing to post.';
        Text013_Txt: Label '%1 must be entered on the purchase order header.';
        Text014_Txt: Label 'Sales Document: %1';
        Text015_Txt: Label '%1 must be %2.';
        Text016_Txt: Label '%1 %2 does not exist on customer entries.';
        Text017_Txt: Label '%1 %2 %3 does not exist.';
        Text018_Txt: Label 'Receive and Credit Memo';
        Text019_Txt: Label '%1 %2 must be specified.';
        Text020_Txt: Label '%1 must be 0 when %2 is 0.';
        Text021_Txt: Label 'Drop shipments are only possible for items.';
        Text022_Txt: Label 'You cannot ship sales order line %1 because the line is marked';
        Text023_Txt: Label 'as a drop shipment and is not yet associated with a purchase order.';
        Text024_Txt: Label 'The %1 on the shipment is not the same as the %1 on the sales header.';
        Text025_Txt: Label 'Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.';
        Text026_Txt: Label 'Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.';
        Text027_Txt: Label '%1 must have the same sign as the shipments.';
        Text031_Txt: Label 'Receive';
        Text032_Txt: Label 'Return Order Posting: %1';
        Text033_Txt: Label 'Total %1 Excl. VAT';
        Text034_Txt: Label 'Enter "Yes" in %1 and/or %2 and/or %3.';
        Text035_Txt: Label 'You must enter the customer''s %1.';
        Text036_Txt: Label 'The quantity you are attempting to invoice is greater than the quantity in shipment %1.';
        Text037_Txt: Label 'The quantity you are attempting to invoice is greater than the quantity in return receipt %1.';
        Text038_Txt: Label 'The %1 on the return receipt is not the same as the %1 on the sales header.';
        Text039_Txt: Label '%1 must have the same sign as the return receipt.';
        Text043_Txt: Label '%1 must be zero.';
        Text045_Txt: Label '%1 must not be %2 for %3 %4.';
        Text046_Txt: Label '%1 must be completely preinvoiced before you can ship or invoice the line.';
        Text050_Txt: Label 'VAT Amount Specification in ';
        Text051_Txt: Label 'Local Currency';
        Text052_Txt: Label 'Exchange rate: %1/%2';
        Text053_Txt: Label '%1 can at most be %2.';
        Text054_Txt: Label '%1 must be at least %2.';
        Sales_Document___TestCaptionLbl: Label 'Sales Document - Test';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Ship_toCaptionLbl: Label 'Ship-to';
        Sell_toCaptionLbl: Label 'Sell-to';
        Bill_toCaptionLbl: Label 'Bill-to';
        Sales_Header___Posting_Date_CaptionLbl: Label 'Posting Date';
        Sales_Header___Document_Date_CaptionLbl: Label 'Document Date';
        Sales_Header___Due_Date_CaptionLbl: Label 'Due Date';
        Sales_Header___Pmt__Discount_Date_CaptionLbl: Label 'Pmt. Discount Date';
        Sales_Header___Posting_Date__Control105CaptionLbl: Label 'Posting Date';
        Sales_Header___Document_Date__Control106CaptionLbl: Label 'Document Date';
        Sales_Header___Order_Date_CaptionLbl: Label 'Order Date';
        Sales_Header___Shipment_Date_CaptionLbl: Label 'Shipment Date';
        Sales_Header___Due_Date__Control19CaptionLbl: Label 'Due Date';
        Sales_Header___Pmt__Discount_Date__Control22CaptionLbl: Label 'Pmt. Discount Date';
        Sales_Header___Posting_Date__Control131CaptionLbl: Label 'Posting Date';
        Sales_Header___Document_Date__Control132CaptionLbl: Label 'Document Date';
        Sales_Header___Posting_Date__Control137CaptionLbl: Label 'Posting Date';
        Sales_Header___Document_Date__Control138CaptionLbl: Label 'Document Date';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        ErrorText_Number_CaptionLbl: Label 'Warning!';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Sales_Line___Line_Discount___CaptionLbl: Label 'Line Disc. %';
        AmountCaptionLbl: Label 'Amount';
        TempSalesLine__Inv__Discount_Amount_CaptionLbl: Label 'Inv. Discount Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        VATDiscountAmountCaptionLbl: Label 'Payment Discount on VAT';
        Line_DimensionsCaptionLbl: Label 'Line Dimensions';
        ErrorText_Number__Control97CaptionLbl: Label 'Warning!';
        VATAmountLine__VAT_Amount__Control150CaptionLbl: Label 'VAT Amount';
        VATAmountLine__VAT_Base__Control151CaptionLbl: Label 'VAT Base';
        VATAmountLine__VAT___CaptionLbl: Label 'VAT %';
        VAT_Amount_SpecificationCaptionLbl: Label 'VAT Amount Specification';
        VATAmountLine__VAT_Identifier_CaptionLbl: Label 'VAT Identifier';
        VATAmountLine__Invoice_Discount_Amount__Control173CaptionLbl: Label 'Invoice Discount Amount';
        VATAmountLine__Inv__Disc__Base_Amount__Control171CaptionLbl: Label 'Inv. Disc. Base Amount';
        VATAmountLine__Line_Amount__Control169CaptionLbl: Label 'Line Amount';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption_Control155Lbl: Label 'Continued';
        TotalCaptionLbl: Label 'Total';
        VALVATAmountLCY_Control88CaptionLbl: Label 'VAT Amount';
        VALVATBaseLCY_Control165CaptionLbl: Label 'VAT Base';
        VATAmountLine__VAT____Control167CaptionLbl: Label 'VAT %';
        VATAmountLine__VAT_Identifier__Control241CaptionLbl: Label 'VAT Identifier';
        ContinuedCaption_Control87Lbl: Label 'Continued';
        ContinuedCaption_Control244Lbl: Label 'Continued';
        TotalCaption_Control247Lbl: Label 'Total';
        Item_Charge_SpecificationCaptionLbl: Label 'Item Charge Specification';
        SalesLine2_DescriptionCaptionLbl: Label 'Description';
        SalesLine2_QuantityCaptionLbl: Label 'Assignable Qty';
        ContinuedCaption_Control210Lbl: Label 'Continued';
        TotalCaption_Control220Lbl: Label 'Total';
        ContinuedCaption_Control223Lbl: Label 'Continued';
        SalesHeaderFilter: Text;
        SellToAddr: array[8] of Text[50];
        BillToAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        ShipInvText: Text[50];
        ReceiveInvText: Text[50];
        DimText: Text[120];
        OldDimText: Text[120];
        ErrorText: array[99] of Text[250];
        QtyToHandleCaption: Text[30];
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        MaxQtyToBeInvoiced: Decimal;
        RemQtyToBeInvoiced: Decimal;
        QtyToBeInvoiced: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        QtyToHandle: Decimal;
        ErrorCounter: Integer;
        OrigMaxLineNo: Integer;
        InvOnNextPostReqValue: Boolean;
        ShipReceiveOnNextPostReqValue: Boolean;
        VATNoError: Boolean;
        ApplNoError: Boolean;
        ShowDimValue: Boolean;
        Continue: Boolean;
        ShowCostAssignment: Boolean;
        MoreLines: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        SumLineAmount: Decimal;
        SumInvDiscountAmount: Decimal;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    local procedure CheckShptLines(SalesLine2: Record "Sales Line")
    var
        TempPostedDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        with SalesLine2 do begin
            if Abs(RemQtyToBeInvoiced) > Abs("Qty. to Ship") then begin
                SaleShptLine.Reset();
                case "Document Type" of
                    "Document Type"::Order:
                        begin
                            SaleShptLine.SetCurrentKey("Order No.", "Order Line No.");
                            SaleShptLine.SetRange("Order No.", "Document No.");
                            SaleShptLine.SetRange("Order Line No.", "Line No.");
                        end;
                    "Document Type"::Invoice:
                        begin
                            SaleShptLine.SetRange("Document No.", "Shipment No.");
                            SaleShptLine.SetRange("Line No.", "Shipment Line No.");
                        end;
                end;

                SaleShptLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');
                if SaleShptLine.Find('-') then
                    repeat
                        DimMgt.GetDimensionSet(TempPostedDimSetEntry, SaleShptLine."Dimension Set ID");
                        if not DimMgt.CheckDimIDConsistency(
                             TempDimSetEntry, TempPostedDimSetEntry, DATABASE::"Sales Line", DATABASE::"Sales Shipment Line")
                        then
                            AddError(DimMgt.GetDocDimConsistencyErr());
                        if SaleShptLine."Sell-to Customer No." <> "Sell-to Customer No." then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption("Sell-to Customer No.")), 1, 250));
                        if SaleShptLine.Type <> Type then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption(Type)), 1, 250));
                        if SaleShptLine."No." <> "No." then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption("No.")), 1, 250));
                        if SaleShptLine."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption("Gen. Bus. Posting Group")), 1, 250));
                        if SaleShptLine."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption("Gen. Prod. Posting Group")), 1, 250));
                        if SaleShptLine."Location Code" <> "Location Code" then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption("Location Code")), 1, 250));
                        if SaleShptLine."Job No." <> "Job No." then
                            AddError(
                              copystr(
                                StrSubstNo(
                                  Text024_Txt,
                                  FieldCaption("Job No.")), 1, 250));

                        if -SalesLine."Qty. to Invoice" * SaleShptLine.Quantity < 0 then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text027_Txt, FieldCaption("Qty. to Invoice")), 1, 250));

                        QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Qty. to Ship";
                        if Abs(QtyToBeInvoiced) > Abs(SaleShptLine.Quantity - SaleShptLine."Quantity Invoiced") then
                            QtyToBeInvoiced := -(SaleShptLine.Quantity - SaleShptLine."Quantity Invoiced");
                        RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                        SaleShptLine."Quantity Invoiced" := SaleShptLine."Quantity Invoiced" - QtyToBeInvoiced;
                        SaleShptLine."Qty. Shipped Not Invoiced" :=
                          SaleShptLine.Quantity - SaleShptLine."Quantity Invoiced"
                    until (SaleShptLine.Next() = 0) or (Abs(RemQtyToBeInvoiced) <= Abs("Qty. to Ship"))
                else
                    AddError(
                      Copystr(
                        StrSubstNo(
                          Text026_Txt,
                          "Shipment Line No.",
                          "Shipment No."), 1, 250));
            end;

            if Abs(RemQtyToBeInvoiced) > Abs("Qty. to Ship") then
                if "Document Type" = "Document Type"::Invoice then
                    AddError(
                      Copystr(
                        StrSubstNo(
                          Text036_Txt,
                          "Shipment No."), 1, 250));
        end;
    end;

    local procedure CheckRcptLines(SalesLine2: Record "Sales Line")
    var
        TempPostedDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        with SalesLine2 do begin
            if Abs(RemQtyToBeInvoiced) > Abs("Return Qty. to Receive") then begin
                ReturnRcptLine.Reset();
                case "Document Type" of
                    "Document Type"::"Return Order":
                        begin
                            ReturnRcptLine.SetCurrentKey("Return Order No.", "Return Order Line No.");
                            ReturnRcptLine.SetRange("Return Order No.", "Document No.");
                            ReturnRcptLine.SetRange("Return Order Line No.", "Line No.");
                        end;
                    "Document Type"::"Credit Memo":
                        begin
                            ReturnRcptLine.SetRange("Document No.", "Return Receipt No.");
                            ReturnRcptLine.SetRange("Line No.", "Return Receipt Line No.");
                        end;
                end;

                ReturnRcptLine.SetFilter("Return Qty. Rcd. Not Invd.", '<>0');
                if ReturnRcptLine.Find('-') then
                    repeat
                        DimMgt.GetDimensionSet(TempPostedDimSetEntry, ReturnRcptLine."Dimension Set ID");
                        if not DimMgt.CheckDimIDConsistency(
                             TempDimSetEntry, TempPostedDimSetEntry, DATABASE::"Sales Line", DATABASE::"Return Receipt Line")
                        then
                            AddError(DimMgt.GetDocDimConsistencyErr());
                        if ReturnRcptLine."Sell-to Customer No." <> "Sell-to Customer No." then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption("Sell-to Customer No.")), 1, 250));
                        if ReturnRcptLine.Type <> Type then
                            AddError(
                              CopyStr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption(Type)), 1, 250));
                        if ReturnRcptLine."No." <> "No." then
                            AddError(
                              CopyStr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption("No.")), 1, 250));
                        if ReturnRcptLine."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                            AddError(
                              CopyStr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption("Gen. Bus. Posting Group")), 1, 250));
                        if ReturnRcptLine."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                            AddError(
                              CopyStr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption("Gen. Prod. Posting Group")), 1, 250));
                        if ReturnRcptLine."Location Code" <> "Location Code" then
                            AddError(
                              copystr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption("Location Code")), 1, 250));
                        if ReturnRcptLine."Job No." <> "Job No." then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                  Text038_Txt,
                                  FieldCaption("Job No.")), 1, 250));

                        if SalesLine."Qty. to Invoice" * ReturnRcptLine.Quantity < 0 then
                            AddError(
                              Copystr(
                                StrSubstNo(
                                Text039_Txt, FieldCaption("Qty. to Invoice")), 1, 250));
                        QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
                        if Abs(QtyToBeInvoiced) > Abs(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced") then
                            QtyToBeInvoiced := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                        RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                        ReturnRcptLine."Quantity Invoiced" := ReturnRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
                        ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
                          ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                    until (ReturnRcptLine.Next() = 0) or (Abs(RemQtyToBeInvoiced) <= Abs("Return Qty. to Receive"))
                else
                    AddError(
                      copystr(
                        StrSubstNo(
                          Text025_Txt,
                          "Return Receipt Line No.",
                          "Return Receipt No."), 1, 250));
            end;

            if Abs(RemQtyToBeInvoiced) > Abs("Return Qty. to Receive") then
                if "Document Type" = "Document Type"::"Credit Memo" then
                    AddError(
                      Copystr(
                        StrSubstNo(
                          Text037_Txt,
                          "Return Receipt No."), 1, 250));
        end;
    end;

    local procedure IsInvtPosting(): Boolean
    var
        SalesLineLocal: Record "Sales Line";
    begin
        with "Sales Header" do begin
            SalesLineLocal.SetRange("Document Type", "Document Type");
            SalesLineLocal.SetRange("Document No.", "No.");
            SalesLineLocal.SetFilter(Type, '%1|%2', SalesLineLocal.Type::Item, SalesLineLocal.Type::"Charge (Item)");
            if SalesLineLocal.IsEmpty() then
                exit(false);
            if Ship then begin
                SalesLineLocal.SetFilter("Qty. to Ship", '<>%1', 0);
                if not SalesLineLocal.IsEmpty() then
                    exit(true);
            end;
            if Receive then begin
                SalesLineLocal.SetFilter("Return Qty. to Receive", '<>%1', 0);
                if not SalesLineLocal.IsEmpty() then
                    exit(true);
            end;
            if Invoice then begin
                SalesLineLocal.SetFilter("Qty. to Invoice", '<>%1', 0);
                if not SalesLineLocal.IsEmpty() then
                    exit(true);
            end;
        end;
    end;

    procedure AddDimToTempLine(SalesLine: Record "Sales Line")
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get();

        with SalesLine do begin
            TableID[1] := DimMgt.TypeToTableID3(Type.AsInteger());
            No[1] := "No.";
            TableID[2] := DATABASE::Job;
            No[2] := "Job No.";
            TableID[3] := DATABASE::"Responsibility Center";
            No[3] := "Responsibility Center";

            "Shortcut Dimension 1 Code" := '';
            "Shortcut Dimension 2 Code" := '';
            "Dimension Set ID" :=
              DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                "Dimension Set ID", DATABASE::Customer);
        end;
    end;

    procedure InitializeRequest(NewShipReceiveOnNextPostReq: Boolean; NewInvOnNextPostReq: Boolean; NewShowDim: Boolean; NewShowCostAssignment: Boolean)
    begin
        ShipReceiveOnNextPostReqValue := NewShipReceiveOnNextPostReq;
        InvOnNextPostReqValue := NewInvOnNextPostReq;
        ShowDimValue := NewShowDim;
        ShowCostAssignment := NewShowCostAssignment;
    end;

    local procedure CheckType(SalesLine2: Record "Sales Line")
    begin
        with SalesLine2 do
            case Type of
                Type::"G/L Account":
                    begin
                        if ("No." = '') and (Amount = 0) then
                            exit;

                        if "No." <> '' then
                            if GLAcc.Get("No.") then begin
                                if GLAcc.Blocked then
                                    AddError(
                                      StrSubstNo(
                                        Text007_Txt,
                                        GLAcc.FieldCaption(Blocked), false, GLAcc.TableCaption(), "No."));
                                if not GLAcc."Direct Posting" and ("Line No." <= OrigMaxLineNo) then
                                    AddError(
                                      StrSubstNo(
                                        Text007_Txt,
                                        GLAcc.FieldCaption("Direct Posting"), true, GLAcc.TableCaption(), "No."));
                            end else
                                AddError(
                                  StrSubstNo(
                                    Text008_Txt,
                                    GLAcc.TableCaption(), "No."));
                    end;
                Type::Item:
                    begin
                        if ("No." = '') and (Quantity = 0) then
                            exit;

                        if "No." <> '' then
                            if Item.Get("No.") then begin
                                if Item.Blocked then
                                    AddError(
                                      StrSubstNo(
                                        Text007_Txt,
                                        Item.FieldCaption(Blocked), false, Item.TableCaption(), "No."));
                                if Item.Reserve = Item.Reserve::Always then begin
                                    CalcFields("Reserved Quantity");
                                    if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
                                        if (SignedXX(Quantity) < 0) and (Abs("Reserved Quantity") < Abs("Return Qty. to Receive")) then
                                            AddError(
                                              StrSubstNo(
                                                Text015_Txt,
                                                FieldCaption("Reserved Quantity"), SignedXX("Return Qty. to Receive")));
                                    end else
                                        if (SignedXX(Quantity) < 0) and (Abs("Reserved Quantity") < Abs("Qty. to Ship")) then
                                            AddError(
                                              StrSubstNo(
                                                Text015_Txt,
                                                FieldCaption("Reserved Quantity"), SignedXX("Qty. to Ship")));
                                end
                            end else
                                AddError(
                                  StrSubstNo(
                                    Text008_Txt,
                                    Item.TableCaption(), "No."));
                    end;
                Type::Resource:
                    begin
                        if ("No." = '') and (Quantity = 0) then
                            exit;

                        if Res.Get("No.") then begin
                            if Res."Privacy Blocked" then
                                AddError(
                                  StrSubstNo(
                                    Text007_Txt,
                                    Res.FieldCaption("Privacy Blocked"), false, Res.TableCaption(), "No."));
                            if Res.Blocked then
                                AddError(
                                  StrSubstNo(
                                    Text007_Txt,
                                    Res.FieldCaption(Blocked), false, Res.TableCaption(), "No."));
                        end else
                            AddError(
                              StrSubstNo(
                                Text008_Txt,
                                Res.TableCaption(), "No."));
                    end;
                Type::"Fixed Asset":
                    begin
                        if ("No." = '') and (Quantity = 0) then
                            exit;
                        if "No." <> '' then
                            if FA.Get("No.") then begin
                                if FA.Blocked then
                                    AddError(
                                      StrSubstNo(
                                        Text007_Txt,
                                        FA.FieldCaption(Blocked), false, FA.TableCaption(), "No."));
                                if FA.Inactive then
                                    AddError(
                                      StrSubstNo(
                                        Text007_Txt,
                                        FA.FieldCaption(Inactive), false, FA.TableCaption(), "No."));
                                if "Depreciation Book Code" = '' then
                                    AddError(StrSubstNo(Text006_Txt, FieldCaption("Depreciation Book Code")))
                                else
                                    if not FADeprBook.Get("No.", "Depreciation Book Code") then
                                        AddError(
                                          StrSubstNo(
                                            Text017_Txt,
                                            FADeprBook.TableCaption(), "No.", "Depreciation Book Code"));
                            end else
                                AddError(
                                  StrSubstNo(
                                    Text008_Txt,
                                    FA.TableCaption(), "No."));
                    end;
            end;
    end;

    local procedure VerifySellToCust(SalesHeader: Record "Sales Header")
    var
        ShipQtyExist: Boolean;
    begin
        with SalesHeader do
            if "Sell-to Customer No." = '' then
                AddError(Copystr(StrSubstNo(Text006_Txt, FieldCaption("Sell-to Customer No.")), 1, 250))
            else
                if Cust.Get("Sell-to Customer No.") then begin
                    if (Cust.Blocked = Cust.Blocked::Ship) and Ship then begin
                        SalesLine2.SetRange("Document Type", "Document Type");
                        SalesLine2.SetRange("Document No.", "No.");
                        SalesLine2.SetFilter("Qty. to Ship", '>0');
                        if SalesLine2.FindFirst() then
                            ShipQtyExist := true;
                    end;
                    if Cust."Privacy Blocked" then
                        AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
                    if (Cust.Blocked = Cust.Blocked::All) or
                       ((Cust.Blocked = Cust.Blocked::Invoice) and
                        (not ("Document Type" in
                              ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]))) or
                       ShipQtyExist
                    then
                        AddError(
                          Copystr(
                            StrSubstNo(
                              Text045_Txt,
                              Cust.FieldCaption(Blocked), Cust.Blocked, Cust.TableCaption(), "Sell-to Customer No."), 1, 250))
                end else
                    AddError(
                      copystr(
                        StrSubstNo(
                          Text008_Txt,
                          Cust.TableCaption(), "Sell-to Customer No."), 1, 250));
    end;

    local procedure VerifyBillToCust(SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do
            if "Bill-to Customer No." = '' then
                AddError(Copystr(StrSubstNo(Text006_Txt, FieldCaption("Bill-to Customer No.")), 1, 250))
            else
                if "Bill-to Customer No." <> "Sell-to Customer No." then
                    if Cust.Get("Bill-to Customer No.") then begin
                        if Cust."Privacy Blocked" then
                            AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
                        if (Cust.Blocked = Cust.Blocked::All) or
                           ((Cust.Blocked = Cust.Blocked::Invoice) and
                            ("Document Type" in
                             ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]))
                        then
                            AddError(
                              copystr(
                                StrSubstNo(
                                  Text045_Txt,
                                  Cust.FieldCaption(Blocked), false, Cust.TableCaption(), "Bill-to Customer No."), 1, 250));
                    end else
                        AddError(
                          Copystr(
                            StrSubstNo(
                              Text008_Txt,
                              Cust.TableCaption(), "Bill-to Customer No."), 1, 250));
    end;

    local procedure VerifyPostingDate(SalesHeader: Record "Sales Header")
    var
        UserSetupManagement: Codeunit "User Setup Management";
        InvtPeriodEndDate: Date;
    begin
        with SalesHeader do
            if "Posting Date" = 0D then
                AddError(Copystr(StrSubstNo(Text006_Txt, FieldCaption("Posting Date")), 1, 250))
            else
                if "Posting Date" <> NormalDate("Posting Date") then
                    AddError(Copystr(StrSubstNo(Text009_Txt, FieldCaption("Posting Date")), 1, 250))
                else begin
                    UserSetupManagement.CheckAllowedPostingDate("Posting Date");
                    if IsInvtPosting() then begin
                        InvtPeriodEndDate := "Posting Date";
                        if not InvtPeriod.IsValidDate(InvtPeriodEndDate) then
                            AddError(
                              Copystr(StrSubstNo(Text010_Txt, Format("Posting Date")), 1, 250))
                    end;
                end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesPostGetSalesLines(var SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary)
    begin
    end;
}