table 80120 "MICA G/L Acc. Forced Dim."
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA G/L Acc. Forced Dim.";
    DrillDownPageId = "MICA G/L Acc. Forced Dim.";
    fields
    {
        field(1; "MICA G/L Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            NotBlank = true;

        }
        field(2; "MICA Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Code';
            TableRelation = Dimension;
            NotBlank = true;
        }
        field(3; "MICA Dimension Value Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Code Value';
            TableRelation = "Dimension Value".Code
                where
                    (
                        "Dimension Code" = field ("MICA Dimension Code"),
                        "Dimension Value Type" = const (Standard)
                    );
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "MICA G/L Account No.", "MICA Dimension Code", "MICA Dimension Value Code")
        {
            Clustered = true;
        }
    }
}