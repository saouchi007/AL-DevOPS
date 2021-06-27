pageextension 80768 "MICA Value Entries Ext" extends "Value Entries"
{
    layout
    {
        addafter("Dimension Set ID")
        {
            field("MICA Accr. Item  Grp."; Rec."MICA Accr. Item Grp.")
            {
                ApplicationArea = All;
            }

            field("MICA Accr. Customer Grp."; Rec."MICA Accr. Customer Grp.")
            {
                ApplicationArea = All;
            }
            field("MICA Sell-to Customer No."; Rec."MICA Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
        }
    }
}