table 81940 "MICA Deferred Calc Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Accruals Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates Code';
        }
        field(2; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(3; "Accruals Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates Amount';
        }
        field(4; "Total Accruals Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Deferred Rebates Amount';
        }
        field(5; "Country-of Sales"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country-of Sales';
        }
        field(6; "Market Code"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Market Code';

        }
        field(7; "Forecast Code"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Forecast Code';
        }
        field(8; "Intercompany Dimension"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Intercompany Dimension';
        }
        field(9; "Accruals %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates %';
        }
        field(10; "Structure Dimension"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Structure Dimension';
        }
        field(11; "Total G/L Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total G/L Amount';
        }
        field(12; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
        }
    }

    keys
    {
        key(PK; "Accruals Code", "Country-of Sales", "Market Code", "Forecast Code", "Intercompany Dimension", "Structure Dimension", "Item No.", "Currency Code")
        {
            Clustered = true;
        }
    }

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