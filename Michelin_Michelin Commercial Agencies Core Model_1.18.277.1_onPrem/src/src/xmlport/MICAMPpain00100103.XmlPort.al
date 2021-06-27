xmlport 81550 "MICA MP pain.001.001.03"
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
                    textelement(InitgPty)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        //textelement(initgptyid)
                        //{
                        //    XmlName = 'Id';
                        //textelement(initgptyorgid)
                        //{
                        //    XmlName = 'OrgId';
                        //    textelement(bicorbei)
                        //    {
                        //        XmlName = 'BICOrBEI';
                        //        trigger OnBeforePassVariable()
                        //        begin
                        //            BICOrBEI := FinancialReportingSetup."Mass Payment Company Code";
                        //        end;
                        //    }
                        //}
                        //}
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
                    textelement(PmtTpInf)
                    {
                        textelement(SvcLvl)
                        {
                            textelement(Cd)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    Cd := 'TODO'
                                end;
                            }
                        }
                        textelement(LclInstrm)
                        {
                            textelement(Prtry)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    Prtry := 'TODO'
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
                            fieldelement(BIC; PaymentExportDataGroup."Sender Bank BIC")//TODO
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
                        /*textelement(ChrgBr)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportData."Payment Type" = 'RTGS' then
                                    ChrgBr := 'DEBT'
                                else
                                    ChrgBr := 'null';
                            end;
                        }*/
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
                                    fieldelement(MmbId; PaymentExportData."Transit No.")
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
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")
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
                        textelement(RltdRmtInfEmal)
                        {
                            XmlName = 'RltdRmtInf';
                            textelement(RmtLctnMtdEmal)
                            {
                                XmlName = 'RmtLctnMtd';
                                trigger OnBeforePassVariable()
                                begin
                                    RmtLctnMtdEmal := 'EMAL';
                                end;
                            }
                            fieldelement(RmtLctnElctrncAdrEmal; PaymentExportData."Recipient Email Address")
                            {
                                XmlName = 'RmtLctnElctrncAdr';
                            }
                        }
                        textelement(RltdRmtInfFaxi)
                        {
                            XmlName = 'RltdRmtInf';
                            textelement(RmtLctnMtdFaxi)
                            {
                                XmlName = 'RmtLctnMtd';
                                trigger OnBeforePassVariable()
                                begin
                                    RmtLctnMtdFaxi := 'FAXI';
                                end;
                            }
                            textelement(RmtLctnElctrncAdrFaxi)
                            {
                                XmlName = 'RmtLctnElctrncAdr';
                                trigger OnBeforePassVariable()
                                var
                                    Vend: Record Vendor;
                                begin
                                    if Vend.Get(paymentexportdata."Recipient ID") then
                                        RmtLctnElctrncAdrFaxi := Vend."Fax No.";
                                end;
                            }
                        }
                        tableelement(PurchasesPayablesSetup; "Purchases & Payables Setup")
                        {
                            XmlName = 'RmtInf';
                            SourceTableView = sorting("Primary Key") where("MICA Detail Invoices Mass Pay." = const(true));
                            MinOccurs = Zero;
                            textelement(Strd)
                            {

                                tableelement(TmpVendorLedgerEntry; "Vendor Ledger Entry")
                                {
                                    UseTemporary = true;
                                    XmlName = 'RfrdDocInf';
                                    //textelement(RfrdDocInf)
                                    //{
                                    fieldelement(Nb; TmpVendorLedgerEntry."Applies-to Ext. Doc. No.") //TODO ?
                                    {

                                    }
                                    fieldelement(RltdDt; TmpVendorLedgerEntry."Posting Date")//TODO ?
                                    {

                                    }
                                    //}
                                }
                                textelement(RfrdDocAmt)
                                {
                                    textelement(DuePyblAmt)
                                    {
                                        fieldattribute(Ccy; PaymentExportData."Currency Code")
                                        {

                                        }
                                        fieldelement(InvoiceAmount; PaymentExportDataGroup."Invoice Amount")
                                        {

                                        }
                                    }
                                }
                                tableelement(TmpCustLedgerEntry; "Cust. Ledger Entry")
                                {
                                    UseTemporary = true;
                                    XmlName = 'RfrdDocInf';
                                    //textelement(RfrdDocInf)
                                    //{
                                    fieldelement(Nb; TmpCustLedgerEntry."Applies-to Ext. Doc. No.") //TODO ?
                                    {

                                    }
                                    fieldelement(RltdDt; TmpCustLedgerEntry."Posting Date")//TODO ?
                                    {

                                    }
                                    //}
                                }
                                textelement(RfrdDocAmt2)
                                {
                                    XmlName = 'RfrdDocAmt';
                                    textelement(DuePyblAmt2)
                                    {
                                        XmlName = 'DuePyblAmt';
                                        fieldattribute(Ccy; PaymentExportData."Currency Code")
                                        {

                                        }
                                        fieldelement(InvoiceAmount; PaymentExportDataGroup."Invoice Amount")
                                        {

                                        }
                                    }
                                }
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
            "Gen. Journal Line".SetRange("Journal Template Name", JournalTemplateName);
        if JournalBatchId <> '' then
            "Gen. Journal Line".SetRange("Journal Batch Id", JournalBatchId);
        if PaymentMethodCode <> '' then
            "Gen. Journal Line".SetRange("Payment Method Code", PaymentMethodCode);
        "Gen. Journal Line".SetRange("Exported to Payment File", false);
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.', Comment = '%1=Field;%2=Value;%3=Value';
        //FinancialReportingSetup: Record 80010;
        CurrentDateTimeTxt: Text;
}

