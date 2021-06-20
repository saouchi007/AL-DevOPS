page 60000 "Demo Item"
{
    PageType = List;
    SourceTable = "Demo Item";
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
            }
        }

    }
}