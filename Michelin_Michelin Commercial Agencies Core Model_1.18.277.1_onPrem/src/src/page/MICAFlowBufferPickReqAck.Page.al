page 81220 "MICA Flow Buffer Pick Req.Ack."
{//INT-3PL-007: Pick request acknowledgement (in)
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA Flow Buffer Pick Req.Ack2";
    Caption = 'Flow Buffer Pick Request Ack. (in)';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
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
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                }
                field("Error"; Rec."Error")
                {
                    ApplicationArea = All;
                }
                field("Date Time Last Modified"; Rec."Date Time Last Modified")
                {
                    ApplicationArea = All;
                }

                //Pick request acknowledgement (in)
                field("RAW REFERENCEID"; Rec."RAW REFERENCEID")
                {
                    ApplicationArea = All;
                }
                field("Shipment No."; Rec."Shipment No.")
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
                field(ORIGREF; Rec.ORIGREF)
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
                    Extract: Codeunit "MICA Flow Extract Pick Req.Ack";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Extract.Run(FlowEntry);
                end;
            }
            action("Import Pick Request Ack.")
            {
                Caption = 'Import Pick Request Ack.';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Receive: Codeunit "MICA Flow Process Pick Req.Ack";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Receive.Run(FlowEntry);
                end;
            }
            action("Check for OverDelay Pick Request Ack.")
            {
                Caption = 'Check for OverDelay Pick Request Ack.';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    Check: Codeunit "MICA Set 3PL Error Whs. Ship.";
                begin
                    Check.Run();
                end;
            }

        }
    }

}
