table 81021 "MICA STE4 Extraction"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(3; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(5; "Initial Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount (LCY)';
        }
        field(6; "Remaining Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Amount (LCY)';
        }
        field(7; "Customer Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(8; Open; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Open';
        }
        field(9; NDCA; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'NDCA';
        }
        field(10; LB; Code[20])
        {
            Dataclassification = CustomerContent;
            Caption = 'LB';
        }
        field(11; "Party Ownership"; Option)
        {
            Caption = 'Party Ownership';
            DataClassification = CustomerContent;
            OptionMembers = "Non Group",Group,"Group Network",Internal;
        }
        field(12; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(13; "UserId"; Code[50])
        {
            Caption = 'UserId';
            DataClassification = CustomerContent;
        }
        field(14; "Origin Entry No."; Integer)
        {
            Caption = 'Origin Entry no.';
            DataClassification = CustomerContent;
        }
        field(15; "Market Code"; Code[2])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Origin Entry No.", LB, UserId)
        {
            Clustered = true;
            SumIndexFields = "Initial Amount (LCY)", "Remaining Amount (LCY)";
        }
        Key(Key2; LB, "Market Code", "Document Type", "Posting Date", "Customer Posting Group", UserId)
        {
            SumIndexFields = "Initial Amount (LCY)", "Remaining Amount (LCY)";
        }
        Key(Key3; LB, "Market Code", "Document Type", Open, "Due Date", "Customer Posting Group", "Party Ownership", UserId)
        {
            SumIndexFields = "Initial Amount (LCY)", "Remaining Amount (LCY)";
        }
        Key(Key4; "Customer No.", "Document Type", "Posting Date", Open, "Due Date", UserId)
        {
            SumIndexFields = "Initial Amount (LCY)", "Remaining Amount (LCY)";
        }
    }
}