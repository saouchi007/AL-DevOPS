pageextension 50101 PQ_Linde_Update extends "Purchase Quote"
{
    AdditionalSearchTerms = 'Demande achat';
    Caption = 'Demande achat';

    trigger OnOpenPage()
    begin
        Caption := 'Demande d''achat';
        Editable := true;
    end;
}
