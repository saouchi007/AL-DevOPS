/// <summary>
/// TableExtension ISA_CustomerCard_Ext (ID 50229) extends Record MyTargetTable.
/// </summary>
tableextension 50101 ISA_CustomerCard_Ext extends Customer
{
    fields
    {
        field(50228; ISA_TradeRegister; Text[18])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Trade Register', FRA = 'R.C';
            trigger OnValidate()
            begin
                Rec.ISA_TradeRegister := UpperCase(ISA_TradeRegister);
                Rec.Modify();
            end;
        }
        field(50229; ISA_FiscalID; Text[15])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Fiscal Identification', FRA = 'N.I.F';
            trigger OnValidate()
            begin
                Rec.ISA_FiscalID := UpperCase(ISA_FiscalID);
                Rec.Modify();
            end;
        }
        field(50230; ISA_StatisticalID; Text[15])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Statistical Identification Number', FRA = 'N.I.S';
            trigger OnValidate()
            begin
                Rec.ISA_StatisticalID := UpperCase(ISA_StatisticalID);
                Rec.Modify();
            end;
        }
        field(50231; ISA_ItemNumber; Text[11])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Item Number', FRA = 'A.I';
            trigger OnValidate()
            begin
                Rec.ISA_ItemNumber := UpperCase(ISA_ItemNumber);
                Rec.Modify();
            end;
        }
    }
}