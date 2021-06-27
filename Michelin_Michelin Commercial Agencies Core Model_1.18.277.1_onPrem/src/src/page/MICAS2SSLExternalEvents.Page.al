page 82871 "MICA S2S SL External Events"
{
    ApplicationArea = All;
    Caption = 'Sales Line External Events (s2s)';
    PageType = List;
    SourceTable = "MICA S2S S.Line Ext. Event";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Event Date Time"; Rec."Event Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Source Event Type"; Rec."Source Event Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Source Record ID"; Rec."Source Record ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Resource; Rec.Resource)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

}
