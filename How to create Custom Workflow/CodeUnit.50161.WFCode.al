/// <summary>
/// Codeunit WFCode (ID 50161).
/// </summary>
codeunit 50161 WFCode
{
    trigger OnRun()
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        SendJobReq: TextConst ENU = 'Approval Request for Job is requested', ENG = 'Approval Request for Job is requested';
        AppReqJob: TextConst ENU = 'Approval Request for Job is approved', ENG = 'Approval Request for Job is approved';
        RejReqJob: TextConst ENU = 'Approval Request for Job is rejected', ENG = 'Approval Request for Job is rejected';
        DelReqJob: TextConst ENU = 'Approval Request for Job is delegated', ENG = 'Approval Request for Job is delegated';
        SendForPendAppTxt: TextConst ENU = 'Status of Job changed to Pending approval', ENG = 'Status of Job changed to Pending approval';
        ReleaseJobTxt: TextConst ENU = 'Release Job', ENG = 'Release Job';
        ReOpenJobTxt: TextConst ENU = 'ReOpen Job', ENG = 'ReOpen Job';

    /// <summary>
    /// RunWorkflowOnSendJobApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnSendJobApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendJobApproval'))
    end;

    /// <summary>
    /// RunWorkflowOnSendJobApproval.
    /// </summary>
    /// <param name="Job">VAR Record Job.</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::IntegrationCU, 'OnSendJobsforApproval', '', false, false)]
    procedure RunWorkflowOnSendJobApproval(var Job: Record Job)
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendJobApprovalCode(), Job);
    end;

    /// <summary>
    /// RunWorkflowOnApproveJobApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnApproveJobApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveJobApproval'))
    end;

    /// <summary>
    /// RunWorkflowOnApproveJobApproval.
    /// </summary>
    /// <param name="ApprovalEntry">VAR Record "Approval Entry".</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    procedure RunWorkflowOnApproveJobApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveJobApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    /// <summary>
    /// RunWorkflowOnRejectJobApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnRejectJobApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectJobApproval'))
    end;

    /// <summary>
    /// RunWorkflowOnRejectJobApproval.
    /// </summary>
    /// <param name="ApprovalEntry">VAR Record "Approval Entry".</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    procedure RunWorkflowOnRejectJobApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectJobApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    /// <summary>
    /// RunWorkflowOnDelegateJobApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnDelegateJobApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateJobApproval'))
    end;

    /// <summary>
    /// RunWorkflowOnDelegateJobApproval.
    /// </summary>
    /// <param name="ApprovalEntry">VAR Record "Approval Entry".</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    procedure RunWorkflowOnDelegateJobApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateJobApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    /// <summary>
    /// SetStatusToPendingApprovalCodeJob.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure SetStatusToPendingApprovalCodeJob(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApprovalJob'));
    end;

    /// <summary>
    /// SetStatusToPendingApprovalJob.
    /// </summary>
    /// <param name="Variant">VAR Variant.</param>
    procedure SetStatusToPendingApprovalJob(var Variant: Variant)
    var
        RecRef: RecordRef;
        Job: Record Job;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::Job:
                begin
                    RecRef.SetTable(Job);
                    Job.Validate("Approval Status", Job."Approval Status"::"Pending Approval");
                    Job.Modify();
                    Variant := Job;
                end;
        end;
    end;

    /// <summary>
    /// ReleaseJobCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure ReleaseJobCode(): Code[128]
    begin
        exit(UpperCase('ReleaseJob'));
    end;

    /// <summary>
    /// ReleaseJob.
    /// </summary>
    /// <param name="Variant">VAR Variant.</param>
    procedure ReleaseJob(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        Job: Record Job;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReleaseJob(Variant);
                end;
            DATABASE::Job:
                begin
                    RecRef.SetTable(Job);
                    Job.Validate("Approval Status", Job."Approval Status"::Released);
                    Job.Modify();
                    Variant := Job;
                end;
        end;
    end;

    /// <summary>
    /// ReOpenJobCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure ReOpenJobCode(): Code[128]
    begin
        exit(UpperCase('ReOpenJob'));
    end;

    /// <summary>
    /// ReOpenJob.
    /// </summary>
    /// <param name="Variant">VAR Variant.</param>
    procedure ReOpenJob(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        Job: Record Job;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpenJob(Variant);
                end;
            DATABASE::Job:
                begin
                    RecRef.SetTable(Job);
                    Job.Validate("Approval Status", Job."Approval Status"::Open);
                    Job.Modify();
                    Variant := Job;
                end;
        end;
    end;

    /// <summary>
    /// AddJobEventToLibrary.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddJobEventToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendJobApprovalCode(), Database::Job, SendJobReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveJobApprovalCode(), Database::"Approval Entry", AppReqJob, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectJobApprovalCode(), Database::"Approval Entry", RejReqJob, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegateJobApprovalCode(), Database::"Approval Entry", DelReqJob, 0, false);
    end;

    /// <summary>
    /// AddJobRespToLibrary.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    procedure AddJobRespToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodeJob(), 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseJobCode(), 0, ReleaseJobTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenJobCode(), 0, ReOpenJobTxt, 'GROUP 0');
    end;

    /// <summary>
    /// ExeRespForJob.
    /// </summary>
    /// <param name="ResponseExecuted">VAR Boolean.</param>
    /// <param name="Variant">Variant.</param>
    /// <param name="xVariant">Variant.</param>
    /// <param name="ResponseWorkflowStepInstance">Record "Workflow Step Instance".</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForJob(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of
                SetStatusToPendingApprovalCodeJob():
                    begin
                        SetStatusToPendingApprovalJob(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseJobCode():
                    begin
                        ReleaseJob(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenJobCode():
                    begin
                        ReOpenJob(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;
}