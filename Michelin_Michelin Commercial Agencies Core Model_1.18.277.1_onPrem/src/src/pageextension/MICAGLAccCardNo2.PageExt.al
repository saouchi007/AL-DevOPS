#pragma implicitwith disable
pageextension 80080 "MICA GLAccCardNo2" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("MICA No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
                //Caption = 'No.2';
            }
        }
        addafter("Cost Accounting")
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Excl. From Flux2 Report"; Rec."MICA Excl. From Flux2 Report")
                {
                    ApplicationArea = All;
                }
                field("MICA F2 Incl. Year Amt. Only"; Rec."MICA F2 Incl. Year Amt. Only")
                {
                    ApplicationArea = All;
                    Editable = not Rec."MICA Excl. From Flux2 Report";
                }
                field("MICA Incl. on Flux2 Code3 Rpt."; Rec."MICA Incl. on Flux2 Code3 Rpt.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
#pragma implicitwith restore
