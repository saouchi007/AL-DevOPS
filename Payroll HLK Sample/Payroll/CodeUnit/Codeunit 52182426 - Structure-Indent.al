/// <summary>
/// Codeunit Structure-Indent (ID 52182426).
/// </summary>
codeunit 52182426 "Structure-Indent"
//codeunit 39108398 "Structure-Indent"
{
    // version HALRHPAIE.6.1.01

    TableNo = 52182434;

    trigger OnRun();
    begin
        IF NOT
           CONFIRM(
             STRSUBSTNO(
               Text000 +
               Text001 +
               Text002 +
               Text003), TRUE)
        THEN
            EXIT;

        Indent;
    end;

    var
        Text000: TextConst ENU = 'This function updates the indentation of all the dimension values for dimension %1. ', FRA = 'Cette fonction met à jour l''indentation de toutes les structures. ';
        Text001: TextConst ENU = 'All dimension values between a Begin-Total and the matching End-Total are indented by one level. ', FRA = 'Toutes les structures entre un  Début total et un Fin total correspondant sont indentées d''un niveau. ';
        Text002: TextConst ENU = 'The Totaling field for each End-Total is also updated.\\', FRA = 'La totalisation pour chaque Fin total est aussi mise à jour.\\';
        Text003: TextConst ENU = 'Do you want to indent the dimension values?', FRA = 'Voulez-vous indenter les structures ?';
        Text004: TextConst ENU = 'Indenting Dimension Values @1@@@@@@@@@@@@@@@@@@', FRA = 'Indentation structures @1@@@@@@@@@@@@@@@@@@';
        Text005: TextConst ENU = 'End-Total %1 is missing a matching Begin-Total.', FRA = 'Il manque un Début total pour le Fin total %1.';
        Structure: Record 52182434;
        Window: Dialog;
        DimValCode: array[10] of Code[20];
        i: Integer;

    /// <summary>
    /// Indent.
    /// </summary>
    procedure Indent();
    var
        NoOfDimVals: Integer;
        Progress: Integer;
    begin
        Window.OPEN(Text004);

        NoOfDimVals := Structure.COUNTAPPROX;
        IF NoOfDimVals = 0 THEN
            NoOfDimVals := 1;
        WITH Structure DO
            IF FIND('-') THEN
                REPEAT
                    Progress := Progress + 1;
                    Window.UPDATE(1, 10000 * Progress DIV NoOfDimVals);

                    IF "Structure Type" = "Structure Type"::"End-Total" THEN BEGIN
                        IF i < 1 THEN
                            ERROR(
                              Text005,
                              Code);
                        Totaling := DimValCode[i] + '..' + Code;
                        i := i - 1;
                    END;

                    Indentation := i;
                    MODIFY;

                    IF "Structure Type" = "Structure Type"::"Begin-Total" THEN BEGIN
                        i := i + 1;
                        DimValCode[i] := Code;
                    END;
                UNTIL NEXT = 0;

        Window.CLOSE;
    end;
}

