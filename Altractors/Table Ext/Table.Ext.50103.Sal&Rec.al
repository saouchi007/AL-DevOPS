/// <summary>
/// TableExtension ISA_SalesReceivable_Ext (ID 50231) extends Record Sales Receivables Setup.
/// </summary>
tableextension 50103 ISA_SalesReceivable_Ext extends "Sales & Receivables Setup"
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
        field(50232; ISA_StampDutyPaymentTermsCode; Code[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty', FRA = 'CG du droit de timbre';
            TableRelation = "Payment Method";
            ValidateTableRelation = true;
        }
    }

}