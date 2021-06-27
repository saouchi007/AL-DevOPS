page 81260 "MICA FlowBuff Receive TranspEv"
{  //EDD-ITG-003: GIT – Transport Event Integration

    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA FlowBuff Receive TranspEv";
    Caption = 'Flow Buffer GIT – Transport Event Integration';

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
                field("Document_No"; Rec.Document_No)
                {
                    ApplicationArea = All;
                }
                field(SRD; Rec.SRD)
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
                begin
                    message('Need to be created.');
                end;
            }
            action(PostProcess)
            {
                Caption = 'Postprocess Transport Event';
                ApplicationArea = All;
                Image = Process;
                trigger OnAction()
                var
                    Process: Codeunit "MICA Transport Event Integrat";
                begin
                    Process.Run();
                end;
            }
            action("Transport Event Set SRD")
            {
                Caption = 'Transport Event Set SRD';
                ApplicationArea = All;
                Visible = false;
                Image = ChangeDates;
                trigger OnAction()
                var
                    JobQ: Record "Job Queue Entry";
                    SetSRD: Codeunit "MICA Transport Event Set SRD";
                begin
                    SetSRD.Run(JobQ);
                end;
            }

        }
    }

}
