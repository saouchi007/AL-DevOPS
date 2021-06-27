codeunit 80302 "MICA Prepmt Workflow Response"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddPrepaymentWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        CheckprepaymentNeeded_Txt: Label 'Check if prepayment is needed';
        SetStatusToPendingPrepayment_Txt: Label 'Set document status to Pending prepayment.';
        UpdatePrepaidAmt_Txt: Label 'Update prepaid amount';
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CheckPrepaymentIsNeededCode(), 0, COPYSTR(CheckprepaymentNeeded_Txt, 1, 250), 'GROUP 80300');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingPrepaymentCode(), 0, COPYSTR(SetStatusToPendingPrepayment_Txt, 1, 250), 'GROUP 80300');
        WorkflowResponseHandling.AddResponseToLibrary(UpdatePrepaidAmtCode(), 0, COPYSTR(UpdatePrepaidAmt_Txt, 1, 250), 'GROUP 80300');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddPrepaymentWorkflowEventResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        CASE ResponseFunctionName OF
            CheckPrepaymentIsNeededCode():
                WorkflowResponseHandling.AddResponsePredecessor(CheckPrepaymentIsNeededCode(), WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode());
            SetStatusToPendingPrepaymentCode():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingPrepaymentCode(), WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode());
            UpdatePrepaidAmtCode():
                WorkflowResponseHandling.AddResponsePredecessor(UpdatePrepaidAmtCode(), WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode());
        END;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure OnExecutePrepaymentWorkflowResponse(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE WorkflowResponse."Function Name" OF
                CheckPrepaymentIsNeededCode():
                    BEGIN
                        CheckPrepayment(Variant);
                        ResponseExecuted := TRUE;
                    END;
                SetStatusToPendingPrepaymentCode():
                    begin
                        SetStatusToPendingPrepayment(Variant);
                        ResponseExecuted := TRUE;
                    end;
                UpdatePrepaidAmtCode():
                    begin
                        UpdatePrepaidAmount(Variant);
                        ResponseExecuted := true;
                    end;
            END;
    end;

    procedure CheckPrepaymentIsNeededCode(): Code[128]
    var
        Prepayment_Txt: label 'CheckPrepayment';
    begin
        EXIT(COPYSTR(UpperCase(Prepayment_Txt), 1, 128));
    end;

    procedure SetStatusToPendingPrepaymentCode(): Code[128]
    var
        StatusPrepayment_Txt: label 'SetStatusToPendingPrepayment';
    begin
        EXIT(COPYSTR(UpperCase(StatusPrepayment_Txt), 1, 128));
    end;

    procedure UpdatePrepaidAmtCode(): Code[128]
    var
        UpdatePrepaidAmt_Txt: label 'UpdatePrepaidAmount';
    begin
        EXIT(COPYSTR(UpperCase(UpdatePrepaidAmt_Txt), 1, 128));
    end;

    local procedure CheckPrepayment(Variant: Variant)
    var
        SalesHeader: record "Sales Header";
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Variant);

        CASE RecordRef.NUMBER() OF
            DATABASE::"Sales Header":
                BEGIN
                    SalesHeader := Variant;
                    SalesHeader.CheckPrepayment();
                END;
        END;
    end;

    procedure SetStatusToPendingPrepayment(Variant: variant)
    var
        SalesHeader: record "Sales Header";
        RecordRef: RecordRef;
        UnsupportedRecordType_Err: label 'Record type %1 is not supported by this workflow response.';
    begin
        RecordRef.GETTABLE(Variant);
        CASE RecordRef.NUMBER() OF
            DATABASE::"Sales Header":
                BEGIN
                    RecordRef.SETTABLE(SalesHeader);
                    SalesHeader.VALIDATE(Status, SalesHeader.Status::"Pending Prepayment");
                    SalesHeader.MODIFY(TRUE);
                    Variant := SalesHeader;
                END;
            ELSE
                ERROR(UnsupportedRecordType_Err, RecordRef.CAPTION());
        END;
    end;

    procedure UpdatePrepaidAmount(Variant: variant)
    var
        SalesHeader: record "Sales Header";
        ApprovalEntry: record "Approval Entry";
        RecordRef: RecordRef;
        UnsupportedRecordType_Err: label 'Record type %1 is not supported by this workflow response.';
    begin
        RecordRef.GETTABLE(Variant);

        CASE RecordRef.NUMBER() OF
            DATABASE::"Approval Entry":
                BEGIN
                    RecordRef.SETTABLE(ApprovalEntry);
                    IF NOT SalesHeader.GEt(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then
                        exit;
                    SalesHeader."MICA Prepaid Amount" := SalesHeader."MICA Prepayment Amount";
                    SalesHeader.MODIFY(TRUE);
                    Variant := ApprovalEntry;
                END;
            ELSE
                ERROR(UnsupportedRecordType_Err, RecordRef.CAPTION());
        END;
    end;
}