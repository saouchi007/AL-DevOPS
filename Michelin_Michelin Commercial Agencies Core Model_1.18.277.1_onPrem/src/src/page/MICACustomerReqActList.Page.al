page 80105 "MICA Customer Req. Act. List"
{

    ApplicationArea = All;
    UsageCategory = Lists;

    Caption = 'Customer Request Activities';
    PageType = List;
    SourceTable = "MICA Interaction Activities";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interaction No."; Rec."Interaction No.")
                {
                    ApplicationArea = All;
                }
                field("Activity No."; Rec."Activity No.")
                {
                    ApplicationArea = All;
                }
                field("Activity Title"; Rec.Description)
                {
                    Caption = 'Activity Title';
                    ApplicationArea = All;
                }
                field("Activity Status"; Rec."Activity Status")
                {
                    ApplicationArea = All;
                }
                field("Assigned User Name"; Rec."Assigned User Name")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Estimated Ending Date"; Rec."Estimated Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                }
                field("Internal Comment"; Rec.GetInternalComment())
                {
                    Caption = 'Internal Comment';
                    ApplicationArea = All;
                }
                field("Public Comment"; Rec.GetPublicComment())
                {
                    Caption = 'Public Comment';
                    ApplicationArea = All;
                }
            }
        }
    }
}

