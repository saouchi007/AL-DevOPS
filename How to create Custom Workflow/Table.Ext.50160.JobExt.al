tableextension 50160 Job_Ext extends Job
{
    fields
    {
        field(50160; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Pending Approval",Released;
            OptionCaption = 'Open,Pending Approval, Released';
            Editable = false;
        }
    }

    var
        myInt: Integer;
}