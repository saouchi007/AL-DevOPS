pageextension 50101 PerTenantLicState extends "Customer List"
{
    trigger OnOpenPage()
    var
        tenantLicState: Codeunit "Tenant License State";
        tenantLicStateEnum: Enum "Tenant License State";
        tenantLicStateMsg: Label 'Tenant License State is %1.\ Priod is %2.\ Starting Date is %3.\ Ending Date is %4.';
        Period: Integer;
        LicenseState: Text;
        StartDate: DateTime;
        EndDate: DateTime;
    begin
        LicenseState := Format(tenantLicState.GetLicenseState());

        if tenantLicState.IsTrialMode() then begin
            Period := tenantLicState.GetPeriod(tenantLicStateEnum::Trial);
        end;
        if tenantLicState.IsPaidMode() then begin
            Period := tenantLicState.GetPeriod(tenantLicStateEnum::Paid)
        end;
        StartDate := tenantLicState.GetStartDate();
        EndDate := tenantLicState.GetEndDate();

        Message(tenantLicStateMsg, LicenseState, Period, StartDate, EndDate);

    end;
}