/// <summary>
/// TableExtension ISA_ServiceLine_Ext (ID 50111) extends Record MyTargetTable.
/// </summary>
tableextension 50111 ISA_ServiceLine_Ext extends "Service Line"
{
    fields
    {
        field(50111; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Stamp Duty';
            Editable = false;
        }

        field(50112; ISA_PayMethodCode; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Methods Code';
            TableRelation = "Payment Method";
            ValidateTableRelation = true;
        }
    }


}