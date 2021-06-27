tableextension 80182 "MICA Item Discount Group" extends "Item Discount Group"
{
    fields
    {
        field(80000; "MICA Add. Item Disc. Grp Count"; Integer)
        {
            Caption = 'Add. Item Disc. Group Count';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Count ("MICA Add. Item Discount Group" WHERE("Item Discount Group Code" = FIELD(Code)));
        }
    }

}