pageextension 50101 UTC_DT extends "Customer List"
{
    trigger OnOpenPage()
    var
        localDateTime: DateTime;
        UTC: Text;
        mesg: Label 'Local DateTime is %1.\UTC is %2.';
        typeHelper: Codeunit "Type Helper";
    begin
        localDateTime := CurrentDateTime;
        //UTC := Format(CurrentDateTime, 0, 9);
        UTC := typeHelper.GetCurrUTCDateTimeAsText();
        Message(mesg, localDateTime, UTC);
    end;
}