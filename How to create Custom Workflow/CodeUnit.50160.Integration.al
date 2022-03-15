/// <summary>
/// Codeunit IntegrationCU (ID 50160).
/// </summary>
codeunit 50160 IntegrationCU
{
    trigger OnRun()
    begin

    end;
    /// <summary>
    /// OnSendJobsforApproval.
    /// </summary>
    /// <param name="job">VAR Record Job.</param>
    [IntegrationEvent(false, false)]
    procedure OnSendJobsforApproval(var job: Record Job);
    begin
    end;

    /// <summary>
    /// isEnabled.
    /// </summary>
    /// <param name="job">VAR Record Job.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure isJobEnabled(var job: Record Job): Boolean
    var
        WFMngmt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode;
    begin
        exit(WFMngmt.CanExecuteWorkflow(job, WFCode.RunWorkflowOnSendJobApprovalCode()));
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        job: Record Job;
        NoWorkflowEnb: TextConst ENU = 'No workflow enabled for this record type';
    begin
        if not isJobEnabled(job) then
            Error(NoWorkflowEnb);
    end;
}