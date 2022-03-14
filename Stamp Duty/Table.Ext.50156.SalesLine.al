/// <summary>
/// TableExtension ISA_DutyStamp (ID 50156) extends Record Sales Header.
/// </summary>
tableextension 50156 ISA_DutyStamp extends "Sales Line"
{
    fields
    {
        field(50156; ISA_DutyStamp; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Stamp Duty';
            Editable = false;
        }
    }

}