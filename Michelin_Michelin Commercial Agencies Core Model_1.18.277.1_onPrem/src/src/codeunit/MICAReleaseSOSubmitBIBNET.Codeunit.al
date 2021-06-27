codeunit 82500 "MICA Release SO Submit BIBNET"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        UpdatedSalesHeader: Record "Sales Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Workflow: Record Workflow;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        EmptyGuid: Guid;
    begin
        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."MICA BIBNET. Release Order" then
            exit;

        SalesHeader.Reset();
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.SetRange("MICA Automatic Release Date", 0D);
        if Rec."Parameter String" <> '' then
            SalesHeader.SetFilter("MICA Created By", '*' + Rec."Parameter String" + '*')
        else
            SalesHeader.SetFilter("SC Unique Webshop Document Id", '<>%1', EmptyGuid);

        if SalesHeader.FindSet(false, false) then
            repeat
                UpdatedSalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
                if (SalesReceivablesSetup."MICA Approval Workflow" <> '') and Workflow.Get(SalesReceivablesSetup."MICA Approval Workflow") and Workflow.Enabled
                    then begin
                    if ApprovalsMgmt.CheckSalesApprovalPossible(UpdatedSalesHeader) then begin
                        UpdatedSalesHeader.Validate("MICA Automatic Release Date", WorkDate());
                        ApprovalsMgmt.OnSendSalesDocForApproval(UpdatedSalesHeader);
                    end;
                end else begin
                    UpdatedSalesHeader.Validate("MICA Automatic Release Date", WorkDate());
                    ReleaseSalesDocument.Run(UpdatedSalesHeader);
                end;
                Commit();
            until SalesHeader.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeSalesHeaderInsert(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        Rec.Validate("MICA Created By", UserId());
    end;
}