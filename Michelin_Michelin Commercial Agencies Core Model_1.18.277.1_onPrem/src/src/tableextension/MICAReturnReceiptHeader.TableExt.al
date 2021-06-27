tableextension 81122 "MICA Return Receipt Header" extends "Return Receipt Header" //MyTargetTableId
{
    fields
    {
        field(81120; "MICA Return Order With Collect"; Boolean)
        {
            Caption = 'Return Order With Collect';
            DataClassification = CustomerContent;
        }
        field(81570; "MICA Retrieve-From Addr. Code"; Code[10])
        {
            Caption = 'Retrieve-From Address Code';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
            Editable = false;
        }
        field(81571; "MICA Retrieve-From Address"; Text[50])
        {
            Caption = 'Retrieve-From Address';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}