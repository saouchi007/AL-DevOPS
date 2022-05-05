/// <summary>
/// TableExtension ISA_SalesInvHeader_Ext (ID 50233) extends Record Sales Invoice Header.
/// </summary>
tableextension 50233 ISA_SalesInvHeader_Ext extends "Sales Invoice Header"
{
    fields
    {
        field(50230; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty';
            Editable = false;
        }
    }

}