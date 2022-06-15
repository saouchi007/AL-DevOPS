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
            CaptionML = ENU = 'Stamp Duty G/L Account', FRA = 'CG du droit de timbre';
            TableRelation = "G/L Account";
            ValidateTableRelation = true;
        }
        field(50232; ISA_StampDutyPymtMethodsCode; Code[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty Payment Method', FRA = 'Mode de règlement du droit de timbre';
            TableRelation = "Payment Method";
            ValidateTableRelation = true;
        }
    }

}