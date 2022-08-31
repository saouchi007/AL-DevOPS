/// <summary>
/// PageExtension ISA_SalesQuote_Ext (ID 50216).
/// </summary>
pageextension 50216 ISA_SalesQuote_Ext extends "Sales Quote"
{
    trigger OnOpenPage()
    var
        MaxLength: Integer;
        Lenght: Integer;
        MaxStrLabel: Label 'The MaxStrLen method returns %1';
        StrLenLabel: Label 'The StrLen method returns %2';
    begin
        MaxLength := MaxStrLen(Rec."Bill-to Contact");
        Lenght := StrLen(Rec."External Document No.");
        Message(MaxStrLabel + '\' + StrLenLabel, MaxLength, Lenght);
    end;
}