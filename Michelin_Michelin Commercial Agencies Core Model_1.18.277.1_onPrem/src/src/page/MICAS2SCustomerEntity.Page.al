page 82780 "MICA S2S Customer Entity"
{
    PageType = API;
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif    
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sCustomerEntity', Locked = true;
    EntityName = 's2sCustomer';
    EntitySetName = 's2sCustomers';
    ODataKeyFields = SystemId;
    SourceTable = Customer;
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
                field(number; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'number', Locked = true;
                }
                field(displayName; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'displayName', Locked = true;
                }
                field(mdmId; Rec."MICA MDM ID LE")
                {
                    ApplicationArea = All;
                    Caption = 'mdmId', Locked = true;
                }
                field(mdmIdBT; Rec."MICA MDM ID BT")
                {
                    ApplicationArea = All;
                    Caption = 'mdmIdBT', Locked = true;
                }

                field(mdmBillToSiteUseId; Rec."MICA MDM Bill-to Site Use ID")
                {
                    ApplicationArea = All;
                    Caption = 'mdmBillToSiteUseId', Locked = true;
                }
                field(externalRef; Rec."MICA S2S External Ref.")
                {
                    ApplicationArea = All;
                    Caption = 'externalRef', Locked = true;
                }
                field(exactQuantity; Rec."MICA S2S Exact Qty.")
                {
                    ApplicationArea = All;
                    Caption = 'exactQuantity', Locked = true;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
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