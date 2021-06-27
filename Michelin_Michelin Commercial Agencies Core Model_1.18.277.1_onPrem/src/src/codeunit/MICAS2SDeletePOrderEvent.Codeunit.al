codeunit 82784 "MICA S2S Delete P. Order Event"
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
        MICAS2SPHeaderExtEvent: Record "MICA S2S P.Header Ext. Event";
        MICAS2SPHeaderIntEvent: Record "MICA S2S P.Header Int. Event";
        LastDate: Date;
        LastTime: Time;
        CalculatedLastDT: DateTime;
    begin
        MICAS2SPHeaderExtEvent.FindLast();
        LastDate := CalcDate(CalulatedDateFormula, DT2Date(MICAS2SPHeaderExtEvent."Last Modified Date Time"));
        LastTime := DT2Time(MICAS2SPHeaderExtEvent."Last Modified Date Time");
        CalculatedLastDT := CreateDateTIme(LastDate, LastTime);

        MICAS2SPHeaderExtEvent.SetFilter("Last Modified Date Time", '<=%1', CalculatedLastDT);
        MICAS2SPHeaderExtEvent.DeleteAll(true);

        MICAS2SPHeaderIntEvent.SetFilter("Last Modified Date Time", '<=%1 & <>%2', CalculatedLastDT, 0DT);
        MICAS2SPHeaderIntEvent.DeleteAll(true);
    end;

    procedure DeleteLines()
    var
        MICAS2SPLineExtEvent: Record "MICA S2S P.Line Ext. Event";
        MICAS2SPLineIntEvent: Record "MICA S2S P.Line Int. Event";
        LastDate: Date;
        LastTime: Time;
        CalculatedLastDT: DateTime;
    begin
        MICAS2SPLineExtEvent.FindLast();
        LastDate := CalcDate(CalulatedDateFormula, DT2Date(MICAS2SPLineExtEvent."Last Modified Date Time"));
        LastTime := DT2Time(MICAS2SPLineExtEvent."Last Modified Date Time");
        CalculatedLastDT := CreateDateTIme(LastDate, LastTime);

        MICAS2SPLineExtEvent.SetFilter("Last Modified Date Time", '<=%1', CalculatedLastDT);
        MICAS2SPLineExtEvent.DeleteAll(true);

        MICAS2SPLineIntEvent.SetFilter("Last Modified Date Time", '<=%1 & <>%2', CalculatedLastDT, 0DT);
        MICAS2SPLineIntEvent.DeleteAll(true);
    end;



    var
        MICAS2SEventSetup: Record "MICA S2S Event Setup";
        CalulatedDateFormula: DateFormula;
        WrongDateFormulaErr: Label 'Wrong Date Formula';
}