page 82781 "MICA S2S ShipTo Adr."
{
    PageType = API;
    APIVersion = 'v1.0';
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif        
    Caption = 's2sShipToAddressEntity', Locked = true;
    DelayedInsert = true;
    EntityName = 's2sShipToAddress';
    EntitySetName = 's2sShipToAddresses';
    ODataKeyFields = SystemId;
    SourceTable = "Ship-To Address";
    Extensible = false;
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
                field(customerNumber; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerNumber', Locked = true;
                }
                field(shiptoaddressNumber; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'shiptoaddressNumber', Locked = true;
                }
                field(displayName; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'displayName', Locked = true;
                }
                field(mdmId; Rec."MICA MDM ID")
                {
                    ApplicationArea = All;
                    Caption = 'mdmId', Locked = true;
                }
                field(mdmShipToSiteUseId; Rec."MICA MDM Ship-to Use ID")
                {
                    ApplicationArea = All;
                    Caption = 'mdmShipToSiteUseId', Locked = true;
                }
                field(externalRef; Rec."MICA S2S External Ref.")
                {
                    ApplicationArea = All;
                    Caption = 'externalRef', Locked = true;
                }
                field(lastModifiedDateTime; Rec."MICA Last Mod. Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
                field(companyCode; MICAFinancialReportingSetup."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode', Locked = true;
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

}