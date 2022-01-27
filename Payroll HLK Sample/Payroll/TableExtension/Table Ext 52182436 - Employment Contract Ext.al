tableextension 52182436 "Employment Contract Ext" extends "Employment Contract"
{
    fields
    {
        field(50000; Nature; Option)
        {
            Description = 'HALRHPAIE';
            OptionCaptionML = ENU = 'Contractual,Permanent',
                              FRA = 'Contractuel,Permanent';
            OptionMembers = Contractual,Permanent;
        }
    }

    var
        myInt: Integer;
}