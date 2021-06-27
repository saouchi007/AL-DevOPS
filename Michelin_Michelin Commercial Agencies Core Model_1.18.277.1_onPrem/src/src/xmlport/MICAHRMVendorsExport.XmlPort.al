xmlport 81160 "MICA HRM Vendors Export"
{
    //REP-HERMES: Purchase Data Exports (Vendors) 
    Direction = Export;
    TextEncoding = UTF8;
    Format = VariableText;
    RecordSeparator = '<NewLine>';
    TableSeparator = '<NewLine>';
    FieldSeparator = ',';
    FieldDelimiter = '"';
    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                textelement(Line)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Line := HdrInfoLbl;
                    end;
                }
            }

            tableelement(Vendor; Vendor)
            {
                XmlName = 'Vendor';
                fieldelement(SupplierID; Vendor."No.")
                {
                }
                textelement(SupplierLocationId)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SupplierLocationId := DelChr(Vendor."No.", '<>', '"');
                    end;
                }
                textelement(SupplierName)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SupplierName := DelChr(Vendor.Name, '<>', '"');
                    end;
                }

                textelement(longaddr)
                {
                    XmlName = 'StreetAddress';

                    trigger OnBeforePassVariable()
                    begin
                        LongAddr := DelChr(Vendor.Address + Vendor."Address 2", '<>', '"');
                    end;
                }
                fieldelement(City; Vendor.City)
                {
                }
                textelement(State)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Country; Vendor."Country/Region Code")
                {
                }
                fieldelement(PostalCode; Vendor."Post Code")
                {
                }
                textelement(SupplierType)
                {

                    trigger OnBeforePassVariable()
                    begin
                        IF Vendor."MICA Party Ownership" = Vendor."MICA Party Ownership"::"Non Group" then
                            SupplierType := 'External'
                        ELSE
                            SupplierType := 'Internal';
                    end;
                }
                fieldelement(ContactFirstName; Vendor.Contact)
                {
                    MinOccurs = Zero;
                }
                fieldelement(ContactLastName; Vendor.Contact)
                {
                    MinOccurs = Zero;
                }
                fieldelement(ContactPhoneNumber; Vendor."Phone No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ContactEmail; Vendor."E-Mail")
                {
                    MinOccurs = Zero;
                }
                textelement(PreferredLanguage)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Language: Record Language;
                    begin
                        IF Language.GET(Vendor."Language Code") THEN
                            PreferredLanguage := Language.Name
                        ELSE
                            PreferredLanguage := '';
                    end;
                }
                fieldelement(FaxNumber; Vendor."Fax No.")
                {
                    MinOccurs = Zero;
                }
                textelement(OrderRoutingType)
                {
                    MinOccurs = Zero;
                }
                textelement(DUNSNumber)
                {
                    MinOccurs = Zero;
                }
                textelement(ANNumber)
                {
                    MinOccurs = Zero;
                }
                textelement(PaymentType)
                {

                    trigger OnBeforePassVariable()
                    var
                        PaymentTerms: Record "Payment Terms";
                    begin
                        IF PaymentTerms.GET(Vendor."Payment Terms Code") THEN
                            PaymentType := PaymentTerms.Description
                        ELSE
                            PaymentType := '';
                    end;
                }
                textelement(Diversity)
                {
                    MinOccurs = Zero;
                }
                textelement(MinorityOwned)
                {
                    MinOccurs = Zero;
                }
                textelement(WomanOwned)
                {
                    MinOccurs = Zero;
                }
                textelement(VeteranOwned)
                {
                    MinOccurs = Zero;
                }
                textelement(DiversitySBA8A)
                {
                    MinOccurs = Zero;
                }
                textelement(DiversityHUBZone)
                {
                    MinOccurs = Zero;
                }
                textelement(DiversitySDB)
                {
                    MinOccurs = Zero;
                }
                textelement(DiversityDVO)
                {
                    MinOccurs = Zero;
                }
                textelement(DiversityEthnicity)
                {
                    MinOccurs = Zero;
                }
                textelement(COMPANYXPL)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if MICAFinancialReportingSetup.Get() then
                            COMPANYXPL := MICAFinancialReportingSetup."Company Code"
                        else
                            COMPANYXPL := '';
                    end;
                }
                textelement(Flexfield2)
                {
                    MinOccurs = Zero;
                }
                textelement(Flexfield3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Flexfield3 := Vendor."VAT Registration No.";
                    end;
                }

                trigger OnPreXmlItem()
                var
                    StartDate: Date;
                    EndDate: Date;
                begin
                    StartDate := GetCheckFlowDateParameter('STARTDATE');
                    EndDate := GetCheckFlowDateParameter('ENDDATE');
                    Vendor.SETRANGE("Last Date Modified", StartDate, EndDate);
                    MICAFinancialReportingSetup.Get();
                    if not Blank then
                        Vendor.SetRange("MICA Party Ownership", PartyOwnership);
                end;

                trigger OnAfterGetRecord()
                var
                    FlowRecord: Record "MICA Flow Record";
                begin
                    ExportedRecordCount += 1;
                    FlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", Vendor.RecordId(), MICAFlowEntry."Send Status"::Prepared);

                end;
            }

        }

    }
    trigger OnPreXmlPort()
    begin
        GetAndCheckPartyOwnershipParamValue(PartyOwnership, Blank);
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        //Info: Record "MICA Flow Information";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        //StartDate: Date;
        //EndDate: Date;
        PartyOwnership: option;
        Blank: Boolean;
        ExportedRecordCount: Integer;
        HdrInfoLbl: Label 'SupplierId","SupplierLocationId","SupplierName","StreetAddress","City","State","Country","PostalCode","SupplierType","ContactFirstName","ContactLastName","ContactPhoneNumber","ContactEmail","PreferredLanguage","FaxNumber","OrderRoutingType","DUNSNumber","ANNumber","PaymentType","Diversity","MinorityOwned","WomanOwned","VeteranOwned","DiversitySBA8A","DiversityHUBZone","DiversitySDB","DiversityDVO","DiversityEthnicity","COMPANYXPL","Flexfield2","Flexfield3';

    procedure GetFileName(): Text
    var
        FoundMICAFlowEntry: Record "MICA Flow Entry";
        FileName: Text;
        ExportEntryCount: Integer;
    begin
        FoundMICAFlowEntry.SetRange("Flow Code", MICAFlowEntry."Flow Code");
        ExportEntryCount := FoundMICAFlowEntry.Count();
        FileName := StrSubstNo(GetCheckFlowTextParameter('FILENAMING'),
                                    'SUPPL',
                                    CopyStr(DelChr(MICAFinancialReportingSetup."Company Code", '<>'), 1, 3),
                                    Format(WorkDate(), 8, '<Year4><Month,2><Filler character,0><Day,2><Filler character,0>'),
                                    '0' + FORMAT(ExportEntryCount)
                                    );
        exit(FileName);
    end;


    local procedure GetCheckFlowDateParameter(FlowParameter: Text): Date
    var
        MICAFlowSetup: Record "MICA Flow Setup";
        //FlowInfo: Record "MICA Flow Information";
        MissingFlowSetupLbl: Label 'Missing flow setup: Flow Code %1 with Parameter: %2';
        tempDate: Date;
        ErrorText: Text;
    begin
        tempDate := MICAFlowSetup.GetFlowDateParam(MICAFlowEntry."Flow Code", CopyStr(FlowParameter, 1, 20));
        if tempDate = 0D then begin
            ErrorText := StrSubstNo(MissingFlowSetupLbl, MICAFlowEntry."Flow Code", FlowParameter);
            Error(ErrorText);
        end;
        exit(tempDate);
    end;

    procedure SetFlowEntry(FlowEntryNo: Integer)
    begin
        MICAFlowEntry.Get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    local procedure GetCheckFlowTextParameter(FlowParameter: Text): Text
    var
        MICAFlowSetup: Record "MICA Flow Setup";
        //FlowInfo: Record "MICA Flow Information";
        MissingFlowSetupLbl: Label 'Missing flow setup: Flow Code %1 with Parameter: %2';
        tempText: Text;
        ErrorText: Text;
    begin
        tempText := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", CopyStr(FlowParameter, 1, 20));
        if tempText = '' then begin
            ErrorText := StrSubstNo(MissingFlowSetupLbl, MICAFlowEntry."Flow Code", FlowParameter);
            Error(ErrorText);
        end;
        exit(tempText);
    end;

    local procedure GetAndCheckPartyOwnershipParamValue(var PartyOwnership: Option; var Blank: Boolean)
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        Vendor: Record Vendor;
        ParamValue_PartyOwnership: Text;
        Param_PartyOwnershipLbl: Label 'PARTYOWNERSHIP', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param_PartyOwnershipLbl) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param_PartyOwnershipLbl), '');
            exit;
        end;
        ParamValue_PartyOwnership := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param_PartyOwnershipLbl);
        case ParamValue_PartyOwnership of
            Format(Vendor."MICA Party Ownership"::Group):
                PartyOwnership := Vendor."MICA Party Ownership"::Group;
            Format(Vendor."MICA Party Ownership"::"Group Network"):
                PartyOwnership := Vendor."MICA Party Ownership"::"Group Network";
            Format(Vendor."MICA Party Ownership"::Internal):
                PartyOwnership := Vendor."MICA Party Ownership"::Internal;
            Format(Vendor."MICA Party Ownership"::"Non Group"):
                PartyOwnership := Vendor."MICA Party Ownership"::"Non Group";
            '':
                Blank := true;
            else
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param_PartyOwnershipLbl), '');
        end;
    end;
}