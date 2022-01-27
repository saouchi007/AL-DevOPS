pageextension 50021 SPS extends "User Setup"
{
    layout
    {
        addafter("User ID")
        {
            field("Company Business Unit"; "Company Business Unit")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}