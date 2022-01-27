/// <summary>
/// TableExtension Confidential Information Ext (ID 55216) extends Record Confidential Information.
/// </summary>
tableextension 52182438 "Confidential Information Ext" extends "Confidential Information"
{
    fields
    {
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
    }

    var
        myInt: Integer;
}