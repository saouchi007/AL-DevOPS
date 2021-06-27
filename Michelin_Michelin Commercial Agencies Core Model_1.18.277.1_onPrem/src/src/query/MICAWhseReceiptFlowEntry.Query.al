query 82601 "MICA Whse Receipt Flow Entry"
{
    QueryType = Normal;

    elements
    {
        dataitem(Warehouse_Receipt_Header; "Warehouse Receipt Header")
        {
            column(No_; "No.")
            {

            }
            column(MICA_Status; "MICA Status")
            {

            }


            dataitem(MICA_Flow_Entry; "MICA Flow Entry")
            {
                DataItemLink = "Entry No." = Warehouse_Receipt_Header."MICA Send Last Flow Entry No.";
                SqlJoinType = LeftOuterJoin;

                column(Send_Status; "Send Status")
                {

                }

            }

        }
    }

}