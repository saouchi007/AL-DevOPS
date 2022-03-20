/// <summary>
/// TableExtension ISA_SalesRecSetup_Ext (ID 50159) extends Record Sales  Receivables Setup.
/// </summary>
tableextension 50159 ISA_SalesRecSetup_Ext extends "Sales & Receivables Setup"
{
    fields
    {
        field(50159; ISA_DutyStampGLA; Code[10])
        {
            Caption = 'Duty Stamp G/L Account';
            TableRelation = "G/L Account";
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
        }
    }
}