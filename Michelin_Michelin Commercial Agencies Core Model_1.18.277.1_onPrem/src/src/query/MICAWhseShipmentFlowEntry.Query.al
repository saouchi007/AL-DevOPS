query 82600 "MICA Whse Shipment Flow Entry"
{
    QueryType = Normal;

    elements
    {
        dataitem(Warehouse_Shipment_Header; "Warehouse Shipment Header")
        {
            column(No_; "No.")
            {

            }
            column(Status; Status)
            {

            }


            dataitem(MICA_Flow_Entry; "MICA Flow Entry")
            {
                DataItemLink = "Entry No." = Warehouse_Shipment_Header."MICA Send Last Flow Entry No.";
                SqlJoinType = LeftOuterJoin;

                column(Send_Status; "Send Status")
                {

                }

            }

        }
    }

}