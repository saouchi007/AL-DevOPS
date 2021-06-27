table 80640 "MICA Financial Reporting Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Financial Reporting Setup';
    LookupPageId = "MICA Financial Reporting Setup";
    DrillDownPageId = "MICA Financial Reporting Setup";
    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Intercompany Dimension"; Code[20])
        {
            Caption = 'Intercompany Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(3; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }
        field(4; "Location Filter"; Text[250])
        {
            Caption = 'Location Filter';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(5; "In Transit Location Filter"; Text[250])
        {
            Caption = 'In Transit Location Filter';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(20; "Section Dimension"; Code[20])
        {
            Caption = 'Section Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(30; "Structure Dimension"; Code[20])
        {
            Caption = 'Structure Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(40; "P-FAMILY Dimension"; Code[20])
        {
            Caption = 'P-FAMILY Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(80660; "Non Group Interco Code"; Code[20])
        {
            Caption = 'Non Group Interco Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Intercompany Dimension"));
        }
        field(80760; "Accr. Doc. No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Document No.';
            TableRelation = "No. Series";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80761; "Accr. Last Date Calculation"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Last Date Calculation';
            //To uncomment for prod
            //Editable = false;
        }
        field(80900; "F028 Last Export No."; Code[3])
        {
            DataClassification = CustomerContent;
            Caption = 'F028 Last Export No.';
        }
        field(81020; "LB Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'LB Dimension';
            TableRelation = Dimension.Code;
        }
        field(81021; "STE4 Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 Posting Group';
            TableRelation = "Customer Posting Group";
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by STE4 Posting Group Filter';
        }
        field(81022; "STE4 LOANS Posting Grp Filter"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 Loans Posting Group Filter';
            TableRelation = "Customer Posting Group";
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by STE4 LOANS Pst. Group Filter';
        }
        field(81023; "STE4 PROV Filter"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 PROV Filter';

            trigger OnLookup()
            var
                No2Filter: Text;
            begin
                No2Filter := GetGLAccountNo2Filter(MaxStrLen("STE4 PROV Filter"));
                "STE4 PROV Filter" := CopyStr(No2Filter, 1, MaxStrLen("STE4 PROV Filter"));
            end;
        }
        field(81024; "STE4 Add LOSSES Filter"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 Add LOSSES Filter';

            trigger OnLookup()
            var
                No2Filter: Text;
            begin
                No2Filter := GetGLAccountNo2Filter(MaxStrLen("STE4 Add LOSSES Filter"));
                "STE4 Add LOSSES Filter" := CopyStr(No2Filter, 1, MaxStrLen("STE4 Add LOSSES Filter"));
            end;
        }
        field(81025; "STE4 Sub LOSSES Filter"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 Sub LOSSES Filter';

            trigger OnLookup()
            var
                No2Filter: Text;
            begin
                No2Filter := GetGLAccountNo2Filter(MaxStrLen("STE4 Sub LOSSES Filter"));
                "STE4 Sub LOSSES Filter" := CopyStr(No2Filter, 1, MaxStrLen("STE4 Sub LOSSES Filter"));
            end;
        }
        field(81026; "STE4 Region Code"; Code[20])
        {
            Caption = 'STE Region Code';
            DataClassification = CustomerContent;
        }
        field(81027; "STE4 Posting Group Filter"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 Posting Group Filter';

            trigger OnLookup()
            var
                myFilter: Text;
            begin
                myFilter := GetCustomerPostingGroupsFilter();
                "STE4 Posting Group Filter" := CopyStr(myFilter, 1, MaxStrLen("STE4 Posting Group Filter"));
            end;
        }
        field(81028; "STE4 LOANS Pst. Group Filter"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 Loans Posting Group Filter';
            TableRelation = "Customer Posting Group";
            ObsoleteState = Removed;
            ObsoleteReason = 'Remplace by STE4 AR Pst. Group Filter';
        }
        field(81029; "STE4 AR Pst. Group Filter"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 AR Posting Group Filter';

            trigger OnLookup()
            var
                myFilter: Text;
            begin
                myFilter := GetCustomerPostingGroupsFilter();
                "STE4 AR Pst. Group Filter" := CopyStr(myFilter, 1, MaxStrLen("STE4 AR Pst. Group Filter"));
            end;
        }
        field(81030; "STE4 LOANS Filter"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'STE4 LOANS  Filter';
            trigger OnLookup()
            var
                No2Filter: Text;
            begin
                No2Filter := GetGLAccountNo2Filter(MaxStrLen("STE4 LOANS Filter"));
                "STE4 LOANS Filter" := CopyStr(No2Filter, 1, MaxStrLen("STE4 LOANS Filter"));
            end;
        }
        field(81640; "Sales Agreement Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Agreement Nos.';
            TableRelation = "No. Series";
        }
        field(81800; "Pelican Code-Sending Company"; Code[8])
        {
            DataClassification = CustomerContent;
            Caption = 'Pelican Code-Sending Company';
        }
        field(81880; "Accrual Dimension Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Dimension Code';
            TableRelation = Dimension;
        }
        field(81940; "F336 Last Export No."; code[3])
        {
            DataClassification = CustomerContent;
            Caption = 'F336 Last Export No.';
            Editable = false;
        }
        field(81941; "Commercial Organization Code"; code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Commercial Organization Code';
        }
        field(81942; "F336 G/L Acc. No.2 Filter"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'F336 G/L Acc. No.2 Filter';
        }
        field(81943; "F336 Dimension Section Filter"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'F336 Dimension Section Filter';
        }
        field(81944; "Deferred Group Account"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Group Account"';
        }
        field(82060; "Mass Payment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Mass Payment Amount';
        }
        field(82061; "Dynamic Pay. Mtd. Code Value 1"; Code[10])
        {
            Caption = 'Dynamic Payment Method Code Value 1';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method".Code;
        }
        field(82062; "Dynamic Pay. Mtd. Code Value 2"; Code[10])
        {
            Caption = 'Dynamic Payment Method Code Value 2';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method".Code;
        }
        field(82063; "Mass Payment Flow code"; code[20])
        {
            caption = 'Mass Payment Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(82064; "Mass Payment Codeunit ID"; Integer)
        {
            caption = 'Mass Payment Codeunit ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit), "Object ID" = filter(80000 .. 99999), "Object Caption" = filter('*Process Mass Payment*'));
        }
        field(82065; "Mass Payment Codeunit Name"; Text[50])
        {
            Caption = 'Mass Payment Codeunit Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Codeunit), "Object ID" = field("Mass Payment Codeunit ID")));
        }
        field(82140; "Multi-Posting"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Multi-Posting';
        }
        field(82020; "GIS AP Integrat. Charge (Item)"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'GIS AP Integration Charge (Item)';
            TableRelation = "Item Charge";
        }

        field(82021; "GIS AP Integrat. Freight Item"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'GIS AP Integration Freight Item';
            TableRelation = Item;
        }

        field(80110; "Disable Forced Dim. Uncheck"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Disable Forced Dim. Uncheck';
        }
        field(80640; "Value Entries Parameter"; Integer)
        {
            Caption = 'Value Entries Parameter';
            DataClassification = CustomerContent;
        }
        field(81881; "Deferred Journal Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Journal Name';
            TableRelation = "Gen. Journal Template";
        }
        field(81882; "Deferred Journal Batch Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Deferred Journal Name"));
        }
        field(81883; "Site Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Dimension Code';
            TableRelation = Dimension;
        }
        field(81884; "Deferred Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred No. Series';
            TableRelation = "No. Series";
        }
        field(81885; "Financial Journal Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Financial Journal Name';
            TableRelation = "Gen. Journal Template";
        }
        field(81886; "Financial Journal Batch Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Financial Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Financial Journal Name"));
        }
        field(81887; "Calc. Rebate Rates Codeunit ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculate Rebate Rates Codeunit ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit), "Object ID" = filter(80000 .. 99999));
        }
        field(81801; "RelFact Extract Ext. Doc."; Boolean)
        {
            Caption = 'RelFact Extract Ext. Doc.';
            DataClassification = CustomerContent;
        }
        field(83000; "Rebate Pool Application %"; Integer)
        {
            Caption = 'Rebate Pool Application %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    local procedure GetGLAccountNo2Filter(FieldLen: Integer): Text
    var
        MICASTE4GLAccounts: Page "MICA STE4 GL Accounts";
        No2Filter: Text;
        No2FilterisTooLongErr: Label 'The length of the string is %1, but it must be less than or equal to %2 characters. Value: %3';
        ErrorText: Text;
    begin
        MICASTE4GLAccounts.Editable(false);
        MICASTE4GLAccounts.LookupMode(true);
        if MICASTE4GLAccounts.RunModal() <> Action::LookupOK then
            exit;
        No2Filter := MICASTE4GLAccounts.GetSelectionFilter();
        if StrLen(No2Filter) > FieldLen then begin
            ErrorText := StrSubstNo(No2FilterisTooLongErr, StrLen(No2Filter), FieldLen, No2Filter);
            Error(ErrorText);
        end;
        exit(No2Filter);

    end;

    local procedure GetCustomerPostingGroupsFilter() myFilter: Text;
    var
        CustomerPostingGroups: Page "MICA STE4 Cust. Posting Groups";
    begin
        CustomerPostingGroups.Editable(false);
        CustomerPostingGroups.LookupMode(true);
        if CustomerPostingGroups.RunModal() <> Action::LookupOK then
            exit;
        myFilter := CustomerPostingGroups.GetSelectionFilter();
    end;
}