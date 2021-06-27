report 80260 "MICA Delete Orphan Wkflow Data"
{
    UsageCategory = None;
    caption = 'Delete Orphan Workflow Data';
    ProcessingOnly = true;
    dataset
    {
        dataitem(ApprovalEntries; "Approval Entry")
        {
            DataItemTableView = sorting("Entry No.") order(descending);

            trigger OnPreDataItem()
            begin
                StartDateTime := CurrentDateTime();
                WindowDialog.Open(DialogBoxMsg);
            end;

            trigger OnAfterGetRecord()
            begin
                NoOfEntries += 1;
                WindowDialog.Update(1, format("Entry No."));
                WindowDialog.Update(2, format("Record ID to Approve", 0, 1));
                if not CheckRecordRef.get(ApprovalEntries."Record ID to Approve") then
                    DeleteWorkflowStepInstanceFromApprovalEntries();
                WindowDialog.Update(3, Format(NoOfOrphanApprovalEntryDocuments));
                WindowDialog.Update(4, Format(NoOfWorkflowStepInstanceDeleted));
                WindowDialog.Update(5, Format(NoOfWorkflowTableRelationValueDeleted));
            end;

            trigger OnPostDataItem()
            var
                StatisticMsg: label 'Starting Date & time: %1\\No. of Approval Entries: %2\\No. of orphan Entries: %3\\No. of Workflow Step Instance Deleted: %4\\No. of Workflow Table Relation Value Deleted: %5\\Ending Date & Time: %6';
            begin
                EndDateTime := CurrentDateTime();
                WindowDialog.Close();
                message(StrSubstNo(StatisticMsg, StartDateTime, NoOfEntries, NoOfOrphanApprovalEntryDocuments, NoOfWorkflowStepInstanceDeleted, NoOfWorkflowTableRelationValueDeleted, EndDateTime));
            end;
        }
    }

    trigger OnInitReport()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        UserSetup.TestField("Approval Administrator", true);
    end;

    local procedure DeleteWorkflowStepInstanceFromApprovalEntries()
    var
        WorkflowStepInstance: Record "Workflow Step Instance";
    begin
        NoOfOrphanApprovalEntryDocuments += 1;
        WorkflowStepInstance.SetRange(ID, ApprovalEntries."Workflow Step Instance ID");
        if not WorkflowStepInstance.IsEmpty() then begin
            NoOfWorkflowStepInstanceDeleted += WorkflowStepInstance.Count();
            NoOfWorkflowTableRelationValueDeleted += CountWorkflowTableRelationValue(WorkflowStepInstance);
            WorkflowStepInstance.DeleteAll(true);
        end;
    end;

    local procedure CountWorkflowTableRelationValue(FromWorkflowStepInstance: Record "Workflow Step Instance"): Integer
    var
        WorkflowTableRelationValue: Record "Workflow Table Relation Value";
    begin
        WorkflowTableRelationValue.SetRange("Workflow Step Instance ID", FromWorkflowStepInstance.ID);
        WorkflowTableRelationValue.SetRange("Workflow Code", FromWorkflowStepInstance."Workflow Code");
        exit(WorkflowTableRelationValue.Count());
    end;

    var
        CheckRecordRef: RecordRef;
        NoOfOrphanApprovalEntryDocuments: Integer;
        NoOfWorkflowStepInstanceDeleted: Integer;
        NoOfWorkflowTableRelationValueDeleted: Integer;
        NoOfEntries: Integer;
        StartDateTime: DateTime;
        EndDateTime: DateTime;
        WindowDialog: Dialog;
        DialogBoxMsg: label 'Approval Entry No.: #1####################\\Approval Entry Document: #2####################\\Orphan Entries: #3####################\\Workflow Step Instance Deleted: #4####################\\Workflow Table Relation Value Deleted: #5####################';
}