/// <summary>
/// PageExtension ISA_VendorList_Ext (ID 50120) extends Record Vendor List.
/// </summary>
pageextension 50120 ISA_VendorList_Ext extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field(ISA_TradeRegister; Rec.ISA_TradeRegister)
            {
                ApplicationArea = All;
            }
            field(ISA_StatisticalID; Rec.ISA_StatisticalID)
            {
                ApplicationArea = All;
            }
            field(ISA_ItemNumber; Rec.ISA_ItemNumber)
            {
                ApplicationArea = All;
            }
            field(ISA_FiscalID; Rec.ISA_FiscalID)
            {
                ApplicationArea = All;
            }
        }
    }
}