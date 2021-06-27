codeunit 80301 "MICA Prepayment Workflow Event"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddPrepaymentWorkflowToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        PrepaymentIsNeeded_Txt: Label 'Prepayment is needed.';
        PrepaymentIsNotNeeded_Txt: Label 'Prepayment is not needed.';
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnPrepaymentIsNeededCode(), Database::"Sales Header", COPYSTR(PrepaymentIsNeeded_Txt, 1, 250), 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnPrepaymentIsNotNeededCode(), Database::"Sales Header", COPYSTR(PrepaymentIsNotNeeded_Txt, 1, 250), 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowPrepaymentEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            RunWorkflowOnPrepaymentIsNeededCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnPrepaymentIsNeededCode(), WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnPrepaymentIsNeeded', '', false, false)]
    local procedure RunWorkflowOnPrepaymentIsNeeded(var sender: Record "Sales Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnPrepaymentIsNeededCode(), Sender);
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnPrepaymentIsNotNeeded', '', false, false)]
    local procedure RunWorkflowOnPrepaymentIsNotNeeded(var sender: Record "Sales Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnPrepaymentIsNotNeededCode(), Sender);
    end;

    procedure RunWorkflowOnPrepaymentIsNeededCode(): Code[128];
    var
        PrepaymentIsNeeded_Txt: label 'RunWorkflowOnPrepaymentIsNeeded';
    begin
        EXIT(COPYSTR(UpperCase(PrepaymentIsNeeded_Txt), 1, 128));
    end;

    procedure RunWorkflowOnPrepaymentIsNotNeededCode(): Code[128];
    var
        PrepaymentIsNotNeeded_Txt: label 'RunWorkflowOnPrepaymentIsNotNeeded';
    begin
        EXIT(COPYSTR(UpperCase(PrepaymentIsNotNeeded_Txt), 1, 128));
    end;


}