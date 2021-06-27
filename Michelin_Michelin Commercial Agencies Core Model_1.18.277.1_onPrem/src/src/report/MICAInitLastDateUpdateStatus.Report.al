report 82380 "MICA InitLastDateUpdateStatus"
{
    Caption = 'Init Last Date Update Status';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Header Archive" = r, tabledata "Sales Line Archive" = rm;

    //TODO: to delete, it's a one shot

    dataset
    {
        dataitem("Sales Line Archive"; "Sales Line Archive")
        {
            DataItemTableView = sorting ("No.")
                                where ("MICA Last Date Update Status" = const ());

            trigger OnAfterGetRecord()
            var
                SalesHeaderArchive: Record "Sales Header Archive";
                UpdatedSalesLineArchive: Record "Sales Line Archive";
            begin
                if SalesHeaderArchive.Get("Sales Line Archive"."Document Type", "Sales Line Archive"."Document No.", "Sales Line Archive"."Doc. No. Occurrence", "Sales Line Archive"."Version No.") then
                    if UpdatedSalesLineArchive.Get("Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Line No.") then begin
                        UpdatedSalesLineArchive.Validate("MICA Last Date Update Status", CreateDateTime(SalesHeaderArchive."Document Date", 0T));
                        UpdatedSalesLineArchive.Modify();
                        SalesLineCount += 1;
                    end;
            end;

        }
    }

    trigger OnPostReport()
    begin
        Message(NoLineUpdatedMsg, SalesLineCount);
    end;

    var
        SalesLineCount: Integer;
        NoLineUpdatedMsg: Label '%1 line updated';
}