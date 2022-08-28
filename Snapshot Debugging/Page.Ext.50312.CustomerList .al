pageextension 50312 ISA_CustomerList_Ext extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(HeavyProcessing)
            {
                ApplicationArea = All;
                Caption = 'Heavy Processing';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    CustRec: Record Customer;
                begin
                    if CustRec.FindSet() then begin
                        repeat
                            Heavy2(CustRec);
                        until CustRec.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}