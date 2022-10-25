/// <summary>
/// PageExtension ISA_CustomerCard_Ext (ID 50305) extends Record Customer Card.
/// </summary>
pageextension 50305 ISA_CustomerCard_Ext extends "Customer Card"
{
    actions
    {
        addfirst(processing)
        {
            action(TransferCustomer)
            {
                ApplicationArea = All;
                Caption = 'Transfer Customer Master';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = TransferOrder;

                trigger OnAction()
                var
                    CopyToCompanyName: Text[50];
                    Cust: Record Customer;
                    Companies: Record Company;
                begin
                    clear(CopyToCompanyName);
                    Cust.Reset();

                    if Page.RunModal(Page::Companies, Companies) = Action::LookupOK then
                        CopyToCompanyName := Companies.Name;
                    if Cust.ChangeCompany(CopyToCompanyName) then begin
                        Cust.Init();
                        Cust.TransferFields(Rec);
                        Cust.Insert();
                        Message('Boom ! Sorted Mate ! lol');
                    end;
                end;
            }
        }
    }

}