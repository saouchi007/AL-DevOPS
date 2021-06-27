table 80760 "MICA Accrual Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Rebate Setup';
    LookupPageId = "MICA Accrual Setup List";
    DrillDownPageId = "MICA Accrual Setup List";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            DataClassification = CustomerContent;
            OptionMembers = "Customer","Accr. Cust. Grp.","All Customers";
            OptionCaption = 'Customer,Rebate Customer Group,All Customers';
            trigger OnValidate()
            begin
                if "Sales Type" = "Sales Type"::"All Customers" then
                    Clear("Sales Code");
            end;
        }

        field(4; "Sales Code"; code[100])
        {
            Caption = 'Sales Code';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                case "Sales Type" of
                    "Sales Type"::Customer:
                        LookupCustomer();
                    "Sales Type"::"Accr. Cust. Grp.":
                        LookupAccrualCustomerGroup();
                end;
            end;
        }

        field(5; "Accr. Item  Grp."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Item Grp.';
            trigger OnLookup()
            begin
                LookupRebateItemGroup();
            end;
        }

        field(6; "Begin Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Begin Date';
        }

        field(7; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
        }
        field(9; "Calculation Type"; Option)
        {
            Caption = 'Calculation Type';
            DataClassification = CustomerContent;
            OptionMembers = "Amount","Quantity";
            OptionCaption = 'Amount,Quantity';
        }

        field(11; "Accruals Posting Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebates Posting Code';
            TableRelation = "MICA Accrual Posting Setup";
        }

        field(12; "Is Deferred"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Deferred';
        }
        field(13; "Include in Fin. Report"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include in Fin. Report';
        }
        field(14; "Accrual Global Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates Global Amount';
        }
        field(15; Closed; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed';
            Editable = false;
        }
        field(20; "Reforecast Percentage"; Decimal)
        {
            Caption = 'Reforecast Percentage';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 5;
        }
        field(25; "Description 2"; Text[250])
        {
            Caption = 'Customer Description';
            DataClassification = CustomerContent;
        }
        field(30; "Rebate Pool Posting Setup"; Code[20])
        {
            Caption = 'Rebate Pool Posting Setup';
            DataClassification = CustomerContent;
            TableRelation = "MICA Rebate Pool Posting Setup";
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        CreateDimension();
    end;

    local procedure CreateDimension()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        DimensionValue: Record "Dimension Value";
    begin
        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Accrual Dimension Code");
        IF not DimensionValue.Get(MICAFinancialReportingSetup."Accrual Dimension Code", Code) then begin
            DimensionValue.Init();
            DimensionValue.Validate("Dimension Code", MICAFinancialReportingSetup."Accrual Dimension Code");
            DimensionValue.Validate(Code, Code);
            DimensionValue.Name := Code;
            DimensionValue.Insert(true);
        end;

    end;

    local procedure LookupRebateItemGroup()
    var
        MICAAccrualItemGroup: Record "MICA Accrual Item Group";
        MICAAccrualItemGroups: Page "MICA Accrual Item Groups";
        RebateItemGroups: Text;
        RebateItemGroupsTooLongErr: Label 'The length of the string is %1, but it must be less than or equal to %2 characters. Value: %3';
        ErrorText: Text;
    begin
        MICAAccrualItemGroup.Reset();
        MICAAccrualItemGroups.SetTableView(MICAAccrualItemGroup);
        MICAAccrualItemGroups.LookupMode(true);
        if MICAAccrualItemGroups.RunModal() <> Action::LookupOK then
            exit;
        MICAAccrualItemGroups.SetSelection(MICAAccrualItemGroup);
        if MICAAccrualItemGroup.FindSet() then
            repeat
                if RebateItemGroups = '' then
                    RebateItemGroups := MICAAccrualItemGroup.Code
                else
                    RebateItemGroups += '|' + MICAAccrualItemGroup.Code;
            until MICAAccrualItemGroup.Next() = 0;
        if StrLen(RebateItemGroups) > MaxStrLen("Accr. Item  Grp.") then begin
            ErrorText := StrSubstNo(RebateItemGroupsTooLongErr, StrLen(RebateItemGroups), MaxStrLen("Accr. Item  Grp."), RebateItemGroups);
            Error(ErrorText);
        end;
        "Accr. Item  Grp." := CopyStr(RebateItemGroups, 1, MaxStrLen("Accr. Item  Grp."));
    end;

    local procedure LookupCustomer()
    var
        Customer: Record Customer;
        CustomerList: Page "Customer List";
    begin
        Customer.Reset();
        CustomerList.SetTableView(Customer);
        CustomerList.Editable(false);
        CustomerList.LookupMode(true);
        if CustomerList.RunModal() <> Action::LookupOK then
            exit;
        CustomerList.GetRecord(Customer);
        "Sales Code" := Customer."No.";
    end;

    local procedure LookupAccrualCustomerGroup()
    var
        MICAAccrualCustomerGroup: Record "MICA Accrual Customer Group";
        MICAAccrualCustomerGroups: Page "MICA Accrual Customer Groups";
        RebateCustGroups: Text;
        RebateCustGroupsTooLongErr: Label 'The length of the string is %1, but it must be less than or equal to %2 characters. Value: %3';
        ErrorText: Text;
    begin
        MICAAccrualCustomerGroup.Reset();
        MICAAccrualCustomerGroups.SetTableView(MICAAccrualCustomerGroup);
        MICAAccrualCustomerGroups.LookupMode(true);
        if MICAAccrualCustomerGroups.RunModal() <> Action::LookupOK then
            exit;
        MICAAccrualCustomerGroups.SetSelection(MICAAccrualCustomerGroup);
        if MICAAccrualCustomerGroup.FindSet() then
            repeat
                if RebateCustGroups = '' then
                    RebateCustGroups := MICAAccrualCustomerGroup.Code
                else
                    RebateCustGroups += '|' + MICAAccrualCustomerGroup.Code;
            until MICAAccrualCustomerGroup.Next() = 0;
        if StrLen(RebateCustGroups) > MaxStrLen("Sales Code") then begin
            ErrorText := StrSubstNo(RebateCustGroupsTooLongErr, StrLen(RebateCustGroups), MaxStrLen("Sales Code"), RebateCustGroups);
            Error(ErrorText);
        end;
        "Sales Code" := CopyStr(RebateCustGroups, 1, MaxStrLen("Sales Code"));
    end;


}