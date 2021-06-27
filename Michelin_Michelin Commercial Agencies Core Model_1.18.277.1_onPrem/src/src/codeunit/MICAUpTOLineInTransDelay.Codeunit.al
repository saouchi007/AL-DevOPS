codeunit 80342 "MICA Up TO Line InTrans Delay"
{
    trigger OnRun()
    var
        MICAReallocBackOrderMgt: Codeunit "MICA Realloc. BackOrder Mgt";
    begin
        MICAReallocBackOrderMgt.UpdateTOLineWithInTransitDelay();
    end;
}