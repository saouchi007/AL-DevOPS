table 81282 "MICA F. Security User Access"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA F. Secur User Access List";
    DrillDownPageId = "MICA F. Secur User Access List";
    fields
    {
        field(1; "Table Id"; Integer)
        {
            Caption = 'Table Id';
            DataClassification = CustomerContent;
            TableRelation = "MICA Field Security Field"."Table ID";
        }
        field(10; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            DataClassification = CustomerContent;
            TableRelation = "MICA Field Security Field"."Field Id";
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Delete';
        }
        field(30; "User Group"; Code[20])
        {
            Caption = 'User Group';
            DataClassification = CustomerContent;
            TableRelation = "User Group".Code;
        }
        field(40; Restricted; Boolean)
        {
            Caption = 'Restricted';
            DataClassification = CustomerContent;
        }
        field(50; "User Guid"; Guid)
        {
            Caption = 'User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
        }
        field(60; "User Name"; Code[50])
        {
            Caption = 'User Name';
            Editable = false;
            CalcFormula = Lookup (User."Full Name" WHERE("User Security ID" = FIELD("User Guid"),
                                                         "License Type" = CONST("Full User")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Table Id", "Field ID", "User Guid", "User Group")
        {
            Clustered = true;
        }
    }

}