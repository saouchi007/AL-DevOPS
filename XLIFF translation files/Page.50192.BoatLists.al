/// <summary>
/// Page Page.50192.BoatLists (ID 50192).
/// </summary>
page 50192 "Page.50192.BoatLists"
{
    ApplicationArea = All;
    Caption = 'Boat List';
    PageType = List;
    SourceTable = ISA_Boat;
    UsageCategory = Lists;
    CardPageId = 50193;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No. "; Rec."No. ")
                {
                    ToolTip = 'Specifies the value of the No.  field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Speed; Rec.Speed)
                {
                    ToolTip = 'Specifies the value of the Speed Km/H field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
