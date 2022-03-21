/// <summary>
/// Page ISA_JobCard (ID 50182).
/// </summary>
page 50182 ISA_JobCard
{
    /*
    Endpoint to list all the companies the particular environment –https://api.businesscentral.dynamics.com/v2.0/<tenantid>/<environmentname>/api/v2.0/companies
    Example (using above API details) – https://api.businesscentral.dynamics.com/v2.0/9c5c9bca-3497-4d90-b50e-ccd14c51558c/dev/api/v2.0/companies
    Final API endpoint comes out to be – https://api.businesscentral.dynamics.com/v2.0/9c5c9bca-3497-4d90-b50e-ccd14c51558c/Production/api/MyCompany/app1/v1.0/companies(f2f053b8-361a-ec11-86bc-000d3a70b137)/Jobs
    */
    PageType = API;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Job Card API';
    APIPublisher = 'Saouchi';
    APIGroup = 'Alpha_Ext';
    APIVersion = 'v1.0';
    EntityName = 'Job';
    EntitySetName = 'Jobs';
    SourceTable = Job;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No"; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}