pageextension 50157 SalesHeader_Ext extends "Sales Order List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
            }
            field(UserName; Rec.UserName)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup.AllowViewing then
                exit;
        Rec.FilterGroup(100);
        rec.SetRange(UserName, UserId);
        Rec.FilterGroup(0);
    end;
}