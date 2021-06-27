report 82680 "MICA Archive Flow Entries"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Archive Flow Entries';

    dataset
    {
        dataitem("MICA Flow Entry"; "MICA Flow Entry")
        {
            RequestFilterFields = "Flow Code";
            dataitem("MICA Flow Information"; "MICA Flow Information")
            {
                DataItemLink = "Flow Entry No." = field("Entry No.");

                trigger OnAfterGetRecord()
                begin
                    InsertFlowInformationArchive("MICA Flow Information");
                end;

            }
            dataitem("MICA Flow Record"; "MICA Flow Record")
            {
                DataItemLink = "Flow Entry No." = field("Entry No.");

                trigger OnAfterGetRecord()
                begin
                    InsertFlowRecordArchive("MICA Flow Record");
                end;
            }

            trigger OnPreDataItem()
            var
                DialOpenMsg: Label 'Archiving until: #1########## \ Flow Entries: #2########## \ Flow Informations: #3########## \ Flow Records: #4##########';
            begin
                SetFilter("Created Date Time", '..%1', CreateDateTime(ArchiveUntilDate, 0T));
                Dialog.Open(DialOpenMsg);
                Dialog.Update(1, ArchiveUntilDate);
            end;

            trigger OnAfterGetRecord()
            begin
                InsertFlowEntryArchive("MICA Flow Entry");
                i += 1;
                if i = 100 then begin
                    Commit();
                    i := 0;
                end;
            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(NumberOfDaysToKeep; NumberOfDaysToKeepVar)
                    {
                        Caption = 'Number of Days to Keep';
                        ApplicationArea = All;

                    }
                }
            }
        }

    }
    trigger OnInitReport()
    begin
        Evaluate(NumberOfDaysToKeepVar, '<30D>');
    end;

    trigger OnPreReport()
    var
        NumberOfDaysEmptyErr: Label 'Parameter Number of Days must be filled.';
        ArchiveUntilDateLbl: Label '<-%1>', Comment = '%1', Locked = true;
    begin
        if format(NumberOfDaysToKeepVar) = '' then
            Error(NumberOfDaysEmptyErr);
        ArchiveUntilDate := CalcDate(StrSubstNo(ArchiveUntilDateLbl, NumberOfDaysToKeepVar), Today());
    end;

    trigger OnPostReport()
    var
        ArchivingFinishedMsg: Label '%1 entries are archived.';
    begin
        Dialog.close();
        Message(StrSubstNo(ArchivingFinishedMsg, ArchivedEntriesCount));
    end;

    var
        NumberOfDaysToKeepVar: DateFormula;
        Dialog: Dialog;
        ArchiveUntilDate: Date;
        ArchivedEntriesCount: Integer;
        ArchivedInformationsCount: Integer;
        ArchivedRecordsCount: Integer;

    local procedure InsertFlowEntryArchive(MICAFlowEntry: Record "MICA Flow Entry")
    var
        MICAFlowEntryArchive: record "MICA Flow Entry Archive";
        DeleteMICAFlowEntry: Record "MICA Flow Entry";
    begin
        if MICAFlowEntry.Blob.HasValue() then
            MICAFlowEntry.CalcFields(Blob);
        if MICAFlowEntry."Initial Blob".HasValue() then
            MICAFlowEntry.CalcFields("Initial Blob");
        MICAFlowEntryArchive.TransferFields(MICAFlowEntry);
        MICAFlowEntryArchive.Insert(true);
        DeleteMICAFlowEntry.Get(MICAFlowEntry."Entry No.");
        DeleteMICAFlowEntry.Delete();

        ArchivedEntriesCount += 1;
        Dialog.Update(2, ArchivedEntriesCount);
    end;

    local procedure InsertFlowInformationArchive(MICAFlowInformation: Record "MICA Flow Information")
    var
        MICAFlowInformationArchive: record "MICA Flow Information Archive";
        DeleteMICAFlowInformation: Record "MICA Flow Information";
    begin
        MICAFlowInformationArchive.TransferFields(MICAFlowInformation);
        MICAFlowInformationArchive.Insert(true);
        DeleteMICAFlowInformation.Get(MICAFlowInformation."Entry No.");
        DeleteMICAFlowInformation.Delete();

        ArchivedInformationsCount += 1;
        Dialog.Update(3, ArchivedInformationsCount);
    end;

    local procedure InsertFlowRecordArchive(MICAFlowRecord: Record "MICA Flow Record")
    var
        MICAFlowRecordArchive: Record "MICA Flow Record Archive";
        DeleteMICAFlowRecord: Record "MICA Flow Record";
    begin
        MICAFlowRecordArchive.TransferFields(MICAFlowRecord);
        MICAFlowRecordArchive.Insert(true);
        DeleteMICAFlowRecord.Get(MICAFlowRecord."Entry No.");
        DeleteMICAFlowRecord.Delete();

        ArchivedRecordsCount += 1;
        Dialog.Update(4, ArchivedRecordsCount);
    end;

    var
        i: Integer;
}