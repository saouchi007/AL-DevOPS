query 82780 "MICA S2S SellToShipTo"
{
    QueryType = API;
    APIVersion = 'v1.0';
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif            
    Caption = 's2sSellToShipTo', Locked = true;
    EntityName = 's2sSellToShipTo';
    EntitySetName = 's2sSellToShipTos';

    elements
    {
        dataitem(CompanyInfo; "MICA Financial Reporting Setup")
        {
            column(companyCode; "Company Code")
            {
                Caption = 'companyCode', Locked = true;
            }

            dataitem(Cust; "Customer")
            {
                DataItemLink = "MICA Fin. Report Primary Key" = CompanyInfo."Primary Key";
                SqlJoinType = LeftOuterJoin;

                column(customerId; SystemId)
                {
                    Caption = 'customerId', Locked = true;
                }
                column(customerNumber; "No.")
                {
                    Caption = 'customerNumber', Locked = true;
                }
                column(customerDisplayName; "Name")
                {
                    Caption = 'customerDisplayName', Locked = true;
                }
                column(customerMdmId; "MICA MDM ID LE")
                {
                    Caption = 'customerMdmId', Locked = true;
                }
                column(mdmIdBT; "MICA MDM ID BT")
                {
                    Caption = 'mdmIdBT', Locked = true;
                }
                column(mdmBillToSiteUseId; "MICA MDM Bill-to Site Use ID")
                {
                    Caption = 'mdmBillToSiteUseId', Locked = true;
                }
                column(customerExternalRef; "MICA S2S External Ref.")
                {
                    Caption = 'customerExternalRef', Locked = true;
                }
                column(customerExactQuantity; "MICA S2S Exact Qty.")
                {
                    Caption = 'customerExactQuantity', Locked = true;
                }
                column(customerLastModifiedDateTime; "Last Modified Date Time")
                {
                    Caption = 'customerLastModifiedDateTime', Locked = true;
                }
                dataitem(Ship; "Ship-to Address")
                {
                    DataItemLink = "Customer No." = Cust."No.";
                    SqlJoinType = LeftOuterJoin;
                    column(shiptoaddressId; SystemId)
                    {
                        Caption = 'shiptoaddressId', Locked = true;
                    }
                    column(shiptoaddressNumber; Code)
                    {
                        Caption = 'shiptoaddressNumber', Locked = true;
                    }
                    column(shiptoaddressDisplayName; "Name")
                    {
                        Caption = 'shiptoaddressDisplayName', Locked = true;
                    }
                    column(shiptoaddressMdmId; "MICA MDM ID")
                    {
                        Caption = 'shiptoaddressMdmId', Locked = true;
                    }
                    column(mdmShipToSiteUseId; "MICA MDM Ship-to Use ID")
                    {
                        Caption = 'mdmShipToSiteUseId', Locked = true;
                    }
                    column(shiptoaddressExternalRef; "MICA S2S External Ref.")
                    {
                        Caption = 'shiptoaddressExternalRef', Locked = true;
                    }
                    column(shiptoaddressLastModifiedDateTime; "MICA Last Mod. Date Time")
                    {
                        Caption = 'shiptoaddressLastModifiedDateTime', Locked = true;
                    }
                }
            }
        }
    }
}