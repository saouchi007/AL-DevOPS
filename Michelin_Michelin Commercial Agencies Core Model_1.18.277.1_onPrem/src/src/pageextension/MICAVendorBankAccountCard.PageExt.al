pageextension 82060 "MICA Vendor Bank Account Card" extends "Vendor Bank Account Card"
{
    layout
    {
        addafter(Name)
        {
            field("MICA Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("MICA Blocked"; Rec."MICA Blocked")
            {
                ApplicationArea = All;
            }
        }

        addafter(IBAN)
        {
            field("MICA Bank Account Type"; Rec."MICA Bank Account Type")
            {
                ApplicationArea = all;
            }
        }
    }
}