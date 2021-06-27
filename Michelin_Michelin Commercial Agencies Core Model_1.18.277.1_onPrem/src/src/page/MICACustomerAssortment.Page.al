page 80061 "MICA Customer Assortment"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SC - Cust. Assortment";
    Editable = False;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec."Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Category Code (Internal)"; Rec."Item Category Code (Internal)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Mode; Rec."Mode")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}