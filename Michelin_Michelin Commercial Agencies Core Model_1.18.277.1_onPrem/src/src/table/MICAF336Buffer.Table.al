table 81941 "MICA F336 Buffer"
{
    DataClassification = CustomerContent;
    Caption = 'F336 Buffer';
    
    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(2; "Country-of Sales"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Country-of Sales';
        }
        field(3; "Market Code"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Market Code';
        }
        field(4; "Client Code"; code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Client Code';
        }
        field(5; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(6; "Net Turnover Invoiced"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Turnover Invoiced';
        }
        field(7; "Gross Annual Turnover"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Annual Turnover';
        }
        field(8; "Net Sales"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Sales';
        }
        field(9; CRV; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'CRV';
        }
        field(10; "Net Sales In The Inv. Currency"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Sales In The Invoice Currency';
        }
        field(11; "Invoicing Currency"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoicing Currency';
        }
        field(12; "Intercompany Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Intercompany Dimension';
        }
        field(13; "Structure Dimension"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Structure Dimension';
        }
        field(14; "Service Item"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Service Item';
        }

    }

    keys
    {
        key(PK; "Item No.", "Country-of Sales", "Market Code", "Client Code", "Invoicing Currency", "Intercompany Dimension", "Structure Dimension")
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