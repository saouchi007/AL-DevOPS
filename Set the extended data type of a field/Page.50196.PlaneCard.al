/// <summary>
/// Page ISA_PlaneCard (ID 50196).
/// </summary>
page 50196 ISA_PlaneCard
{
    Caption = 'ISA_PlaneCard';
    PageType = Card;
    SourceTable = ISA_Plane;

    layout
    {
        area(content)
        {
            group(General)
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
                field(Ratio; Rec.Ratio)
                {
                    ToolTip = 'Specifies the value of the Ratio field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ratio := 20;
        CalcFields(Rec.Ratio);
        Message('%1', Rec.Ratio);
    end;
}
