page 82440 "MICA Flow Buffer ETA SRD List"
{

    PageType = List;
    SourceTable = "MICA Flow Buffer ETA SRD";
    Caption = 'MICA Flow Buffer ETA SRD List';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Time Creation"; Rec."Date Time Creation")
                {
                    ApplicationArea = All;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                }
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                }
                field("ASN No. Raw"; Rec."ASN No. Raw")
                {
                    ApplicationArea = All;
                }
                field("ASN No."; Rec."ASN No.")
                {
                    ApplicationArea = All;
                }
                field("SRD Raw"; Rec."SRD Raw")
                {
                    ApplicationArea = All;
                }
                field(SRD; Rec.SRD)
                {
                    ApplicationArea = All;
                }
                field("ETA Raw"; Rec."ETA Raw")
                {
                    ApplicationArea = All;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
