table 80765 "MICA Cust. Detail. Accr. Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Detailed Rebates Entry';
    LookupPageId = "MICA Cust. Det. Accr. Entries";
    DrillDownPageId = "MICA Cust. Det. Accr. Entries";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';

        }
        field(2; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(4; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer No.';

        }
        field(5; "Calculation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation Date';
        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(7; "Accr. Document Type"; Option)
        {
            OptionMembers = Accrual,Settlement,Reverse,;
            OptionCaption = 'Rebate,Settlement,Reverse,';
            Caption = 'Rebate Document Type';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;ObsoleteReason = 'Deleted';
        }
        field(8; "Entry Type"; Option)
        {
            OptionMembers = "Initial Entry","Application";
            OptionCaption = 'Initial Entry, Application';
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(9; "Calculation Type"; Option)
        {
            OptionMembers = "Amount","Quantity";
            Caption = 'Calculation Type';
            OptionCaption = 'Amount, Quantity';
            DataClassification = CustomerContent;
        }
        field(10; "Sales Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Amount';

        }
        field(11; "Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Discount Amount';
        }
        field(12; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(13; "Accruals %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate %';
            DecimalPlaces = 0 : 2;
        }
        field(14; "Accruals Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Amount';
        }
        field(15; "Is Deffered"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Deferred';
        }
        field(16; "Posted in Accounting"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted in Accounting';
            ObsoleteState = Removed;ObsoleteReason = 'Deleted';
        }

        field(17; "Customer Accruals Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Rebate Entry No.';
        }
        field(18; "Applied Cust Accr Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Rebate Entry No.';
            ObsoleteState = Removed;ObsoleteReason = 'Deleted';
        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(20; "Global Dimension 2 Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(21; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(22; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
            TableRelation = User."User Name";
        }
        field(23; "Accr. Item Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Item Group';
            TableRelation = "MICA Accrual Item Group";
        }
        field(24; "Value Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Value Entry No.';
            TableRelation = "Value Entry";
        }

        field(25; "Accr. Customer Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Customer Group';
            TableRelation = "MICA Accrual Customer Group";
        }

        field(26; "Include in Fin. Report"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include in Fin. Report';
        }

        field(27; "Value Entry Document Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Value Entry Document Type';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly';
        }
        field(28; "Reforecast Percentage"; Decimal)
        {
            Caption = 'Reforecast Percentage';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
        }
        field(30; "Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            DataClassification = CustomerContent;
        }
        field(31; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(81880; "Country-of Sales"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country-of Sales';
        }
        field(81881; "Market Code"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Market Code';
            TableRelation = "MICA Table Value" where ("Table Type" = const (MarketCode), Code = field ("Market Code"));

        }
        field(81882; "Forecast Code"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Forecast Code';
        }
        field(81883; "Intercompany Dimension"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Intercompany Dimension';
        }
        field(81884; "Accruals Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Dimension';
        }
        field(81885; "Site Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Dimension';
        }
        field(81886; "Document Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Posting Date';
        }
        field(81887; "Paid AR Credit Memo"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Paid AR Credit Memo';
        }
        field(81888; "Paid AP Invoice"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Paid AP Invoice';
        }

    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SecKey1; "Customer No.", "Posting Date")
        {

        }
        key(SecKey2; "Accr. Customer Group", "Posting Date")
        {

        }
        key(SecKey3; Code, "Country-of Sales", "Market Code", "Forecast Code", "Intercompany Dimension", "Posting Date")
        {
            SumIndexFields = "Accruals Amount";
        }
        key(SecKey4; "Value Entry No.", "Posting Date")
        {
            SumIndexFields = "Accruals Amount";

        }

    }
}