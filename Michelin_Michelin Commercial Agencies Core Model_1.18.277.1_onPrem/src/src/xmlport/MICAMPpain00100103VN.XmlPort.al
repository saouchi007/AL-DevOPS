xmlport 81551 "MICA MP pain.001.001.03 VN"
{
    // version MIC01.00.18

    // MIC:EDD029:1:0      21/02/2017 COSMO.CCO
    //   # New xmlport to manage Mass Payment File creation
    // MIC:EDD MASS-CH:1:1 29/03/2017 COSMO.JMO
    //   # Moved the xml element "Ccy" into the xml root "DbtrAcct"

    Caption = 'MP pain.001.001.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        tableelement("Gen. Journal Line"; "Gen. Journal Line")
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
                                    begin
                                        BICOrBEI := 'BIBMCH22';
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
                    fieldelement(PmtInfId; PaymentExportDataGroup."Payment Information ID")
                    {
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
                                    PaymentType := Split(WorkString, '|');
                                    if PaymentType = 'GIRO' then
                                        Cd := 'NURG'
                                    else
                                        if PaymentType = 'RTGS' then
                                            Cd := 'URGP';
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
                                    PaymentType := Split(WorkString, '|');
                                    PaymentCode := Split(WorkString, '|');
                                    if PaymentType = 'GIRO' then
                                        Prtry := PaymentCode
                                    else
                                        if PaymentType = 'RTGS' then
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
                            /*
                            textelement(AdrLine)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    if CompanyInformation.Address <> '' then
                                        AdrLine := CompanyInformation.Address
                                    else
                                        AdrLine := 'null';
                                    destroyAccent(AdrLine);
                                end;
                            }
                            */
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
                                fieldelement(CtryInfoComp2; CompanyInformation."Country/Region Code")
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
                            fieldelement(EndToEndId; PaymentExportData."End-to-End ID")
                            {
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
                        textelement(ChrgBr)
                        {
                            trigger OnBeforePassVariable()
                            var
                                WorkString: Text;
                                PaymentType: Text;
                            begin
                                WorkString := paymentexportdata."Payment Type";
                                PaymentType := Split(WorkString, '|');
                                if PaymentType = 'RTGS' then
                                    ChrgBr := 'DEBT'
                                else
                                    ChrgBr := 'SHAR';
                            end;
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                //fieldelement(BIC; PaymentExportData."Recipient Bank BIC")
                                //{
                                //    FieldValidate = Yes;
                                //}
                                textelement(ClrSysMmbId)
                                {
                                    fieldelement(MmbId; PaymentExportData."Recipient Bank Clearing Code")//TODO ?
                                    {
                                    }
                                }
                                fieldelement(Nm; paymentexportdata."Recipient Bank Name")
                                {

                                }
                                textelement(PstlAdrViet)
                                {
                                    XmlName = 'PstlAdr';
                                    fieldelement(Ctry; PaymentExportData."Recipient Bank Country/Region")//TODO ?
                                    {

                                    }
                                }
                            }
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; PaymentExportData."Recipient Name")
                            {
                            }
                            textelement(cdtrpstladr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")//TODO ?
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        IF PaymentExportData."Recipient Country/Region Code" = '' THEN
                                            currXMLport.Skip();
                                    end;
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
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                textelement(cdtrothr)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(Id; PaymentExportData."Recipient Bank Acc. No.")
                                    {
                                        FieldValidate = Yes;
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                    }
                                }
                            }
                        }
                        /*textelement(RmtInf)
                        {
                            MinOccurs = Zero;
                            textelement(remittancetext1)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }
                            textelement(remittancetext2)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';

                                trigger OnBeforePassVariable()
                                begin
                                    IF RemittanceText2 = '' THEN
                                        currXMLport.SKIP;
                                end;
                            }

                            trigger OnBeforePassVariable()
                            begin
                                RemittanceText1 := '';
                                RemittanceText2 := '';
                                TempPaymentExportRemittanceText.SETRANGE("Pmt. Export Data Entry No.", PaymentExportData."Entry No.");
                                IF NOT TempPaymentExportRemittanceText.FINDSET THEN
                                    currXMLport.SKIP;
                                RemittanceText1 := TempPaymentExportRemittanceText.Text;
                                IF TempPaymentExportRemittanceText.NEXT = 0 THEN
                                    EXIT;
                                RemittanceText2 := TempPaymentExportRemittanceText.Text;
                            end;
                        }*/
                        textelement(VendEmal)
                        {
                            MinOccurs = Zero;
                            XmlName = 'RltdRmtInf';
                            textelement(RmtLctnMtdEmal)
                            {
                                XmlName = 'RmtLctnMtd';
                                trigger OnBeforePassVariable()
                                begin
                                    RmtLctnMtdEmal := 'EMAL';
                                end;
                            }
                            textelement(RmtLctnElctrncAdrEmal)
                            {
                                XmlName = 'RmtLctnElctrncAdr';
                                trigger OnBeforePassVariable()
                                var
                                    WorkString: Text;
                                begin
                                    WorkString := PaymentExportData."Recipient Email Address";
                                    RmtLctnElctrncAdrEmal := Split(WorkString, '|');
                                end;
                            }
                            trigger OnBeforePassVariable()
                            var
                                WorkString: Text;
                            begin
                                WorkString := PaymentExportData."Recipient Email Address";
                                IF Split(WorkString, '|') = '' THEN
                                    currXMLport.Skip();
                            end;
                        }
                        textelement(VendFax)
                        {
                            MinOccurs = Zero;
                            XmlName = 'RltdRmtInf';
                            textelement(RmtLctnMtdFax)
                            {
                                XmlName = 'RmtLctnMtd';
                                trigger OnBeforePassVariable()
                                begin
                                    RmtLctnMtdFax := 'FAXI';
                                end;
                            }
                            textelement(RmtLctnElctrncAdrFax)
                            {
                                XmlName = 'RmtLctnElctrncAdr';
                                trigger OnBeforePassVariable()
                                var
                                    WorkString: Text;
                                    Email: Text;
                                begin
                                    WorkString := PaymentExportData."Recipient Email Address";
                                    Email := Split(WorkString, '|');
                                    RmtLctnElctrncAdrFax := Split(WorkString, '|');
                                end;
                            }
                            trigger OnBeforePassVariable()
                            var
                                WorkString: Text;
                                Email: Text;
                            begin
                                WorkString := PaymentExportData."Recipient Email Address";
                                Email := Split(WorkString, '|');
                                IF Split(WorkString, '|') = '' THEN
                                    currXMLport.Skip();
                            end;
                        }
                        tableelement(PurchasesPayablesSetup; "Purchases & Payables Setup")
                        {
                            XmlName = 'RmtInf';
                            SourceTableView = sorting("Primary Key") where("MICA Detail Invoices Mass Pay." = const(true));
                            MinOccurs = Zero;

                            fieldelement(Ustrd; paymentexportdata."MICA Explanation")
                            {
                                XmlName = 'Ustrd';
                                trigger OnBeforePassField()
                                begin
                                    IF paymentexportdata."MICA Explanation" = '' THEN
                                        currXMLport.Skip();
                                end;
                            }
                            //textelement(Strd)
                            //{
                            tableelement(TmpVendorLedgerEntry; "Vendor Ledger Entry")
                            {
                                UseTemporary = true;
                                XmlName = 'Strd';
                                MinOccurs = Zero;
                                textelement(RfrdDocInf)
                                {
                                    fieldelement(Nb; TmpVendorLedgerEntry."Document No.") //TODO ?
                                    {

                                    }
                                    fieldelement(RltdDt; TmpVendorLedgerEntry."Posting Date")//TODO ?
                                    {

                                    }
                                }
                                //}
                                textelement(RfrdDocAmt)
                                {
                                    //textelement(DuePyblAmt)
                                    textelement(DuePyblAmtValue)
                                    {
                                        XmlName = 'DuePyblAmt';
                                        fieldattribute(Ccy; PaymentExportData."Currency Code")
                                        {
                                            trigger OnBeforePassField()
                                            begin
                                                TmpVendorLedgerEntry.CalcFields("Remaining Amount");
                                                DuePyblAmtValue := format(Abs(TmpVendorLedgerEntry."Remaining Amount"), 0, '<Precision,2:2><Integer><Decimals><Comma,.>');
                                            end;
                                        }

                                    }
                                }
                                trigger OnPreXmlItem()
                                begin
                                    TmpVendorLedgerEntry.SetRange("Vendor No.", paymentexportdata."Recipient Acc. No.");
                                    if TmpCustLedgerEntry.IsEmpty() then
                                        currXMLport.Break();
                                end;
                            }

                            tableelement(TmpCustLedgerEntry; "Cust. Ledger Entry")
                            {
                                UseTemporary = true;
                                XmlName = 'Strd';
                                MinOccurs = Zero;
                                textelement(RfrdDocInf2)
                                {
                                    XmlName = 'RfrdDocInf';
                                    fieldelement(Nb; TmpCustLedgerEntry."Document No.")
                                    {

                                    }
                                    fieldelement(RltdDt; TmpCustLedgerEntry."Posting Date")
                                    {

                                    }
                                }
                                //}
                                textelement(RfrdDocAmt2)
                                {
                                    XmlName = 'RfrdDocAmt';
                                    textelement(DuePyblAmtValue2)
                                    {
                                        XmlName = 'DuePyblAmt';
                                        fieldattribute(Ccy; PaymentExportData."Currency Code")
                                        {
                                            trigger OnBeforePassField()
                                            begin
                                                TmpCustLedgerEntry.CalcFields("Remaining Amount");
                                                DuePyblAmtValue2 := format(Abs(TmpCustLedgerEntry."Remaining Amount"), 0, '<Precision,2:2><Integer><Decimals><Comma,.>');
                                            end;
                                        }

                                    }
                                }
                                trigger OnPreXmlItem()
                                begin
                                    TmpCustLedgerEntry.SetRange("Customer No.", paymentexportdata."Recipient Acc. No.");
                                    if TmpCustLedgerEntry.IsEmpty() then
                                        currXMLport.Break();
                                end;
                            }
                            tableelement(EmplLedgerEntry; "Employee Ledger Entry")
                            {
                                XmlName = 'Strd';
                                MinOccurs = Zero;
                                textelement(RfrdDocInf3)
                                {
                                    XmlName = 'RfrdDocInf';
                                    fieldelement(Nb; EmplLedgerEntry."Document No.")
                                    {

                                    }
                                    fieldelement(RltdDt; EmplLedgerEntry."Posting Date")
                                    {

                                    }
                                }
                                //}
                                textelement(RfrdDocAmt3)
                                {
                                    XmlName = 'RfrdDocAmt';
                                    textelement(DuePyblAmtValue3)
                                    {
                                        XmlName = 'DuePyblAmt';
                                        fieldattribute(Ccy; PaymentExportData."Currency Code")
                                        {
                                            trigger OnBeforePassField()
                                            begin
                                                EmplLedgerEntry.CalcFields("Remaining Amount");
                                                DuePyblAmtValue3 := format(Abs(EmplLedgerEntry."Remaining Amount"), 0, '<Precision,2:2><Integer><Decimals><Comma,.>');
                                            end;
                                        }

                                    }
                                }
                                trigger OnPreXmlItem()
                                begin
                                    EmplLedgerEntry.SetRange("Employee No.", paymentexportdata."Recipient Acc. No.");
                                    EmplLedgerEntry.SetRange("Applies-to ID", "Gen. Journal Line"."Applies-to ID");
                                    // if EmplLedgerEntry.IsEmpty() then
                                    //    currXMLport.Break();
                                end;
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
    }

    /*requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }*/


    trigger OnInitXmlPort()
    begin
        CurrentDateTimeTxt := Format(CurrentDateTime(), 0, '<Day,2>-<Month,2>-<Year> <Hours24>.<Minutes,2>.<Seconds,2>');
    end;

    trigger OnPreXmlPort()
    begin
        InitData();
        //FinancialReportingSetup.GET;
    end;

    local procedure InitData()
    var
        MICAMPCTFillExportBuffer: Codeunit 81551;
        PaymentGroupNo: Integer;
    begin
        MICAMPCTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData, TmpVendorLedgerEntry, TmpCustLedgerEntry);
        TempPaymentExportRemittanceText.Reset();
        Clear(TempPaymentExportRemittanceText);
        TempPaymentExportRemittanceText.DeleteAll();
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        NoOfTransfers := FORMAT(PaymentExportData.Count());
        NoOfTransfers2 := FORMAT(PaymentExportData.Count());
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := FORMAT(CurrentDateTime(), 19, 9);
        PaymentExportData.CALCSUMS(Amount);
        //ControlSum := FORMAT(PaymentExportData.Amount, 0, 9);

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
        CtrlSum := Format(PaymentExportDataGroup.Amount, 0, 9);
        CtrlSum2 := Format(PaymentExportDataGroup.Amount, 0, 9);
        //DuePyblAmt := Format(PaymentExportDataGroup.Amount, 0, 9);
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

    procedure InitGenJournalLine(JournalTemplateName: Code[10]; JournalBatchId: Guid; PaymentMethodCode: Code[20]; AccType: Option; AccNo: Code[20])
    begin
        if JournalTemplateName <> '' then
            "Gen. Journal Line".SetRange("Journal Template Name", JournalTemplateName);
        if not IsNullGuid(JournalBatchId) then
            "Gen. Journal Line".SetRange("Journal Batch Id", JournalBatchId);
        if PaymentMethodCode <> '' then
            "Gen. Journal Line".SetRange("Payment Method Code", PaymentMethodCode);
        "Gen. Journal Line".SetRange("Account Type", AccType);
        // if AccNo <> '' then
        //    "Gen. Journal Line".SetRange("Account No.", AccNo);
        "Gen. Journal Line".SetRange("Exported to Payment File", false);
    end;

    local procedure Split(var Text: Text; Separator: Text[1]) Token: Text
    var
        Pos: Integer;
    begin
        Pos := StrPos(Text, Separator);
        if Pos > 0 then begin
            Token := CopyStr(Text, 1, Pos - 1);
            if Pos + 1 <= StrLen(Text) then
                Text := CopyStr(Text, Pos + 1)
            else
                Text := '';
        end else begin
            Token := Text;
            Text := '';
        end;
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.', Comment = '%1=Field;%2=Value;%3=Value';
        //FinancialReportingSetup: Record 80010;
        CurrentDateTimeTxt: Text;
}

