/// <summary>
/// Page ISA_PlaneList (ID 50195).
/// </summary>
page 50195 ISA_PlaneList
{
    ApplicationArea = All;
    Caption = 'ISA_PlaneList';
    PageType = List;
    SourceTable = ISA_Plane;
    UsageCategory = Lists;
    CardPageId = 50196;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No. "; Rec."No. ")
                {
                    ToolTip = 'Specifies the value of the No . field.';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ApplicationArea = All;
                }
                field(PhoneNumber; Rec.PhoneNumber)
                {
                    ToolTip = 'Specifies the value of the Phone No field.';
                    ApplicationArea = All;
                }
                field(WebSite; Rec.WebSite)
                {
                    ToolTip = 'Specifies the value of the Web Site field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
