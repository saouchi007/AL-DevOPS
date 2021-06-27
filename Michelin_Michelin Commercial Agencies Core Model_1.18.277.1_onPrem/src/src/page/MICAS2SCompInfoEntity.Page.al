page 82860 "MICA S2S Comp. Info. Entity"
{
    PageType = API;
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif    
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sCompanyInformationEntity', Locked = true;
    EntityName = 's2sCompanyInformation';
    EntitySetName = 's2sCompanyInformations';
    ODataKeyFields = Id;
    SourceTable = "Company";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.Id)
                {
                    ApplicationArea = All;
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'name', Locked = true;
                }
                field(displayName; Rec."Display Name")
                {
                    ApplicationArea = All;
                    Caption = 'displayName', Locked = true;
                }
                field(companyCode; MICAFinancialReportingSetup."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode', Locked = true;
                }
                field(companyLegalCompanyName; CompanyInformation.Name)
                {
                    ApplicationArea = All;
                    Caption = 'companyLegalCompanyName', Locked = true;
                }
                field(countryCode; CompanyInformation."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'countryCode', Locked = true;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        MICAFinancialReportingSetup.ChangeCompany(Rec."Name");
        if not MICAFinancialReportingSetup.Get() then
            MICAFinancialReportingSetup.Init();
        CompanyInformation.ChangeCompany(Rec."Name");
        if not CompanyInformation.Get() then
            CompanyInformation.Init();
    end;


    var
        CompanyInformation: Record "Company Information";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
}