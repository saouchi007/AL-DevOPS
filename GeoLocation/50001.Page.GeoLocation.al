pageextension 50100 GeoLocation extends "Customer List"
{
    trigger OnOpenPage()
    var
        localDateTime: DateTime;
        UTC: Text;
        Msg: Label 'Local DateTime is %1.\UTC is %2.';
        typeHelper: Codeunit "Type Helper";
    begin
        localDateTime := CurrentDateTime;
        //UTC := Format(localDateTime, 0, 9);
        UTC := typeHelper.GetCurrUTCDateTimeAsText();
        Message(Msg, localDateTime, UTC);
    end;
}