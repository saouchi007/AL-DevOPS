report 81780 "MICA Arch. Updated Sales Lines"
{
    Caption = 'Archive Updated Sales Lines';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = where("Document Type" = const(Order));
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "Document Type" = field("Document Type"), "No." = field("Document No.");

                trigger OnAfterGetRecord()
                var
                    ArchiveMgt: Codeunit ArchiveManagement;
                begin
                    if not SalesHeaderList.Contains("Sales Header"."No.") then begin
                        SalesHeaderList.Add("Sales Header"."No.");
                        ArchiveMgt.StoreSalesDocument("Sales Header", false);
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                if "Sales Line".GetFilters = '' then
                    IsAutomaticLaunch := true;
                if "Sales Line".GetFilter("MICA Last Date Update Status") = '' then
                    "Sales Line".SetFilter("MICA Last Date Update Status", '>= %1', GeneralLedgerSetup."MICA Last DateTime SO Archive");
            end;
        }
    }

    trigger OnPreReport()
    begin
        GeneralLedgerSetup.Get();
        WorkDateTime := CurrentDateTime;
    end;

    trigger OnPostReport()
    begin
        if IsAutomaticLaunch then begin
            GeneralLedgerSetup."MICA Last DateTime SO Archive" := WorkDateTime;
            GeneralLedgerSetup.Modify(true);
        end;
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesHeaderList: List of [Code[20]];
        WorkDateTime: DateTime;
        IsAutomaticLaunch: Boolean;

}