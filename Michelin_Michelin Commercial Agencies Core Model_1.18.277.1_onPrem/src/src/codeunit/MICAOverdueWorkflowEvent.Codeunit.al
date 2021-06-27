codeunit 80260 "MICA Overdue Workflow Event"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddCustOverdueWorkflowToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        CustomerOverdueExceeded_Txt: Label 'A customer overdue is exceeded.';
        CustomerOverdueNotExceeded_Txt: Label 'A customer overdue is not exceeded.';
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCustomerOverdueExceededCode(), Database::"Sales Header", COPYSTR(CustomerOverdueExceeded_Txt, 1, 250), 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCustomerOverdueNotExceededCode(), Database::"Sales Header", COPYSTR(CustomerOverdueNotExceeded_Txt, 1, 250), 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowCustOverdueEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            RunWorkflowOnCustomerOverdueExceededCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCustomerOverdueExceededCode(), WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnCustomerOverdueExceeded', '', false, false)]
    local procedure RunWorkflowOnCustomerExceeded(var sender: Record "Sales Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCustomerOverdueExceededCode(), Sender);
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnCustomerOverdueNotExceeded', '', false, false)]
    local procedure RunWorkflowOnCustomerNotExceeded(var sender: Record "Sales Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCustomerOverdueNotExceededCode(), Sender);
    end;

    procedure RunWorkflowOnCustomerOverdueExceededCode(): Code[128];
    var
        OverdueExceeded_Txt: label 'RunWorkflowOnCustomerOverdueExceeded';
    begin
        EXIT(COPYSTR(UpperCase(OverdueExceeded_Txt), 1, 128));
    end;

    procedure RunWorkflowOnCustomerOverdueNotExceededCode(): Code[128];
    var
        OverdueExceeded_Txt: label 'RunWorkflowOnCustomerOverdueNotExceeded';
    begin
        EXIT(COPYSTR(UpperCase(OverdueExceeded_Txt), 1, 128));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."MICA Due Date (Buffer)" := CalcDueDateBuffer(CustLedgerEntry."Due Date")
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        DtldCustLedgEntry."MICA Initial Due Date (Buffer)" := CalcDueDateBuffer(DtldCustLedgEntry."Initial Entry Due Date")
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterValidateEvent', 'Due Date', false, false)]
    local procedure OnAfterValidateDueDate(var Rec: Record "Cust. Ledger Entry")
    begin
        Rec.Validate("MICA Due Date (Buffer)", CalcDueDateBuffer(Rec."Due Date"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure OnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        if FromCustLedgEntry.Open then
            CustLedgEntry."MICA Due Date (Buffer)" := FromCustLedgEntry."MICA Due Date (Buffer)";
    end;

    local procedure CalcDueDateBuffer(DueDate: Date): Date
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        exit(CalcDate(SalesReceivablesSetup."MICA Overdue Buffer", DueDate));
    end;

}