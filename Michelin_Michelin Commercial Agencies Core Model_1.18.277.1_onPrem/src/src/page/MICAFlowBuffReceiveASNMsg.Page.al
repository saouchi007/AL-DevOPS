
page 81500 "MICA FlowBuff Receive ASN Msg"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA FlowBuff Receive ASN Msg";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("GroupName")
            {
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
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
                field("Linked Record ID"; Rec."Linked Record ID")
                {
                    ApplicationArea = All;
                }
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                }
                field("Conversion Error"; Rec."Conversion Error")
                {
                    ApplicationArea = All;
                }

                //ASN Message fields
                field(MichReferencekey; Rec."MichReferencekey")
                {
                    ApplicationArea = All;
                }
                field(No; Rec."No")
                {
                    ApplicationArea = All;
                }
                field("Line_No"; Rec."Line_No")
                {
                    ApplicationArea = All;
                }
                field(ETA; Rec."ETA")
                {
                    ApplicationArea = All;
                }
                field(SRD; Rec."SRD")
                {
                    ApplicationArea = All;
                }
                field("ASN_Date"; Rec."ASN_Date")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
