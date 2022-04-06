/// <summary>
/// Table ISA_SOImportBuffer (ID 50197).
/// </summary>
table 50197 ISA_SOImportBuffer
{
    DataClassification = CustomerContent;
    Caption = 'Sales Orders Import Buffer';
    fields
    {
        field(1; BatchName; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Batch Name';
        }
        field(2; LineNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No. ';
            Editable = false;
        }
        field(3; FileName; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'File Name';
            Editable = false;
        }
        field(4; "Sheet Name"; Text[30])
        {
            Caption = 'Sheet Name';
            DataClassification = CustomerContent;
        }
        field(5; "Imported Date"; Date)
        {
            Caption = 'Imported Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Imported Time"; Time)
        {
            Caption = 'Imported Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(8; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(11; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(12; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(13; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(14; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(16; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; BatchName, LineNo)
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