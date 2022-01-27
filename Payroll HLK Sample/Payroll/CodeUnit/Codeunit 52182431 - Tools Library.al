/// <summary>
/// Codeunit Tools Library (ID 52182431).
/// </summary>
codeunit 52182431 "Tools Library"
//codeunit 39108403 "Tools Library"
{
    // version HALRHPAIE.6.1.01


    trigger OnRun();
    begin
    end;

    var
        Text026: Label 'ZERO';
        Text027: Label 'CENT';
        Text028: Label 'ET';
        Text029: Label '%1 résultat(s) en toutes lettres trop long(s).';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        GLSetup: Record 98;
        Text032: Label 'UN';
        Text033: Label 'DEUX';
        Text034: Label 'TROIS';
        Text035: Label 'QUATRE';
        Text036: Label 'CINQ';
        Text037: Label 'SIX';
        Text038: Label 'SEPT';
        Text039: Label 'HUIT';
        Text040: Label 'NEUF';
        Text041: Label 'DIX';
        Text042: Label 'ONZE';
        Text043: Label 'DOUZE';
        Text044: Label 'TREIZE';
        Text045: Label 'QUATORZE';
        Text046: Label 'QUINZE';
        Text047: Label 'SEIZE';
        Text048: Label 'DIX-SEPT';
        Text049: Label 'DIX-HUIT';
        Text050: Label 'DIX-NEUF';
        Text051: Label 'VINGT';
        Text052: Label 'TRENTE';
        Text053: Label 'QUARANTE';
        Text054: Label 'CINQUANTE';
        Text055: Label 'SOIXANTE';
        Text056: Label 'SOIXANTE-DIX';
        Text057: Label 'QUATRE-VINGT';
        Text058: Label 'QUATRE-VINGT DIX';
        Text059: Label 'MILLE';
        Text060: Label 'MILLION';
        Text061: Label 'MILLIARD';
        EnteteAchat: Record 38;
        LigneAchat: Record 39;
        LigneAchat2: Record 39;
        LigneAchat3: Record 39;
        TotalHT: Decimal;
        QteAffectable: Decimal;
        NumLigne: Integer;
        FraisAnnexes: Record 5800;
        CodeFraisAnnexes: Code[20];
        ParametresAchat: Record 312;
        ParametresCpta: Record 98;
        Article: Record 27;
        AffectationFrais: Record 5805;
        AffectationFrais2: Record 5805;
        AffectationFraisAchat: Codeunit 5805;
        EnteteVente: Record 36;
        LigneVente: Record 37;
        Text01: Label 'Valeur manquante ! Champ %1, Ligne %2';
        UnitesArticle: Record 5404;
        TotalQte: Decimal;
        Qte1: Decimal;
        Qte2: Decimal;
        ParametresVente: Record 311;
        Text02: Label 'Unité de mesure %1 non affectée à l''article %2';
        QteBase: Decimal;
        SectionGrid: Record "Treatment Section Grid";
        Text03: Label 'Valeur manquante ! Champ %1, Client %2';
        RemiseTransport: Decimal;
        Taux: Decimal;
        i: Integer;
        Chn: Text[30];

    /// <summary>
    /// Format_Text.
    /// </summary>
    /// <param name="Texte">Text[30].</param>
    /// <param name="Taille">Integer.</param>
    /// <param name="CaractereVide">Text[1].</param>
    /// <param name="ADroite">Boolean.</param>
    /// <returns>Return variable Resultat of type Text[30].</returns>
    procedure Format_Text(Texte: Text[30]; Taille: Integer; CaractereVide: Text[1]; ADroite: Boolean) Resultat: Text[30];
    var
        Chn: Text[30];
        i: Integer;
    begin
        Chn := Texte;
        FOR i := 1 TO Taille DO
            IF ADroite THEN
                Chn := CaractereVide + Chn
            ELSE
                Chn := Chn + CaractereVide;
        Resultat := Chn;
    end;

    /// <summary>
    /// Money2Text.
    /// </summary>
    /// <param name="NoText">VAR array[2] of Text[80].</param>
    /// <param name="No">Decimal.</param>
    procedure Money2Text(var NoText: array[2] of Text[80]; No: Decimal);
    var
        NoTextIndex: Integer;
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        GLSetup.GET;

        AddToNoText(NoText, NoTextIndex, PrintExponent, GLSetup."LCY Code" + ' ' + Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100));
        AddToNoText(NoText, NoTextIndex, PrintExponent, 'CENTIMES');
    end;

    /// <summary>
    /// AddToNoText.
    /// </summary>
    /// <param name="NoText">VAR array[2] of Text[80].</param>
    /// <param name="NoTextIndex">VAR Integer.</param>
    /// <param name="PrintExponent">VAR Boolean.</param>
    /// <param name="AddText">Text[30].</param>
    procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;
        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;
        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    /// <summary>
    /// InitTextVariable.
    /// </summary>
    procedure InitTextVariable();
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure accesstopay();
    var
        UserPersonalization: Record 91;
    begin
        UserPersonalization.SETFILTER("RH et Paie", 'false');
        UserPersonalization.SETRANGE("User ID", USERID);
        IF UserPersonalization.FINDFIRST THEN
            ERROR('Vous n''avez pas accés au module RH et PAIE');
    end;
}

