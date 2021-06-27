report 80100 "MICA Scheduled Request Closing"
{
    UsageCategory = None;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Interaction Log Entry"; "Interaction Log Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending)
                                WHERE("MICA Request Status" = CONST("Close the Case"));

            trigger OnAfterGetRecord()
            begin
                "Interaction Log Entry".VALIDATE("MICA Request Status", "MICA Request Status"::"Close the Case - CES");
                "Interaction Log Entry".MODIFY(TRUE);
            end;

            trigger OnPreDataItem()
            var
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
            begin
                SalesReceivablesSetup.GET();
                "Interaction Log Entry".SETFILTER("MICA Close the Case Date", '<%1', CREATEDATETIME(CALCDATE(SalesReceivablesSetup."MICA CES Evaluation Period", WORKDATE()), 0T));
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

