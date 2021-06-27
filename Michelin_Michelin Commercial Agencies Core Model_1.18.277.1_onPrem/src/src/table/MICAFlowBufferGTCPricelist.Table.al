table 80940 "MICA Flow Buffer GTCPricelist"
{
    DataClassification = CustomerContent;
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(10; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow EndPoint";
        }
        field(20; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(30; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Flow Code" where("Entry No." = field("Flow Entry No.")));
        }
        field(40; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(50; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(60; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(70; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error), "Flow Buffer Entry No." = field("Entry No.")));
        }

        field(100; "Error"; Boolean)
        {
            DataClassification = CustomerContent;
        }

        //GTC Fields
        field(80940; "Bloc Type"; Text[1])
        {
            DataClassification = CustomerContent;
        }
        field(80941; "Header Raw File Date"; Text[8])
        {
            DataClassification = CustomerContent;
        }
        field(80942; "Header File Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80943; "Line Price List Code"; Text[4])
        {
            DataClassification = CustomerContent;
        }
        field(80944; "Line Item Type"; Text[2])
        {
            DataClassification = CustomerContent;
        }
        field(80945; "Line Item Code"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(80946; "Line Invoicing Unit"; Text[3])
        {
            DataClassification = CustomerContent;
        }
        field(80947; "Line Price Code"; Text[5])
        {
            DataClassification = CustomerContent;
        }
        field(80948; "Line Raw Start Date"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(80949; "Line Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80950; "Line Raw End Date"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(80951; "Line End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80952; "Line Raw Transfer Price"; Text[12])
        {
            DataClassification = CustomerContent;
        }
        field(80953; "Line Transfer Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80954; "Line Currency Code"; Text[3])
        {
            DataClassification = CustomerContent;
        }
        field(80955; "Raw Record Counter"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(80956; "Record Counter"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Validate("Date Time Creation", CurrentDateTime());
    end;
}