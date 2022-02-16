/// <summary>
/// PageExtension CustomerList_Ext (ID 50141) extends Record Customer List.
/// </summary>
pageextension 50141 CustomerList_Ext extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(OpenCustomerList)
            {
                ApplicationArea = All;
                Caption = 'Open Customer List';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CustomerGroup;
                //RunObject = page "Customer List"; // Alt+Shift+W to pop out a new window or click the button on the top right corner 

                trigger OnAction()
                begin
                    //if Page.RunModal(Page::"Customer List") = Action::LookupOK then; // this method does not allow to open in a new Tab
                    Hyperlink(GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Customer List"));
                end;
            }
        }
    }


}