query 81961 "MICA ReceivedAck GetASNLines"
{
    QueryType = Normal;

    elements
    {
        dataitem(Posted_Whse__Receipt_Line; "Posted Whse. Receipt Line")
        {
            filter(Filter_No_; "No.") { }
            filter(Filter_MICA_ASN_No_; "MICA ASN No.") { }

            column(No_; "No.") { }
            column(MICA_ASN_No_; "MICA ASN No.") { }
            column(MICA_ASN_Line_No_; "MICA ASN Line No.") { }
            column(MICA_Container_ID; "MICA Container ID") { }
            column(Item_No_; "Item No.") { }
            column(MICA_AL_No_; "MICA AL No.") { }
            column(MICA_AL_Line_No_; "MICA AL Line No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Quantity; Quantity) { }
            column(Description; Description) { }
            column(PurchaseOrderNo; "MICA Purchase Order No."){}
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}