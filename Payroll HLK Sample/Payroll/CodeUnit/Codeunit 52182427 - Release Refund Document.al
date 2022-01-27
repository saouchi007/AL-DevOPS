/// <summary>
/// Codeunit Release Refund Document (ID 52182427).
/// </summary>
codeunit 52182427 "Release Refund Document"
//codeunit 39108399 "Release Refund Document"
{
    // version HALRHPAIE.6.1.01

    TableNo = "Medical Refund Header";

    trigger OnRun();
    var
        RefundLine: Record "Medical Refund Line";
    begin
        IF Status = Status::Released THEN
            EXIT;
        RefundLine.SETRANGE("Document Type", "Document Type");
        RefundLine.SETRANGE("Document No.", "No.");
        RefundLine.SETRANGE(Type, RefundLine.Type::Employee);
        IF NOT RefundLine.FIND('-') THEN
            ERROR(Text001, "Document Type", "No.");
        Status := Status::Released;
        MODIFY(TRUE);
    end;

    var
        Text001: TextConst ENU = 'There is nothing to release for %1 %2.', FRA = 'Il n''y a rien à lancer pour %1 %2.';

    /// <summary>
    /// Reopen.
    /// </summary>
    /// <param name="ReimbursHeader">VAR Record "Medical Refund Header".</param>
    procedure Reopen(var ReimbursHeader: Record "Medical Refund Header");
    var
        ReimbursLine: Record "Medical Refund Line";
    begin
        WITH ReimbursHeader DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;
            MODIFY(TRUE);
        END;
    end;

    /// <summary>
    /// PerformManualRelease.
    /// </summary>
    /// <param name="ReimbursHeader">VAR Record "Medical Refund Header".</param>
    procedure PerformManualRelease(var ReimbursHeader: Record "Medical Refund Header");
    begin
        CODEUNIT.RUN(39108399, ReimbursHeader);
    end;

    /// <summary>
    /// PerformManualReopen.
    /// </summary>
    /// <param name="ReimbursHeader">VAR Record "Medical Refund Header".</param>
    procedure PerformManualReopen(var ReimbursHeader: Record "Medical Refund Header");
    begin
        Reopen(ReimbursHeader);
    end;
}

