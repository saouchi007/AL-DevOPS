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

}