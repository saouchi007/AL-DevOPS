codeunit 80341 "MICA Commit Item Inside Period"
{
    trigger OnRun()
    var
        MICAReallocBackOrderMgt: Codeunit "MICA Realloc. BackOrder Mgt";
    begin
        MICAReallocBackOrderMgt.CommitItemsInsideCommitmentPeriod('', '');
    end;
}