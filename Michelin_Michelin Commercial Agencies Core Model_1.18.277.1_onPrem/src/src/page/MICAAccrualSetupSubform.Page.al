page 81880 "MICA Accrual Setup Subform"
{
    PageType = ListPart;
    SourceTable = "MICA Accrual Setup Line";
    Caption = 'Lines';
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Minimum; Rec.Minimum)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Minimum';
                }
                field("% Accrual"; Rec."% Accrual")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the % Deferred Rebates';
                }
            }
        }
    }
}