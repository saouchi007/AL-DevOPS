/// <summary>
/// PageExtension ISA_CompanyInformation_Ext (ID 50128) extends Record Company Information.
/// </summary>
pageextension 50128 ISA_CompanyInformation_Ext extends "Company Information"
{
    actions
    {
        addfirst(Processing)
        {
            action(DeletePicture)
            {
                Caption = 'Delete Pciture';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec.Picture.HasValue then
                        if Confirm(ConfirmDeletePicture) then begin
                            Clear(Rec.Picture);
                            CurrPage.SaveRecord;
                        end;
                end;
            }
        }
    }

    var
        ConfirmDeletePicture: Label 'Do you want to delete company logo ?';
}