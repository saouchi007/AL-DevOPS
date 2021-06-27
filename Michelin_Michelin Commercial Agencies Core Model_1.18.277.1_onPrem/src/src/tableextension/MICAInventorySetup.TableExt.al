tableextension 81320 "MICA Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            Editable = false;
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(81320; "MICA DRP stock flow code"; Code[20])
        {
            Caption = 'DRP stock flow code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(81340; "MICA DRP conf. order flow code"; Code[20])
        {
            Caption = 'DRP confirmed flow code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
            Description = 'DRP confirmed flow code';
        }
        field(81360; "MICA DRP ord. ship. flow code"; Code[20])
        {
            Caption = 'DRP orders shipped flow code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
            Description = 'DRP orders shipped flow code';
        }
        field(82360; "MICA DRP InTransit Flow Code"; code[20])
        {
            Caption = 'DRP InTransit Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
            Description = 'DRP InTransit Flow Code';
        }

        field(82800; "MICA Purchase Location Code"; code[10])
        {
            Caption = 'Purchase Location';
            DataClassification = CustomerContent;
            TableRelation = Location where("Use As In-Transit" = filter(false));
            Description = 'EDD_TRO058';
        }
        field(82820; "MICA Keep Value in Item Card"; Boolean)
        {
            Caption = 'Keep Value in Item Card';
            DataClassification = CustomerContent;
        }
        field(82080; "MICA Item Weight Default UoM"; Code[10])
        {
            Caption = 'Item Weight Default Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure".Code;
        }
        field(82085; "MICA Item to PS9 Weight Factor"; Decimal)
        {
            Caption = 'Item to PS9 Weight Factor';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            InitValue = 0.01;
        }
        field(82090; "MICA Item Wght Decimal Places"; Decimal)
        {
            Caption = 'Item Weight Decimal Places';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            InitValue = 0.01;
            MinValue = 0;
        }
    }
}