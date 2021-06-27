query 82940 "MICA Sales Shpt VAT Rate Count"
{
    QueryType = Normal;

    elements
    {
        dataitem(Sales_Shipment_Header; "Sales Shipment Header")
        {
            column(No_; "No.")
            {

            }
            dataitem(Sales_Shipment_Line; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = Sales_Shipment_Header."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Qty. Shipped Not Invoiced" = filter('<>0');
                column(VAT__; "VAT %")
                {

                }
                column(VATCount)
                {
                    Method = Count;
                }

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}