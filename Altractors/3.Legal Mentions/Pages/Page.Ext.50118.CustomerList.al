/// <summary>
/// PageExtension ISA_CustomerList (ID 50118) extends Record MyTargetPage.
/// </summary>
pageextension 50119 ISA_CustomerList extends "Customer List"
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