pageextension 81552 "MICA Employee Card" extends "Employee Card" //MyTargetPageId
{
    layout
    {
        addlast(Payments)
        {
            field("MICA NCC"; Rec."MICA NCC")
            {
                ApplicationArea = All;
            }
            field("MICA Ctry Credit Agent No."; Rec."MICA Ctry Credit Agent No.")
            {
                ApplicationArea = All;
            }
            field("MICA Bank Beneficiary Name"; Rec."MICA Bank Beneficiary Name")
            {
                ApplicationArea = all;
            }
            field("MICA Bank Account Type"; Rec."MICA Bank Account Type")
            {
                ApplicationArea = all;
            }
            field("MICA Employee VAT Reg. No."; Rec."MICA Employee VAT Reg. No.")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Method Code"; Rec."MICA Payment Method Code")
            {
                ApplicationArea = All;
            }
            
        }

    }

    actions
    {
    }
}