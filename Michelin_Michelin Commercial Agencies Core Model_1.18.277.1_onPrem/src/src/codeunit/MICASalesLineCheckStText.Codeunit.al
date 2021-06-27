codeunit 81900 "MICA Sales Line Check St. Text"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Sales Line", 'OnValidateNoOnBeforeInitRec', '', false, false)]
    local procedure OnValidateNoOnBeforeInitRec(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer)
    begin
        CheckLineData(SalesLine);
    end;

    local procedure CheckLineData(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        StandardText: Record "Standard Text";
    begin

        if SalesLine.Type <> SalesLine.Type::" " then
            exit;

        if StandardText.Get(SalesLine."No.") then
            exit;

        if Item.Get(SalesLine."No.") then begin
            SalesLine.Type := SalesLine.Type::Item;
            SalesLine.Validate("No.", SalesLine."No.");
        end;
    End;
}
