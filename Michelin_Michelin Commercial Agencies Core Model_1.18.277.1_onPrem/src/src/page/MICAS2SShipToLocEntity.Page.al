page 82863 "MICA S2S ShipTo Loc. Entity"
{
    PageType = API;
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif        
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sShipToLocationEntity', Locked = true;
    EntityName = 's2sShipToLocation';
    EntitySetName = 's2sShipToLocations';
    ODataKeyFields = SystemId;
    SourceTable = "Ship-to Address";
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
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(companyCode; MICAFinancialReportingSetup."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode', Locked = true;
                }
                field(customerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerNo', Locked = true;
                }
                field(customerId; CustomerSysId)
                {
                    ApplicationArea = All;
                    Caption = 'customerId', Locked = true;
                }
                field(displayName; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'displayName', Locked = true;
                }
                field(mdmShipToSiteUseID; Rec."MICA MDM Ship-to Use ID")
                {
                    ApplicationArea = All;
                    Caption = 'mdmShipToSiteUseID', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationCode', Locked = true;
                }
                field(locationName; Location.Name)
                {
                    ApplicationArea = All;
                    Caption = 'locationName', Locked = true;
                }
            }
        }
    }

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";

    trigger OnOpenPage()
    begin
        if not MICAFinancialReportingSetup.Get() then
            MICAFinancialReportingSetup.Init();
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Customer No.") then
            CustomerSysId := Customer.SystemId
        else
            Clear(CustomerSysId);
        if not Location.Get(Rec."Location Code") then
            Location.Init();
    end;

    var
        Location: Record Location;
        CustomerSysId: Guid;
}