page 80867 "MICA Flow Record Card"
{
    PageType = Card;
    SourceTable = "MICA Flow Record";
    Caption = 'Interface Flow Record Card';
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
                field("RecordId"; Rec."Linked RecordID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
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
