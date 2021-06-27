tableextension 80760 "MICA User Setup" extends "User Setup"
{
    fields
    {
        field(80760; "MICA Allow Run JobQueue"; Boolean)
        {
            Caption = 'Allow Run JobQueue';
            DataClassification = CustomerContent;
        }
        field(81170; "MICA Allow Amt.FCY Era.Process"; Boolean)
        {
            Caption = 'Allow Amount FCY Erasing Process';
            DataClassification = CustomerContent;
        }
        field(81180; "MICA User Category"; Code[10])
        {
            Caption = 'User Category';
            DataClassification = CustomerContent;
            TableRelation = "MICA User Category".Code;

        }
        field(81280; "MICA Allow SalePrice & CTC Upd"; Boolean)
        {
            Caption = 'Allow Sales Price & CTC Update';
            DataClassification = CustomerContent;
        }
        field(81281; "MICA Allow Dates SO lines"; Boolean)
        {
            Caption = 'Allow Dates SO lines';
            DataClassification = CustomerContent;
        }
        field(81290; "MICA Allow Deletion Rebates"; Boolean)
        {
            Caption = 'Allow Deletion Rebate Ledger Entries';
            DataClassification = CustomerContent;
        }
        field(81291; "MICA Allow Calc. Rebates"; Boolean)
        {
            Caption = 'Allow Calculate Rebate Ledger Entries';
            DataClassification = CustomerContent;
        }
        field(82920; "MICA 3rd Party Vendor No."; Code[20])
        {
            Caption = '3rd Party Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(82941; "MICA Allow Combine Shipments"; Boolean)
        {
            Caption = 'Allow Combine Shipments';
            DataClassification = CustomerContent;
        }

        field(83000; "MICA Allow Edit Reb. Pool Jnl."; Boolean)
        {
            Caption = 'Allow Edit Rebate Pool Journal';
            DataClassification = CustomerContent;
        }
    }

}