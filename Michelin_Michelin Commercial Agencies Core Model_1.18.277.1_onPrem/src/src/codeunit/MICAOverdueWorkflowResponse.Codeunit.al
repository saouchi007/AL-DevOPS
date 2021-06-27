codeunit 80261 "MICA Overdue Workflow Response"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddCustOverdueWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        CheckCustomerOverdue_Txt: Label 'Check if the customer overdue is exceeded';
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CheckCustomerOverdueCode(), 0, COPYSTR(CheckCustomerOverdue_Txt, 1, 250), 'GROUP 80000');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddCustOverdueWorkflowEventResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        CASE ResponseFunctionName OF
            CheckCustomerOverdueCode():
                WorkflowResponseHandling.AddResponsePredecessor(CheckCustomerOverdueCode(), WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode());
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure OnExecuteCustOverdueWorkflowResponse(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE WorkflowResponse."Function Name" OF
                CheckCustomerOverdueCode():
                    BEGIN
                        CheckCustomerOverdue(Variant);
                        ResponseExecuted := TRUE;
                    END;
            END;
    end;

    procedure CheckCustomerOverdueCode(): Code[128]
    var
        CustOverdue_Txt: label 'CheckCustomerOverdue';
    begin
        EXIT(COPYSTR(UpperCase(CustOverdue_Txt), 1, 128));
    end;

    local procedure CheckCustomerOverdue(Variant: Variant)
    var
        SalesHeader: record "Sales Header";
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Variant);

        CASE RecordRef.NUMBER() OF
            DATABASE::"Sales Header":
                BEGIN
                    SalesHeader := Variant;
                    SalesHeader.CheckAvailableOverdue();
                END;
        END;
    end;
}