/// <summary>
/// TableExtension ISA_StampDuty (ID 50157) extends Record Sales Line.
/// </summary>
tableextension 50157 ISA_StampDuty_SL extends "Sales Line"
{
    fields
    {
        field(50157; StampDuty; Decimal)
        {
            Caption = 'Stamp Duty';
        }
    }
    /// <summary>
    /// MyProcedure.
    /// </summary>
    /*procedure GetStampDuty()
    var
        ProcAmnt: Decimal;
        set: Boolean;
    begin
        Rec.StampDuty := 0;
        ProcAmnt := 0;
        Rec.SetRange("Line Amount");
        if Rec.Find('-') and set = false then begin
            repeat
                ProcAmnt += Rec."Line Amount";
                Rec.StampDuty := ((ProcAmnt * 0.19) + ProcAmnt) * 0.01;
            until Rec.Next = 0;
            set := true;
        end;
        Rec.Modify();
    end;*/
}