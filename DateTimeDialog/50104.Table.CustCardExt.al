tableextension 50104 CustCardExt extends Customer
{
    fields
    {
        field(50101; "Earliest Contact Date/Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Earliest Contact Date/Time';

            trigger OnLookup()
            begin
                Validate("Earliest Contact Date/Time", lookupDateTime("Earliest Contact Date/Time"));
            end;
        }
    }

    procedure lookupDateTime(intialValue: DateTime): DateTime
    var
        DateTimeDialog: Page "Date-Time Dialog";
        NewValue: DateTime;
    begin
        DateTimeDialog.SetDateTime(intialValue);

        if DateTimeDialog.RunModal() = Action::OK then begin
            NewValue := DateTimeDialog.GetDateTime();
        end;

        exit(NewValue);
    end;

}