table 82220 "MICA eFDM Stock Interf. Contr."
{
    DataClassification = CustomerContent;

    fields
    {
        field(2; "Transfer_To/Inv_Org"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "CAD_Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Qty_InTransit/Qty_OH"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Qty_Blocked"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Stock_Status"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Inventory Organization"; code[3])
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; CAD_Code, "Transfer_To/Inv_Org")
        {
            Clustered = true;
        }
    }

}