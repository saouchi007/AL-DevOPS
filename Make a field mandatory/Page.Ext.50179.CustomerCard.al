/// <summary>
/// PageExtension ISA_CustomerCard (ID 50179) extends Record Customer Card.
/// </summary>
pageextension 50179 ISA_CustomerCard extends "Customer Card"
{
    layout
    {
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
    }
    /*trigger OnClosePage()
    begin
        Rec.TestField("Phone No."); // displays an error message yet closes the window
    end;*/

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Phone No.");
    end;


}