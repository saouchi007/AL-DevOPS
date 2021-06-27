report 80261 "MICA Del. Orph. Wrk. St. Inst."
{
    UsageCategory = None;
    caption = 'Delete Orphan Workflow Step Instance';
    ProcessingOnly = true;

    dataset
    {
        dataitem(WorkflowStepInstance; "Workflow Step Instance")
        {
            DataItemTableView = sorting("Sequence No.") order(descending);

            trigger OnPreDataItem()
            var
                WorkflowStepInstanceForCount: Record "Workflow Step Instance";
                ConfirmForceDeletionWithFilterMsg: label 'Are you sure you want to force deletion of all workflow step instances based on filter %1?';
            begin
                StartDateTime := CurrentDateTime();
                ProgressDialog.Open(ProgressTxt);

                WorkflowTableRelationValue.Reset();
                if WorkflowTableRelationValue.FindFirst() then
                    NoOfWorkflowTableRelationValue := WorkflowTableRelationValue.Count();

                WorkflowStepInstanceForCount.Reset();
                if ForceDeletion then begin
                    WorkflowStepInstanceForCount.SetRange("Workflow Code", WorkFlowCodeToDeleteWithForce);
                    WorkflowStepInstance.SetRange("Workflow Code", WorkFlowCodeToDeleteWithForce);
                end;
                if WorkflowStepInstanceForCount.FindFirst() then
                    NoOfWorkflowStepInstances := WorkflowStepInstanceForCount.Count();

                if ForceDeletion then
                    if not confirm(ConfirmForceDeletionWithFilterMsg, false, WorkflowStepInstance.GetFilters()) then
                        error(ForceDeletionCanceledMsg);

            end;

            trigger OnAfterGetRecord()
            begin
                ProgressDialog.Update(1, "Sequence No.");
                ProgressDialog.Update(2, Format("Record ID", 0, 1));
                CommitCounterInt += 1;
                if ((Format("Record ID") <> '') and not DocumentRecordRef.get("Record ID")) or ForceDeletion then begin
                    NoOfWorkflowStepInstancesDeleted += 1;
                    ProgressDialog.Update(3, NoOfWorkflowStepInstancesDeleted);
                    WorkflowStepInstance.Delete(true);
                    if CommitCounterInt = 5000 then begin
                        Commit();
                        CommitCounterInt := 0;
                    end
                end;
            end;

            trigger OnPostDataItem()
            var
                FinishProcessMsg: label 'Starting Date & time: %1\\No. of Workflow step instances deleted: %2/%3\\No. of workflow table relation value deleted: %4/%5\\Ending Date & Time: %6';
            begin
                EndDateTime := CurrentDateTime();
                ProgressDialog.Close();
                WorkflowTableRelationValue.Reset();
                if WorkflowTableRelationValue.FindFirst() then
                    NoOfWorkflowTableRelationValueDeleted := NoOfWorkflowTableRelationValue - WorkflowTableRelationValue.Count();
                Message(FinishProcessMsg, StartDateTime, NoOfWorkflowStepInstancesDeleted, NoOfWorkflowStepInstances, NoOfWorkflowTableRelationValueDeleted, NoOfWorkflowTableRelationValue, EndDateTime);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    caption = 'Options';
                    field(ForceWorkflowStepInstanceDeletion; ForceDeletion)
                    {
                        ApplicationArea = all;
                        caption = 'Force workflow step instances deletion and delete workflow';
                        ToolTip = 'Force deletion of workflow step instances linked to a disabled workflow, and delete after the workflow.';
                    }
                    field(WorkflowToDeleteWithForce; WorkFlowCodeToDeleteWithForce)
                    {
                        ApplicationArea = all;
                        caption = 'Workflow code to delete with force';
                        TableRelation = Workflow where(Enabled = const(false));
                        trigger OnValidate()
                        begin
                            if WorkFlowCodeToDeleteWithForce <> '' then begin
                                Workflow.get(WorkFlowCodeToDeleteWithForce);
                                CheckIfWorkflowDeletionIsAllowed();
                            end;
                        end;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        UserSetup.TestField("Approval Administrator", true);
    end;

    trigger OnPreReport()
    var
        ConfirmForceDeletionMsg: label 'You will delete all workflow step instances for workflow %1. You must first check that no approval request is in progress for this workflow. Are you sure ?';
    begin
        if ForceDeletion then begin
            CheckIfWorkflowDeletionIsAllowed();
            if not confirm(ConfirmForceDeletionMsg, false, WorkFlowCodeToDeleteWithForce) then
                error(ForceDeletionCanceledMsg);
        end;
        CommitCounterInt := 0;
    end;

    local procedure CheckIfWorkflowDeletionIsAllowed()
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalEntryExistErr: label 'For workflow %1 there is at least 1 approval entry open, please cancel pending requests and start over.';
    begin
        Workflow.get(WorkFlowCodeToDeleteWithForce);
        Workflow.TestField(Enabled, false);
        ApprovalEntry.SetCurrentKey("Approver ID", Status, "Due Date", "Date-Time Sent for Approval");
        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SetRange("Approval Code", WorkFlowCodeToDeleteWithForce);
        if not ApprovalEntry.IsEmpty() then
            error(ApprovalEntryExistErr, WorkFlowCodeToDeleteWithForce);
    end;

    var
        WorkflowTableRelationValue: Record "Workflow Table Relation Value";
        Workflow: Record Workflow;
        DocumentRecordRef: RecordRef;
        NoOfWorkflowStepInstances: Integer;
        NoOfWorkflowStepInstancesDeleted: Integer;
        NoOfWorkflowTableRelationValue: Integer;
        NoOfWorkflowTableRelationValueDeleted: Integer;
        CommitCounterInt: Integer;
        ForceDeletion: boolean;
        WorkFlowCodeToDeleteWithForce: Code[20];
        StartDateTime: DateTime;
        EndDateTime: DateTime;
        ProgressDialog: Dialog;
        ProgressTxt: Label 'Entry No: #1####################\\Document: #2####################\\Workflow step instances deleted: #3####################';
        ForceDeletionCanceledMsg: label 'Process cancelled !';

}