
page 80866 "MICA Flow Record List"
{

    PageType = List;
    SourceTable = "MICA Flow Record";
    Caption = 'Interface Flow Records';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    CardPageId = "MICA Flow Record Card";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                }
                /*field("Info Count"; "Info Count")
                {
                    ApplicationArea = All;
                }
                field("Warning Count"; "Warning Count")
                {
                    ApplicationArea = All;
                }
                field("Error Count"; "Error Count")
                {
                    ApplicationArea = All;
                }*/
                field("Disable Post-Processed"; Rec."Disable Post-Processed")
                {
                    ApplicationArea = All;
                }
                field("Date Time Creation"; Rec."Date Time Creation")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}