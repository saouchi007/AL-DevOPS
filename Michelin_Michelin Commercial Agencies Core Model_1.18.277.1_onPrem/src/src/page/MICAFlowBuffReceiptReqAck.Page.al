page 81240 "MICA FlowBuff Receipt Req.Ack."
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA FlowBuff Receive Req.Ack2";
    Caption = 'Flow Buffer Receive Request Ack. (in)';

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
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
                }
                field("Error"; Rec."Error")
                {
                    ApplicationArea = All;
                }

                //Pick request acknowledgement (in)
                field("RAW REFERENCEID"; Rec."RAW REFERENCEID")
                {
                    ApplicationArea = All;
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Time Stamp"; Rec."Time Stamp")
                {
                    ApplicationArea = All;
                }
                field(STATUSLVL; Rec."STATUSLVL")
                {
                    ApplicationArea = All;
                }
                field(DESCRIPTN; Rec."DESCRIPTN")
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
                    Extract: Codeunit "MICA Flow Extract Rcv.Req.Ack";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Extract.Run(FlowEntry);
                end;
            }
            action("Import Receive Request Ack.")
            {
                Caption = 'Import Receive Request Ack.';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Receive: Codeunit "MICA Flow Process Rcv.Req.Ack";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Receive.Run(FlowEntry);
                end;
            }
            action("Check for OverDelay Receive Request Ack.")
            {
                Caption = 'Check for OverDelay Receive Request Ack.';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    Check: Codeunit "MICA Set 3PL Error Whs.Receipt";
                begin
                    Check.Run();
                end;
            }

        }
    }

}
