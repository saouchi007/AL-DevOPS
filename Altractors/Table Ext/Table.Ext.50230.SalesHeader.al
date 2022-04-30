/// <summary>
/// TableExtension ISA_SalesOrderSubform (ID 50230) extends Record Sales Line.
/// </summary>
tableextension 50230 ISA_SalesHeader extends "Sales Line"
{
    fields
    {
        field(50230; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty', FRA = 'Droit de Timbre';
            Editable = false;
        }
    }
}