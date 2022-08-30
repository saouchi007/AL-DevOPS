/// <summary>
/// PageExtension ISA_CustomerCard_Ext (ID 50316) extends Record Customer Card.
/// </summary>
pageextension 50316 ISA_CustomerCard_Ext extends "Customer Card"
{
    layout
    {
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                Message('OnAfterValidate of the page');
                Rec."Phone No." := '666';
            end;
        }
    }


}