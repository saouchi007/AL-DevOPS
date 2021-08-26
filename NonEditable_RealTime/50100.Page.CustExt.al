pageextension 50100 CustExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field(Locked; Rec.Locked)
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    customerCard: Page "Customer Card";
                begin
                    if Rec.Locked then begin
                        customerCard.SetRecord(Rec);
                        CurrPage.Close();
                        customerCard.Editable := false;
                        customerCard.Run();
                    end;

                end;
            }
        }

    }
    // Unlock feature is added as an action button rather than a field 
    //because otherwise the card would remain locked (Locked = True in the table would be saved and all fields on the card would be locked)
    actions
    {
        addbefore(Dimensions)
        {
            action(Unlock)
            {
                Caption = 'Unlock';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                Image = UnLinkAccount;

                trigger OnAction()
                var
                    customerCard: Page "Customer Card";
                begin
                    if Rec.Locked then begin
                        Rec.Locked := false;
                        Rec.Modify();
                        customerCard.SetRecord(Rec);
                        CurrPage.Close();
                        customerCard.Editable := true;
                        customerCard.Run();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.Locked then begin
            CurrPage.Editable := false;
        end;
    end;
}