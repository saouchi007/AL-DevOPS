page 80860 "MICA Flow Partner List"
{

    PageType = List;
    SourceTable = "MICA Flow Partner";
    Caption = 'Interface Flow Partners';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("EndPoint Substitute Value 1"; Rec."EndPoint Substitute Value 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %6 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 2"; Rec."EndPoint Substitute Value 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %7 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 3"; Rec."EndPoint Substitute Value 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %8 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 4"; Rec."EndPoint Substitute Value 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %9 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 5"; Rec."EndPoint Substitute Value 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %10 in EndPoint substitution';
                }
                field("Flow Count"; Rec."Flow Count")
                {
                    ApplicationArea = All;
                }
                field("Count of Entry"; Rec."Count of Entry")
                {
                    ApplicationArea = All;
                }
                field("Count of Archived File"; Rec."Count of Archived File")
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                }
                field("Last Modified User ID"; Rec."Last Modified User ID")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

}
