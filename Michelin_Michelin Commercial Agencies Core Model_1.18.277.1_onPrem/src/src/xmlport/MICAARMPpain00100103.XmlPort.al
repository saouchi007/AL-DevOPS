xmlport 81555 "MICA AR MP pain.001.001.03"
{
    Caption = 'Mass Payment pain.001.001.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        tableelement(PaymentJournalLine; "Gen. Journal Line")
        {
            XmlName = 'Document';
            UseTemporary = true;
            tableelement(companyinformation; "Company Information")
            {
                XmlName = 'CstmrCdtTrfInitn';
                textelement(GrpHdr)
                {
                    textelement(messageid)
                    {
                        XmlName = 'MsgId';
                    }
                    textelement(createddatetime)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(nooftransfers)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(CtrlSum)
                    {

                    }
                    textelement(InitgPty)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(initgptyid)
                        {
                            XmlName = 'Id';
                            textelement(initgptyorgid)
                            {
                                XmlName = 'OrgId';
                                textelement(bicorbei)
                                {
                                    XmlName = 'BICOrBEI';
                                    trigger OnBeforePassVariable()
                                    var
                                        WorkString: Text;
                                        PaymentType: Text;
                                    begin
                                        WorkString := paymentexportdata."Payment Type";
                                        PaymentType := WorkString.Split('|').Get(1);
                                        CASE PaymentType of
                                            'DFT':
                                                BICOrBEI := 'BIBMCH22';
                                            'INTERNATIONAL':
                                                BICOrBEI := 'BIBMCH20';
                                        end;
                                    end;
                                }
                            }
                        }
                    }
                }
                tableelement(paymentexportdatagroup; "Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;
                    textelement(PmtInfId)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            PmtInfId := PaymentExportData."Message ID";
                        end;
                    }
                    textelement(PmtMtd)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            PmtMtd := 'TRF';
                        end;
                    }
                    textelement(BtchBookg)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            BtchBookg := 'true';
                        end;
                    }
                    textelement(nooftransfers2)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(CtrlSum2)
                    {
                        XmlName = 'CtrlSum';
                    }
                    textelement(PmtTpInf)
                    {
                        textelement(SvcLvl)
                        {
                            textelement(Cd)
                            {
                                trigger OnBeforePassVariable()
                                var
                                    WorkString: Text;
                                    PaymentType: Text;
                                begin
                                    WorkString := paymentexportdata."Payment Type";
                                    PaymentType := WorkString.Split('|').Get(1);
                                    if paymentexportdata."MICA Payment Priority Code" <> '' then
                                        Cd := paymentexportdata."MICA Payment Priority Code"
                                    else
                                        Cd := 'XXXX';
                                end;
                            }
                        }
                        textelement(LclInstrm)
                        {
                            textelement(Prtry)
                            {
                                trigger OnBeforePassVariable()
                                var
                                    WorkString: Text;
                                    PaymentType: Text;
                                    PaymentCode: Text;
                                begin
                                    WorkString := paymentexportdata."Payment Type";
                                    PaymentType := WorkString.Split('|').Get(1);
                                    PaymentCode := WorkString.Split('|').Get(2);
                                    Prtry := PaymentCode;
                                end;
                            }
                        }
                    }
                    fieldelement(ReqdExctnDt; PaymentExportDataGroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(dbtrpstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(CtryInfoComp; CompanyInformation."Country/Region Code")
                            {
                                XmlName = 'Ctry';
                            }
                            textelement(AdrLine)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    if CompanyInformation.Address <> '' then
                                        AdrLine := CompanyInformation.Address
                                    else
                                        AdrLine := 'null';
                                end;
                            }
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrother)
                            {
                                XmlName = 'Othr';
                                fieldelement(Id; PaymentExportDataGroup."Sender Bank Account No.")
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                }
                            }
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BIC; PaymentExportDataGroup."Sender Bank BIC")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                            textelement(PstlAdr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(CtryInfoComp2; PaymentExportDataGroup."Sender Bank Country/Region")
                                {
                                    XmlName = 'Ctry';
                                }
                            }
                        }
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkTable = PaymentExportDataGroup;
                        LinkFields = "Sender Bank BIC" = field("Sender Bank BIC"),
                                "SEPA Instruction Priority Text" = field("SEPA Instruction Priority Text"),
                                "Transfer Date" = field("Transfer Date"),
                                "SEPA Batch Booking" = field("SEPA Batch Booking"),
                                "SEPA Charge Bearer Text" = field("SEPA Charge Bearer Text");
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            textelement(EndToEndId)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    EndToEndId := ReplaceStdPmtIDWithSpecificSeparator(PaymentExportData."End-to-End ID");
                                end;
                            }
                        }
                        textelement(PmtTpInfCol)
                        {
                            XmlName = 'PmtTpInf';
                            textelement(SvcLvlCol)
                            {
                                XmlName = 'SvcLvl';
                                textelement(CdCol)
                                {
                                    XmlName = 'Cd';
                                    trigger OnBeforePassVariable()
                                    begin
                                        CdCol := 'NURG';
                                    end;
                                }
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; PaymentExportData.Amount)
                            {
                                fieldattribute(Ccy; PaymentExportData."Currency Code")
                                {
                                }
                            }
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                textelement(ClrSysMmbId)
                                {
                                    fieldelement(MmbId; PaymentExportData."Recipient Bank Clearing Code")
                                    {
                                    }
                                    trigger OnBeforePassVariable()
                                    begin
                                        if PaymentExportData."Recipient Bank Clearing Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                            }
                            textelement(CdtrAgtBrnchId)
                            {
                                XmlName = 'BrnchId';

                                fieldelement(CdtrAgtBrnchIdId; PaymentExportDataGroup."MICA Bank Branch No.")
                                {
                                    XmlName = 'Id';
                                }
                            }
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; PaymentExportData."Recipient Name")
                            {
                            }
                            textelement(CdtrPstlAdr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(TwnNm; paymentexportdata."Recipient City")
                                {

                                }
                                textelement(CdtrPstlAdrCtrySubDvsn)
                                {
                                    XmlName = 'CtrySubDvsn';
                                    trigger OnBeforePassVariable()
                                    begin
                                        CdtrPstlAdrCtrySubDvsn := '00';
                                    end;
                                }
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        IF PaymentExportData."Recipient Country/Region Code" = '' THEN
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(AdrLine; paymentexportdata."Recipient Address")
                                {

                                }
                                trigger OnBeforePassVariable()
                                begin
                                    IF (PaymentExportData."Recipient Address" = '') AND
                                       (PaymentExportData."Recipient Post Code" = '') AND
                                       (PaymentExportData."Recipient City" = '') AND
                                       (PaymentExportData."Recipient Country/Region Code" = '')
                                    THEN
                                        currXMLport.Skip();
                                end;
                            }
                            textelement(Id)
                            {
                                textelement(OrgId)
                                {
                                    textelement(Othr)
                                    {
                                        textelement(TaxId)
                                        {
                                            XmlName = 'Id';
                                            trigger OnBeforePassVariable()
                                            begin
                                                TaxId := PaymentExportData."MICA Recipient VAT Reg. No.";
                                            end;
                                        }
                                        textelement(SchmeNm)
                                        {
                                            textelement(CdCol2)
                                            {
                                                XmlName = 'Cd';
                                                trigger OnBeforePassVariable()
                                                begin
                                                    CdCol2 := 'TXID';
                                                end;
                                            }
                                        }
                                    }
                                }
                                trigger OnBeforePassVariable()
                                var
                                    WorkString: Text;
                                    PaymentType: Text;
                                begin
                                    WorkString := paymentexportdata."Payment Type";
                                    PaymentType := WorkString.Split('|').Get(1);
                                    if PaymentType = 'INTERNATIONAL' then
                                        currXMLport.Skip();
                                end;
                            }
                        }

                        textelement(CdtrAcctIBAN)
                        {
                            XmlName = 'CdtrAcct';
                            MinOccurs = Zero;
                            textelement(CdtrAcctIbanId)
                            {
                                XmlName = 'Id';
                                fieldelement(CdtrAcctIbanNo; paymentexportdata."MICA Recipient IBAN")
                                {
                                    XmlName = 'IBAN';
                                }

                            }
                            textelement(Tp)
                            {
                                fieldelement(Cd; PaymentExportData."MICA Bank Account Type")
                                {
                                    XmlName = 'Cd';
                                }
                                trigger OnBeforePassVariable()
                                begin
                                    if PaymentExportData."MICA Bank Account Type" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            trigger OnBeforePassVariable()
                            begin
                                if paymentexportdata."MICA Recipient IBAN" = '' then
                                    currXMLport.Skip();
                            end;
                        }
                        textelement(CdtrAcctNotIBAN)
                        {
                            XmlName = 'CdtrAcct';
                            MinOccurs = Zero;
                            textelement(CdtrAcctNotIbanId)
                            {
                                XmlName = 'Id';
                                textelement(OthrNotIban)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(CdtrAcctIbanNo; paymentexportdata."Recipient Bank Acc. No.")
                                    {
                                        XmlName = 'Id';
                                    }
                                }
                            }
                            textelement(TpNotIban)
                            {
                                XmlName = 'Tp';
                                fieldelement(Cd; PaymentExportData."MICA Bank Account Type")
                                {
                                    XmlName = 'Cd';
                                }
                            }
                            trigger OnBeforePassVariable()
                            begin
                                if paymentexportdata."MICA Recipient IBAN" <> '' then
                                    currXMLport.Skip();
                            end;
                        }
                        tableelement(PurchasesPayablesSetup; "Purchases & Payables Setup")
                        {
                            XmlName = 'RmtInf';
                            SourceTableView = sorting("Primary Key") where("MICA Detail Invoices Mass Pay." = const(true));
                            MinOccurs = Zero;
                            fieldelement(UstrdAddInf1; PaymentExportData."MICA Additional Information 1")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 1" = '') or not PurchasesPayablesSetup."MICA Add. Info. in Mass Pmt." THEN
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(UstrdAddInf2; PaymentExportData."MICA Additional Information 2")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 2" = '') or not PurchasesPayablesSetup."MICA Add. Info. in Mass Pmt." THEN
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(UstrdAddInf3; PaymentExportData."MICA Additional Information 3")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 3" = '') or not PurchasesPayablesSetup."MICA Add. Info. in Mass Pmt." THEN
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(UstrdAddInf4; PaymentExportData."MICA Additional Information 4")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 4" = '') or not PurchasesPayablesSetup."MICA Add. Info. in Mass Pmt." THEN
                                        currXMLport.Skip();
                                end;
                            }


                            textelement(Strd)
                            {

                                tableelement(TmpThirdPartyEntries; "Ledger Entry Matching Buffer")
                                {
                                    UseTemporary = true;
                                    XmlName = 'RfrdDocInf';
                                    LinkTable = PaymentExportData;
                                    LinkFields = "Account No." = field("Recipient Acc. No."), "MICA Applies-to ID" = field("MICA Applies-to ID");

                                    fieldelement(Nb; TmpThirdPartyEntries."Document No.")
                                    {

                                    }
                                    fieldelement(RltdDt; TmpThirdPartyEntries."Posting Date")
                                    {

                                    }
                                    textelement(RfrdDocAmt)
                                    {
                                        textelement(DuePyblAmtValue)
                                        {
                                            XmlName = 'DuePyblAmt';
                                            fieldattribute(Ccy; PaymentExportData."Currency Code")
                                            {
                                                trigger OnBeforePassField()
                                                begin
                                                    DuePyblAmtValue := format(TmpThirdPartyEntries."Remaining Amount", 0, '<Precision,2:2><Integer><Decimals><Comma,.>');
                                                end;
                                            }

                                        }
                                    }
                                }
                            }
                        }
                        tableelement(PurchasesPayablesSetup2; "Purchases & Payables Setup")
                        {
                            XmlName = 'RmtInf';
                            SourceTableView = sorting("Primary Key") where("MICA Detail Invoices Mass Pay." = const(false), "MICA Add. Info. in Mass Pmt." = const(true));
                            MinOccurs = Zero;
                            fieldelement(UstrdAddInf1; PaymentExportData."MICA Additional Information 1")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 1" = '') Then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(UstrdAddInf2; PaymentExportData."MICA Additional Information 2")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 2" = '') Then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(UstrdAddInf3; PaymentExportData."MICA Additional Information 3")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 3" = '') Then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(UstrdAddInf4; PaymentExportData."MICA Additional Information 4")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF (PaymentExportData."MICA Additional Information 4" = '') Then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT PaymentExportData.GetPreserveNonLatinCharacters() THEN
                        PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);
                end;
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        CurrentDateTimeTxt := Format(CurrentDateTime(), 0, '<Day,2>-<Month,2>-<Year> <Hours24>.<Minutes,2>.<Seconds,2>');
    end;

    trigger OnPreXmlPort()
    begin
        InitData();
    end;

    local procedure InitData()
    var
        MICAMassPaymentFillBuffers: Codeunit "MICA Mass Payment Fill Buffers";
        PaymentGroupNo: Integer;
    begin
        GetPmtIDSeparatorParamFromFlow();
        MICAMassPaymentFillBuffers.PrepareBuffers(PaymentJournalLine, PaymentExportData, TmpThirdPartyEntries);
        DeduceWithholdingTaxesFromPayableAmmount(PaymentExportData);
        TempPaymentExportRemittanceText.Reset();
        Clear(TempPaymentExportRemittanceText);
        TempPaymentExportRemittanceText.DeleteAll();
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        NoOfTransfers := FORMAT(PaymentExportData.Count());
        NoOfTransfers2 := FORMAT(PaymentExportData.Count());
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := FORMAT(CurrentDateTime(), 19, 9);
        PaymentExportData.CALCSUMS(Amount);

        PaymentExportData.SETCURRENTKEY(
          "Sender Bank BIC", "SEPA Instruction Priority Text", "Transfer Date",
          "SEPA Batch Booking", "SEPA Charge Bearer Text");

        IF NOT PaymentExportData.FindSet() THEN
            ERROR(NoDataToExportErr);

        InitPmtGroup();
        REPEAT
            IF IsNewGroup() THEN BEGIN
                InsertPmtGroup(PaymentGroupNo);
                InitPmtGroup();
            END;
            PaymentExportDataGroup."Line No." += 1;
            PaymentExportDataGroup.Amount += PaymentExportData.Amount;
        UNTIL PaymentExportData.Next() = 0;
        InsertPmtGroup(PaymentGroupNo);
        CtrlSum := Format(PaymentExportDataGroup.Amount, 0, '<Precision,2:2><Integer><Decimals><Comma,.>');
        CtrlSum2 := Format(PaymentExportDataGroup.Amount, 0, '<Precision,2:2><Integer><Decimals><Comma,.>');
    end;

    local procedure DeduceWithholdingTaxesFromPayableAmmount(var ToPaymentExportData: Record "Payment Export Data")
    var
        PaymentJournalWithHoldings: record "Gen. Journal Line";
    begin
        if ToPaymentExportData.IsEmpty() then
            exit;

        PaymentJournalWithHoldings.CopyFilters(PaymentJournalLine);
        PaymentJournalWithHoldings.SetRange("Payment Method Code");
        PaymentJournalWithHoldings.Setrange("Account Type", PaymentJournalWithHoldings."Account Type"::"G/L Account");

        if ToPaymentExportData.FindSet() then
            Repeat
                PaymentJournalWithHoldings.SetRange("Document No.", ToPaymentExportData."Document No.");
                If PaymentJournalWithHoldings.FindFirst() then begin
                    PaymentJournalWithHoldings.CalcSums(Amount);
                    if (PaymentJournalWithHoldings.Amount <> ToPaymentExportData.Amount) then begin
                        ToPaymentExportData.Amount += PaymentJournalWithHoldings.Amount;
                        ToPaymentExportData.Modify(False);
                    end;
                end;
            Until ToPaymentExportData.Next() = 0;
    end;

    local procedure IsNewGroup(): Boolean
    begin
        EXIT(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") OR
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") OR
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") OR
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") OR
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup()
    begin
        PaymentExportDataGroup := PaymentExportData;
        PaymentExportDataGroup."Line No." := 0; // used for counting transactions within group
        PaymentExportDataGroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer)
    var
        PayInfoIdLbl: Label '%1/%2', Comment = '%1%2', Locked = true;
    begin
        PaymentGroupNo += 1;
        PaymentExportDataGroup."Entry No." := PaymentGroupNo;
        PaymentExportDataGroup."Payment Information ID" :=
          COPYSTR(
            STRSUBSTNO(PayInfoIdLbl, PaymentExportData."Message ID", PaymentGroupNo),
            1, MAXSTRLEN(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup.Insert();
    end;

    procedure InitGenJournalLine(JournalTemplateName: Code[10]; JournalBatchId: Guid; PaymentMethodCode: Code[20])
    begin
        if JournalTemplateName <> '' then
            PaymentJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        if JournalBatchId <> '' then
            PaymentJournalLine.SetRange("Journal Batch Id", JournalBatchId);
        if PaymentMethodCode <> '' then
            PaymentJournalLine.SetRange("Payment Method Code", PaymentMethodCode);
        PaymentJournalLine.SetRange("Exported to Payment File", false);
    end;

    local procedure ReplaceStdPmtIDWithSpecificSeparator(FromID: Text[50]): Text[50]
    var
        TextHelper: TextBuilder;
    begin
        if PmtIDSeparator = '' then
            exit(FromID);
        TextHelper.Append(FromID);
        TextHelper.Replace('/', PmtIDSeparator);
        exit(CopyStr(TextHelper.ToText(), 1, 50));
    end;

    local procedure GetPmtIDSeparatorParamFromFlow()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        MICAFlowSetup: record "MICA Flow Setup";
    begin
        MICAFinancialReportingSetup.Get();
        PmtIDSeparator := CopyStr(MICAFlowSetup.GetFlowTextParam(MICAFinancialReportingSetup."Mass Payment Flow code", 'PMTIDSEPARATORCHAR'), 1, 1);
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.', Comment = '%1=Field;%2=Value;%3=Value';
        CurrentDateTimeTxt: Text;
        PmtIDSeparator: Text[1];
}