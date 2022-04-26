/// <summary>
/// TableExtension ISA_VendorCard_Ext (ID 50228) extends Record Vendor.
/// </summary>
tableextension 50228 ISA_VendorCard_Ext extends Vendor
{
    fields
    {
        field(50228; ISA_TradeRegister; Text[15])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Trade Register', FRA = 'R.C';
        }
        field(50229; ISA_FiscalID; Integer)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Fiscal Identification', FRA = 'N.I.F';
        }
        field(50230; ISA_StatisticalID; Integer)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Statistical Identification Number', FRA = 'N.I.S';
        }
        field(50231; ISA_ItemNumber; Integer)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Item Number', FRA = 'A.I';
        }
    }

}