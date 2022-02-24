/// <summary>
/// Table TotalSalesLines (ID 50153).
/// </summary>
table 50153 TotalSalesLines
{
    DataClassification = CustomerContent;
    Caption = 'Total Sales Lines';

    fields
    {
        field(1; Number; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number';

        }
        field(2; LinesCount; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Count';
        }
        field(3; LinesAverage; Decimal)
        {
            Caption = 'Average';
            DataClassification = CustomerContent;
        }
        field(4;Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
    }

    keys
    {
        key(PK; Number)
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