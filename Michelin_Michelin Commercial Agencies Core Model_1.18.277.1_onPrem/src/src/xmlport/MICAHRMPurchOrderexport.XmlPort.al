xmlport 81140 "MICA HRM Purch.Order export"
{
    //REP-HERMES-001: Purchase Data Exports (Purchase Orders) 
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
            tableelement(TempPurchLine; "Purchase Line")
            {
                XmlName = 'PurchaseLine';
                UseTemporary = true;
                MinOccurs = Once;
                textelement(Company_Code)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Company_Code := MICAFinancialReportingSetup."Company Code";
                    end;
                }
                textelement(PO_Description)
                {
                    trigger OnBeforePassVariable()
                    var
                        CommentLine: Record "Purch. Comment Line";
                    begin
                        PO_Description := '';
                        CommentLine.SetRange("Document Type", CommentLine."Document Type"::Order);
                        CommentLine.SetRange("No.", PurchaseHeader."No.");
                        CommentLine.SetRange("Document Line No.", 0);
                        if CommentLine.FindSet(false) then begin
                            repeat
                                PO_Description += DelChr(CommentLine.Comment, '<>', '"') + ' ';
                            until CommentLine.Next() = 0;
                            PO_Description := CopyStr(DelChr(PO_Description, '>'), 1, 255);
                        end;
                    end;
                }
                fieldelement(PO_Name; TempPurchLine."Document No.")
                { }
                textelement(PO_Key)
                { }
                fieldelement(PO_Line_Number; TempPurchLine."Line No.")
                { }
                textelement(PO_Line_Key)
                { }
                textelement(Split_Accounting_Number)
                { }
                textelement(Ordered_Date)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Ordered_Date := Format(PurchaseHeader."Document Date", 10, '<Year4>-<Month,2><Filler character,0>-<Day,2><Filler character,0>');
                    end;
                }
                textelement(Quantity)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Quantity := Format(TempPurchLine.Quantity, 23, '<Sign><Integer><Decimals,5><Comma,.>');
                    end;
                }
                textelement(Unit_Price)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Unit_Price := Format(TempPurchLine."Direct Unit Cost", 23, '<Sign><Integer><Decimals,6><Comma,.>');
                    end;
                }
                textelement(Amount)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Amount := Format(TempPurchLine.Amount, 23, '<Sign><Integer><Decimals,6><Comma,.>');
                    end;
                }
                textelement(Currency)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if TempPurchLine."Currency Code" = '' then
                            Currency := GeneralLedgerSetup."LCY Code"
                        else
                            Currency := TempPurchLine."Currency Code";
                    end;
                }
                textelement(Description)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Description := DelChr(TempPurchLine.Description + TempPurchLine."Description 2", '<>', '"');
                    end;
                }
                textelement(ERP_Commodity_Name)
                {
                    trigger OnBeforePassVariable()
                    var
                        Entry: Record "Dimension Set Entry";
                    begin
                        Entry.SetRange("Dimension Set ID", TempPurchLine."Dimension Set ID");
                        Entry.SetRange("Dimension Code", MICAFinancialReportingSetup."P-FAMILY Dimension");
                        if Entry.FindFirst() then
                            ERP_Commodity_Name := Entry."Dimension Value Code"
                        else
                            ERP_Commodity_Name := '';
                    end;
                }

                textelement(ERP_Commodity_Description)
                { }
                fieldelement(Part_Number; TempPurchLine."No.")
                { }
                textelement(Part_Revision_Number)
                { }
                fieldelement(Unit_Of_Measure; TempPurchLine."Unit of Measure Code")
                { }
                fieldelement(Unit_Of_Measure_Description; TempPurchLine."Unit of Measure")
                { }
                textelement(Delivery_Address)
                {
                    trigger OnBeforePassVariable()
                    var
                        FormatAddress: Codeunit "Format Address";
                        Address: array[8] of Text;
                        Delivery_AddressLbl: Label '%1 %2 %3 %4 %5 %6 %7 %8', Comment = '%1%2%3%4%5%6%7%8', Locked = true;
                    begin
                        FormatAddress.PurchHeaderShipTo(Address, PurchaseHeader);
                        Delivery_Address := DelChr(StrSubstNo(Delivery_AddressLbl,
                                                   Address[1], Address[2], Address[3], Address[4], Address[5], Address[6], Address[7], Address[8]), '<>', '"');
                    end;
                }
                textelement(Charge)
                { }
                fieldelement(Shipment_Site_Code; TempPurchLine."Buy-from Vendor No.")
                { }
                fieldelement(Supplier_Name; TempPurchLine."Buy-from Vendor No.")
                { }
                textelement(Supplier_City)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Supplier_City := CopyStr(PurchaseHeader."Buy-from City", 1, 20);
                    end;
                }
                textelement(Supplier_Country)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Supplier_Country := PurchaseHeader."Buy-from Country/Region Code";
                    end;
                }
                fieldelement(Supplier_Location_Number; TempPurchLine."Buy-from Vendor No.")
                { }
                textelement(Requester_Code)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Requester_Code := CopyStr(PurchaseHeader."Assigned User ID", 1, 40);
                    end;
                }
                textelement(Requester_Name)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Requester_Name := CopyStr(PurchaseHeader."Assigned User ID", 1, 40);
                    end;
                }
                textelement(Account)
                {
                    trigger OnBeforePassVariable()
                    var
                        Setup: Record "General Posting Setup";
                        AccountNo: Code[20];
                    begin
                        Account := '';
                        case TempPurchLine.Type of
                            TempPurchLine.Type::"G/L Account":
                                AccountNo := TempPurchLine."No.";
                            TempPurchLine.Type::Item:
                                if Setup.Get(TempPurchLine."Gen. Bus. Posting Group", TempPurchLine."Gen. Prod. Posting Group") then
                                    AccountNo := Setup."Purch. Account";
                        end;
                        if not GLAccount.Get(AccountNo) then
                            GLAccount.Init()
                        else
                            Account := GLAccount."No. 2";
                    end;
                }
                textelement(Account_Description)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Account_Description := DelChr(GLAccount."Search Name", '<>', '"');
                    end;
                }
                textelement(Account_Company_Code)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Account_Company_Code := MICAFinancialReportingSetup."Company Code";
                    end;
                }
                textelement(Company_Site_Name)
                { }
                textelement(Site)
                { }
                textelement(Cost_Center_Name)
                {
                    trigger OnBeforePassVariable()
                    var
                        Entry: record "Dimension Set Entry";
                    begin
                        Cost_Center_Name := '';
                        if Entry.Get(TempPurchLine."Dimension Set ID", MICAFinancialReportingSetup."Section Dimension") then
                            Cost_Center_Name := Entry."Dimension Value Code";
                        if Entry.Get(TempPurchLine."Dimension Set ID", MICAFinancialReportingSetup."Structure Dimension") then
                            Cost_Center_Name += Entry."Dimension Value Code";
                    end;
                }
                textelement(Cost_Center_Company_Code)
                { }
                textelement(Project_Code)
                { }
                textelement(Task_Code)
                { }
                textelement(PO_Payment_terms)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PO_Payment_terms := PurchaseHeader."Payment Terms Code";
                    end;
                }
                textelement(Incoterm)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Incoterm := PurchaseHeader."Shipment Method Code";
                    end;
                }
                textelement(Manufacturer_Name)
                { }
                fieldelement(Contract_Name; TempPurchLine."Document No.")
                { }
                textelement(Contract_Release_Number)
                { }
                textelement(Duration_)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if Round((WorkDate() - TempPurchLine."Order Date") / 30.44, 1) < 1 then
                            Duration_ := format(MinimumDurationValue, 4, '<Sign><Integer>')
                        else
                            Duration_ := Format(Round((WorkDate() - TempPurchLine."Order Date") / 30.44, 1), 4, '<Sign><Integer>');
                    end;
                }
                textelement(Open_PO_Indicator)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if PurchaseHeader.Status in [PurchaseHeader.Status::Open, PurchaseHeader.Status::"Pending Approval", PurchaseHeader.Status::"Pending Prepayment"] then
                            Open_PO_Indicator := 'Open'
                        else
                            Open_PO_Indicator := 'Closed';
                    end;
                }
                textelement(Line_Type)
                { }
                textelement(Strucrure)
                { }
                textelement(Beneficiary_Code)
                { }
                textelement(Beneficiary_Name)
                { }
                textelement(PO_Type)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PO_Type := '1';
                    end;
                }

                trigger OnPreXmlItem()
                begin
                    TempPurchLine.SETRANGE("MICA Last Date Modified", StartDate, EndDate);
                end;

                trigger OnAfterGetRecord()
                var
                    FlowRecord: Record "MICA Flow Record";
                begin
                    PurchaseHeader.Get(TempPurchLine."Document Type", TempPurchLine."Document No.");

                    ExportedRecordCount += 1;
                    FlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", PurchaseHeader.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                    FlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", TempPurchLine.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                end;
            }

        }
    }
    trigger OnPreXmlPort()
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        MinimumDurationValue := MICAFlowSetup.GetFlowIntParam(MICAFlowEntry."Flow Code", 'MINIMUMDURATION');
        StartDate := GetCheckFlowDateParameter('STARTDATE');
        EndDate := GetCheckFlowDateParameter('ENDDATE');
        MICAFinancialReportingSetup.Get();
        GeneralLedgerSetup.Get();
        CRLF := ' ';
        CRLF[1] := 13;
        CRLF[2] := 10;
        GetAndCheckPartyOwnershipParamValue(PartyOwnership, Blank);
        Param_GLAccountValue := GetCheckFlowTextParameter(Param_GLAccountTxt);
        SetData();
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        PurchaseHeader: Record "Purchase Header";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
        PartyOwnership: option;
        CRLF: Text[2];
        Param_GLAccountValue: Text;
        ExportedRecordCount: Integer;
        MinimumDurationValue: integer;
        StartDate: Date;
        EndDate: Date;
        Blank: Boolean;
        HdrInfoLbl: Label 'CompanyXPL","HeaderLevelDescription","POId","ExtraPOKey","POLineNumber","ExtraPOLineKey","SplitAccountingNumber","OrderedDate","Quantity","UnitPrice","Amount","AmountCurrency","Description","ERPCommodityId","ERPCommodityDescription","PartNumber","PartRevisionNumber","UnitOfMeasure","UnitOfMeasureDescription","DeliveryAddress","Orderdest","ShipSiteCode","SupplierId","SupplierCity","SupplierCountry","SupplierLocationId","RequesterId","RequesterName","AccountId","AccountDescription","AccountCompanyCode","CompanySiteId","CostSite","CostCenterId","CostCenterCompanyCode","ProjectID","TaskID","POPaymentTerms","Incoterm","ManufacturerName","ContractId","ContractReleaseNumber","DurationInMonths","OpenPOIndicator","LineType","Structure","BeneficiaryID","BeneficiaryName","POType';
        Param_GLAccountTxt: Label 'GLACCOUNTFILTER', locked = true;



    procedure SetFlowEntry(FlowEntryNo: Integer)
    begin
        MICAFlowEntry.Get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    procedure GetFileName(): Text
    var
        FoundMICAFlowEntry: Record "MICA Flow Entry";
        FileName: Text;
        ExportEntryCount: Integer;
    begin
        FoundMICAFlowEntry.SetRange("Flow Code", MICAFlowEntry."Flow Code");
        ExportEntryCount := FoundMICAFlowEntry.Count();
        FileName := StrSubstNo(GetCheckFlowTextParameter('FILENAMING'),
                                    'PORDE',
                                    CopyStr(DelChr(MICAFinancialReportingSetup."Company Code", '<>'), 1, 3),
                                    Format(WorkDate(), 8, '<Year4><Month,2><Filler character,0><Day,2><Filler character,0>'),
                                    '0' + FORMAT(ExportEntryCount)
                                    );
        exit(FileName);
    end;

    local procedure GetCheckFlowDateParameter(FlowParameter: Text): Date
    var
        MICAFlowSetup: Record "MICA Flow Setup";
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

    local procedure GetCheckFlowTextParameter(FlowParameter: Text): Text
    var
        MICAFlowSetup: Record "MICA Flow Setup";
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

    local procedure SetData()
    var
        Vendor: Record Vendor;
        PurchaseLine: Record "Purchase Line";
    begin
        if not TempPurchLine.IsTemporary() then
            Error('');
        Vendor.Reset();
        if not Blank then
            Vendor.SetRange("MICA Party Ownership", PartyOwnership);
        if Vendor.FindSet() then
            repeat
                PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
                PurchaseLine.SetFilter("No.", '<>%1', '');
                PurchaseLine.SetRange("Buy-from Vendor No.", Vendor."No.");
                PurchaseLine.SETRANGE("MICA Last Date Modified", StartDate, EndDate);
                if PurchaseLine.FindSet() then
                    repeat
                        case PurchaseLine.Type of
                            PurchaseLine.Type::"G/L Account":
                                if GetValidGLAccountNo2(PurchaseLine) then begin
                                    TempPurchLine.TransferFields(PurchaseLine);
                                    TempPurchLine.Insert();
                                end;
                            else
                                TempPurchLine.TransferFields(PurchaseLine);
                                TempPurchLine.Insert();
                        end;
                    until PurchaseLine.Next() = 0;
            until Vendor.Next() = 0;
    end;

    local procedure GetValidGLAccountNo2(NewPurchaseLine: Record "Purchase Line"): Boolean
    var
        FoundNoGLAccount: Record "G/L Account";
        GLAccountNo2FirstChar: Text[5];
    begin
        GLAccountNo2FirstChar := '';

        if NewPurchaseLine.Type <> NewPurchaseLine.Type::"G/L Account" then
            exit(false);

        if not FoundNoGLAccount.Get(NewPurchaseLine."No.") then
            exit(false);

        GLAccountNo2FirstChar := copystr(FoundNoGLAccount."No. 2", 1, 1);

        if StrPos(Param_GLAccountValue, GLAccountNo2FirstChar) > 0 then
            exit(true);
    end;
}