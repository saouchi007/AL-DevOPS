xmlport 81150 "MICA HRM P.Purch.Invoice exp."
{
    //REP-HERMES-002: Purchase Data Exports (AP-Invoices) 
    Direction = Export;
    TextEncoding = UTF8;
    Format = VariableText;
    RecordSeparator = '<NewLine>';
    TableSeparator = '<NewLine>';
    Permissions = tabledata 122 = rm;
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

            tableelement(TempPurchInvLine; "Purch. Inv. Line")
            {
                XmlName = 'PurchInvLine';
                UseTemporary = true;
                textelement(Company_Code)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Company_Code := MICAFinancialReportingSetup."Company Code";
                    end;
                }
                textelement(Invoice_Description)
                {
                    trigger OnBeforePassVariable()
                    var
                        CommentLine: Record "Purch. Comment Line";
                    begin
                        Invoice_Description := '';
                        CommentLine.SetRange("Document Type", CommentLine."Document Type"::"Posted Invoice");
                        CommentLine.SetRange("No.", PurchInvHeader."No.");
                        CommentLine.SetRange("Document Line No.", 0);
                        if CommentLine.FindSet(false) then begin
                            repeat
                                Invoice_Description += DelChr(CommentLine.Comment, '<>', '"') + ' ';
                            until CommentLine.Next() = 0;
                            Invoice_Description := CopyStr(DelChr(Invoice_Description, '>'), 1, 255);
                        end;
                    end;
                }
                fieldelement(Invoice_Name; TempPurchInvLine."Document No.")
                { }
                textelement(Invoice_Key)
                { }
                fieldelement(Invoice_Line_Number; TempPurchInvLine."Line No.")
                { }
                textelement(Invoice_Line_Key)
                { }
                textelement(Split_Accounting_Number)
                { }
                textelement(Accounting_Date)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Accounting_Date := Format(PurchInvHeader."Posting Date", 10, '<Year4>-<Month,2><Filler character,0>-<Day,2><Filler character,0>');
                    end;
                }
                textelement(Quantity)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Quantity := Format(TempPurchInvLine.Quantity, 23, '<Sign><Integer><Decimals,5><Comma,.>');
                    end;
                }
                textelement(Unit_Price)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Unit_Price := Format(TempPurchInvLine."Direct Unit Cost", 23, '<Sign><Integer><Decimals,6><Comma,.>');
                    end;
                }
                textelement(Amount)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Amount := Format(TempPurchInvLine.Amount, 23, '<Sign><Integer><Decimals,6><Comma,.>');
                    end;
                }
                textelement(Currency)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if PurchInvHeader."Currency Code" = '' then
                            Currency := GeneralLedgerSetup."LCY Code"
                        else
                            Currency := PurchInvHeader."Currency Code";
                    end;
                }
                textelement(Description)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Description := DelChr(TempPurchInvLine.Description + TempPurchInvLine."Description 2", '<>', '"');
                    end;
                }
                textelement(ERP_Commodity_Code)
                {
                    trigger OnBeforePassVariable()
                    var
                        Entry: Record "Dimension Set Entry";
                    begin
                        Entry.SetRange("Dimension Set ID", TempPurchInvLine."Dimension Set ID");
                        Entry.SetRange("Dimension Code", MICAFinancialReportingSetup."P-FAMILY Dimension");
                        if Entry.FindFirst() then
                            ERP_Commodity_Code := Entry."Dimension Value Code"
                        else
                            ERP_Commodity_Code := '';
                    end;
                }

                textelement(ERP_Commodity_Description)
                { }
                fieldelement(Part_Number; TempPurchInvLine."No.")
                { }
                textelement(Part_Revision_Number)
                { }
                fieldelement(Unit_Of_Measure; TempPurchInvLine."Unit of Measure Code")
                { }
                fieldelement(Unit_Of_Measure_Description; TempPurchInvLine."Unit of Measure")
                { }
                textelement(Structure)
                { }
                textelement(Delivery_Address)
                {
                    trigger OnBeforePassVariable()
                    var
                        FormatAddress: Codeunit "Format Address";
                        Address: array[8] of Text;
                        Delivery_AddressLbl: Label '%1 %2 %3 %4 %5 %6 %7 %8', Comment = '%1%2%3%4%5%6%7%8', Locked = true;

                    begin
                        FormatAddress.PurchInvShipTo(Address, PurchInvHeader);
                        Delivery_Address := DelChr(StrSubstNo(Delivery_AddressLbl,
                                                   Address[1], Address[2], Address[3], Address[4], Address[5], Address[6], Address[7], Address[8]), '<>', '"');
                    end;
                }
                fieldelement(Supplier_Name; TempPurchInvLine."Buy-from Vendor No.")
                { }
                textelement(Supplier_Address)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Supplier_Address := PurchInvHeader."Buy-from Address" + ' ' + PurchInvHeader."Buy-from Address 2";
                    end;
                }
                textelement(Supplier_City)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Supplier_City := CopyStr(PurchInvHeader."Buy-from City", 1, 20);
                    end;
                }
                textelement(Supplier_Country)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Supplier_Country := PurchInvHeader."Buy-from Country/Region Code";
                    end;
                }
                fieldelement(Supplier_Location_Number; TempPurchInvLine."Buy-from Vendor No.")
                { }
                textelement(Requester_Code)
                { }
                textelement(Requester_Name)
                { }
                textelement(Account)
                {
                    trigger OnBeforePassVariable()
                    var
                        Setup: Record "General Posting Setup";
                        AccountNo: Code[20];
                    begin
                        Account := '';
                        case TempPurchInvLine.Type of
                            TempPurchInvLine.Type::"G/L Account":
                                AccountNo := TempPurchInvLine."No.";
                            TempPurchInvLine.Type::Item:
                                if Setup.Get(TempPurchInvLine."Gen. Bus. Posting Group", TempPurchInvLine."Gen. Prod. Posting Group") then
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
                        if Entry.Get(TempPurchInvLine."Dimension Set ID", MICAFinancialReportingSetup."Section Dimension") then
                            Cost_Center_Name := Entry."Dimension Value Code";
                        if Entry.Get(TempPurchInvLine."Dimension Set ID", MICAFinancialReportingSetup."Structure Dimension") then
                            Cost_Center_Name += Entry."Dimension Value Code";
                    end;
                }
                textelement(Cost_Center_Company_Code)
                { }
                textelement(Project_Code)
                { }
                textelement(Task_Code)
                { }
                fieldelement(Contract_Name; TempPurchInvLine."Order No.")
                { }
                fieldelement(PO_Name; TempPurchInvLine."Order No.")
                { }
                textelement(PO_Key)
                { }
                fieldelement(PO_Line_Number; TempPurchInvLine."Order Line No.")
                { }
                textelement(PO_Line_Key)
                { }
                textelement(Invoice_Date)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Invoice_Date := Format(PurchInvHeader."Document Date", 10, '<Year4>-<Month,2><Filler character,0>-<Day,2><Filler character,0>');
                    end;
                }
                textelement(Paid_Date)
                { }
                textelement(Invoice_Number)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Invoice_Number := PurchInvHeader."Vendor Invoice No.";
                    end;
                }
                textelement(AP_Payment_Terms)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AP_Payment_Terms := PurchInvHeader."Payment Terms Code";
                    end;
                }
                textelement(End_Year_Discount_Amount)
                { }
                textelement(End_Year_Discount_Percentage)
                { }
                textelement(Incoterm)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Incoterm := PurchInvHeader."Shipment Method Code";
                    end;
                }
                textelement(FreightWithPO)
                { }
                textelement(ContactReleaseNumber)
                { }
                textelement(Validation_Date)
                { }
                textelement(InvoiceType)
                { }

                trigger OnAfterGetRecord()
                var
                    FlowRecord: Record "MICA Flow Record";
                begin
                    PurchInvHeader.Get(TempPurchInvLine."Document No.");

                    ExportedRecordCount += 1;
                    FlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", PurchInvHeader.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                    FlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", TempPurchInvLine.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                end;
            }
        }
    }
    trigger OnPreXmlPort()
    begin
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
        PurchInvHeader: Record "Purch. Inv. Header";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
        PartyOwnership: option;
        CRLF: Text[2];
        Param_GLAccountValue: Text;
        StartDate: Date;
        EndDate: Date;
        ExportedRecordCount: Integer;
        Blank: Boolean;
        HdrInfoLbl: Label 'CompanyXPL","HeaderLevelDescription","InvoiceId","ExtraInvoiceKey","InvoiceLineNumber","ExtraInvoiceLineKey","SplitAccountingNumber","AccountingDate","Quantity","UnitPrice","Amount","AmountCurrency","Description","ERPCommodityId","ERPCommodityDescription","PartNumber","PartRevisionNumber","UnitOfMeasure","UnitOfMeasureDescription","Structure","DeliveryAddress","SupplierId","SupplierAddress","SupplierCity","SupplierCountry","SupplierLocationId","RequesterId","RequesterName","AccountId","AccountDescription","AccountCompanyCode","CompanySiteId","CostSite","CostCenterId","CostCenterCompanyCode","ProjectID","TaskID","ContractId","POId","ExtraPOKey","POLineNumber","ExtraPOLineKey","InvoiceDate","PaidDate","InvoiceNumber","APPaymentTerms","EndYearDiscountAmount","EndYearDiscountPercentage","Incoterms","FreightWithPO","ContractReleaseNumber","ValidationDate","InvoiceType';
        Param_GLAccountTxt: Label 'GLACCOUNTFILTER', locked = true;

    procedure GetFileName(): Text
    var
        FoundMICAFlowEntry: Record "MICA Flow Entry";
        FileName: Text;
        ExportEntryCount: Integer;
    begin
        FoundMICAFlowEntry.SetRange("Flow Code", MICAFlowEntry."Flow Code");
        ExportEntryCount := FoundMICAFlowEntry.Count();
        FileName := StrSubstNo(GetCheckFlowTextParameter('FILENAMING'),
                                    'INVOI',
                                    CopyStr(DelChr(MICAFinancialReportingSetup."Company Code", '<>'), 1, 3),
                                    Format(WorkDate(), 8, '<Year4><Month,2><Filler character,0><Day,2><Filler character,0>'),
                                    '0' + FORMAT(ExportEntryCount)
                                    );
        exit(FileName);
    end;

    procedure SetFlowEntry(FlowEntryNo: Integer)
    begin
        MICAFlowEntry.Get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
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

    local procedure SetData()
    var
        Vendor: Record Vendor;
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        if not TempPurchInvLine.IsTemporary() then
            Error('');
        Vendor.Reset();
        if not Blank then
            Vendor.SetRange("MICA Party Ownership", PartyOwnership);
        if Vendor.FindSet() then
            repeat
                PurchInvLine.SetRange("Buy-from Vendor No.", Vendor."No.");
                PurchInvLine.SETRANGE("Posting Date", StartDate, EndDate);
                if PurchInvLine.FindSet() then
                    repeat
                        case PurchInvLine.Type of
                            PurchInvLine.Type::"G/L Account":
                                if GetValidGLAccountNo2(PurchInvLine) then begin
                                    TempPurchInvLine.TransferFields(PurchInvLine);
                                    TempPurchInvLine.Insert();
                                end;
                            else
                                TempPurchInvLine.TransferFields(PurchInvLine);
                                TempPurchInvLine.Insert();
                        end;
                    until PurchInvLine.Next() = 0;
            until Vendor.Next() = 0;
    end;

    local procedure GetValidGLAccountNo2(NewPurchInvLine: Record "Purch. Inv. Line"): Boolean
    var
        FoundNoGLAccount: Record "G/L Account";
        GLAccountNo2FirstChar: Text[5];
    begin
        GLAccountNo2FirstChar := '';

        if NewPurchInvLine.Type <> NewPurchInvLine.Type::"G/L Account" then
            exit(false);

        if not FoundNoGLAccount.Get(NewPurchInvLine."No.") then
            exit(false);

        GLAccountNo2FirstChar := copystr(FoundNoGLAccount."No. 2", 1, 1);

        if StrPos(Param_GLAccountValue, GLAccountNo2FirstChar) > 0 then
            exit(true);
    end;
}
