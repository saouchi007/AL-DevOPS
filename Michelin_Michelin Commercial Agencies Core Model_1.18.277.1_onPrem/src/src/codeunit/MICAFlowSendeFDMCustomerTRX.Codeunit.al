codeunit 82280 "MICA Flow Send eFDMCustomerTRX"
{
    //FDM002
    TableNo = "MICA Flow";

    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SellToCustomer: Record Customer;
        BillToCustomer: Record Customer;
        Currency: Record Currency;
        Location: Record Location;
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempBlob: Codeunit "Temp Blob";
        ExportedRecordCount: Integer;
        FileDateTime: DateTime;
        NetAmt: Decimal;
        NetAmtVat: Decimal;
        TopDiscount: Decimal;

        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        UnableToCreateErr: Label 'Unable to create Flow Entry';
        StartPreparingMsg: Label 'Start Preparing Data';
        FieldSeparatorLbl: label ';', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        MissingCurrencyMsg: Label 'Missing value for LCY Code in General Ledger Setup';
        DateFilterMsg: Label 'Parameter value: %1, for Parameter: %2, is not valid.';
        ParamValue_NAME: Text;
        ParamValue_INSTANCE: Text;
        ParamValue_HEADERFILE: Text;
        ParamValue_APPLICATION: Text;
        ParamValue_FLOWNAME: Text;
        ParamValue_APPMODE: Text;
        ParamValue_HEADERBLOCK: Text;
        ParamValue_BLOCKNAME: Text;
        ParamValue_FOOTERBLOCK: Text;
        ParamValue_FOOTERFILE: Text;
        ParamValue_RECORDIDENTIFIER: Text;
        ParamValue_INTERCOMPANYDIM: Text;
        ParamValue_FileExtension: Text;
        ParamValue_DateFilter: Text;
        ParamValue_FileName: Text;
        Uniquekey: Text;
        Param_NAMETok: Label 'NAME', Locked = true;
        Param_INSTANCETok: Label 'INSTANCE', Locked = true;
        Param_HEADERFILETok: Label 'HEADERFILE', Locked = true;
        Param_APPLICATIONTok: Label 'APPLICATION', Locked = true;
        Param_FLOWNAMETok: Label 'FLOWNAME', Locked = true;
        Param_APPMODETok: Label 'APPMODE', Locked = true;
        Param_HEADERBLOCKTok: Label 'HEADERBLOCK', Locked = true;
        Param_BLOCKNAMETok: Label 'BLOCKNAME', Locked = true;
        Param_FOOTERBLOCKTok: Label 'FOOTERBLOCK', Locked = true;
        Param_FOOTERFILETok: Label 'FOOTERFILE', Locked = true;
        Param_RECORDIDENTIFIERTok: Label 'RECORDIDENTIFIER', Locked = true;
        Param_INTERCOMPANYDIMTok: Label 'INTERCOMPANYDIM', Locked = true;
        Param_FileExtensionLbl: Label 'FILEEXTENSION', Locked = true;
        Param_DateFilterLbl: Label 'DATEFILTER', Locked = true;
        Param_FileNameTok: Label 'FILENAME', Locked = true;
        MissingFieldValueTxt: Label 'Missing Value for %1. ';
        MissingFieldValueKeyTxt: Label '%1 is empty in the record %2 where: %3';
        DocKeyTxt: Label 'Document No: %1, Line No: %2';
        NoKeyTxt: Label 'No: %1', Locked = true;
        DimSetEntryKeyTxt: Label 'Dimension Set ID: %1, Dimension Code: %2';
        ShipToAddressKeyTxt: Label 'Code: %1, Customer No: %2';
        OrganizationCodeTok: Label 'ORGANIZATION CODE', Locked = true;
        CustomerCountryTok: Label 'CUSTOMER_COUNTRY', Locked = true;
        CustLegalEntityCodeTok: Label 'CUSTOMER_LEGAL_ENTITY_CODE', Locked = true;
        SellToCustCodeTok: Label 'SELL_TO_CUSTOMER_CODE', Locked = true;
        BillToCustCodeTok: Label 'BILL_TO_CUSTOMER_CODE', Locked = true;
        ShipToCustCodeTok: Label 'SHIP_TO_CUSTOMER_CODE', Locked = true;
        DocPostingDateTok: Label 'DOCUMENT_POSTING_DATE', Locked = true;
        DocCurrencyTok: Label 'DOCUMENT_CURRENCY', Locked = true;
        TrxLineUnitSellingPriceTok: Label 'TRX_LINE_UNIT_SELLING_PRICE', Locked = true;
        IntercompanyCodeTok: Label 'INTERCOMPANY_CODE', Locked = true;

    trigger OnRun()
    begin
        CompanyInformation.Get();
        CountryRegion.Get(CompanyInformation."Country/Region Code");
        MICAFinancialReportingSetup.Get();
        CheckIfFieldIsEmpty(
            MICAFinancialReportingSetup."Company Code",
            StrSubstNo(MissingFieldValueTxt, OrganizationCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                MICAFinancialReportingSetup.FieldCaption("Company Code"),
                MICAFinancialReportingSetup.TableCaption(),
                ''));
        GeneralLedgerSetup.Get();
        CheckIfFieldIsEmpty(
            GeneralLedgerSetup."LCY Code",
            StrSubstNo(MissingFieldValueTxt, DocCurrencyTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                GeneralLedgerSetup.FieldCaption("LCY Code"),
                GeneralLedgerSetup.TableCaption(),
                ''));
        FileDateTime := CurrentDateTime();
        CustomerTRXExport(Rec);
    end;

    local procedure CustomerTRXExport(MICAFlow: Record "MICA Flow")
    var
        InvLinesExist: Boolean;
        CrMemoLinesExist: Boolean;
        BaseDate: Date;
        OutStream: OutStream;
        InStream: InStream;
        InvoiceLineLbl: Label '<CM-%1M+1D>', Comment = '%1', Locked = true;
    begin
        If not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
            MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, UnableToCreateErr, '');
            exit;
        end;
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartPreparingMsg, ''));

        if GeneralLedgerSetup."LCY Code" = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingCurrencyMsg), '');

        CheckAndRetrieveParameters();
        if ParamValue_DateFilter <> '' then
            if not ValidDateFilter(ParamValue_DateFilter) then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(DateFilterMsg, ParamValue_DateFilter, Param_DateFilterLbl), '');
                exit;
            end;

        GenerateUniqueKey();
        MICAFlowEntry.Description := CopyStr(GenerateFileName(), 1, MaxStrLen(MICAFlowEntry.Description));

        BaseDate := WorkDate();
        if ParamValue_DateFilter = '' then
            SalesInvoiceLine.SetRange("Posting Date", CalcDate(StrSubstNo(InvoiceLineLbl, ParamMICAFlowSetup.GetFlowIntParam(MICAFlow.Code, 'MONTHS') + 1), BaseDate), CalcDate('<CM>', BaseDate))
        else
            SalesInvoiceLine.SetFilter("Posting Date", ParamValue_DateFilter);
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        InvLinesExist := SalesInvoiceLine.FindSet(false);
        if ParamValue_DateFilter = '' then
            SalesCrMemoLine.Setrange("Posting Date", CalcDate(StrSubstNo(InvoiceLineLbl, ParamMICAFlowSetup.GetFlowIntParam(MICAFlow.Code, 'MONTHS') + 1), BaseDate), CalcDate('<CM>', BaseDate))
        else
            SalesCrMemoLine.SetFilter("Posting Date", ParamValue_DateFilter);
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
        CrMemoLinesExist := SalesCrMemoLine.FindSet(false);

        if InvLinesExist or CrMemoLinesExist then begin
            TempBlob.CreateOutStream(OutStream);
            OutStream.WriteText(Header() + MICAFlow.GetCRLF());
            OutStream.WriteText(HeaderDataBlock() + MICAFlow.GetCRLF());
            // TempBlob.WriteTextLine(Header() + Flow.GetCRLF());
            // TempBlob.WriteTextLine(HeaderDataBlock() + Flow.GetCRLF());
            if InvLinesExist then
                repeat
                    GetInvoiceHeader(SalesInvoiceLine."Document No.");
                    GetCustomer(SalesInvoiceHeader."Bill-to Customer No.", SalesInvoiceHeader."Sell-to Customer No.", SalesInvoiceHeader."Currency Code");
                    GetItem(SalesInvoiceLine."No.");
                    GetLocation(SalesInvoiceLine."Location Code");
                    OutStream.WriteText(InvoiceLineBlock() + MICAFlow.GetCRLF());
                    // TempBlob.WriteTextLine(InvoiceLineBlock() + Flow.GetCRLF());
                    ExportedRecordCount += 1;
                until SalesInvoiceLine.Next() = 0;
            if CrMemoLinesExist then
                repeat
                    GetCrMemoHeader(SalesCrMemoLine."Document No.");
                    GetCustomer(SalesCrMemoHeader."Bill-to Customer No.", SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Currency Code");
                    GetItem(SalesCrMemoLine."No.");
                    GetLocation(SalesCrMemoLine."Location Code");
                    OutStream.WriteText(CrMemoLineBlock() + MICAFlow.GetCRLF());
                    // TempBlob.WriteTextLine(CrMemoLineBlock() + Flow.GetCRLF());
                    ExportedRecordCount += 1;
                until SalesCrMemoLine.Next() = 0;
            OutStream.WriteText(FooterDataBlock() + MICAFlow.GetCRLF());
            OutStream.WriteText(Footer());
            // TempBlob.WriteTextLine(FooterDataBlock() + Flow.GetCRLF());
            // TempBlob.WriteTextLine(Footer());
        end;
        // Update Blob with exported data
        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_NAMETok, ParamValue_NAME, true);
        CheckPrerequisitesAndRetrieveParameters(Param_INSTANCETok, ParamValue_INSTANCE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HEADERFILETok, ParamValue_HEADERFILE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_APPLICATIONTok, ParamValue_APPLICATION, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FLOWNAMETok, ParamValue_FLOWNAME, true);
        CheckPrerequisitesAndRetrieveParameters(Param_APPMODETok, ParamValue_APPMODE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HEADERBLOCKTok, ParamValue_HEADERBLOCK, true);
        CheckPrerequisitesAndRetrieveParameters(Param_BLOCKNAMETok, ParamValue_BLOCKNAME, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FOOTERBLOCKTok, ParamValue_FOOTERBLOCK, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FOOTERFILETok, ParamValue_FOOTERFILE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_RECORDIDENTIFIERTok, ParamValue_RECORDIDENTIFIER, true);
        CheckPrerequisitesAndRetrieveParameters(Param_INTERCOMPANYDIMTok, ParamValue_INTERCOMPANYDIM, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FileExtensionLbl, ParamValue_FileExtension, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DateFilterLbl, ParamValue_DateFilter, false);
        CheckPrerequisitesAndRetrieveParameters(Param_FileNameTok, ParamValue_FileName, true);
    end;

    [TryFunction]
    local procedure ValidDateFilter(var DateFilter: Text)
    var
        LocalItem: Record Item;
        TextMgtFilterTokens: Codeunit "Filter Tokens";
    begin
        TextMgtFilterTokens.MakeDateFilter(DateFilter);
        LocalItem.SETFILTER("Date Filter", DateFilter);
        DateFilter := LocalItem.GETFILTER("Date Filter");
    end;

    local procedure CheckInvoiceMandatoryFields(SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceLine: Record "Sales Invoice Line"; ShiptoAddress: Record "Ship-to Address"; DimensionSetEntry: Record "Dimension Set Entry")
    begin
        CheckIfFieldIsEmpty(
            CountryRegion."ISO Code",
            StrSubstNo(MissingFieldValueTxt, CustomerCountryTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                CountryRegion.FieldCaption(CountryRegion."ISO Code"),
                CountryRegion.TableCaption(),
                StrSubstNo(NoKeyTxt, CountryRegion.Code)));
        CheckIfFieldIsEmpty(
            BilltoCustomer."MICA MDM ID LE",
            StrSubstNo(MissingFieldValueTxt, CustLegalEntityCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                BilltoCustomer.FieldCaption("MICA MDM ID LE"),
                BilltoCustomer.TableCaption(),
                StrSubstNo(NoKeyTxt, BillToCustomer."No.")));
        CheckIfFieldIsEmpty(
            SelltoCustomer."MICA MDM ID LE",
            StrSubstNo(MissingFieldValueTxt, SellToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SelltoCustomer.FieldCaption("MICA MDM ID LE"),
                SelltoCustomer.TableCaption(),
                StrSubstNo(NoKeyTxt, SelltoCustomer."No.")));
        CheckIfFieldIsEmpty(
            BillToCustomer."MICA MDM ID BT",
            StrSubstNo(MissingFieldValueTxt, BillToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                BillToCustomer.FieldCaption("MICA MDM ID BT"),
                BillToCustomer.TableCaption(),
                StrSubstNo(NoKeyTxt, BillToCustomer."No.")));
        CheckIfFieldIsEmpty(
            ShiptoAddress."MICA MDM ID",
            StrSubstNo(MissingFieldValueTxt, ShipToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                ShiptoAddress.FieldCaption("MICA MDM ID"),
                ShiptoAddress.TableCaption(),
                StrSubstNo(ShipToAddressKeyTxt, SalesInvoiceHeader."Ship-to Code", SellToCustomer."No.")));
        CheckIfFieldIsEmpty(
            Format(SalesInvoiceHeader."Posting Date"),
            StrSubstNo(MissingFieldValueTxt, DocPostingDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesInvoiceHeader.FieldCaption("Posting Date"),
                SalesInvoiceHeader.TableCaption(),
                StrSubstNo(DocKeyTxt, SalesInvoiceHeader."No.", 0)));
        CheckIfFieldIsEmpty(
            Format(SalesInvoiceLine."Unit Price"),
            StrSubstNo(MissingFieldValueTxt, TrxLineUnitSellingPriceTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesInvoiceLine.FieldCaption("Unit Price"),
                SalesInvoiceLine.TableCaption(),
                StrSubstNo(DocKeyTxt, SalesInvoiceHeader."No.", SalesInvoiceLine."Line No.")));
        CheckIfFieldIsEmpty(
            Format(SalesInvoiceLine."Unit Price"),
            StrSubstNo(MissingFieldValueTxt, TrxLineUnitSellingPriceTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesInvoiceLine.FieldCaption("Unit Price"),
                SalesInvoiceLine.TableCaption(),
                StrSubstNo(DocKeyTxt, SalesInvoiceHeader."No.", SalesInvoiceLine."Line No.")));
        CheckIfFieldIsEmpty(
            DimensionSetEntry."Dimension Value Code",
            StrSubstNo(MissingFieldValueTxt, IntercompanyCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                DimensionSetEntry.FieldCaption("Dimension Value Code"),
                DimensionSetEntry.TableCaption(),
                StrSubstNo(DimSetEntryKeyTxt, DimensionSetEntry."Dimension Set ID", DimensionSetEntry."Dimension Code")));
    end;

    local procedure CheckCreditMemoMandatoryFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesCrMemoLine: Record "Sales Cr.Memo Line"; DimensionSetEntry: Record "Dimension Set Entry")
    begin
        CheckIfFieldIsEmpty(
            CountryRegion."ISO Code",
            StrSubstNo(MissingFieldValueTxt, CustomerCountryTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                CountryRegion.FieldCaption(CountryRegion."ISO Code"),
                CountryRegion.TableCaption(),
                StrSubstNo(NoKeyTxt, CountryRegion.Code)));
        CheckIfFieldIsEmpty(
            BilltoCustomer."MICA MDM ID LE",
            StrSubstNo(MissingFieldValueTxt, CustLegalEntityCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                BilltoCustomer.FieldCaption("MICA MDM ID LE"),
                BilltoCustomer.TableCaption(),
                StrSubstNo(NoKeyTxt, BillToCustomer."No.")));
        CheckIfFieldIsEmpty(
            SelltoCustomer."MICA MDM ID LE",
            StrSubstNo(MissingFieldValueTxt, SellToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SelltoCustomer.FieldCaption("MICA MDM ID LE"),
                SelltoCustomer.TableCaption(),
                StrSubstNo(NoKeyTxt, SelltoCustomer."No.")));
        CheckIfFieldIsEmpty(
            BillToCustomer."MICA MDM ID BT",
            StrSubstNo(MissingFieldValueTxt, BillToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                BillToCustomer.FieldCaption("MICA MDM ID BT"),
                BillToCustomer.TableCaption(),
                StrSubstNo(NoKeyTxt, BillToCustomer."No.")));
        CheckIfFieldIsEmpty(
            Format(SalesCrMemoHeader."Posting Date"),
            StrSubstNo(MissingFieldValueTxt, DocPostingDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesCrMemoHeader.FieldCaption("Posting Date"),
                SalesCrMemoHeader.TableCaption(),
                StrSubstNo(DocKeyTxt, SalesCrMemoHeader."No.", 0)));
        CheckIfFieldIsEmpty(
            Format(SalesCrMemoLine."Unit Price"),
            StrSubstNo(MissingFieldValueTxt, TrxLineUnitSellingPriceTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesCrMemoLine.FieldCaption("Unit Price"),
                SalesCrMemoLine.TableCaption(),
                StrSubstNo(DocKeyTxt, SalesCrMemoHeader."No.", SalesCrMemoLine."Line No.")));
        CheckIfFieldIsEmpty(
            DimensionSetEntry."Dimension Value Code",
            StrSubstNo(MissingFieldValueTxt, IntercompanyCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                DimensionSetEntry.FieldCaption("Dimension Value Code"),
                DimensionSetEntry.TableCaption(),
                StrSubstNo(DimSetEntryKeyTxt, DimensionSetEntry."Dimension Set ID", DimensionSetEntry."Dimension Code")));
    end;

    procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text; Mandatory: Boolean)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if (ParamValue = '') and Mandatory then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

    local procedure Header() FormattedText: Text
    var
        FileDate: Text[14];
        StrSubstNo1Lbl: Label '%1_%2', Comment = '%1%2', Locked = true;
        StrSubstNo2Lbl: Label '%1_%2_%3', Comment = '%1%2%3', Locked = true;
    begin
        FileDate := Format(FileDateTime, 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');

        FormattedText := ParamValue_HEADERFILE + FieldSeparatorLbl;
        FormattedText += ParamValue_APPLICATION + FieldSeparatorLbl;
        FormattedText += StrSubstNo(StrSubstNo1Lbl, ParamValue_INSTANCE, CompanyInformation."Country/Region Code") + FieldSeparatorLbl;
        FormattedText += ParamValue_FLOWNAME + FieldSeparatorLbl;
        FormattedText += ParamValue_APPMODE + FieldSeparatorLbl;
        FormattedText += Format(FileDateTime, 20, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z') + FieldSeparatorLbl;
        FormattedText += Uniquekey + FieldSeparatorLbl;
        FormattedText += StrSubstNo(StrSubstNo2Lbl, ParamValue_APPLICATION, CompanyInformation."Country/Region Code", MICAFinancialReportingSetup."Company Code") + FieldSeparatorLbl;
        FormattedText += Format(FileDateTime, 20, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z') + FieldSeparatorLbl;
        FormattedText += GenerateFileName();
    end;

    local procedure HeaderDataBlock() FormattedText: Text
    begin
        FormattedText := ParamValue_HEADERBLOCK + FieldSeparatorLbl;
        FormattedText += ParamValue_BLOCKNAME;
    end;

    local procedure InvoiceLineBlock() FormattedText: Text
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        ShiptoAddress: Record "Ship-to Address";
        ShipToCode: Code[10];
    begin
        GetShipToCodeFromSalesOrder(ShipToCode, SalesInvoiceLine."Order No.");
        FormattedText := ParamValue_RECORDIDENTIFIER + FieldSeparatorLbl;
        FormattedText += MICAFinancialReportingSetup."Company Code" + FieldSeparatorLbl;
        if SalesInvoiceHeader."Ship-to Country/Region Code" = '' then
            GetCountry(SalesInvoiceHeader."Sell-to Country/Region Code")
        else
            GetCountry(SalesInvoiceHeader."Ship-to Country/Region Code");
        FormattedText += CountryRegion."ISO Code" + FieldSeparatorLbl;

        BillToCustomer.Get(SalesInvoiceHeader."Bill-to Customer No.");
        SellToCustomer.Get(SalesInvoiceHeader."Sell-to Customer No.");
        FormattedText += BilltoCustomer."MICA MDM ID LE" + FieldSeparatorLbl;
        FormattedText += SelltoCustomer."MICA MDM ID BT" + FieldSeparatorLbl;
        FormattedText += BillToCustomer."MICA MDM ID LE" + FieldSeparatorLbl;

        if SalesInvoiceHeader."Ship-to Code" <> '' then begin
            if ShiptoAddress.Get(SellToCustomer."No.", SalesInvoiceHeader."Ship-to Code") then;
        end else
            if ShiptoAddress.Get(SellToCustomer."No.", ShipToCode) then;
        if ShiptoAddress."MICA MDM ID" <> '' then
            FormattedText += ShiptoAddress."MICA MDM ID" + FieldSeparatorLbl
        else
            FormattedText += FieldSeparatorLbl;

        FormattedText += SalesInvoiceLine."Document No." + FieldSeparatorLbl;
        FormattedText += FormatInteger(SalesInvoiceLine."Line No.") + FieldSeparatorLbl;
        if SalesInvoiceHeader."Document Date" = 0D then
            FormattedText += Format(SalesInvoiceHeader."Posting Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl
        else
            FormattedText += Format(SalesInvoiceHeader."Document Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl;
        FormattedText += Format(SalesInvoiceHeader."Posting Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl;
        FormattedText += 'Invoice' + FieldSeparatorLbl;
        if SalesInvoiceHeader."Currency Code" <> '' then
            FormattedText += SalesInvoiceHeader."Currency Code" + FieldSeparatorLbl
        else
            FormattedText += GeneralLedgerSetup."LCY Code" + FieldSeparatorLbl;
        FormattedText += FieldSeparatorLbl;
        FormattedText += FormatDecimal(NetAmt + TopDiscount, true) + FieldSeparatorLbl; //Document_Gross_Amt
        FormattedText += FormatDecimal(TopDiscount, true) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(NetAmt, true) + FieldSeparatorLbl; //Net_Amt
        FormattedText += FormatDecimal(NetAmtVat, true) + FieldSeparatorLbl; //Net_Amt_Vat
        FormattedText += SalesInvoiceLine."No." + FieldSeparatorLbl;
        FormattedText += SalesInvoiceLine.Description + SalesInvoiceLine."Description 2" + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesInvoiceLine.Quantity, false) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesInvoiceLine."Unit Price", true) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price", true) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesInvoiceLine."Amount Including VAT", true) + FieldSeparatorLbl;
        FormattedText += BillToCustomer."MICA Market Code" + FieldSeparatorLbl;
        FormattedText += GetForecastCode(SalesInvoiceLine."Bill-to Customer No.") + FieldSeparatorLbl; //FORECAST_CUSTOMER_CODE
        FormattedText += FieldSeparatorLbl; //BUSINESS_LINE
        FormattedText += Format(SalesInvoiceHeader."Order Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl;
        FormattedText += SalesInvoiceLine."Order No." + FieldSeparatorLbl;
        FormattedText += FormatInteger(SalesInvoiceLine."Order Line No.") + FieldSeparatorLbl;

        if DimensionSetEntry.Get(SalesInvoiceLine."Dimension Set ID", ParamValue_INTERCOMPANYDIM) then
            FormattedText += DimensionSetEntry."Dimension Value Code" + FieldSeparatorLbl
        else
            FormattedText += FieldSeparatorLbl;

        FormattedText += SalesInvoiceLine."MICA 3PL Country Of Origin" + FieldSeparatorLbl;
        FormattedText += SalesInvoiceLine."MICA 3PL DOT Value" + FieldSeparatorLbl;
        FormattedText += Item."Item Category Code" + FieldSeparatorLbl;
        FormattedText += GetCustomerUseID(SalesInvoiceLine."Bill-to Customer No.") + FieldSeparatorLbl;
        FormattedText += GetAddressUseID(ShipToCode, SalesInvoiceLine."Sell-to Customer No.") + FieldSeparatorLbl;
        CheckInvoiceMandatoryFields(SalesInvoiceHeader, SalesInvoiceLine, ShiptoAddress, DimensionSetEntry);
    end;

    local procedure GetShipToCodeFromSalesOrder(var ShipToCode: Code[10]; SalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        Clear(ShipToCode);
        if SalesOrderNo = '' then
            exit;
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then begin
            SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
            SalesHeaderArchive.SetRange("No.", SalesOrderNo);
            if SalesHeaderArchive.FindLast() then
                ShipToCode := SalesHeaderArchive."Ship-to Code";
            exit;
        end;
        ShipToCode := SalesHeader."Ship-to Code"
    end;

    local procedure CrMemoLineBlock() FormattedText: Text
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        FormattedText := ParamValue_RECORDIDENTIFIER + FieldSeparatorLbl;
        FormattedText += MICAFinancialReportingSetup."Company Code" + FieldSeparatorLbl;
        if SalesCrMemoHeader."Ship-to Country/Region Code" = '' then
            GetCountry(SalesCrMemoHeader."Sell-to Country/Region Code")
        else
            GetCountry(SalesCrMemoHeader."Ship-to Country/Region Code");
        FormattedText += CountryRegion."ISO Code" + FieldSeparatorLbl;
        BillToCustomer.Get(SalesCrMemoHeader."Bill-to Customer No.");
        SellToCustomer.Get(SalesCrMemoHeader."Sell-to Customer No.");
        FormattedText += BilltoCustomer."MICA MDM ID LE" + FieldSeparatorLbl;
        FormattedText += SelltoCustomer."MICA MDM ID BT" + FieldSeparatorLbl;
        FormattedText += BillToCustomer."MICA MDM ID LE" + FieldSeparatorLbl;
        FormattedText += FieldSeparatorLbl;
        FormattedText += SalesCrMemoLine."Document No." + FieldSeparatorLbl;
        FormattedText += FormatInteger(SalesCrMemoLine."Line No.") + FieldSeparatorLbl;
        if SalesCrMemoHeader."Document Date" = 0D then
            FormattedText += Format(SalesCrMemoHeader."Posting Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl
        else
            FormattedText += Format(SalesCrMemoHeader."Document Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl;
        FormattedText += Format(SalesCrMemoHeader."Posting Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl;
        FormattedText += 'Credit Memo' + FieldSeparatorLbl;
        if SalesCrMemoHeader."Currency Code" <> '' then
            FormattedText += SalesCrMemoHeader."Currency Code" + FieldSeparatorLbl
        else
            FormattedText += GeneralLedgerSetup."LCY Code" + FieldSeparatorLbl;
        FormattedText += FieldSeparatorLbl;
        FormattedText += FormatDecimal(NetAmt + TopDiscount, true) + FieldSeparatorLbl; //Document_Gross_Amt
        FormattedText += FormatDecimal(TopDiscount, true) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(NetAmt, true) + FieldSeparatorLbl; //Net_Amt
        FormattedText += FormatDecimal(NetAmtVat, true) + FieldSeparatorLbl; //Net_Amt_Vat
        FormattedText += SalesCrMemoLine."No." + FieldSeparatorLbl;
        FormattedText += SalesCrMemoLine.Description + SalesCrMemoLine."Description 2" + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesCrMemoLine.Quantity, false) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesCrMemoLine."Unit Price", true) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price", true) + FieldSeparatorLbl;
        FormattedText += FormatDecimal(SalesCrMemoLine."Amount Including VAT", true) + FieldSeparatorLbl;
        FormattedText += BillToCustomer."MICA Market Code" + FieldSeparatorLbl;
        FormattedText += GetForecastCode(SalesCrMemoLine."Bill-to Customer No.") + FieldSeparatorLbl; //FORECAST_CUSTOMER_CODE
        FormattedText += FieldSeparatorLbl; //BUSINESS_LINE
        FormattedText += Format(SalesCrMemoHeader."Posting Date", 20, '<Year4>-<Month,2>-<Day,2>T00:00:00Z') + FieldSeparatorLbl;
        FormattedText += SalesCrMemoLine."Order No." + FieldSeparatorLbl;
        FormattedText += FormatInteger(SalesCrMemoLine."Order Line No.") + FieldSeparatorLbl;

        if DimensionSetEntry.Get(SalesCrMemoLine."Dimension Set ID", ParamValue_INTERCOMPANYDIM) then
            FormattedText += DimensionSetEntry."Dimension Value Code" + FieldSeparatorLbl
        else
            FormattedText += FieldSeparatorLbl;

        FormattedText += SalesCrMemoLine."MICA 3PL Country Of Origin" + FieldSeparatorLbl;
        FormattedText += SalesCrMemoLine."MICA 3PL DOT Value" + FieldSeparatorLbl;
        FormattedText += Item."Item Category Code" + FieldSeparatorLbl;
        FormattedText += GetCustomerUseID(SalesCrMemoLine."Bill-to Customer No.") + FieldSeparatorLbl;
        FormattedText += FieldSeparatorLbl;
        CheckCreditMemoMandatoryFields(SalesCrMemoHeader, SalesCrMemoLine, DimensionSetEntry);
    end;

    local procedure FooterDataBlock() FormattedText: Text
    begin
        FormattedText := ParamValue_FOOTERBLOCK + FieldSeparatorLbl;
        FormattedText += ParamValue_BLOCKNAME + FieldSeparatorLbl;
        FormattedText += DelChr(Format(ExportedRecordCount, 15, 1), '<');
    end;

    local procedure Footer() FormattedText: Text
    begin
        FormattedText := ParamValue_FOOTERFILE + FieldSeparatorLbl;
        FormattedText += DelChr(Format(ExportedRecordCount + 2, 15, 1), '<');
    end;

    local procedure GetInvoiceHeader(DocNo: Code[20])
    var
        FoundSalesInvoiceLine: Record "Sales Invoice Line";
        MICAPostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
        TotlaDiscProc: Decimal;
    begin
        if SalesInvoiceHeader."No." <> DocNo then begin
            SalesInvoiceHeader.Get(DocNo);
            NetAmt := 0;
            NetAmtVat := 0;
            TopDiscount := 0;
            FoundSalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
            FoundSalesInvoiceLine.SETRANGE(Type, FoundSalesInvoiceLine.Type::Item);
            IF FoundSalesInvoiceLine.FindSet(false) THEN
                REPEAT
                    NetAmt += FoundSalesInvoiceLine.Amount;
                    NetAmtVat += FoundSalesInvoiceLine."Amount Including VAT";

                    MICAPostedAppliedSLDisc.SetCurrentKey("Posted Document Type", "Posted Document No.", "Posted Document Line No.", "Rebates Type");
                    MICAPostedAppliedSLDisc.SetRange("Posted Document Type", MICAPostedAppliedSLDisc."Posted Document Type"::Invoice);
                    MICAPostedAppliedSLDisc.SetRange("Posted Document No.", FoundSalesInvoiceLine."Document No.");
                    MICAPostedAppliedSLDisc.SetRange("Posted Document Line No.", FoundSalesInvoiceLine."Line No.");
                    MICAPostedAppliedSLDisc.SetRange("Rebates Type", MICAPostedAppliedSLDisc."Rebates Type"::"Payment Terms");
                    if MICAPostedAppliedSLDisc.FindSet(false) then begin
                        TotlaDiscProc := 0;
                        repeat
                            TotlaDiscProc += MICAPostedAppliedSLDisc."Sales Discount %";
                        until MICAPostedAppliedSLDisc.Next() = 0;
                        TopDiscount += FoundSalesInvoiceLine."Unit Price" * FoundSalesInvoiceLine.Quantity * TotlaDiscProc / 100;
                    end;


                UNTIL FoundSalesInvoiceLine.NEXT() = 0;


        end;
    end;

    local procedure GetCrMemoHeader(DocNo: Code[20])
    var
        FoundSalesCrMemoLine: Record "Sales Cr.Memo Line";
        MICAPostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
        TotlaDiscProc: Decimal;
    begin
        if SalesCrMemoHeader."No." <> DocNo then begin
            SalesCrMemoHeader.Get(DocNo);
            NetAmt := 0;
            NetAmtVat := 0;
            TopDiscount := 0;
            FoundSalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
            FoundSalesCrMemoLine.SETRANGE(Type, FoundSalesCrMemoLine.Type::Item);
            IF FoundSalesCrMemoLine.FindSet(false) THEN
                REPEAT
                    NetAmt += FoundSalesCrMemoLine.Amount;
                    NetAmtVat += FoundSalesCrMemoLine."Amount Including VAT";

                    MICAPostedAppliedSLDisc.SetCurrentKey("Posted Document Type", "Posted Document No.", "Posted Document Line No.", "Rebates Type");
                    MICAPostedAppliedSLDisc.SetRange("Posted Document Type", MICAPostedAppliedSLDisc."Posted Document Type"::"Credit Memo");
                    MICAPostedAppliedSLDisc.SetRange("Posted Document No.", SalesCrMemoLine."Document No.");
                    MICAPostedAppliedSLDisc.SetRange("Posted Document Line No.", SalesCrMemoLine."Line No.");
                    MICAPostedAppliedSLDisc.SetRange("Rebates Type", MICAPostedAppliedSLDisc."Rebates Type"::"Payment Terms");

                    if MICAPostedAppliedSLDisc.FindSet(false) then begin
                        TotlaDiscProc := 0;
                        repeat
                            TotlaDiscProc += MICAPostedAppliedSLDisc."Sales Discount %";
                        until MICAPostedAppliedSLDisc.Next() = 0;
                        TopDiscount += FoundSalesCrMemoLine."Unit Price" * FoundSalesCrMemoLine.Quantity * TotlaDiscProc / 100;
                    end;
                UNTIL FoundSalesCrMemoLine.NEXT() = 0;
        end;
    end;

    local procedure GetForecastCode(CustomerNo: Code[20]): Code[5]
    var
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
    begin
        IF MICAForecastCustomerCode.Get(CustomerNo, Item."Item Category Code") then
            exit(MICAForecastCustomerCode."Forecast Code");
    end;

    local procedure GetCountry(CountryCode: Code[10])
    begin
        if CountryRegion.Code <> CountryCode then
            if not CountryRegion.Get(CountryCode) then
                Clear(CountryRegion);
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if Item."No." <> ItemNo then
            if not Item.Get(ItemNo) then
                Clear(Item);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if Location.Code <> LocationCode then
            if not Location.Get(LocationCode) then
                Clear(Location);
    end;

    local procedure GetCustomer(BillToCustomerNo: Code[20]; SellToCustomerNo: Code[20]; CurrencyCode: Code[10])
    begin
        if BillToCustomerNo <> BillToCustomer."No." then
            if not BillToCustomer.Get(BillToCustomerNo) then
                Clear(BillToCustomer);

        if SellToCustomerNo <> SellToCustomer."No." then
            if not SellToCustomer.Get(SellToCustomerNo) then
                Clear(SellToCustomer);

        if CurrencyCode <> Currency.Code then begin
            Clear(Currency);
            IF CurrencyCode = '' THEN
                currency.InitRoundingPrecision()
            ELSE
                currency.GET(CurrencyCode);
        end;
    end;

    local procedure FormatDecimal(Dec: decimal; AsInteger: Boolean): Text
    begin
        if AsInteger then
            Dec := Round(Dec / Currency."Amount Rounding Precision", 1);
        exit(DelChr(Format(Dec, 15, 1), '<'));
    end;

    local procedure FormatInteger(Int: Integer): Text
    begin
        exit(DelChr(Format(Int, 10, 1), '<'));
    end;

    procedure GenerateFileName(): Text
    var
        FileName: Text;
        FileNameLbl: Label '%1.%2', Comment = '%1%2', Locked = true;
    begin
        FileName := StrSubstNo(FileNameLbl,
                                    CreateFileName(),
                                    ParamValue_FileExtension);
        exit(FileName);
    end;

    local procedure GenerateUniqueKey()
    var
        UniquekeyLbl: Label '%1_%2_%3_%4_%5', Comment = '%1%2%3%4%5', Locked = true;
    begin
        Uniquekey := StrSubstNo(UniquekeyLbl,
                                    ParamValue_NAME,
                                    ParamValue_INSTANCE,
                                    CompanyInformation."Country/Region Code",
                                    MICAFinancialReportingSetup."Company Code",
                                    FORMAT(FileDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'))
    end;

    local procedure CheckIfFieldIsEmpty(FieldValue: Text; Description: Text; Description2: Text)
    begin
        if FieldValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, Description, Description2);
    end;

    local procedure CreateFileName(): Text
    var
        FileName: Text;
    begin
        FileName :=
            StrSubstNo(
                ParamValue_FileName,
                ParamValue_NAME,
                ParamValue_INSTANCE,
                CompanyInformation."Country/Region Code",
                MICAFinancialReportingSetup."Company Code",
                FORMAT(FileDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        exit(FileName);
    end;

    local procedure GetAddressUseID(ShipToAddressCode: Code[20]; CustomerNo: code[20]): Code[40]
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if ShiptoAddress.Get(CustomerNo, ShipToAddressCode) then
            exit(ShiptoAddress."MICA MDM Ship-to Use ID")
        else
            exit('');
    end;

    local procedure GetCustomerUseID(CustomerNo: Code[20]): Code[40]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit(Customer."MICA MDM Bill-to Site Use ID")
        else
            exit('');
    end;
}