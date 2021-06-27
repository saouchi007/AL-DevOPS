table 81040 "MICA Batch Job Execution Setup"
{
    DataClassification = CustomerContent;

    Caption = 'Batch Job Execution Setup';

    fields
    {
        field(81040; "Ending date"; Date)
        {
            Caption = 'Ending date';
            DataClassification = CustomerContent;
        }
        field(81041; Period; Text[30])
        {
            Caption = 'Period';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                InsertEndingDateLbl: label 'Please Select Ending Date';
            begin
                IF "Ending date" <> 0D then
                    "Period Ending Date" := CalcDate(Period, "Ending date")
                else
                    Error(InsertEndingDateLbl);
            end;
        }


        field(81042; Location; CODE[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }

        field(81043; "Combine shipments"; Boolean)
        {
            Caption = 'Combine shipments';
            DataClassification = CustomerContent;
        }

        field(81044; "Shipping agent"; Code[20])
        {
            Caption = 'Shipping agent';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent";
        }
        field(81045; "Period Ending Date"; Date)
        {
            Caption = 'Period Ending Date';
            DataClassification = CustomerContent;
        }

        field(81046; Created; Boolean)
        {
            Caption = 'Created';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(4; "Last Ready State"; DateTime)
        {
            Caption = 'Last Ready State';
            DataClassification = CustomerContent;
        }

        field(5; "Expiration Date/Time"; DateTime)
        {
            Caption = 'Expiration Date/Time';
            DataClassification = CustomerContent;
        }
        field(6; "Earliest Start Date/Time"; DateTime)
        {
            Caption = 'Earliest Start Date/Time';
            DataClassification = CustomerContent;
        }
        field(11; "Maximum No. of Attempts to Run"; Integer)
        {
            Caption = 'Maximum No. of Attempts to Run';
            DataClassification = CustomerContent;
        }

        field(13; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            //Differs - made as in Que Table
            OptionMembers = "Ready","In Process","Error","On Hold","Finished","On Hold with Inactivity Timeout";
            InitValue = "On Hold";
            trigger OnValidate()
            var
                JobQueueEntry: Record "Job Queue Entry";
                NoQueueEntryErr: Label 'Job Queue entry is not created';
            begin
                JobQueueEntry.SetRange(JobQueueEntry."Parameter String", "Parameter String");
                IF NOT JobQueueEntry.FindFirst() then
                    Error(NoQueueEntryErr);

                JobQueueEntry.Status := Status;
                JobQueueEntry.Modify(True);
            end;
        }

        field(16; "Parameter String"; Text[250])
        {
            Caption = 'Parameter String';
            DataClassification = CustomerContent;
        }

        field(17; "Recurring Job"; Boolean)
        {
            Caption = 'Recurring Job';
            DataClassification = CustomerContent;
        }

        field(18; "No. of Minutes between Runs"; Integer)
        {
            Caption = 'No. of Minutes between Runs';
            DataClassification = CustomerContent;
        }
        field(19; "Run on Mondays"; Boolean)
        {
            Caption = 'Rn on mondays';
            DataClassification = CustomerContent;
        }
        field(20; "Run on Tuesdays"; Boolean)
        {
            Caption = 'Run on Tuesdays';
            DataClassification = CustomerContent;
        }
        field(21; "Run on Wednesdays"; Boolean)
        {
            Caption = 'Run on Wednesdays';
            DataClassification = CustomerContent;
        }
        field(22; "Run on Thursdays"; Boolean)
        {
            Caption = 'Run on Thursdays';
            DataClassification = CustomerContent;
        }
        field(23; "Run on Fridays"; Boolean)
        {
            Caption = 'Run on Fridays';
            DataClassification = CustomerContent;
        }
        field(24; "Run on Saturdays"; Boolean)
        {
            Caption = 'Run on Saturdays';
            DataClassification = CustomerContent;
        }
        field(25; "Run on Sundays"; Boolean)
        {
            Caption = 'Run on Sundays';
            DataClassification = CustomerContent;
        }


        field(26; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            DataClassification = CustomerContent;
        }
        field(27; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            DataClassification = CustomerContent;
        }

        field(52; "Inactivity Timeout Period"; Integer)
        {
            Caption = 'Inactivity Timeout Period';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Parameter String")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        MICABatchJobExecutionSetup: Record "MICA Batch Job Execution Setup";
    begin

        "Parameter String" := 'Test' + Format(MICABatchJobExecutionSetup.Count());
        Status := Status::"On Hold";
    end;

}
