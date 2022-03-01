pageextension 50158 UserSetup_Ext extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field(AllowViewing; Rec.AllowViewing)
            {
                ApplicationArea = All;
            }
        }
    }

}