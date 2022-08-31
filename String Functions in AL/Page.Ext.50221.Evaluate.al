/// <summary>
/// PageExtension ISA_PostedSalShip (ID 50221) extends Record Posted Sales Shipments.
/// </summary>
pageextension 50221 ISA_PostedSalShip extends "Posted Sales Shipments"
{
    trigger OnOpenPage()
    var
        VarIntger: Integer;
        VarDate: Date;
        VarYesNo: Boolean;
        VarDuration: Duration;

        Value: Text;
        Ok1: Boolean;
        Ok2: Boolean;
        Ok3: Boolean;
        Ok4: Boolean;

        Text000: Label 'VarIntger = %1, the return code is %2.\';
        Text001: Label 'VarDate = %3, the return code is %4.\';
        Text002: Label 'VarYesNo = %5, the return code is %6.\';
        Text003: Label 'VarDuration = %7, the return code is %8.\';
    begin
        Value := '31082022';
        Ok1 := Evaluate(VarIntger, Value);
        Ok2 := Evaluate(VarDate, Value);
        Ok3 := Evaluate(VarYesNo, Value);
        Value := '2days 4hours 3.7 seconds 17 milliseconds';
        Ok4 := Evaluate(VarDuration, Value);

        Message(Text000 + Text001 + Text002 + Text003, VarIntger, Ok1, VarDate, Ok2, VarYesNo, Ok3, VarDuration, Ok4);
    end;
}