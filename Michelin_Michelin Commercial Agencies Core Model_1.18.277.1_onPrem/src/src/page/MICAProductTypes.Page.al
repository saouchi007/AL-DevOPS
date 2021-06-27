page 81801 "MICA Product Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Product Type";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product Type"; Rec."Product Type")
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

    actions
    {
    }
}