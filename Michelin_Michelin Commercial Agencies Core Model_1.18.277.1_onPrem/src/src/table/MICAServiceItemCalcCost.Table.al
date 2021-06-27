table 81942 "MICA Service Item Calc. Cost"
{
    DataClassification = CustomerContent;
    Caption = 'Service Item Calculation Cost';
    
    fields
    {
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(3; "Country-of Sales"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country-of Sales';
        }
        field(4; "Market Code"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Market Code';
        }
        field(5; "Client Code"; code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Client Code';
        }
        field(6; "Net Turnover Invoiced"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Turnover Invoiced';
        }
        field(7; "Invoicing Currency"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoicing Currency';
        }
        field(8; "Intercompany Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Intercompany Dimension';
        }
        field(9; "Structure Dimension"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Structure Dimension';
        }
        field(10; "% of cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% of cost';
        }
    }

    keys
    {
        key(PK; "Item No.", "Country-of Sales", "Market Code", "Client Code", "Invoicing Currency", "Intercompany Dimension", "Structure Dimension")
        {
            Clustered = true;
        }
        key(SK1; "Structure Dimension")
        {
        }
        key(SK2; "Country-of Sales", "Market Code", "Client Code", "Invoicing Currency", "Intercompany Dimension", "Structure Dimension")
        {
            SumIndexFields = "Net Turnover Invoiced";
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