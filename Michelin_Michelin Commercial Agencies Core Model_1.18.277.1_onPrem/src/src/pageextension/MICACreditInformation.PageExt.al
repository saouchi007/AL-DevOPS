pageextension 83000 "MICA Credit Information" extends "Available Credit"
{
    layout
    {
        addbefore(GetTotalAmountLCYUI)
        {
            field("MICA Rebate Pool Rem. Amount"; Rec."MICA Rebate Pool Rem. Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total Rebate Pool Remaining Amount for choosen Customer.';
            }
        }
    }
}