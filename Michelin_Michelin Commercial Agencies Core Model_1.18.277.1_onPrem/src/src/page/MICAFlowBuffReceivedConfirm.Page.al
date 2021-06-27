page 81210 "MICA FlowBuff Received Confirm"
{
    //INT-3PL-006: Received confirmation (in)
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA FlowBuff ReceivedConfirm2";
    Caption = 'Flow Buffer Received Confirmation';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
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
                    Editable = false;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                }
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error"; Rec.Error)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                //REceive Confirmation (in) Fields
                field("RAW Actual Ship DateTime"; Rec."RAW Actual Delivery DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Actual Ship DateTime"; Rec."Actual Delivery DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("RAW Shipped Quantity"; Rec."RAW Received Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipped Quantity"; Rec."Received Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("RAW Document Line Number"; Rec."RAW Document Line Number")
                {
                    ApplicationArea = All;
                }
                field("Document Line Number"; Rec."Document Line Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("RAW Planned Ship Quantity"; Rec."RAW Expected Quantity")
                {
                    ApplicationArea = All;
                }
                field("Planned Ship Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import to Buffer")
            {
                Caption = 'Import to Buffer';
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Extract: Codeunit "MICA Flow Extract ReceivedConf";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Extract.Run(FlowEntry);
                end;
            }
            action("Import Received Confirmation")
            {
                Caption = 'Import Received Confirmation';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Receive: Codeunit "MICA Flow Process ReceivedConf";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Receive.Run(FlowEntry);
                end;
            }
        }
    }
}
