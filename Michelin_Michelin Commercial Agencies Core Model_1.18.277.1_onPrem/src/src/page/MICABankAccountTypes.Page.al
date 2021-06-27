page 81550 "MICA Bank Account Types"
{

    PageType = List;
    SourceTable = "MICA Bank Account Type";
    Caption = 'Bank Account Types';
    ApplicationArea = All;
    UsageCategory = Administration;

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
            }
        }
    }

}
