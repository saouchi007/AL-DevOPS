codeunit 81555 "MICA Execute Mass Payment"
{
    TableNo = "Gen. Journal Line";

    var
        MICAFinancialReportingSetup: record "MICA Financial Reporting Setup";
        MICAFlow: Record "MICA Flow";
        FromGenJournalLine: record "Gen. Journal Line";
        MICAVendorBankAccMgt: Codeunit "MICA Vendor Bank Acc Mgt.";
        GenJnlLineEmptyErr: Label 'Payment Journal %1 is empty.';
        GenJnlLineAlreadyExportedErr: Label 'The lines in payment journal %1 have already been exported to payment file.';
        ErrorText: Text;

    trigger OnRun()
    begin
        CheckSetup();

        FromGenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        FromGenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        if FromGenJournalLine.IsEmpty() then begin
            ErrorText := StrSubstNo(GenJnlLineEmptyErr, Rec."Journal Batch Name");
            Error(ErrorText);
        end;
        FromGenJournalLine.SetRange("Exported to Payment File", false);
        if FromGenJournalLine.IsEmpty() then
            error(GenJnlLineAlreadyExportedErr, Rec."Journal Batch Name");

        MICAVendorBankAccMgt.CheckBankAccBeforeExportPaymentFile(FromGenJournalLine);

        Codeunit.Run(MICAFinancialReportingSetup."Mass Payment Codeunit ID", FromGenJournalLine);

    end;

    local procedure CheckSetup()
    begin
        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Mass Payment Flow code");
        MICAFinancialReportingSetup.TestField("Mass Payment Codeunit ID");
        MICAFlow.Get(MICAFinancialReportingSetup."Mass Payment Flow code");
    end;

    procedure ExecuteSendFlowMassPayment()
    var
        InterfaceMICAFlow: Record "MICA Flow";
        MICASendFlowEntry: Report "MICA Send Flow Entry";
        SendFileMsg: Label 'Send process %1 for file(s) on state <Prepared> executed! If there were errors, the messages were displayed.';
    begin
        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Mass Payment Flow code");
        InterfaceMICAFlow.SetRange(Code, MICAFinancialReportingSetup."Mass Payment Flow code");
        MICASendFlowEntry.SetTableView(InterfaceMICAFlow);
        MICASendFlowEntry.UseRequestPage(false);
        MICASendFlowEntry.Run();
        Message(StrSubstNo(SendFileMsg, MICAFinancialReportingSetup."Mass Payment Flow code"));
    end;
}