codeunit 80800 "MICA Date Management"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeValidatePostingAndDocumentDate', '', false, false)]
    LOCAL procedure C90OnBeforeValidatePostingAndDocumentDate(VAR PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin

        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit;

        PurchaseHeader."Posting Date" := WorkDate();
        PurchaseHeader.VALIDATE("Currency Code");

        PurchaseHeader.VALIDATE("Document Date", WorkDate());

        PurchaseHeader.MODIFY();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeValidatePostingAndDocumentDate', '', false, false)]
    LOCAL procedure C80OnBeforeValidatePostingAndDocumentDate(VAR SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin

        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        SalesHeader."Posting Date" := WorkDate();
        SalesHeader.SynchronizeAsmHeader();
        SalesHeader.VALIDATE("Currency Code");

        SalesHeader.VALIDATE("Document Date", WorkDate());

        SalesHeader.MODIFY();
    end;


}


