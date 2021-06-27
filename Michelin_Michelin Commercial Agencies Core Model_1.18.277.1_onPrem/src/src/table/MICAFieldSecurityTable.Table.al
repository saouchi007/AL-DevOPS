table 81280 "MICA Field Security Table"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Field Security Table List";
    LookupPageId = "MICA Field Security Table List";
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            TableRelation = "Table Metadata".ID;
        }
        field(10; "Table Name"; Text[50])
        {
            Caption = 'Table Name';
            //DataClassification = CustomerContent;
            FieldClass = FlowField;
            CalcFormula = lookup ("Table Metadata".Caption where (ID = field ("Table ID")));
        }
        field(20; Enable; Boolean)
        {
            Caption = 'Enable';
            DataClassification = CustomerContent;
        }
        field(30; "No. Of Fields Setup"; Integer)
        {
            Caption = 'No. Of Fields Setup';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Field Security Field" where ("Table ID" = field ("Table ID")));
        }
    }

    keys
    {
        key(PK; "Table ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        MICAFieldSecurityField: Record "MICA Field Security Field";
    begin
        MICAFieldSecurityField.SetRange("Table ID", "Table ID");
        MICAFieldSecurityField.DeleteAll(true);
    end;

}