page 80027 "MICA Time Zone List"
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "Time Zone";
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Display Name"; Rec."Display Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}