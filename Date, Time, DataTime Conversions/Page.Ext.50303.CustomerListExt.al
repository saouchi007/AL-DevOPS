/// <summary>
/// PageExtension MyExtension (ID 50303) extends Record Customer List.
/// </summary>
pageextension 50303 ISA_CustomerListExt extends "Customer List"
{
    trigger OnOpenPage()
    var
        ISA_Date: Date;
        ISA_Time: Time;
        ISA_DateTime: DateTime;
    begin
        //Building datetime out of a date and time variables
        ISA_Date := Today;
        ISA_Time := Time;
        ISA_DateTime := CreateDateTime(ISA_Date, ISA_Time);
        Message(Format(ISA_DateTime));

        //Splitting time and date out of a datetime variable
        ISA_DateTime := CurrentDateTime;
        ISA_Date := DT2Date(ISA_DateTime);
        ISA_Time := DT2Time(ISA_DateTime);
        Message('%1:\- %2\- %3', ISA_DateTime, ISA_Date, ISA_Time);
    end;
}