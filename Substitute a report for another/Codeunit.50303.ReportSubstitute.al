/// <summary>
/// Codeunit ISA_ReportSubstitute (ID 50303).
/// </summary>
codeunit 50303 ISA_ReportSubstitute
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Standard Sales - Order Conf." then
            NewReportId := Report::ISA_SalesOrderConf;
    end;
}