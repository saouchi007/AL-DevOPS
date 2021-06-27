tableextension 80768 "MICA ValueEntriesExt" extends "Value Entry"
{
    fields
    {
        field(80760; "MICA Accr. Item Grp."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Item Group';
            TableRelation = "Item"."MICA Accr. Item Grp.";
        }
        field(80761; "MICA Accr. Customer Grp."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Customer Group';
            TableRelation = Customer."MICA Accr. Customer Grp.";
        }
        field(80762; "MICA Sell-to Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
    }
}