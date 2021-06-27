page 80101 "MICA New Cust. Request SubForm"
{
    // version REQUEST

    //ApplicationArea = All;
    Caption = 'Activities';
    CardPageID = "MICA Interaction Activity";
    PageType = ListPart;
    SourceTable = "MICA Interaction Activities";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User Name")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Activity Status"; Rec."Activity Status")
                {
                    ApplicationArea = All;
                }
                field("Estimated Ending Date"; Rec."Estimated Ending Date")
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

