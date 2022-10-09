/// <summary>
/// Codeunit ISA_ToolBox (ID 50100).
/// </summary>
codeunit 50100 ISA_ToolBox
{

    /*--------------------------------------------------------- Stamp Duty Processing ----------------------------------------------*/
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    /// <param name="SHeader">Record "Sales Header".</param>
    /// <param name="DocType">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure ProcessSaleStampDuty(var SHeader: Record "Sales Header"; DocType: Text): Decimal
    var
        SalesHeader: Record "Sales Header";
        CheckStampDuty: Decimal;

    begin
        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", DocType);
        SalesHeader.SetFilter("No.", SHeader."No.");

        if SalesHeader.FindSet then begin

            SalesHeader.CalcFields("Amount Including VAT");
            CheckStampDuty := (SalesHeader."Amount Including VAT" * 0.01);


            if CheckStampDuty < 5 then begin
                SalesHeader.ISA_StampDuty := 5;
                SalesHeader.ISA_AmountIncludingStampDuty := SalesHeader.ISA_StampDuty + SalesHeader."Amount Including VAT";
                SalesHeader.Modify();
            end;
            if CheckStampDuty > 2500 then begin
                SalesHeader.ISA_StampDuty := 2500;
                SalesHeader.ISA_AmountIncludingStampDuty := SalesHeader.ISA_StampDuty + SalesHeader."Amount Including VAT";
                SalesHeader.Modify();
            end;
            if (CheckStampDuty > 5) and (CheckStampDuty < 2500) then begin
                SalesHeader.ISA_StampDuty := Round(CheckStampDuty, 0.01, '=');
                SalesHeader.ISA_AmountIncludingStampDuty := SalesHeader.ISA_StampDuty + SalesHeader."Amount Including VAT";
                SalesHeader.Modify();
            end;

        end;
        exit(SalesHeader.ISA_StampDuty);
    end;


    /// <summary>
    /// ProcessServiceStampDuty.
    /// </summary>
    /// <param name="SvcHeader">Record "Service Header".</param>
    /// <param name="DocType">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure ProcessServiceStampDuty(SvcHeader: Record "Service Header"; DocType: Text): Decimal
    var
        ServiceLine: Record "Service Line";
        CheckStampDuty: Decimal;
    begin
        ServiceLine.Reset();
        ServiceLine.SetFilter("Document Type", DocType);
        ServiceLine.SetFilter("Document No.", SvcHeader."No.");

        if ServiceLine.FindSet then begin
            ServiceLine.CalcSums("Amount Including VAT");
            CheckStampDuty := ServiceLine."Amount Including VAT" * 0.01;
        end;
        if CheckStampDuty < 5 then begin
            SvcHeader.ISA_StampDuty := 5;
            SvcHeader.ISA_AmountIncludingStampDuty := SvcHeader.ISA_StampDuty + ServiceLine."Amount Including VAT";
            SvcHeader.Modify();
        end;
        if CheckStampDuty > 2500 then begin
            SvcHeader.ISA_StampDuty := 2500;
            SvcHeader.ISA_AmountIncludingStampDuty := SvcHeader.ISA_StampDuty + ServiceLine."Amount Including VAT";

            SvcHeader.Modify();
        end;
        if (CheckStampDuty > 5) and (CheckStampDuty < 2500) then begin
            SvcHeader.ISA_StampDuty := Round(CheckStampDuty, 0.01, '=');
            SvcHeader.ISA_AmountIncludingStampDuty := SvcHeader.ISA_StampDuty + ServiceLine."Amount Including VAT";
            SvcHeader.Modify();
        end;
        //SvcHeader.ISA_StampDuty := ServiceLine."Amount Including VAT" * 0.01;
        //TotalAmountIncVAT := ServiceLine."Amount Including VAT";

        if SvcHeader.FindSet then begin
            //SalesHeader.CalcFields("Amount Including VAT");
            SvcHeader.ISA_AmountIncludingStampDuty := ServiceLine."Amount Including VAT" + SvcHeader.ISA_StampDuty;
            SvcHeader.Modify();
            //Message('%1', SalesLine."Amount Including VAT");
            //Message('%1\%2\%3', (SalesHeader."Amount Including VAT" + SvcHeader.ISA_StampDuty), SalesHeader."Amount Including VAT", SvcHeader.ISA_StampDuty);
        end;
        exit(SvcHeader.ISA_StampDuty);
    end;


    /*----------------------------------------------------------------------------------------------------------------*/

    /*--------------------------------------------------------- Insert Stamp Duty GLEntries with Sales Order ----------------------------------------------*/

    //Permissions = tabledata "Sales Header" = RIMD;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostGLAndCustomer', '', false, false)]
    local procedure CreateandPostStampDuty(var SalesHeader: Record "Sales Header"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; var SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        PostingDutyEntries(SalesHeader, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, GenJnlPostLine);
    end;

    local procedure PostingDutyEntries(SalesHeader: Record "Sales Header"; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        //PostCustomerEntry in post sales
        GenJnlLine: Record "Gen. Journal Line";
        SalesLine: Record "Sales Line";
    begin
        SalesAndRec.Get();
        if (SalesHeader."Payment Method Code" = SalesAndRec.ISA_StampDutyPymtMethodsCode) and (SalesAndRec.ISA_StampDutyPymtMethodsCode <> '') then begin

            with GenJnlLine do begin
                InitNewLine(
                  SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
                  SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
                  SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

                CopyDocumentFields("Gen. Journal Document Type"::" ", DocNo, ExtDocNo, SourceCode, '');
                "Account Type" := "Account Type"::Customer;
                "Account No." := SalesHeader."Bill-to Customer No.";
                CopyFromSalesHeader(SalesHeader);

                Amount := SalesHeader.ISA_StampDuty;
                Description := SalesHeader."Bill-to Name" + ' - ' + SalesHeader."No." + ' - Droit de timbre';
                GenJnlPostLine.RunWithCheck(GenJnlLine);

                InitNewLine(
             SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
             SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
             SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

                CopyDocumentFields("Gen. Journal Document Type"::" ", DocNo, ExtDocNo, SourceCode, '');
                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := SalesAndRec.ISA_StampDuty_GLA;
                CopyFromSalesHeader(SalesHeader);

                Amount := SalesHeader.ISA_StampDuty * -1;
                Description := SalesHeader."Bill-to Name" + ' - ' + SalesHeader."No." + ' - Droit de timbre';
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;
        end;
    end;



    /*--------------------------------------------------------- Transfer Stamp Duty and Amount Including SDuty GLEntries with Sales Order ----------------------------------------------*/

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Posting Journals Mgt.", 'OnAfterPostCustomerEntry', '', true, true)]
    local procedure CreateandPostStampDutyOnService(var GenJournalLine: Record "Gen. Journal Line"; var ServiceHeader: Record "Service Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        PostingDutyEntriesOnService(ServiceHeader, GenJnlPostLine, GenJournalLine);
    end;

    // OnBeforePostCustomerEntry(GenJnlLine, ServiceHeader, TotalServiceLine, TotalServiceLineLCY, GenJnlPostLine, GenJnlLineDocNo);


    Procedure PostingDutyEntriesOnService(var ServiceHeader: record "Service Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var GenJnlLine: Record "Gen. Journal Line")
    var
        SrcCodeSetup: Record "Source Code Setup";
    begin
        SrcCode := SrcCodeSetup."Service Management";
        SalesAndRec.Get();
        if (ServiceHeader."Payment Method Code" = SalesAndRec.ISA_StampDutyPymtMethodsCode) and (SalesAndRec.ISA_StampDutyPymtMethodsCode <> '') then begin
            with GenJnlLine do begin
                InitNewLine(
                  ServiceHeader."Posting Date", "Document Date", ServiceHeader."Posting Description",
                  ServiceHeader."Shortcut Dimension 1 Code", ServiceHeader."Shortcut Dimension 2 Code",
                  ServiceHeader."Dimension Set ID", "Reason Code");

                CopyDocumentFields("Gen. Journal Document Type".FromInteger(GenJnlLine."Document Type"), 'SO000003', GenJnlLine."External Document No.", GenJnlLine."Source Code", '');

                "Account Type" := "Account Type"::Customer;
                "Account No." := ServiceHeader."Bill-to Customer No.";
                CopyFromServiceHeader(ServiceHeader);

                "Document Type" := "Document Type"::Invoice;
                Amount := ServiceHeader.ISA_StampDuty;
                Description := ServiceHeader."Bill-to Name" + ' - ' + ServiceHeader."No." + ' - Droit de timbre';
                "System-Created Entry" := true;
                GenJnlPostLine.RunWithCheck(GenJnlLine);

                InitNewLine(
                  ServiceHeader."Posting Date", ServiceHeader."Document Date", ServiceHeader."Posting Description",
                  ServiceHeader."Shortcut Dimension 1 Code", ServiceHeader."Shortcut Dimension 2 Code",
                  ServiceHeader."Dimension Set ID", ServiceHeader."Reason Code");

                CopyDocumentFields("Gen. Journal Document Type".FromInteger(GenJnlLine."Document Type"), 'SO000003', GenJnlLine."External Document No.", GenJnlLine."Source Code", '');

                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := SalesAndRec.ISA_StampDuty_GLA;
                CopyFromServiceHeader(ServiceHeader);

                "Document Type" := "Document Type"::Invoice;
                Amount := ServiceHeader.ISA_StampDuty * -1;
                Description := ServiceHeader."Bill-to Name" + ' - ' + ServiceHeader."No." + ' - Droit de timbre';
                "System-Created Entry" := true;
                GenJnlPostLine.RunWithCheck(GenJnlLine);

            end;
        end;
    end;

    /*----------------------------------------------------------------------------------------------------------------*/
   /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterSalesDeltaUpdateTotals', '', false, false)]
    local procedure DocumentTotals_OnAfterSalesDeltaUpdateTotals(var TotalSalesLine: Record "Sales Line"; var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
        //Message('Amnt 01 %1\%2\%3', TotalSalesLine.Amount);
        TotalSalesLine.CalcSums("Amount Including VAT");
        TotalSalesLine.ISA_StampDuty += TotalSalesLine."Amount Including VAT" * 0.01;
        TotalSalesLine."Amount Including VAT" += TotalSalesLine.ISA_StampDuty;

        Message('OnAfterSalesDeltaUpdateTotals Alpha');
        //TotalSalesLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterCalculateSalesSubPageTotals', '', false, false)]
    local procedure DocumentTotals_OnAfterCalculateSalesSubPageTotals(var TotalSalesLine2: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        DocType: Enum "Sales Document Type";
    begin
        //Message('Amnt 01 %1\%2\%3', TotalSalesLine.Amount);
        TotalSalesLine2.CalcSums("Amount Including VAT");
        TotalSalesLine2.ISA_StampDuty += TotalSalesLine2."Amount Including VAT" * 0.01;
        TotalSalesLine2."Amount Including VAT" += TotalSalesLine2.ISA_StampDuty;
        //TotalSalesLine2.Modify();
        Message('OnAfterCalculateSalesSubPageTotals Beta');
    end;*/

    /*----------------------------------------------------------------------------------------------------------------*/


    var
        SrcCode: Code[10];
        SrcCodeSetup: Record "Source Code Setup";
        SalesAndRec: Record "Sales & Receivables Setup";
        GEL: Record "G/L Entry";
        SalesInvHeader: Record "Sales Invoice Header";
}