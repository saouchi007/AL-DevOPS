page 80875 "MICA License Information"
{
#if OnPremise
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "License Information";
    Editable = false;
    caption = 'License Information';

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("Text"; Text) { ApplicationArea = All; }
            }
        }
    }
#endif
}