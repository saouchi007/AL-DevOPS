table 80023 "MICA Market Code"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Market Code List";
    //DrillDownPageId = "MICA Market Code List";
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(1; "Code"; Code[2])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[10])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(81760; "Business Line"; Option)
        {
            Caption = 'Business Line';
            OptionMembers = "","LB-OE","LB-RT";
            OptionCaption = ',LB-OE,LB-RT';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}