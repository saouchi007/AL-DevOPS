/// <summary>
/// Codeunit ISA_StampDutyProcessor (ID 50230).
/// </summary>
codeunit 50106 ISA_ToolBox
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
                //"Account Type" := "Document Type"::Invoice;
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


    /******************************NumberInWords*********************************************************/
    /// <summary>
    /// NumberInWords.
    /// </summary>
    /// <param name="number">Decimal.</param>
    /// <param name="CurrencyName">Text[30].</param>
    /// <param name="DenomName">Text[30].</param>
    /// <returns>Return value of type Text[300].</returns>
    procedure NumberInWords(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);

        WholeInWords := NumberToWords(WholePart, CurrencyName);

        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, DenomName);
            WholeInWords := WholeInWords + ' ET ' + DecimalInWords;
        END;

        ISA_AmountInWords := '' + WholeInWords;
        EXIT(ISA_AmountInWords);
    end;

    /******************************NumberToWords*********************************************************/
    /// <summary>
    /// NumberToWords.
    /// </summary>
    /// <param name="number">Decimal.</param>
    /// <param name="appendScale">Text[30].</param>
    /// <returns>Return value of type Text[300].</returns>
    procedure NumberToWords(number: Decimal; appendScale: Text[30]): Text[300]
    var
        numString: text[300];
        pow: Integer;
        powStr: Text[300];
        log: Integer;
    begin
        numString := '';
        IF number < 100 THEN
            IF number < 20 THEN BEGIN
                IF number <> 0 THEN numString := OnesText[number];
            END ELSE BEGIN
                numString := TensText[number DIV 10];
                IF (number MOD 10) > 0 THEN
                    numString := numString + ' ' + OnesText[number MOD 10];
            END
        ELSE BEGIN
            pow := 0;
            powStr := '';
            IF number < 1000 THEN BEGIN // number is between 100 and 1000
                pow := 100;
                powStr := ThousText[1];
            END ELSE BEGIN // find the scale of the number
                log := ROUND(STRLEN(FORMAT(number DIV 1000)) / 3, 1, '>');
                pow := POWER(1000, log);
                powStr := ThousText[log + 1];
            END;

            numString := NumberToWords(number DIV pow, powStr) + ' ' + NumberToWords(number MOD pow, '');
        END;

        EXIT(DELCHR(numString, '<>', ' ') + ' ' + appendScale);
    end;

    /******************************NumberToWords*********************************************************/
    /// <summary>
    /// InitTextVariable.
    /// </summary>
    procedure InitTextVariable()
    begin
        OnesText[1] := 'UN';
        OnesText[2] := 'DEUX';
        OnesText[3] := 'TROIS';
        OnesText[4] := 'QUATRE';
        OnesText[5] := 'CINQ';
        OnesText[6] := 'SIX';
        OnesText[7] := 'SEPT';
        OnesText[8] := 'HUIT';
        OnesText[9] := 'NEUF';
        OnesText[10] := 'DIX';
        OnesText[11] := 'ONZE';
        OnesText[12] := 'DOUZE';
        OnesText[13] := 'TREIZE';
        OnesText[14] := 'QUATORZE';
        OnesText[15] := 'QUINZE';
        OnesText[16] := 'SEIZE';
        OnesText[17] := 'DIX-SEPT';
        OnesText[18] := 'DIX-HUIT';
        OnesText[19] := 'DIX-NEUF';

        TensText[1] := '';
        TensText[2] := 'VINGT';
        TensText[3] := 'TRENTE';
        TensText[4] := 'QUARANTE';
        TensText[5] := 'CINQUANTE';
        TensText[6] := 'SOIXANTE';
        TensText[7] := 'SOIXANTE-DIX';
        TensText[8] := 'QUATRE-VINGT';
        TensText[9] := 'QUATRE-VINGT-DIX';

        ThousText[1] := 'CENT';
        ThousText[2] := 'MILLE';
        ThousText[3] := 'MILLION';
        ThousText[4] := 'MILLIARD';
        ThousText[5] := 'TRILLION';
    end;

    //******************** Customer Legal Mentions Notification *********************************************************
    /// <summary>
    /// OpenCustLedgerEntries.
    /// </summary>
    /// <param name="TradeRegisterNotification">Notification.</param>
    /* procedure OpenCustomersList(TradeRegisterNotification: Notification)
    begin
        Page.Run(22);
    end; */
    /// <summary>
    /// OpenCustomersList.
    /// </summary>
    /// <param name="TradeRegisterNotification">Notification.</param>
    procedure OpenCustomersListTradeRegister(TradeRegisterNotification: Notification)
    var
        CurrentTradeRegister: Text;
        TradeRegisterFilter: Text;
        Customers: Record Customer;
    begin
        TradeRegisterFilter := TradeRegisterNotification.GetData(CurrentTradeRegister);
        Customers.Reset();
        Customers.SetRange(ISA_TradeRegister, TradeRegisterFilter);
        Page.Run(22, Customers);
    end;
    //************************************************************
    /// <summary>
    /// OpenCustomersListFiscalID.
    /// </summary>
    /// <param name="FiscalIDNotification">Notification.</param>
    procedure OpenCustomersListFiscalID(FiscalIDNotification: Notification)
    var
        CurrentFiscalID: Text;
        FiscalIDFilter: Text;
        Customers: Record Customer;
    begin
        FiscalIDFilter := FiscalIDNotification.GetData(CurrentFiscalID);
        Customers.Reset();
        Customers.SetRange(ISA_FiscalID, FiscalIDFilter);
        Page.Run(22, Customers);
    end;
    //*********************************************************************
    /// <summary>
    /// OpenCustomersListStatisticalID.
    /// </summary>
    /// <param name="StatisticalIDNotification">Notification.</param>
    procedure OpenCustomersListStatisticalID(StatisticalIDNotification: Notification)
    var
        CurrentStatisticalID: Text;
        StatisticalIDFilter: Text;
        Customers: Record Customer;
    begin
        StatisticalIDFilter := StatisticalIDNotification.GetData(CurrentStatisticalID);
        Customers.Reset();
        Customers.SetRange(ISA_StatisticalID, StatisticalIDFilter);
        Page.Run(22, Customers);
    end;
    //*********************************************************************
    /// <summary>
    /// OpenCustomersListItemNumber.
    /// </summary>
    /// <param name="ItemNumberNotification">Notification.</param>
    procedure OpenCustomersListItemNumber(ItemNumberNotification: Notification)
    var
        CurrentItemNumber: Text;
        ItemNumberFilter: Text;
        Customers: Record Customer;
    begin
        ItemNumberFilter := ItemNumberNotification.GetData(CurrentItemNumber);
        Customers.Reset();
        Customers.SetRange(ISA_ItemNumber, ItemNumberFilter);
        Page.Run(22, Customers);
    end;
    //******************** Vendor Legal Mentions Notification *********************************************************
    /// <summary>
    /// OpenVendorsListItemNumber.
    /// </summary>
    /// <param name="ItemNumberNotification">Notification.</param>
    procedure OpenVendorsListItemNumber(ItemNumberNotification: Notification)
    var
        CurrentItemNumber: Text;
        ItemNumberFilter: Text;
        Vendors: Record Vendor;
    begin
        ItemNumberFilter := ItemNumberNotification.GetData(CurrentItemNumber);
        Vendors.Reset();
        Vendors.SetRange(ISA_ItemNumber, ItemNumberFilter);
        Page.Run(27, Vendors);
    end;
    //*********************************************************************
    /// <summary>
    /// OpenVendorsListStatisticalID.
    /// </summary>
    /// <param name="StatisticalIDNotification">Notification.</param>
    procedure OpenVendorsListStatisticalID(StatisticalIDNotification: Notification)
    var
        CurrentStatisticalID: Text;
        StatisticalIDFilter: Text;
        Vendors: Record Vendor;
    begin
        StatisticalIDFilter := StatisticalIDNotification.GetData(CurrentStatisticalID);
        Vendors.Reset();
        Vendors.SetRange(ISA_StatisticalID, StatisticalIDFilter);
        Page.Run(27, Vendors);
    end;
    //*********************************************************************
    /// <summary>
    /// OpenVendorsListFiscalID.
    /// </summary>
    /// <param name="FiscalIDNotification">Notification.</param>
    procedure OpenVendorsListFiscalID(FiscalIDNotification: Notification)
    var
        CurrentFiscalID: Text;
        FiscalIDFilter: Text;
        Vendors: Record Vendor;
    begin
        FiscalIDFilter := FiscalIDNotification.GetData(CurrentFiscalID);
        Vendors.Reset();
        Vendors.SetRange(ISA_FiscalID, FiscalIDFilter);
        Page.Run(27, Vendors);
    end;
    //*********************************************************************
    /// <summary>
    /// OpenVendorsListTradeRegister.
    /// </summary>
    /// <param name="TradeRegisterNotification">Notification.</param>
    procedure OpenVendorsListTradeRegister(TradeRegisterNotification: Notification)
    var
        CurrentTradeRegister: Text;
        TradeRegisterFilter: Text;
        Vendors: Record Vendor;
    begin
        TradeRegisterFilter := TradeRegisterNotification.GetData(CurrentTradeRegister);
        Vendors.Reset();
        Vendors.SetRange(ISA_TradeRegister, TradeRegisterFilter);
        Page.Run(27, Vendors);
    end;
    //*********************************************************************************************************
    var
        SrcCode: Code[10];
        SrcCodeSetup: Record "Source Code Setup";
        SalesAndRec: Record "Sales & Receivables Setup";
        GEL: Record "G/L Entry";
        SalesInvHeader: Record "Sales Invoice Header";

        AmountCustomer: Decimal;
        ISA_SalesComments: Record "Sales Comment Line";
        OnesText: array[20] of Text[3000];
        TensText: array[10] of Text[3000];
        ThousText: array[10] of Text[3000];
        ISA_AmountInWords: Text[3000];
        DecimalInWords: Text[3000];
        WholeInWords: Text[3000];
        WholePart: Integer;
        DecimalPart: Integer;


}