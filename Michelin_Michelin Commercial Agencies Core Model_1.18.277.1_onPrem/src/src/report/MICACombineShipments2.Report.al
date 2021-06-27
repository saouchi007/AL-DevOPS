report 82941 "MICA Combine Shipments2"
{
    ApplicationArea = Basic, Suite;
    Caption = 'MICA Combine Shipments';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesOrderHeaderFilter; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "Bill-to Customer No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "Sell-to Customer No.", "Bill-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            dataitem(SalesShipmentHeaderFilter; "Sales Shipment Header")
            {
                DataItemTableView = SORTING("Order No.");
                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Posted Sales Shipment';
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }

        dataitem(TempSortingLine; "MICA Sorting Line2")
        {
            DataItemTableView = SORTING("Field 3", "Field 4", "Field 5", "Field 6", "Field 7", "Field 8", "Field 9", "Field 10", "Field 11", "Field 12", "Field 13", "Field 14", "Field 15", "Field 16", "Document No.", "Line No.");
            UseTemporary = true;


            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("document No."), "Line No." = FIELD("Line No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                var
                    TransientTopMgt: Codeunit "MICA Transient Top Management";
                    IsHandled: Boolean;
                begin
                    IsHandled := false;
                    OnBeforeSalesShipmentLineOnAfterGetRecord("Sales Shipment Line", IsHandled);
                    if IsHandled then
                        CurrReport.Skip();

                    if Type = "Sales Line Type"::" " then
                        if (not CopyTextLines) or ("Attached to Line No." <> 0) then
                            CurrReport.Skip();


                    if "Authorized for Credit Card" then
                        CurrReport.Skip();

                    if SalesOrderHeader."No." <> "Sales Shipment Line"."Order No." then
                        SalesOrderHeader.get(SalesOrderHeader."Document Type"::Order, "Sales Shipment Line"."Order No.");

                    if SalesShipmentHeader."No." <> "Sales Shipment Line"."Document No." then
                        SalesShipmentHeader.Get("Sales Shipment Line"."Document No.");

                    if GuiAllowed then begin
                        Window.Update(1, SalesOrderHeader."Bill-to Customer No.");
                        Window.Update(2, SalesOrderHeader."No.");
                        Window.Update(3, SalesShipmentHeader."No.");
                    end;

                    if ("Qty. Shipped Not Invoiced" <> 0) or (Type = "Sales Line Type"::" ") then begin
                        if ("Bill-to Customer No." <> Cust."No.") and
                           ("Sell-to Customer No." <> '')
                        then
                            Cust.Get("Bill-to Customer No.");
                        if not (Cust.Blocked in [Cust.Blocked::All, Cust.Blocked::Invoice]) then begin
                            if ShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, SalesShipmentHeader, "Sales Shipment Line") then begin
                                if SalesHeader."No." <> '' then
                                    FinalizeSalesInvHeader();
                                InsertSalesInvHeader();
                                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                SalesLine.SetRange("Document No.", SalesHeader."No.");
                                SalesLine."Document Type" := SalesHeader."Document Type";
                                SalesLine."Document No." := SalesHeader."No.";
                            end;
                            SalesShptLine := "Sales Shipment Line";
                            HasAmount := HasAmount or ("Qty. Shipped Not Invoiced" <> 0);
                            SalesShptLine.InsertInvLineFromShptLine(SalesLine);
                            TransientTopMgt.UpdateHeaderSalesAgreementsFromLine(SalesLine, false);
                            LastVATRate := "Sales Shipment Line"."VAT %";
                        end else
                            NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
                    end;
                end;

                trigger OnPostDataItem()
                var
                    SalesShipmentLine: Record "Sales Shipment Line";
                    SalesLineInvoice: Record "Sales Line";
                    SalesGetShpt: Codeunit "Sales-Get Shipment";
                begin
                    SalesShipmentLine.SetRange("Document No.", "Document No.");
                    SalesShipmentLine.SetRange(Type, Type::"Charge (Item)");
                    if SalesShipmentLine.FindSet() then
                        repeat
                            SalesLineInvoice.SetRange("Document Type", SalesLineInvoice."Document Type"::Invoice);
                            SalesLineInvoice.SetRange("Document No.", SalesHeader."No.");
                            SalesLineInvoice.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
                            if SalesLineInvoice.FindFirst() then
                                SalesGetShpt.GetItemChargeAssgnt(SalesShipmentLine, SalesLineInvoice."Qty. to Invoice");
                        until SalesShipmentLine.Next() = 0;
                end;

                trigger OnPreDataItem()
                var
                    VATRate: Decimal;
                begin
                    if SalesSetup."MICA Combine Ship. By VAT Rate" then
                        IF TempSortingLine."Field 14" <> '' then begin
                            Evaluate(VATRate, TempSortingLine."Field 14");
                            "Sales Shipment Line".SetRange("VAT %", VATRate);
                        end;
                end;
            }


            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                    Error(Text000Lbl);
                if DocDateReq = 0D then
                    Error(Text001Lbl);
                if GuiAllowed then
                    Window.Open(
                      Text002Lbl +
                      Text003Lbl +
                      Text004Lbl +
                      Text005Lbl);

            end;

            trigger OnPostDataItem()
            begin
                CurrReport.Language := GlobalLanguage;
                if GuiAllowed then
                    Window.Close();
                if SalesHeader."No." <> '' then begin // Not the first time
                    FinalizeSalesInvHeader();
                    if (NoOfSalesInvErrors = 0) and not HideDialog then begin
                        if GuiAllowed then
                            if NoOfskippedShiment > 0 then
                                Message(
                                  Text011Lbl,
                                  NoOfSalesInv, NoOfskippedShiment)
                            else
                                if GuiAllowed then
                                    Message(
                                      Text010Lbl,
                                      NoOfSalesInv);
                    end else
                        if not HideDialog then
                            if GuiAllowed then
                                if PostInv then
                                    Message(
                                      Text007Lbl,
                                      NoOfSalesInvErrors)
                                else
                                    Message(
                                      NotAllInvoicesCreatedMsg,
                                      NoOfSalesInvErrors)
                end else
                    if not HideDialog then
                        if GuiAllowed then
                            Message(Text008Lbl);
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
                    field(PostingDate; PostingDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the invoice(s) that the batch job creates. This field must be filled in.';
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date';
                        ToolTip = 'Specifies the document date for the invoice(s) that the batch job creates. This field must be filled in.';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies if you want the invoice discount amount to be automatically calculated on the shipment.';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get();
                            SalesSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                    field(PostInv; PostInv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Invoices';
                        ToolTip = 'Specifies if you want to have the invoices posted immediately.';
                    }
                    field(OnlyStdPmtTerms; OnlyStdPmtTerms)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Only Std. Payment Terms';
                        ToolTip = 'Specifies if you want to include shipments with standard payments terms. If you select this option, you must manually invoice all other shipments.';
                    }
                    field(CopyTextLines; CopyTextLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Copy Text Lines';
                        ToolTip = 'Specifies if you want manually written text on the shipment lines to be copied to the invoice.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            SalesSetup.Get();
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        OnBeforePostReport();
    end;

    trigger OnPreReport()
    begin
        OnBeforePreReport();
        SalesReceivablesSetup.Get();
        InitSortingLines();
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        SalesOrderHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        PmtTerms: Record "Payment Terms";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Text000Lbl: Label 'Enter the posting date.';
        Text001Lbl: Label 'Enter the document date.';
        Text002Lbl: Label 'Combining shipments...\\';
        Text003Lbl: Label 'Customer No.    #1##########\';
        Text004Lbl: Label 'Order No.       #2##########\';
        Text005Lbl: Label 'Shipment No.    #3##########';
        Text007Lbl: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text008Lbl: Label 'There is nothing to combine.';
        Text010Lbl: Label 'The shipments are now combined and the number of invoices created is %1.';
        Window: Dialog;
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvDisc: Boolean;
        PostInv: Boolean;
        OnlyStdPmtTerms: Boolean;
        HasAmount: Boolean;
        HideDialog: Boolean;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        Text011Lbl: Label 'The shipments are now combined, and the number of invoices created is %1.\%2 Shipments with nonstandard payment terms have not been combined.', Comment = '%1-Number of invoices,%2-Number Of shipments';
        NoOfskippedShiment: Integer;
        CopyTextLines: Boolean;
        NotAllInvoicesCreatedMsg: Label 'Not all the invoices were created. A total of %1 invoices were not created.';
        LastShipmentPostingDate: Date;
        LastShipmentNo: Code[20];
        LastVATRate: Decimal;

    local procedure FinalizeSalesInvHeader()
    var
        HasError: Boolean;
    begin
        HasError := false;
        OnBeforeFinalizeSalesInvHeader(SalesHeader, HasAmount, HasError);
        if HasError then
            NoOfSalesInvErrors += 1;

        with SalesHeader do begin
            if (not HasAmount) or HasError then begin
                OnFinalizeSalesInvHeaderOnBeforeDelete(SalesHeader);
                Delete(true);
                OnFinalizeSalesInvHeaderOnAfterDelete(SalesHeader);
                exit;
            end;
            OnFinalizeSalesInvHeader(SalesHeader);
            if CalcInvDisc then
                SalesCalcDisc.Run(SalesLine);
            Find();
            Commit();
            Clear(SalesCalcDisc);
            Clear(SalesPost);
            NoOfSalesInv := NoOfSalesInv + 1;
            if PostInv or (SalesReceivablesSetup."MICA Combine Shipment Option" = SalesReceivablesSetup."MICA Combine Shipment Option"::CreateAndPost) then begin
                Clear(SalesPost);
                if not SalesPost.Run(SalesHeader) then
                    NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
            end;
        end;
    end;

    local procedure InsertSalesInvHeader()
    begin
        Clear(SalesHeader);
        with SalesHeader do begin
            Init();
            "Document Type" := "Document Type"::Invoice;
            "No." := '';
            OnBeforeSalesInvHeaderInsert(SalesHeader, SalesOrderHeader);
            Insert(true);
            Validate("Sell-to Customer No.", SalesOrderHeader."Sell-to Customer No.");
            if "Bill-to Customer No." <> SalesOrderHeader."Bill-to Customer No." then begin
                SetHideValidationDialog(true);
                Validate("Bill-to Customer No.", SalesOrderHeader."Bill-to Customer No.");
            end;
            Validate("Posting Date", PostingDateReq);
            Validate("Document Date", DocDateReq);
            Validate("Currency Code", SalesOrderHeader."Currency Code");
            Validate("EU 3-Party Trade", SalesOrderHeader."EU 3-Party Trade");
            "Salesperson Code" := SalesOrderHeader."Salesperson Code";
            "Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
            "Dimension Set ID" := SalesOrderHeader."Dimension Set ID";

            Validate("Ship-to Code", SalesOrderHeader."Ship-to Code");
            Validate("MICA Order Type", SalesOrderHeader."MICA Order Type");
            Validate("Combine Shipments", SalesOrderHeader."Combine Shipments");
            Validate("Your Reference", SalesOrderHeader."Your Reference");
            Validate("MICA Customer Transport", SalesOrderHeader."MICA Customer Transport");
            Validate("MICA Sales Agreement", SalesOrderHeader."MICA Sales Agreement");
            Validate("Payment Terms Code", SalesOrderHeader."Payment Terms Code");
            Validate("MICA Truck License Plate", SalesShipmentHeader."MICA Truck License Plate");
            Validate("MICA Truck Driver Info", SalesShipmentHeader."MICA Truck Driver Info");
            LastShipmentPostingDate := SalesShipmentHeader."Posting Date";
            LastShipmentNo := SalesShipmentHeader."No.";

            OnBeforeSalesInvHeaderModify(SalesHeader, SalesOrderHeader, SalesShipmentHeader);
            Modify();
            Commit();
            HasAmount := false;
        end;

        OnAfterInsertSalesInvHeader(SalesHeader, SalesShipmentHeader);
    end;

    procedure InitializeRequest(NewPostingDate: Date; NewDocDate: Date; NewCalcInvDisc: Boolean; NewPostInv: Boolean; NewOnlyStdPmtTerms: Boolean; NewCopyTextLines: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocDate;
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostInv;
        OnlyStdPmtTerms := NewOnlyStdPmtTerms;
        CopyTextLines := NewCopyTextLines;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure ShouldFinalizeSalesInvHeader(SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line") Finalize: Boolean
    begin
        if SalesOrderHeader."MICA Order Type" = SalesOrderHeader."MICA Order Type"::"Express Order" then
            Finalize := ((SalesShipmentHeader."No." <> LastShipmentNo) and (LastShipmentNo <> '')); // Finalize when switching to a new shipment in order to combine the lines belonging to the same shipment
        if not Finalize then
            if not SalesOrderHeader."Combine Shipments" then
                Finalize := ((SalesShipmentHeader."No." <> LastShipmentNo) and (LastShipmentNo <> ''));// Finalize when switching to a new shipment in order to combine the lines belonging to the same shipment
        if not Finalize then
            Finalize :=
                (SalesOrderHeader."Sell-to Customer No." <> SalesHeader."Sell-to Customer No.") or
                (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
                (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
                (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") or
                (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID") or
                (SalesOrderHeader."Ship-to Code" <> SalesHeader."Ship-to Code") or
                (SalesOrderHeader."MICA Order Type" <> SalesHeader."MICA Order Type") or
                (SalesOrderHeader."Combine Shipments" <> SalesHeader."Combine Shipments") or
                (SalesOrderHeader."Your Reference" <> SalesHeader."Your Reference") or
                (SalesOrderHeader."MICA Customer Transport" <> SalesHeader."MICA Customer Transport") or
                (SalesOrderHeader."MICA Sales Agreement" <> SalesHeader."MICA Sales Agreement") or
                (SalesOrderHeader."Payment Terms Code" <> SalesHeader."Payment Terms Code") or
                (SalesShipmentHeader."MICA Truck License Plate" <> SalesHeader."MICA Truck License Plate") or
                (SalesShipmentHeader."MICA Truck Driver Info" <> SalesHeader."MICA Truck Driver Info") or
                (SalesShipmentHeader."Posting Date" <> LastShipmentPostingDate);
        if SalesSetup."MICA Combine Ship. By VAT Rate" then
            Finalize := Finalize or (SalesShipmentLine."VAT %" <> LastVATRate);
        OnAfterShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, Finalize, SalesShipmentHeader, SalesShipmentLine);
        exit(Finalize);
    end;


    local procedure InsertSortingLine(SalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; WithVAT: Boolean)
    var
        IsHandled: Boolean;
    begin
        OnBeforeInsertSortingLine(TempSortingLine, SalesOrderHeader, SalesShipmentHeader, SalesShipmentLine, IsHandled);
        if IsHandled then
            exit;

        Clear(TempSortingLine);
        TempSortingLine."Document No." := SalesShipmentLine."Document No.";
        TempSortingLine."Line No." := SalesShipmentLine."Line No.";
        TempSortingLine."Field 3" := SalesOrderHeader."Bill-to Customer No.";
        TempSortingLine."Field 4" := format(SalesOrderHeader."MICA Order Type");
        TempSortingLine."Field 5" := format(SalesOrderHeader."Combine Shipments");
        TempSortingLine."Field 6" := SalesOrderHeader."Ship-to Code";
        TempSortingLine."Field 7" := SalesOrderHeader."Your Reference";
        TempSortingLine."Field 8" := format(SalesOrderHeader."MICA Customer Transport");
        TempSortingLine."Field 9" := SalesOrderHeader."MICA Sales Agreement";
        TempSortingLine."Field 10" := SalesOrderHeader."Payment Terms Code";
        TempSortingLine."Field 11" := SalesShipmentHeader."MICA Truck License Plate";
        TempSortingLine."Field 12" := SalesShipmentHeader."MICA Truck Driver Info";
        TempSortingLine."Field 13" := format(SalesShipmentHeader."Posting Date");
        if WithVAT then
            TempSortingLine."Field 14" := format(SalesShipmentLine."VAT %");
        if TempSortingLine.Insert(true) then;

        OnAfterInsertSortingLine(TempSortingLine, SalesOrderHeader, SalesShipmentHeader, SalesShipmentLine);

    end;

    local procedure SkipShipmentHeader(SalesShipmentHeader: Record "Sales Shipment Header"): Boolean
    var
        DueDate: Date;
        PmtDiscDate: Date;
        PmtDiscPct: Decimal;
    begin
        if SalesShipmentHeader.IsCompletlyInvoiced() then
            exit(true);

        if OnlyStdPmtTerms then begin
            Cust.Get(SalesShipmentHeader."Bill-to Customer No.");
            PmtTerms.Get(Cust."Payment Terms Code");
            if PmtTerms.Code = SalesShipmentHeader."Payment Terms Code" then begin
                DueDate := CalcDate(PmtTerms."Due Date Calculation", SalesShipmentHeader."Document Date");
                PmtDiscDate := CalcDate(PmtTerms."Discount Date Calculation", SalesShipmentHeader."Document Date");
                PmtDiscPct := PmtTerms."Discount %";
                if (DueDate <> SalesShipmentHeader."Due Date") or
                   (PmtDiscDate <> SalesShipmentHeader."Pmt. Discount Date") or
                   (PmtDiscPct <> SalesShipmentHeader."Payment Discount %")
                then begin
                    NoOfskippedShiment := NoOfskippedShiment + 1;
                    exit(true);
                end;
            end else begin
                NoOfskippedShiment := NoOfskippedShiment + 1;
                exit(true);
            end;
        end;
    end;

    local procedure InitSortingLines()
    var
        SalesOrders: Record "Sales Header";
        SalesShipment: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        VATRateCountQuery: query "MICA Sales Shpt VAT Rate Count";
        RateCount: Integer;
        VATRate: Decimal;
    begin
        SalesOrders.SetCurrentKey("Bill-to Customer No.");
        SalesOrders.CopyFilters(SalesOrderHeaderFilter);
        if SalesOrders.IsEmpty then
            exit;
        SalesOrders.FindSet();
        repeat
            SalesShipment.CopyFilters(SalesShipmentHeaderFilter);
            SalesShipment.SetRange("Order No.", SalesOrders."No.");
            if SalesShipment.FindSet() then
                repeat
                    if not SkipShipmentHeader(SalesShipment) then begin
                        //Is not completly Invoiced
                        SalesShipmentLine.SetRange("Document No.", SalesShipment."No.");
                        SalesShipmentLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');
                        if not SalesShipmentLine.IsEmpty() then
                            if not SalesSetup."MICA Combine Ship. By VAT Rate" then begin
                                SalesShipmentLine.FindSet();
                                repeat
                                    if not SalesShipmentLine.IsLinkedToSalesInvLine() then
                                        InsertSortingLine(SalesOrders, SalesShipment, SalesShipmentLine, false);
                                until SalesShipmentLine.Next() = 0;
                            end else begin
                                ///////
                                RateCount := 0;
                                VATRateCountQuery.Setrange(No_, SalesShipment."No.");
                                if VATRateCountQuery.Open() then
                                    While VATRateCountQuery.Read() do
                                        RateCount += 1;

                                /// 
                                if RateCount = 1 then begin// All the lines have the same VAT %
                                    SalesShipmentLine.FindSet();
                                    repeat
                                        if not SalesShipmentLine.IsLinkedToSalesInvLine() then
                                            InsertSortingLine(SalesOrders, SalesShipment, SalesShipmentLine, false);
                                    until SalesShipmentLine.Next() = 0;
                                end else
                                    if RateCount > 1 then begin // shipment lines have different VAT % --> must split sorting lines
                                        VATRateCountQuery.Open();
                                        While VATRateCountQuery.Read() do begin
                                            VATRate := VATRateCountQuery.VAT__;
                                            SalesShipmentLine.SetRange("VAT %", VATRate);
                                            if SalesShipmentLine.FindSet() then
                                                repeat
                                                    if not SalesShipmentLine.IsLinkedToSalesInvLine() then
                                                        InsertSortingLine(SalesOrders, SalesShipment, SalesShipmentLine, true);
                                                until SalesShipmentLine.Next() = 0;
                                        end;

                                    end;
                            end;
                    end;
                until SalesShipment.Next() = 0;
        until SalesOrders.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecordSalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header"; var HasAmount: Boolean; var HasError: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePreReport()
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePostReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderModify(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesShipmentLineOnAfterGetRecord(var SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnAfterDelete(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnBeforeDelete(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesOrderHeaderOnPreDataItem(var SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldFinalizeSalesInvHeader(var SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; var Finalize: Boolean; SaleShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSortingLine(var SortingLine: Record "MICA Sorting Line2"; SalesHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; isHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSortingLine(var SortingLine: Record "MICA Sorting Line2"; SalesHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line")
    begin
    end;
}

