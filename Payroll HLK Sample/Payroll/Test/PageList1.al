page 50102 "Reward List"
{
    // Specify that this page will be a list page.
    PageType = List;
    // The page will be part of the "Lists" group of search results.
    UsageCategory = Lists;
    // The data of this page is taken from the "Reward" table.
    SourceTable = "Company Business Unit";
    // The "CardPageId" is set to the Reward Card previously created.
    // This will allow users to open records from the list in the "Reward Card" page.
    //CardPageId = "Reward Card";

    layout
    {
        area(content)
        {
            repeater(Rewards)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of reward that the customer has at this point.';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}