table 80160 "MICA G/L Acc. Allowed Dim."
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA G/L Acc. Allowed Dim.";
    LookupPageId = "MICA G/L Acc. Allowed Dim.";

    fields
    {
        field(1; "MICA G/L Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";

        }
        field(2; "MICA Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(3; "MICA Dimension Value Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Code Value';
            TableRelation = "Dimension Value".Code where ("Dimension Code" = field ("MICA Dimension Code"));
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
    trigger OnInsert()
    begin
        rec.TestField("MICA Dimension Value Code");
    end;
}