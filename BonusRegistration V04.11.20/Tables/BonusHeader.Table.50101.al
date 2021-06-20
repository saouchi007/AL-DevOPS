table 50101 BonusHeaderTable
{
    DataClassification = CustomerContent;
    Caption = 'Header Table';
    DrillDownPageId = BonusListPage;
    LookupPageId = BonusListPage;

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

        }
        field(2; "Customer No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date';
        }
        field(4; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
        }
        field(5; "Status"; Enum BonusStatus)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}