codeunit 81640 "MICA Terms Of Payment Mgt"
{
    /*
    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateEventSalesLineNo(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if (CurrFieldNo <> 0) then
            if Rec.Type = Rec.Type::Item then begin
                CheckSalesAgreementSetupFromSOLine(Rec);
                InitSalesAgreement(Rec);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeModifySalesDoc', '', false, false)]
    local procedure ReleaseSalesDocOnBeforeModifySalesDoc(var SalesHeader: Record "Sales Header")
    var
        SalesLine: record "Sales Line";
    begin
        SalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet(false, false) then
            repeat
                CheckSalesAgreementSetupFromSOLine(SalesLine);
            until SalesLine.next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeTestSalesLine', '', false, false)]
    local procedure SalesPostOnBeforeTestSalesLine(var SalesLine: Record "Sales Line")
    begin
        CheckSalesAgreementSetupFromSOLine(SalesLine);
    end;

    local procedure CheckSalesAgreementSetupFromSOLine(var FromSalesLine: Record "Sales Line")
    var
        SalesAgreement: Record "MICA Sales Agreement";
        SalesAgrmtErr: Label 'You must set up at least one Sales Agreement for the customer no.%1.';
    begin
        // #####################################
        // EXIT IS SET TO DEACTIVE TO MANAGEMENT
        // #####################################
        // exit;
        // #####################################

        SalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
        SalesAgreement.SetRange("Customer No.", FromSalesLine."Sell-to Customer No.");
        SalesAgreement.SetRange("Item Category Code", FromSalesLine."Item Category Code");
        SalesAgreement.SetRange(DefaultLP, true);
        if not SalesAgreement.IsEmpty() then
            exit;
        SalesAgreement.SetRange("Item Category Code");
        SalesAgreement.SetRange(DefaultLP);
        SalesAgreement.SetRange(Default, true);
        if SalesAgreement.IsEmpty() then
            error(StrSubstNo(SalesAgrmtErr, FromSalesLine."Sell-to Customer No."));
    end;

    local procedure InitSalesAgreement(Var Rec: Record "Sales Line")
    var
        SalesLine: record "Sales Line";
        MICASalesAgreement: Record "MICA Sales Agreement";
        Item: record Item;
    begin
        with Rec DO begin
            Item.GET("No.");
            if Item."Item Category Code" <> '' THEN begin
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "Document No.");
                SalesLine.SetRange("Item Category Code", "Item Category Code");
                SalesLine.SetFilter("Line No.", '<> %1', "Line No.");
                if SalesLine.findfirst() then begin
                    "MICA Sales Agreement No." := SalesLine."MICA Sales Agreement No.";
                    "MICA Priority Code" := SalesLine."MICA Priority Code";
                    VALIDATE("MICA Payment Terms Code", SalesLine."MICA Payment Terms Code");
                    "MICA Payment Method Code" := SalesLine."MICA Payment Method Code";
                    VALIDATE("MICA Payment Terms Line Disc. %", SalesLine."MICA Payment Terms Line Disc. %");
                end else begin
                    MICASalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
                    MICASalesAgreement.SetRange("Customer No.", "Sell-to Customer No.");
                    MICASalesAgreement.SetRange("Item Category Code", "Item Category Code");
                    MICASalesAgreement.SetRange(DefaultLP, true);
                    if MICASalesAgreement.findfirst() then begin
                        if (WorkDate() >= MICASalesAgreement."Start Date") AND (WorkDate() <= MICASalesAgreement."end Date") then begin
                            "MICA Sales Agreement No." := MICASalesAgreement."No.";
                            "MICA Priority Code" := MICASalesAgreement."Priority Code";
                            VALIDATE("MICA Payment Terms Code", MICASalesAgreement."Payment Terms Code");
                            "MICA Payment Method Code" := MICASalesAgreement."Payment Method Code";
                            VALIDATE("MICA Payment Terms Line Disc. %", MICASalesAgreement."Payment Terms Discount %");
                        end;
                    end else begin
                        MICASalesAgreement.SetRange("Item Category Code");
                        MICASalesAgreement.SetRange(DefaultLP);
                        MICASalesAgreement.SetRange(Default, true);
                        if MICASalesAgreement.findfirst() then
                            if (WorkDate() >= MICASalesAgreement."Start Date") AND (WorkDate() <= MICASalesAgreement."end Date") then begin
                                "MICA Sales Agreement No." := MICASalesAgreement."No.";
                                "MICA Priority Code" := MICASalesAgreement."Priority Code";
                                VALIDATE("MICA Payment Terms Code", MICASalesAgreement."Payment Terms Code");
                                "MICA Payment Method Code" := MICASalesAgreement."Payment Method Code";
                                VALIDATE("MICA Payment Terms Line Disc. %", MICASalesAgreement."Payment Terms Discount %");
                            end;
                    end;
                end;
            end else begin
                MICASalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
                MICASalesAgreement.SetRange("Customer No.", "Sell-to Customer No.");
                MICASalesAgreement.SetRange(Default, true);
                if MICASalesAgreement.findfirst() then
                    if (WorkDate() >= MICASalesAgreement."Start Date") AND (WorkDate() <= MICASalesAgreement."end Date") then begin
                        "MICA Sales Agreement No." := MICASalesAgreement."No.";
                        "MICA Priority Code" := MICASalesAgreement."Priority Code";
                        VALIDATE("MICA Payment Terms Code", MICASalesAgreement."Payment Terms Code");
                        "MICA Payment Method Code" := MICASalesAgreement."Payment Method Code";
                        VALIDATE("MICA Payment Terms Line Disc. %", MICASalesAgreement."Payment Terms Discount %");
                    end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'MICA Payment Terms Code', false, false)]
    local procedure OnAfterValidateEventSalesLineMICAPaymtTermsCode(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeader: record "Sales Header";
        PaymentTerms: record "Payment Terms";
    begin
        with Rec do BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            IF ("MICA Payment Terms Code" <> '') AND (SalesHeader."Document Date" <> 0D) THEN BEGIN
                PaymentTerms.GET("MICA Payment Terms Code");
                IF ("Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN
                    "MICA Due Date" := SalesHeader."Document Date"
                ELSE
                    "MICA Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", SalesHeader."Document Date");
            END ELSE
                VALIDATE("MICA Due Date", SalesHeader."Document Date");
        END;
    end;

    procedure PostSalesOrder(SalesHeader: record "Sales Header")
    var
        SalesLine: record "Sales Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: record "Sales Invoice Line";
        TempSalesLine: Record "Sales Line" temporary;
        SplitNo: Integer;
        MaxSplitNo: Integer;
        NewSplitNo: Integer;
    begin
        SplitNo := 0;
        InitInvSplitNo(SalesHeader, SplitNo);
        MaxSplitNo := SplitNo;
        SaveOriginalSalesLine(SalesHeader, TempSalesLine);

        //* Post
        For SplitNo := 1 to MaxSplitNo do begin
            InitSalesLineQtyToShip(SalesHeader, SplitNo);

            SalesLine.reset();
            SalesLine.setrange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.type::item);
            SalesLine.Setrange("MICA Inv. Split No.", SplitNo);
            SalesLine.Setfilter("Qty. to Invoice", '<>0');
            if SalesLine.FindFirst() then begin
                //* Update Header
                UpdateSalesHeaderPayment(SalesHeader, SalesLine);

                if SplitNo = 1 THEN
                    Codeunit.run(CODEUNIT::"Sales-Post (Yes/No)", SalesHeader)
                else
                    Codeunit.Run(CODEUNIT::"Sales-Post", SalesHeader);

                NewSplitNo := SplitNo;
                InitInvSplitNo(SalesHeader, NewSplitNo);

                SalesLine.reset();
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.type::item);
                SalesLine.SetFilter("MICA Inv. Split No.", '<>%1&>%1', SplitNo);
                if SalesLine.FindSet() then
                    UpdateSalesLineQtyToShip(SalesLine, TempSalesLine, SplitNo);
            end;
        end;

        SalesInvHeader.SetCurrentKey("Order No.");
        SalesInvHeader.SetRange("Order No.", SalesHeader."No.");
        IF SalesInvHeader.Findset() then
            repeat
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                SalesInvLine.SetRange(Quantity, 0);
                if SalesInvLine.Findset() then
                    SalesInvLine.deleteall();
            until SalesInvHeader.next() = 0;

        if SplitNo = MaxSplitNo then
            OpenPostedDocument(SalesHeader);
    end;

    local procedure InitInvSplitNo(Var SalesHeader: record "Sales Header"; Var SplitNo: integer)
    var
        SalesLine: Record "Sales Line";
        SalesLine2: record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.type::item);
        SalesLine.Setfilter("Qty. to Invoice", '<>0');
        if SalesLine.FINDSET() then
            SalesLine.ModifyAll("MICA Inv. Split No.", 0);

        SalesLine.RESET();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Qty. to Invoice", '<>0');
        if SalesLine.FINDSET() then
            repeat
                SalesLine2.RESET();
                SalesLine2.SetRange("Document Type", SalesLine."Document Type");
                SalesLine2.SetRange("Document No.", SalesLine."Document No.");
                SalesLine2.SetRange("MICA Payment Terms Code", SalesLine."MICA Payment Terms Code");
                SalesLine2.SetRange("MICA Payment Method Code", SalesLine."MICA Payment Method Code");
                SalesLine2.SetFilter("Line No.", '<>%1', SalesLine."Line No.");
                SalesLine2.SetFilter("Qty. to Invoice", '<>0');
                SalesLine2.SetFilter("MICA Inv. Split No.", '<> 0');
                if SalesLine2.FindFirst() then
                    SalesLine."MICA Inv. Split No." := SalesLine2."MICA Inv. Split No."
                else begin
                    SplitNo += 1;
                    SalesLine."MICA Inv. Split No." := SplitNo;
                end;
                SalesLine.Modify();
            until SalesLine.next() = 0;
    end;

    local procedure SaveOriginalSalesLine(SalesHeader: Record "Sales Header"; var TempSalesLine: record "Sales Line" temporary)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FINDSET() then
            repeat
                TempSalesLine := SalesLine;
                TempSalesLine.INSERT();
            until SalesLine.Next() = 0;
    end;

    local procedure UpdateSalesLineQtyToShip(Var SalesLine: Record "Sales Line"; TempSalesLine: Record "Sales Line"; SplitNo: integer)
    var
    begin
        IF SalesLine.FindSet() then
            repeat
                TempSalesLine.setrange("Line No.", SalesLine."Line No.");
                If TempSalesLine.Findset() then begin
                    SalesLine.VALIDATE("Qty. to Ship", SalesLine.Quantity - SalesLine."Quantity Shipped");
                    SalesLine.VALIDATE("Qty. to Invoice", SalesLine.Quantity - SalesLine."Quantity Invoiced");
                    SalesLine.MODIFY();
                end;
            until SalesLine.Next() = 0;
    end;

    local procedure InitSalesLineQtyToShip(SalesHeader: record "Sales Header"; SplitNo: integer)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.setrange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("MICA Inv. Split No.", '<>%1&<>0', SplitNo);
        if SalesLine.FindSet() then
            repeat
                SalesLine.VALIDATE("Qty. to Ship", 0);
                // SalesLine."Qty. to Ship" := 0;
                // SalesLine."Qty. to Ship (Base)" := 0;
                SalesLine.VALIDATE("Qty. to Invoice", 0);
                // SalesLine."Qty. to Invoice" := 0;
                // SalesLine."Qty. to Invoice (Base)" := 0;
                SalesLine.modify(true);
            until SalesLine.Next() = 0;
    end;

    local procedure UpdateSalesHeaderPayment(Var SalesHeader: record "Sales Header"; SalesLine: Record "Sales Line")
    begin
        with SalesHeader do begin
            validate("Payment Method Code", SalesLine."MICA Payment Method Code");
            validate("Payment Terms Code", SalesLine."MICA Payment Terms Code");
            "MICA Sales Agreement" := SalesLine."MICA Sales Agreement No.";
            Modify(true);
        end;
    end;

    local procedure OpenPostedDocument(SalesHeader: Record "Sales Header")
    var
        OrderSalesHeader: record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        OpenPostedSalesOrderQst: label 'The order is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';
    begin
        IF NOT OrderSalesHeader.GET(SalesHeader."Document Type", SalesHeader."No.") THEN BEGIN
            //SalesInvoiceHeader.SETRANGE("No.", SalesHeader."Last Posting No.");
            SalesInvoiceHeader.SetCurrentKey("Order No.");
            SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
            IF SalesInvoiceHeader.FINDFIRST() THEN
                IF InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesOrderQst, SalesInvoiceHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode())
                THEN
                    PAGE.RUN(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
        END;
    end;
    */
}