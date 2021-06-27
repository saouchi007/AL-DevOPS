codeunit 82863 "MICA S2S Delete S. Order Event"
{
    trigger OnRun()
    begin
        MICAS2SEventSetup.Get();
        MICAS2SEventSetup.TestField("Keep Events For");
        if not Evaluate(CalulatedDateFormula, '-' + Format(MICAS2SEventSetup."Keep Events For")) then
            Error(WrongDateFormulaErr);

        DeleteHeaders();
        DeleteLines();
    end;

    procedure DeleteHeaders()
    var
        MICAS2SSHeaderExtEvent: Record "MICA S2S S.Header Ext. Event";
        MICAS2SSHeaderIntEvent: Record "MICA S2S S.Header Int. Event";
        LastDate: Date;
        LastTime: Time;
        CalculatedLastDT: DateTime;
    begin
        MICAS2SSHeaderExtEvent.FindLast();
        LastDate := CalcDate(CalulatedDateFormula, DT2Date(MICAS2SSHeaderExtEvent."Last Modified Date Time"));
        LastTime := DT2Time(MICAS2SSHeaderExtEvent."Last Modified Date Time");
        CalculatedLastDT := CreateDateTIme(LastDate, LastTime);

        MICAS2SSHeaderExtEvent.SetFilter("Last Modified Date Time", '<=%1', CalculatedLastDT);
        MICAS2SSHeaderExtEvent.DeleteAll(true);

        MICAS2SSHeaderIntEvent.SetFilter("Last Modified Date Time", '<=%1 & <>%2', CalculatedLastDT, 0DT);
        MICAS2SSHeaderIntEvent.DeleteAll(true);
    end;

    procedure DeleteLines()
    var
        MICAS2SSLineExtEvent: Record "MICA S2S S.Line Ext. Event";
        MICAS2SSLineIntEvent: Record "MICA S2S S.Line Int. Event";
        LastDate: Date;
        LastTime: Time;
        CalculatedLastDT: DateTime;
    begin
        MICAS2SSLineExtEvent.FindLast();
        LastDate := CalcDate(CalulatedDateFormula, DT2Date(MICAS2SSLineExtEvent."Last Modified Date Time"));
        LastTime := DT2Time(MICAS2SSLineExtEvent."Last Modified Date Time");
        CalculatedLastDT := CreateDateTIme(LastDate, LastTime);

        MICAS2SSLineExtEvent.SetFilter("Last Modified Date Time", '<=%1', CalculatedLastDT);
        MICAS2SSLineExtEvent.DeleteAll(true);

        MICAS2SSLineIntEvent.SetFilter("Last Modified Date Time", '<=%1 & <>%2', CalculatedLastDT, 0DT);
        MICAS2SSLineIntEvent.DeleteAll(true);
    end;



    var
        MICAS2SEventSetup: Record "MICA S2S Event Setup";
        CalulatedDateFormula: DateFormula;
        WrongDateFormulaErr: Label 'Wrong Date Formula';
}