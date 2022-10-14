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



    /*--------------------------------------------------------- Transfer Stamp Duty and Amount Including SDuty GLEntries with Service Order ----------------------------------------------*/


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

                //"Document Type" := "Document Type"::Invoice;
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

                //"Document Type" := "Document Type"::Invoice;
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
    procedure InitTextVariable_Old()
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
    /// <summary>
    /// InitTextVariable.
    /// </summary>
    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    begin
        FormatNoTextFR(NoText, No, CurrencyCode);
    end;

    procedure FormatNoTextFR(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;

                if Hundreds = 1 then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027)
                else
                    if Hundreds > 1 then begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                        if (Tens * 10 + Ones) = 0 then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027 + 'S')
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                    end;

                FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

                if PrintExponent and (Exponent > 1) then
                    if ((Hundreds * 100 + Tens * 10 + Ones) > 1) and (Exponent <> 2) then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent] + 'S')
                    else
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);

                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

        if CurrencyCode = '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text10800)
        else begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, UpperCase(Currency.Description));
        end;

        No := No * 100;
        Ones := No mod 10;
        Tens := No div 10;
        FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

        if (CurrencyCode = '') or (CurrencyCode = 'FRF') then
            case true of
                No = 1:
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text10801);
                No > 1:
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text10801 + 'S');
            end;
    end;

    procedure FormatTens(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; Exponent: Integer; Hundreds: Integer; Tens: Integer; Ones: Integer)
    begin
        case Tens of
            9:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10]);
                end;
            8:
                if Ones = 0 then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057 + 'S')
                else begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end;
            7:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text055);
                    if Ones = 1 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10]);
                end;
            2:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text051);
                    if Ones > 0 then begin
                        if Ones = 1 then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    end;
                end;
            1:
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
            0:
                begin
                    if Ones > 0 then
                        if (Ones = 1) and (Hundreds < 1) and (Exponent = 2) then
                            PrintExponent := true
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end;
            else begin
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                if Ones > 0 then begin
                    if Ones = 1 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, 'ET');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end;
            end;
        end;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    var
        SrcCode: Code[10];
        SrcCodeSetup: Record "Source Code Setup";
        SalesAndRec: Record "Sales & Receivables Setup";
        GEL: Record "G/L Entry";
        SalesInvHeader: Record "Sales Invoice Header";

        AmountCustomer: Decimal;
        ISA_SalesComments: Record "Sales Comment Line";
        //OnesText: array[20] of Text[3000];
        //TensText: array[10] of Text[3000];
        ThousText: array[10] of Text[3000];
        ISA_AmountInWords: Text[3000];
        DecimalInWords: Text[3000];
        WholeInWords: Text[3000];
        WholePart: Integer;
        DecimalPart: Integer;

        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\must not be activated when Applies-to ID is specified in the journal lines.';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'CENT';
        Text028: Label 'ET';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'UN';
        Text033: Label 'DEUX';
        Text034: Label 'TROIS';
        Text035: Label 'QUATRE';
        Text036: Label 'CINQ';
        Text037: Label 'SIX';
        Text038: Label 'SEPT';
        Text039: Label 'HUIT';
        Text040: Label 'NEUF';
        Text041: Label 'DIX';
        Text042: Label 'ONZE';
        Text043: Label 'DOUZE';
        Text044: Label 'TREIZE';
        Text045: Label 'QUATORZE';
        Text046: Label 'QUINZE';
        Text047: Label 'SEIZE';
        Text048: Label 'DIX-SEPT';
        Text049: Label 'DIX-HUIT';
        Text050: Label 'DIX-NEUF';
        Text051: Label 'VINGT';
        Text052: Label 'TRENTE';
        Text053: Label 'QUARANTE';
        Text054: Label 'CINQUANTE';
        Text055: Label 'SOIXANTE';
        Text056: Label 'SOIXANTE-DIX';
        Text057: Label 'QUATRE-VINGT';
        Text058: Label 'QUATRE-VINGT';
        Text059: Label 'MILLE';
        Text060: Label 'MILLION';
        Text061: Label 'MILLIARD';
        CompanyInfo: Record "Company Information";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        Employee: Record Employee;
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        CompanyAddr: array[8] of Text[100];
        CheckToAddr: array[8] of Text[100];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Enum "Gen. Journal Account Type";
        BalancingNo: Code[20];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocNo: Text[30];
        ExtDocNo: Text[35];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        AddedRemainingAmount: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        JournalPostingDate: Date;
        i: Integer;
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        LineAmount2: Decimal;
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text065: Label 'Subtotal';
        Text10800: Label 'DINARS';
        Text10801: Label 'CENTIME';
        CheckNoTextCaptionLbl: Label 'Check No.';
        LineAmountCaptionLbl: Label 'Net Amount';
        LineDiscountCaptionLbl: Label 'Discount';
        AmountCaptionLbl: Label 'Amount';
        DocNoCaptionLbl: Label 'Document No.';
        DocDateCaptionLbl: Label 'Document Date';
        CurrencyCodeCaptionLbl: Label 'Currency Code';
        YourDocNoCaptionLbl: Label 'Your Document No.';
        TransportCaptionLbl: Label 'Transport';
        BlockedEmplForCheckErr: Label 'You cannot print check because employee %1 is blocked due to privacy.', Comment = '%1 - Employee no.';
        AlreadyAppliedToEmployeeErr: Label ' is already applied to %1 %2 for employee %3.', Comment = '%1 = Document type, %2 = Document No., %3 = Employee No.';

}