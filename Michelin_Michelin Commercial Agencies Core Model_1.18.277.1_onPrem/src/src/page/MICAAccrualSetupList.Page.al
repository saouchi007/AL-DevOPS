page 80768 "MICA Accrual Setup List"
{

    PageType = List;
    SourceTable = "MICA Accrual Setup";
    Caption = 'Rebate Setup List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "MICA Accrual Setup";
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                }
                field("Accr. Item  Grp."; Rec."Accr. Item  Grp.")
                {
                    ApplicationArea = All;
                }
                field("Begin Date"; Rec."Begin Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }

                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }

                field("Accruals Posting Code"; Rec."Accruals Posting Code")
                {
                    ApplicationArea = All;
                }
                field("Is Deferred"; Rec."Is Deferred")
                {
                    ApplicationArea = All;
                }
                field("Include in Fin. Report"; Rec."Include in Fin. Report")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
    trigger OnOpenPage()
    begin
        Rec.SetRange(Closed,false);
    end;
}
