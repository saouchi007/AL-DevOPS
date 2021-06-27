pageextension 81820 "MICA SMTP Mail Setup" extends "SMTP Mail Setup"
{
    layout
    {
        addafter("User ID")
        {
            field("MICA Default From Email Addr."; Rec."MICA Default From Email Addr.")
            {
                ApplicationArea = All;
            }
        }
    }
}