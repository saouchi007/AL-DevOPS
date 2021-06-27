codeunit 82300 "MICA SetupRemitance Reports"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
    begin
        SetupReportSelections();
    end;

    local procedure SetupReportSelections()
    var
        ReportSelections: Record "Report Selections";
    begin
        InsertReportSelections(ReportSelections.Usage::"V.Remittance", '1', Report::"MICA Remitance Advice Journal");
        InsertReportSelections(ReportSelections.Usage::"P.V.Remit.", '1', Report::"MICA Remittance Advice Entries");
    end;

    local procedure InsertReportSelections(ReportUsage: Enum "Report Selection Usage"; ReportSequence: Code[10]; ReportId: Integer)
    var
        ReportSelections: Record "Report Selections";
    begin
        if not ReportSelections.Get(ReportUsage, ReportSequence) then begin
            ReportSelections.Init();
            ReportSelections.Usage := ReportUsage;
            ReportSelections.Sequence := ReportSequence;
            ReportSelections."Report ID" := ReportId;
            ReportSelections."Use for Email Attachment" := true;
            ReportSelections."Use for Email Body" := false;
            if ReportSelections.Insert() then;
        end;
    end;
}