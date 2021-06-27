tableextension 80860 "MICA General Ledger Setup" extends "General Ledger Setup" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Field Security Enable"; Boolean)
        {
            Caption = 'Field Security Enable';
            DataClassification = CustomerContent;
        }
        field(80010; "MICA Mandatory Field Enable"; Boolean)
        {
            Caption = 'Mandatory Field Enable';
            DataClassification = CustomerContent;
        }
        field(80860; "MICA Special Characters"; Text[250])
        {
            Caption = 'Special Characters';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("MICA Special Char. Length", StrLen("MICA Special Characters"));
            end;
        }
        field(80861; "MICA Special Char. Length"; Integer)
        {
            Caption = 'Special Char. Length';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80862; "MICA Translated Characters"; Text[250])
        {
            Caption = 'Translated Characters';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("MICA Translated Char. Length", StrLen("MICA Translated Characters"));
            end;
        }
        field(80864; "MICA Translated Char. Length"; Integer)
        {
            Caption = 'Translated Char. Length';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81760; "MICA LB Dimension code"; Code[20])
        {
            Caption = 'LB Dimension code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;

        }
        field(81780; "MICA Last DateTime SO Archive"; DateTime)
        {
            Caption = 'Last DateTime SO Archive';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}