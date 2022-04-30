tableextension 50231 ISA_SalesReceivable_Ext extends "Sales & Receivables Setup"
{
    fields
    {
        field(50231; ISA_StampDuty_GLA; Code[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty G/L Account';
            TableRelation = "G/L Account";
            ValidateTableRelation = true;
        }
    }

}