/// <summary>
/// PageExtension ISA_ (ID 50120) extends Record MyTargetPage.
/// </summary>
pageextension 50120 ISA_ItemCard_Ext extends "Item Card"
{
    trigger OnOpenPage()
    var
        ItemProfit: Decimal;
        NoText: array[2] of Text;
    begin
        ItemProfit := Rec."Profit %";
        InitTextVariable();
        AmountInWords := NumberInWords(Round(ItemProfit, 0.01), 'Dinars', 'Centimes');
        Message(AmountInWords);
    end;
    /******************************NumberInWords*********************************************************/
    local procedure NumberInWords(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);

        WholeInWords := NumberToWords(WholePart, CurrencyName);

        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, DenomName);
            WholeInWords := WholeInWords + ' et ' + DecimalInWords;
        END;

        AmountInWords := '' + WholeInWords + ' Seulement';
        EXIT(AmountInWords);
    end;

    /******************************NumberToWords*********************************************************/
    local procedure NumberToWords(number: Decimal; appendScale: Text[30]): Text[300]
    var
        numString: text[300];
        pow: Integer;
        powStr: Text[300];
        log: Integer;
    begin
        numString := '';
        IF number < 100 THEN
            IF number < 20 THEN BEGIN
                IF number <> 0 THEN numString := OnesText[number];
            END ELSE BEGIN
                numString := TensText[number DIV 10];
                IF (number MOD 10) > 0 THEN
                    numString := numString + ' ' + OnesText[number MOD 10];
            END
        ELSE BEGIN
            pow := 0;
            powStr := '';
            IF number < 1000 THEN BEGIN // number is between 100 and 1000
                pow := 100;
                powStr := ThousText[1];
            END ELSE BEGIN // find the scale of the number
                log := ROUND(STRLEN(FORMAT(number DIV 1000)) / 3, 1, '>');
                pow := POWER(1000, log);
                powStr := ThousText[log + 1];
            END;

            numString := NumberToWords(number DIV pow, powStr) + ' ' + NumberToWords(number MOD pow, '');
        END;

        EXIT(DELCHR(numString, '<>', ' ') + ' ' + appendScale);
    end;

    /******************************NumberToWords*********************************************************/
    local procedure InitTextVariable()
    begin
        OnesText[1] := 'Un';
        OnesText[2] := 'Deux';
        OnesText[3] := 'Trois';
        OnesText[4] := 'Quatre';
        OnesText[5] := 'Cinq';
        OnesText[6] := 'Six';
        OnesText[7] := 'Sept';
        OnesText[8] := 'Huit';
        OnesText[9] := 'Neuf';
        OnesText[10] := 'Dix';
        OnesText[11] := 'Onze';
        OnesText[12] := 'Douze';
        OnesText[13] := 'Treize';
        OnesText[14] := 'Quatorze';
        OnesText[15] := 'Quinze';
        OnesText[16] := 'Seize';
        OnesText[17] := 'Dix-sept';
        OnesText[18] := 'Diez-huit';
        OnesText[19] := 'Dix-neuf';

        TensText[1] := '';
        TensText[2] := 'Vingt';
        TensText[3] := 'Trente';
        TensText[4] := 'Quarante';
        TensText[5] := 'Cinquante';
        TensText[6] := 'Soixante';
        TensText[7] := 'Soixante-dix';
        TensText[8] := 'Quatre-vingt';
        TensText[9] := 'Quatre-vingt-dix';

        ThousText[1] := 'Cent';
        ThousText[2] := 'Mille';
        ThousText[3] := 'Million';
        ThousText[4] := 'Milliard';
        ThousText[5] := 'Triillion';
    end;

    var
        OnesText: array[20] of Text[3000];
        TensText: array[10] of Text[3000];
        ThousText: array[10] of Text[3000];

        AmountInWords: Text[3000];
        DecimalInWords: Text[3000];
        WholeInWords: Text[3000];
        WholePart: Integer;
        DecimalPart: Integer;
}