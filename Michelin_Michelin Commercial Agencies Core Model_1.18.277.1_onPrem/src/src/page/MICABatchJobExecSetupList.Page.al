page 81041 "MICA Batch Job Exec Setup List"//MyTargetPageId
{
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "MICA Batch Job Execution Setup";
    Caption = 'Batch Job Execution Setup List';
    CardPageId = "MICA Batch Job Execution Setup";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Control 1")
            {

                field("Parameter String"; Rec."Parameter String")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Status")
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

                field("Maximum No. of Attempts to Run"; Rec."Maximum No. of Attempts to Run")
                {

                    ApplicationArea = All;
                }
                field("Last Ready State"; Rec."Last Ready State")
                {
                    ApplicationArea = All;
                }
                field("Earliest Start Date/Time"; Rec."Earliest Start Date/Time")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date/Time"; Rec."Expiration Date/Time")
                {

                    ApplicationArea = All;
                }


                field("Recurring Job"; Rec."Recurring Job")
                {
                    ApplicationArea = All;
                }


                field("Run on Mondays"; Rec."Run on Mondays")
                {
                    ApplicationArea = All;
                }
                field("Run on Tuesdays"; Rec."Run on Tuesdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Wednesdays"; Rec."Run on Wednesdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Thursdays"; Rec."Run on Thursdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Fridays"; Rec."Run on Fridays")
                {
                    ApplicationArea = All;
                }
                field("Run on Saturdays"; Rec."Run on Saturdays")
                {
                    ApplicationArea = All;
                }
                field("Run on Sundays"; Rec."Run on Sundays")
                {
                    ApplicationArea = All;
                }


                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = All;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = All;
                }
                field("No. of Minutes between Runs"; Rec."No. of Minutes between Runs")
                {
                    ApplicationArea = All;
                }
                field("Inactivity Timeout Period"; Rec."Inactivity Timeout Period")
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

        }
    }

    trigger OnAfterGetRecord()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange(JobQueueEntry."Parameter String", Rec."Parameter String");
        IF JobQueueEntry.FindFirst() then begin
            Rec.TransferFields(JobQueueEntry);
            //Status := JobQueueEntry.Status;
            Rec.Modify(false);
        END;
    end;


}
