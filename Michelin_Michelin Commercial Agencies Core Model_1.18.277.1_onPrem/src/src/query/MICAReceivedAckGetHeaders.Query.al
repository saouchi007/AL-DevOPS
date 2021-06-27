query 81960 "MICA ReceivedAck GetHeaders"
{
    QueryType = Normal;
    OrderBy = ascending (No_, MICA_ASN_No_);

    elements
    {
        dataitem(Posted_Whse__Receipt_Header; "Posted Whse. Receipt Header")
        {
            DataItemTableFilter = "MICA Send Ack. Received" = const (false);
            column(No_; "No.") { }
            dataitem(Posted_Whse__Receipt_Line; "Posted Whse. Receipt Line")
            {
                DataItemTableFilter = "MICA ASN No." = filter ('<>''''');
                DataItemLink = "No." = Posted_Whse__Receipt_Header."No.";
                column(MICA_ASN_No_; "MICA ASN No.") { }
                column(Counter)
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