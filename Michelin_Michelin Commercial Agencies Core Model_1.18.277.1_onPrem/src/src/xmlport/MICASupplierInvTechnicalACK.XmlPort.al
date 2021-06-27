xmlport 82021 "MICA Supplier Inv.TechnicalACK"
{
    //INTGIS001 – Supplier Invoice Integration
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    Namespaces = xsi = 'http://www.w3.org/2001/XMLSchema-instance';
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
        textelement(CONFIRM_BOD_004)
        {
            textelement(CNTROLAREA)
            {
                textelement(BSR)
                {
                    textelement(VERB)
                    {
                        textattribute(valueverb)
                        {
                            XmlName = 'value';
                        }
                    }
                    textelement(NOUN)
                    {
                        textattribute(valuenoun)
                        {
                            XmlName = 'value';
                        }
                    }
                    textelement(REVISION)
                    {
                        textattribute(valuerev)
                        {
                            XmlName = 'value';
                        }
                    }
                }
                textelement(SENDER)
                {
                    textelement(LOGICALID)
                    {
                    }
                    textelement(COMPONENT)
                    {
                    }
                    textelement(TASK)
                    {
                    }
                    textelement(REFERENCEID)
                    {
                    }
                    textelement(CONFIRMATION)
                    {
                    }
                    textelement(LANGUAGE)
                    {
                    }
                    textelement(CODEPAGE)
                    {
                    }
                    textelement(AUTHID)
                    {
                    }
                }
                textelement(DATETIME)
                {
                    textattribute(index)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            index := 'text';
                        end;
                    }
                    textattribute(type)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            type := 'F';
                        end;

                    }
                    textattribute(qualifier)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            qualifier := 'TO';
                        end;
                    }
                    textelement(YEAR)
                    {
                    }
                    textelement(MONTH)
                    {
                    }
                    textelement(DAY)
                    {
                    }
                    textelement(HOUR)
                    {
                    }
                    textelement(MINUTE)
                    {
                    }
                    textelement(SECOND)
                    {
                    }
                    textelement(SUBSECOND)
                    {
                    }
                    textelement(TIMEZONE)
                    {
                    }
                }
            }
            textelement(DATAAREA)
            {
                textelement(CONFIRM_BOD)
                {
                    textelement(CONFIRM)
                    {
                        textelement(cntrolareaconf)
                        {
                            XmlName = 'CNTROLAREA';
                            textelement(bsrconf)
                            {
                                XmlName = 'BSR';
                                textelement(verbconf)
                                {
                                    XmlName = 'VERB';
                                    textattribute(valueconfverb)
                                    {
                                        XmlName = 'value';
                                    }
                                }
                                textelement(nounconf)
                                {
                                    XmlName = 'NOUN';
                                    textattribute(valueconfnoun)
                                    {
                                        XmlName = 'value';
                                    }
                                }
                                textelement(revisionconf)
                                {
                                    XmlName = 'REVISION';
                                    textattribute(valueconfrev)
                                    {
                                        XmlName = 'value';
                                    }
                                }
                            }
                            textelement(senderconf)
                            {
                                XmlName = 'SENDER';
                                textelement(logicalidconf)
                                {
                                    XmlName = 'LOGICALID';
                                }
                                textelement(componentconf)
                                {
                                    XmlName = 'COMPONENT';
                                }
                                textelement(taskconf)
                                {
                                    XmlName = 'TASK';
                                }
                                textelement(referenceidconf)
                                {
                                    XmlName = 'REFERENCEID';
                                }
                                textelement(confirmationconf)
                                {
                                    XmlName = 'CONFIRMATION';
                                }
                                textelement(languageconf)
                                {
                                    XmlName = 'LANGUAGE';
                                }
                                textelement(codepageconf)
                                {
                                    XmlName = 'CODEPAGE';
                                }
                                textelement(authidconf)
                                {
                                    XmlName = 'AUTHID';
                                }
                            }
                            textelement(datetimeconf)
                            {
                                XmlName = 'DATETIME';
                                textattribute(indexconfdt)
                                {
                                    XmlName = 'index';
                                    trigger OnBeforePassVariable()
                                    begin
                                        indexconfdt := 'text';
                                    end;
                                }
                                textattribute(typeconfdt)
                                {
                                    XmlName = 'type';
                                    trigger OnBeforePassVariable()
                                    begin
                                        typeconfdt := 'F';
                                    end;
                                }
                                textattribute(qualifierconfdt)
                                {
                                    XmlName = 'qualifier';
                                    trigger OnBeforePassVariable()
                                    begin
                                        qualifierconfdt := 'TO';
                                    end;

                                }
                                textelement(yearconfdt)
                                {
                                    XmlName = 'YEAR';
                                }
                                textelement(monthconfdt)
                                {
                                    XmlName = 'MONTH';
                                }
                                textelement(dayconfdt)
                                {
                                    XmlName = 'DAY';
                                }
                                textelement(hourconfdt)
                                {
                                    XmlName = 'HOUR';
                                }
                                textelement(minuteconfdt)
                                {
                                    XmlName = 'MINUTE';
                                }
                                textelement(secondconfdt)
                                {
                                    XmlName = 'SECOND';
                                }
                                textelement(subsecondconfdt)
                                {
                                    XmlName = 'SUBSECOND';
                                }
                                textelement(timezoneconfdt)
                                {
                                    XmlName = 'TIMEZONE';
                                }
                            }
                        }
                        textelement(statuslvlconf)
                        {
                            XmlName = 'STATUSLVL';
                        }
                        textelement(descriptnconf)
                        {
                            XmlName = 'DESCRIPTN';
                        }
                        textelement(origrefconf)
                        {
                            XmlName = 'ORIGREF';
                        }
                        textelement(userareaconf)
                        {
                            XmlName = 'USERAREA';
                        }
                        textelement(CONFIRMMSG)
                        {
                            textelement(descriptnconfmsg)
                            {
                                XmlName = 'DESCRIPTN';
                            }
                            textelement(reasoncodeconfmsg)
                            {
                                XmlName = 'REASONCODE';
                            }
                            textelement(userareaconfmsg)
                            {
                                XmlName = 'USERAREA';
                            }
                        }
                    }
                }
            }
        }

    }

    var
        MICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowEntry: Record "MICA Flow Entry";
        PurchaseHeader: Record "Purchase Header";
        MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        ExportedRecordCount: Integer;
        ErrorCodes: Text;
        ErrorDescription: Text;

    trigger OnPreXmlPort()
    var
        RecTimeZone: Record "Time Zone";
        MySessionSettings: SessionSettings;
        DT: DateTime;
        ReferenceIDLbl: Label '%1 %2', Comment = '%1%2', Locked = true;
        CODEPAGELbl: Label 'Code page of Broker - %1', Comment = '%1', Locked = true;
        OrigrefconfLbl: Label '%1%2OROD%3', Comment = '%1%2%3', Locked = true;
    begin
        DT := CurrentDateTime();

        valueverb := 'CONFIRM';
        valuenoun := 'PROCESSINVOICE';
        valuerev := '002';
        LogicalID := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'LogicalID');
        ReferenceID := StrSubstNo(ReferenceIDLbl, PurchaseHeader."No.", Format(DT, 0, 9));
        Component := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'Component');
        Task := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'Task');
        CONFIRMATION := '0';
        LANGUAGE := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'Language');

        MySessionSettings.Init();
        CODEPAGE := StrSubstNo(CODEPAGELbl, Format(MySessionSettings.LocaleId(), 0, 9));
        AUTHID := UserId();
        YEAR := FORMAT(CURRENTDATETIME(), 0, '<Year4>');
        MONTH := FORMAT(CURRENTDATETIME(), 0, '<Month,2>');
        DAY := FORMAT(CURRENTDATETIME(), 0, '<Day,2>');
        HOUR := FORMAT(CURRENTDATETIME(), 0, '<Hours24>');
        MINUTE := FORMAT(CURRENTDATETIME(), 0, '<Min,2>');
        SECOND := FORMAT(CURRENTDATETIME(), 0, '<Second,2>');
        SUBSECOND := '0000';

        RecTimeZone.Setrange(ID, MySessionSettings.TimeZone());
        RecTimeZone.FindFirst();
        TIMEZONE := DelChr(CopyStr(RecTimeZone."Display Name", StrPos(RecTimeZone."Display Name", 'UTC') + 3, 6), '=', ':');

        languageconf := LANGUAGE;
        componentconf := COMPONENT;

        valueconfverb := valueverb;
        valueconfnoun := valuenoun;
        valueconfrev := valuerev;
        logicalidconf := LOGICALID;
        referenceidconf := REFERENCEID;
        componentconf := COMPONENT;
        taskconf := TASK;
        confirmationconf := '0';
        languageconf := LANGUAGE;
        codepageconf := CODEPAGE;
        authidconf := AUTHID;

        yearconfdt := FORMAT(CURRENTDATETIME(), 0, '<Year4>');
        monthconfdt := FORMAT(CURRENTDATETIME(), 0, '<Month,2>');
        dayconfdt := FORMAT(CURRENTDATETIME(), 0, '<Day,2>');
        hourconfdt := FORMAT(CURRENTDATETIME(), 0, '<Hours24>');
        minuteconfdt := FORMAT(CURRENTDATETIME(), 0, '<Min,2>');
        secondconfdt := FORMAT(CURRENTDATETIME(), 0, '<Second,2>');
        subsecondconfdt := '0000';
        timezoneconfdt := TIMEZONE;

        if ErrorCodes = '' then
            statuslvlconf := 'SUCCESS'
        else begin
            statuslvlconf := 'ERROR';
            descriptnconfmsg := ErrorDescription;
            reasoncodeconfmsg := ErrorCodes;
        end;
        descriptnconf := StrSubstNo(MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'DESCRIPTN'), MICAFlowBufferSupplierInv."Vendor Invoice No.");
        origrefconf := StrSubstNo(OrigrefconfLbl, MICAFlowBufferSupplierInv."Vendor Invoice No.", MICAFlowBufferSupplierInv.SHIPNUMBER, MICAFlowBufferSupplierInv.RELFACTCODE);
    end;

    trigger OnPostXmlPort()
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
        CreationDT: DateTime;
        DocDateTime: Text;
        DocDateTimeLbl: Label '%1-%2-%3T%4:%5:%6%7%8', Comment = '%1%2%3%4%5%6%7%8', Locked = true;
    begin
        CreationDT := 0DT;
        ExportedRecordCount += 1;

        DocDateTime := StrSubstNo(DocDateTimeLbl, YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, CopyStr(TIMEZONE, 1, 3), CopyStr(TIMEZONE, 4, 2));
        DTVariant := CreationDT;
        TypeHelper.Evaluate(DTVariant, DocDateTime, '', '');
        Evaluate(CreationDT, format(DTVariant));
        MICAFlowEntry.UpdateTechnicalData(LOGICALID, Component, Task, REFERENCEID, CreationDT, '', '', '', '', '', '');
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    procedure SetParameters(var InMICAFlowEntry: Record "MICA Flow Entry"; inPurchaseHeader: Record "Purchase Header"; var inMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; inErrCode: Text; inErrDescr: Text)
    begin
        MICAFlowEntry := InMICAFlowEntry;
        PurchaseHeader := inPurchaseHeader;
        MICAFlowBufferSupplierInv := inMICAFlowBufferSupplierInv;
        ErrorCodes := inErrCode;
        ErrorDescription := inErrDescr;
    end;
}
