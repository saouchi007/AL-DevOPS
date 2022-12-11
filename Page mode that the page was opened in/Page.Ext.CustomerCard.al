/// <summary>
/// PageExtension ISA_CustomerCardExt (ID 50301) extends Record Customer Card.
/// </summary>
pageextension 50301 ISA_CustomerCardExt extends "Customer Card"
{
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup.ISA_AllowEditMode then
                exit;
        CurrPage.Editable(false);
    end;
}