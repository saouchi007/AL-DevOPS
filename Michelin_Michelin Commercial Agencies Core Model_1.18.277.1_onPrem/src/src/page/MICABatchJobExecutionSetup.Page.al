page 81040 "MICA Batch Job Execution Setup"//MyTargetPageId
{
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "MICA Batch Job Execution Setup";
    Caption = 'Batch Job Execution Setup';

    layout
    {
        area(Content)
        {
            Group(General)
            {
                field("Parameter String"; Rec."Parameter String")
                {
                    ApplicationArea = All;
                }
                field("Ending date"; Rec."Ending date")
                {

                    ApplicationArea = All;
                }

                field(Period; Rec."Period")
                {
                    ApplicationArea = All;
                }

                field(Location; Rec."Location")
                {
                    ApplicationArea = All;
                }

                field("Combine shipments"; Rec."Combine shipments")
                {
                    ApplicationArea = All;
                }
                field("Shipping agent"; Rec."Shipping agent")
                {

                    ApplicationArea = All;
                }
            }
            group("Report Status Bar")
            {
                field("Maximum No. of Attempts to Run"; Rec."Maximum No. of Attempts to Run")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Last Ready State"; Rec."Last Ready State")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Earliest Start Date/Time"; Rec."Earliest Start Date/Time")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Expiration Date/Time"; Rec."Expiration Date/Time")
                {
                    Editable = NOT Rec.Created;

                    ApplicationArea = All;
                }

                field(Status; Rec."Status")
                {
                    Editable = NOT Rec.Created;

                    ApplicationArea = All;
                }
            }
            group("Recurrence Tab")
            {
                field("Recurring Job"; Rec."Recurring Job")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }


                field("Run on Mondays"; Rec."Run on Mondays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Run on Tuesdays"; Rec."Run on Tuesdays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Run on Wednesdays"; Rec."Run on Wednesdays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Run on Thursdays"; Rec."Run on Thursdays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Run on Fridays"; Rec."Run on Fridays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Run on Saturdays"; Rec."Run on Saturdays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Run on Sundays"; Rec."Run on Sundays")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }


                field("Starting Time"; Rec."Starting Time")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("No. of Minutes between Runs"; Rec."No. of Minutes between Runs")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }
                field("Inactivity Timeout Period"; Rec."Inactivity Timeout Period")
                {
                    Editable = NOT Rec.Created;
                    ApplicationArea = All;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Create)
            {
                Caption = 'Create Joq Queue Entry';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                Image = Job;
                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                    //BatchJobExec: codeunit "MICA Batch Job Exec";
                    JobEntryAlreadyExistsLbl: Label 'JOB queue for this batch already exists';
                begin
                    JobQueueEntry.SetRange(JobQueueEntry."Parameter String", Rec."Parameter String");
                    IF JobQueueEntry.FindFirst() then
                        Error(JobEntryAlreadyExistsLbl);

                    JobQueueEntry.Init();
                    JobQueueEntry.TransferFields(Rec);
                    JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
                    JobQueueEntry.Validate("Object ID to Run", 81040);
                    JobQueueEntry."Parameter String" := Rec."Parameter String";
                    JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
                    JobQueueEntry.Insert(true);
                    Rec.Created := true;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }

            action("Run Once")
            {
                Caption = 'Run Once';
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                Image = Calculate;
                trigger OnAction()
                var
                    TestCode: Codeunit "MICA Batch Job Exec";
                begin
                    TestCode.Code(Rec."Parameter String");
                end;
            }

            action("Open Job Que entry")
            {
                Caption = 'Open Job Queue entry';
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                Image = JobTimeSheet;

                trigger OnAction()
                var
                    JobQueEntry: Record "Job Queue Entry";
                    JobQueEntryCard: Page "Job Queue Entry Card";
                    noJobQueEntryErr: Label 'Job Queue for this batch does not exist';
                begin
                    JobQueEntry.SetRange("Parameter String", Rec."Parameter String");
                    if JobQueEntry.FindSet() then begin
                        JobQueEntryCard.SetTableView(JobQueEntry);
                        JobQueEntryCard.Run();
                    end else
                        Error(noJobQueEntryErr);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange(JobQueueEntry."Parameter String", Rec."Parameter String");
        if JobQueueEntry.FindFirst() then begin
            Rec.TransferFields(JobQueueEntry);
            //Status := JobQueueEntry.Status;
            Rec.Modify(false);
        end;
    end;
}