/// <summary>
/// Page Consumers (ID 50144).
/// </summary>
page 50144 Consumers
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Consumers;
    Caption = 'Consumers List';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
