table 80766 "MICA Customer Accrual Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Rebate Entry';

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

        field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }

        field(4; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }

        field(5; "Calculation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation Date';
        }

        field(6; "Accr. Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Accrual","Settlement","Reverse"," ";
            Caption = 'Rebate Document Type';
            OptionCaption = 'Rebate,Settlement,Reverse, ';
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(7; "Calculation Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Amount","Quantity";
            Caption = 'Calculation Type';
            OptionCaption = 'Amount,Quantity';
        }

        field(8; "Base Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Amount';
        }

        field(9; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }

        field(10; "Accruals %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate %';
            DecimalPlaces = 0 : 2;
        }

        field(11; "Accruals Amount"; Decimal)
        {
            Caption = 'Rebate Amount';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = sum("MICA Cust. Detail. Accr. Entry"."Accruals Amount" where
                ("Entry Type" = FILTER('Initial Entry'),
                "Customer Accruals Entry No." = Field("Entry No.")));
        }

        field(12; Open; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Open';
        }

        field(13; "Is Deffered"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Deferred';
        }

        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = sum("MICA Cust. Detail. Accr. Entry"."Accruals Amount" where
                ("Customer Accruals Entry No." = field("Entry No.")));
        }

        field(15; "Customer Accrual Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Def. Reb. Posting Group';
            //TableRelation = "MICA Accr. Cust. Posting Group";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(16; "Document No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(17; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
        }

        field(18; "Closed By Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed By Entry No.';
            Editable = False;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(19; "Closed At Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed At Date';
            Editable = False;
        }
        field(20; "Accr. Customer Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Customer Group';
            TableRelation = "MICA Accrual Customer Group";
        }
        field(21; "Include in Fin. Report"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include in Fin. Report';
        }
        field(81880; "Paid Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Paid Amount';
            Editable = false;
        }
        field(22; "Closed By Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Closed By Document No.';
            Editable = false;
        }
        field(30; "Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            DataClassification = CustomerContent;
        }
        field(31; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(32; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(33; "Rebate Code Ending Date"; Date)
        {
            Caption = 'Rebate Code Ending Date';
            DataClassification = CustomerContent;
        }
        field(81881; "Sales Credit Memo No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Credit Memo No.';
        }
        field(81882; "Sales Cr. Memo Creation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Credit Memo Creation Date';
        }
        field(81883; "Paid Invoices"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Paid AR Credit Memo';
        }
        field(81884; "Paid AP Invoice"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Paid AP Invoice';
        }
        field(83000; "Rebate Pool Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Pool Amount';
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
    }
}