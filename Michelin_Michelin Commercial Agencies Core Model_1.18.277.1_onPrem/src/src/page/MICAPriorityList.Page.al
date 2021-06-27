page 81640 "MICA Priority List"
{
    
    PageType = List;
    SourceTable = "MICA Priority";
    Caption = 'Priority List';
    ApplicationArea = All;
    UsageCategory = Lists;
    
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