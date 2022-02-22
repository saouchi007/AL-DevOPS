/// <summary>
/// PageExtension CustomerList_Ext (ID 50150) extends Record Customer List.
/// </summary>
pageextension 50150 CustLedgEntr_Ext extends "Customer Ledger Entries"
{
    trigger OnOpenPage()
    begin
        Message('All GLE : %1 lines', Rec.Count);

        Rec.SetRange("Document Type", Rec."Document Type"::Payment);
        Message('Payments : %1 lines', Rec.Count);

        Rec.SetRange("Customer No.", '10000', '20000');
        Message('Payments filtered on Customer No.: %1 lines', Rec.Count);

        Rec.SetRange("Customer No.");
        Message('Customer No. filter ahs been removed without removing Document Type''s');

    end;
}