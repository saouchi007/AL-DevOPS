/// <summary>
/// PageExtension ISA_VendorsList_Ext (ID 50223) extends Record Vendor List.
/// </summary>
pageextension 50223 ISA_VendorsList_Ext extends "Vendor List"
{
    trigger OnOpenPage()
    var
        DateTime001: DateTime;
        DateTime002: DateTime;
        Duration: Duration;
        InoutString: Text[1024];
        StringList: List of [Text];
        OutputString: Label 'Day is %1\\Hour is %2\\Minute is %3 \\Second is %4';
    begin
        DateTime001 := CreateDateTime(20210101D, 000000T); //01/01/21 12:00 AM
        DateTime002 := CreateDateTime(20210210D, 094235T); //02/10/21 09:42 AM
        Duration := DateTime002 - DateTime001;
        Message(Format(Duration));
        InoutString := Format(Duration);
        StringList := InoutString.Split(' ');
        Message(OutputString, StringList.Get(1), StringList.Get(3), StringList.Get(5), StringList.Get(7));
        Message(StringList.Get(3) + ':' + StringList.Get(5)); // display 09:42 format
    end;


}