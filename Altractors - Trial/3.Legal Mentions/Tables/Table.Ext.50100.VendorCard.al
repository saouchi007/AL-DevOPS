/// <summary>
/// TableExtension ISA_VendorCard_Ext (ID 50228) extends Record Vendor.
/// </summary>
tableextension 50100 ISA_VendorCard_Ext extends Vendor
{
    fields
    {
        field(50101; ISA_TradeRegister; Text[18])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Trade Register', FRA = 'R.C';
            trigger OnValidate()
            begin
                Rec.ISA_TradeRegister := UpperCase(ISA_TradeRegister);
                Rec.Modify();
            end;
            
        }
        field(50102; ISA_FiscalID; Text[15])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Fiscal Identification', FRA = 'N.I.F';
            trigger OnValidate()
            begin
                Rec.ISA_FiscalID := UpperCase(ISA_FiscalID);
                Rec.Modify();
            end;
        }
        field(50103; ISA_StatisticalID; Text[15])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Statistical Identification Number', FRA = 'N.I.S';
            trigger OnValidate()
            begin
                Rec.ISA_StatisticalID := UpperCase(ISA_StatisticalID);
                Rec.Modify();
            end;
        }
        field(50104; ISA_ItemNumber; Text[11])
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