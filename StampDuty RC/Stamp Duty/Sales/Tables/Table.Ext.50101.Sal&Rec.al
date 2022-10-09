/// <summary>
/// TableExtension ISA_SalesReceivable_Ext (ID 50103) extends Record Sales Receivables Setup.
/// </summary>
tableextension 50101 ISA_SalesReceivable_Ext extends "Sales & Receivables Setup"
{
    fields
    {
        field(50101; ISA_StampDuty_GLA; Code[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty G/L Account', FRA = 'CG du droit de timbre';
            TableRelation = "G/L Account";
            ValidateTableRelation = true;
        }
        field(50102; ISA_StampDutyPymtMethodsCode; Code[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty Payment Method', FRA = 'Mode de règlement du droit de timbre';
            TableRelation = "Payment Method";
            ValidateTableRelation = true;
        }
        field(50103; ISA_TransactionType; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Internal Usage Gen. Bus. Posting Group', FRA = 'Grp Compta Marché consommations internes';
            TableRelation = "Gen. Business Posting Group";
            ValidateTableRelation = true;
        }
    }

}