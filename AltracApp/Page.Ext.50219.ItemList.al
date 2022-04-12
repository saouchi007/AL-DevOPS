/// <summary>
/// PageExtension ISA_ItemList (ID 50219) extends Record MyTargetPage.
/// </summary>
pageextension 50219 ISA_ItemList extends "Item List"
{
    layout
    {
        addafter(Description)
        {
           /* field("Product Group Code"; Rec."Product Group Code")
            {
                ApplicationArea = All;
                Caption = 'Product Group Code';
            } The field has been depricated and replaced by the tool tip that you can read by uncomenting the field
            */ 
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}