pageextension 81170 "MICA VAT Entries" extends "VAT Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("MICA Tax Area Code"; Rec."Tax Area Code")
            {
                ApplicationArea = all;
            }
            field("MICA Tax Group Code"; Rec."Tax Group Code")
            {
                ApplicationArea = all;
            }
            field("MICA Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
            {
                ApplicationArea = all;
            }
        }
    }
}