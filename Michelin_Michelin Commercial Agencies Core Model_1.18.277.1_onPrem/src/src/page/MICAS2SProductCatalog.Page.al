page 82864 "MICA S2S Product Catalog"
{
    PageType = API;
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif        
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sProductCatalog', Locked = true;
    EntityName = 's2sProductCatalog';
    EntitySetName = 's2sProductCatalogs';
    ODataKeyFields = SystemId;
    SourceTable = "MICA S2S Product Catalog";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'id';
                }
                field(customerId; Rec.customerId)
                {
                    ApplicationArea = All;
                    Caption = 'customerId';
                }
                field(customerNumber; Rec.customerNumber)
                {
                    ApplicationArea = All;
                    Caption = 'customerNumber';
                }
                field(customerName; Rec.customerName)
                {
                    ApplicationArea = All;
                    Caption = 'customerName';
                }
                field(mdmBillToSiteUseId; Rec."MDM Bill-to Site Use ID")
                {
                    ApplicationArea = All;
                    Caption = 'mdmBillToSiteUseId';
                }
                field(itemId; Rec.itemId)
                {
                    ApplicationArea = All;
                    Caption = 'itemId';
                }
                field(itemNumber; Rec.itemNumber)
                {
                    ApplicationArea = All;
                    Caption = 'itemNumber';
                }
                field(itemName; Rec.itemName)
                {
                    ApplicationArea = All;
                    Caption = 'itemName';
                }
                field(startingDate; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'startingDate';
                }
                field(endingDate; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'endingDate';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'unitPrice';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'currencyCode';
                }
                field(companyCode; Rec."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'lastModifiedDateTime';
                }
                field(itemLocation; Rec.itemLocation)
                {
                    ApplicationArea = All;
                    Caption = 'itemLocation';
                }
                field(blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Caption = 'blocked';
                }
            }
        }
    }
}