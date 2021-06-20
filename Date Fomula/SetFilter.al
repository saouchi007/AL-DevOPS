pageextension 50101 customerExt extends "Customer List"
{

    actions
    {
        addfirst(processing)
        {
            action(setFilter)
            {
                Caption = 'Set Filter';
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    grp: integer;
                begin
                    grp := Rec.FilterGroup;
                    Rec.FilterGroup(10);
                    Rec.SetFilter("No.", '1000', '3000');
                    Rec.FilterGroup(11);
                    Rec.SetRange("No.", '2000', '4000');
                    Rec.FilterGroup(grp);
                end;
            }
        }
    }
}