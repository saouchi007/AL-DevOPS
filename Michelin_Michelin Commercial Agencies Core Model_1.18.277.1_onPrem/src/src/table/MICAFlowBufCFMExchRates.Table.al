table 80925 "MICA Flow Buf. CFM Exch. Rates"
{
    Caption = 'Flow Buffer CFM Exchange Rates';
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Buf. CFM Exch. Rates";
    LookupPageId = "MICA Flow Buf. CFM Exch. Rates";

    fields
    {
        field(1; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
            Editable = false;
        }
        field(2; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry"."Entry No.";

            trigger OnValidate()
            var
                MICAFlowEntry: Record "MICA Flow Entry";
            begin
                if MICAFlowEntry.Get("Flow Entry No.") then
                    Rec.Validate("Flow Code", MICAFlowEntry."Flow Code");
            end;
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Creation Date/time"; DateTime)
        {
            Caption = 'Creation Date/time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No."),
                                 "Flow Entry No." = field("Flow Entry No.")));
        }
        field(60; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No."),
                                 "Flow Entry No." = field("Flow Entry No.")));
        }
        field(70; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Buffer Entry No." = field("Entry No."),
                                 "Flow Entry No." = field("Flow Entry No.")));
        }
        field(80; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
        }
        field(90; "Linked Record ID"; RecordId)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            Editable = False;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }
        field(100; "Error"; Boolean)
        {
            Caption = 'Error';
            DataClassification = CustomerContent;
        }
        field(110; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(120; "Last Modified Date/Time"; DateTime)
        {
            Caption = 'Last Modified Date/Time';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // QUANTUM RATES FIELDS
        field(80000; "Bloc Type"; Text[2])
        {
            Caption = 'Bloc Type';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(80010; "Exchange Rate Date Raw"; Text[8])
        {
            Caption = 'Exchange Rate Date Raw';
            DataClassification = CustomerContent;
        }
        field(80020; "Exchange Rate Date"; Date)
        {
            Caption = 'Exchange Rate Date';
            DataClassification = CustomerContent;
        }
        field(80030; "Exchange Rate Receipt Date Raw"; Text[8])
        {
            Caption = 'Exchange Rate Receipt Date Raw';
            DataClassification = CustomerContent;
        }
        field(80040; "Exchange Rate Receipt Date"; Date)
        {
            Caption = 'Exchange Rate Receipt Date';
            DataClassification = CustomerContent;
        }
        field(80050; "Base Currency Code Raw"; Text[10])
        {
            Caption = 'Base Currency Code Raw';
            DataClassification = CustomerContent;
        }
        field(80060; "Base Currency Code"; Code[10])
        {
            Caption = 'Base Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
        }
        field(80070; "Country/Region Description"; Text[20])
        {
            Caption = 'Country/Region Description';
            DataClassification = CustomerContent;
        }
        field(80080; "Currency Code Raw"; Text[10])
        {
            Caption = 'Currency Code Raw';
            DataClassification = CustomerContent;
        }
        field(80090; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
        }
        field(80100; "Direct Cross Rate Raw"; Text[20])
        {
            Caption = 'Direct Cross Rate Raw';
            DataClassification = CustomerContent;
        }
        field(80110; "Direct Cross Rate"; Decimal)
        {
            Caption = 'Direct Cross Rate';
            DecimalPlaces = 1 : 6;
            DataClassification = CustomerContent;
        }
        field(80120; "Indirect Cross Rate Raw"; Text[20])
        {
            Caption = 'Indirect Cross Rate Raw';
            DataClassification = CustomerContent;
        }
        field(80130; "Indirect Cross Rate"; Decimal)
        {
            Caption = 'Indirect Cross Rate';
            DecimalPlaces = 1 : 6;
            DataClassification = CustomerContent;
        }
        field(80140; Unit; Text[1])
        {
            Caption = 'Unit';
            DataClassification = CustomerContent;
        }
        field(80150; "Country/Region Code Raw"; Text[10])
        {
            Caption = 'Country/Region Code Raw';
            DataClassification = CustomerContent;
        }
        field(80160; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
        }
    }
    keys
    {
        key(PK; "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key01; "Bloc Type", "Base Currency Code", Error)
        { }
    }
    trigger OnInsert()
    var
        MICAFlowBufCFMExchRates: Record "MICA Flow Buf. CFM Exch. Rates";
    begin
        if MICAFlowBufCFMExchRates.FindLast() then
            "Entry No." := MICAFlowBufCFMExchRates."Entry No." + 1
        else
            "Entry No." := 1;
        Validate("Creation Date/time", CurrentDateTime());
    end;

    trigger OnModify()
    begin
        Validate("Last Modified Date/Time", CurrentDateTime());
    end;

}
