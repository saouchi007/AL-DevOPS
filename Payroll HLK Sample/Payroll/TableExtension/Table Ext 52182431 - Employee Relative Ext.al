/// <summary>
/// TableExtension Employee Relative Ext (ID 52182431) extends Record Employee Relative.
/// </summary>
tableextension 52182431 "Employee Relative Ext" extends "Employee Relative"
{
    fields
    {
        field(50000; Sex; Option)
        {
            CaptionML = ENU = 'Sex',
                        FRA = 'Sexe';
            Description = 'HALRHPAIE';
            OptionCaptionML = ENU = ' ,Female,Male',
                              FRA = ' ,Féminin,Masculin';
            OptionMembers = " ",Female,Male;
        }
        field(50001; Descendant; Boolean)
        {
            CaptionML = ENU = 'Descendant',
                        FRA = 'Descendant';
            Description = 'HALRHPAIE';
            Editable = false;
        }
        field(50002; Studying; Boolean)
        {
            CaptionML = ENU = 'Studying',
                        FRA = 'Scolarisé';
            Description = 'HALRHPAIE';
        }
    }

    var
        myInt: Integer;
}