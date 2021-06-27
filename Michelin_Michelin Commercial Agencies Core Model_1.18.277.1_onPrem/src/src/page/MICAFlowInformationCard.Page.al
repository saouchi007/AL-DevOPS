page 80869 "MICA Flow Information Card"
{
    PageType = Card;
    SourceTable = "MICA Flow Information";
    Caption = 'Interface Flow Information Card';
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group(General)
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
                field("Flow Buffer Entry No."; Rec."Flow Buffer Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Info Type"; Rec."Info Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                }
                field("End Date Time"; Rec."End Date Time")
                {
                    ApplicationArea = All;
                }
                field("Information Duration"; Rec."Information Duration")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
