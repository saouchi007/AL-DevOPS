/// <summary>
/// PageExtension ISA_CustomerList (ID 50308) extends Record Customer List.
/// </summary>
pageextension 50308 ISA_CustomerList extends "Customer List"
{


    actions
    {
        addfirst(processing)
        {
            action(Dialog)
            {
                ApplicationArea = all;
                Caption = 'Dialog';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SD: Page ISA_StandardDialog;
                begin
                    SD.ISA_Setup('Saouchi', 'Warner', 'Thanos');

                    if SD.RunModal() = Action::OK then
                        Message('%1 - %2 - %3', SD.GetX(), SD.GetY(), SD.GetZ());
                end;
            }
        }
    }


}