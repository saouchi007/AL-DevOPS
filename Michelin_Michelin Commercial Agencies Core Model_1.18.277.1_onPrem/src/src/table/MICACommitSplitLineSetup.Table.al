table 80140 "MICA Commit/Split Line Setup"
{
    // version NAVW111.00
    DataClassification = CustomerContent;
    LookupPageId = "MICA Commit/Split Line Setup";
    DrillDownPageId = "MICA Commit/Split Line Setup";
    Caption = 'Commitment/Split Line Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(100; "Disable Latest Shipment Date"; Boolean)
        {
            Caption = 'Disable Latest Shipment Date';
            DataClassification = CustomerContent;
        }
        field(200; "Back Order Default Ship. Date"; Date)
        {
            Caption = 'Back Order Default Ship. Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

