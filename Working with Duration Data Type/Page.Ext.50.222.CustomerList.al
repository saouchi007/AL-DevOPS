/// <summary>
/// PageExtension ISA_CustomersList_Ext (ID 50222) extends Record Customer List.
/// </summary>
pageextension 50222 ISA_CustomersList_Ext extends "Customer List"
{
    trigger OnOpenPage()
    var
        DateTime001: DateTime;
        DateTime002: DateTime;
        Duration: Duration;
        OutputString: Label 'The value of Duration is %1';
    begin
        DateTime001 := CreateDateTime(20210101D, 000000T); //01/01/21 12:00 AM
        DateTime002 := CreateDateTime(20210210D, 094235T); //02/10/21 09:42 AM
        Duration := DateTime002 - DateTime001;
        //Message('001 :' + Format(DateTime001) + '\002 :' + Format(DateTime002));
        Message(Format(Duration));
        Message(OutputString + ' milliseconds', Format(Duration / 1)); //milliseconds = Duration / 1
        Message(OutputString + ' seconds', Format(Duration / 1000)); //seconds = Duration / 1000
        Message(OutputString + ' minutes', Format(Round(Duration / 60000, 0.01, '>'))); //minutes = Duration / 60000, 0.01 for 2 decimals
        Message(OutputString + ' minutes', Format(Duration div 60000)); //ROUND or Div to get the clean result you want
        /*
        milliseconds = Duration / 1

        seconds = Duration / 1000

        minutes = Duration / 60000

        hours = Duration / 3600000

        days = Duration / 86400000  */
    end;
}
