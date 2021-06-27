codeunit 82862 "MICA Refresh s2s Events"
{
    trigger OnRun()
    var
        MICAS2SSHeaderExtEvent: Record "MICA S2S S.Header Ext. Event";
        MICAS2SSLineExtEvent: Record "MICA S2S S.Line Ext. Event";
        MICAS2SPHeaderExtEvent: Record "MICA S2S P.Header Ext. Event";
        MICAS2SPLineExtEvent: Record "MICA S2S P.Line Ext. Event";
    begin
        MICAS2SSHeaderExtEvent.RefreshFromIntervalEvent();
        MICAS2SSLineExtEvent.RefreshFromIntervalEvent();
        MICAS2SPHeaderExtEvent.RefreshFromIntervalEvent();
        MICAS2SPLineExtEvent.RefreshFromIntervalEvent();
    end;
}