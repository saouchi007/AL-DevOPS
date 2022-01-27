/// <summary>
/// TableExtension Gen. Journal Template Ext (ID 52182427) extends Record Gen. Journal Template.
/// </summary>
tableextension 52182427 "Gen. Journal Template Ext" extends "Gen. Journal Template"
{
    fields
    {
        field(50000; "Company Business Unit"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit',
                        FRA = 'Direction de société';
            Description = 'Cloisonnement par direction';
            TableRelation = Company;
        }
    }

    var
        myInt: Integer;
}