table 81281 "MICA Field Security Field"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Field Security Field List";
    LookupPageId = "MICA Field Security Field List";
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            TableRelation = "MICA Field Security Table";
        }
        field(10; "Field Id"; Integer)
        {
            Caption = 'Field Id';
            DataClassification = CustomerContent;
            TableRelation = Field."No." where (TableNo = field ("Table ID"), Class = const (Normal));
        }
        field(20; "Field Caption"; Text[50])
        {
            Caption = 'Field Caption';
            FieldClass = FlowField;
            CalcFormula = lookup (Field."Field Caption" where (TableNo = field ("Table ID"), "No." = field ("Field Id")));
        }
        field(30; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
            DataClassification = CustomerContent;
        }
        field(40; "Equal To"; Text[250])
        {
            Caption = 'Equal To';
            DataClassification = CustomerContent;
        }
        field(50; "User Access Count"; Integer)
        {
            Caption = 'User Access Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA F. Security User Access" where ("Table Id" = field ("Table ID"), "Field ID" = field ("Field Id")));
        }
    }

    keys
    {
        key(PK; "Table ID", "Field Id")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        MICAFSecurityUserAccess: Record "MICA F. Security User Access";
    begin
        MICAFSecurityUserAccess.SetRange("Table Id", "Table ID");
        MICAFSecurityUserAccess.SetRange("Field ID", "Field Id");
        MICAFSecurityUserAccess.DeleteAll(true);
    end;

    procedure TableIsEnable(): Boolean
    var
        MICAFieldSecurityTable: Record "MICA Field Security Table";
    begin
        if MICAFieldSecurityTable.Get("Table ID") then
            exit(MICAFieldSecurityTable.Enable);
        exit(false);
    end;

    procedure GetTableName(): Text[50]
    var
        MICAFieldSecurityTable: Record "MICA Field Security Table";
    begin
        if MICAFieldSecurityTable.Get("Table ID") then begin
            MICAFieldSecurityTable.CalcFields("Table Name");
            exit(MICAFieldSecurityTable."Table Name");
        end;
        exit('');
    end;
}