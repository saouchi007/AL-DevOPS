page 82879 "MICA S2S PO External Events"
{
    ApplicationArea = All;
    Caption = 'Purchase Order External Events (s2s)';
    PageType = List;
    SourceTable = "MICA S2S P.Header Ext. Event";
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
