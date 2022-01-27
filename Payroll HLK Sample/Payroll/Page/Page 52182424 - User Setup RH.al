/// <summary>
/// Page User Setup RH (ID 52182424).
/// </summary>
page 52182424 "User Setup RH"
{
    // version NAVW14.00,HALRHPAIE.6.1.01

    CaptionML = ENU = 'User Setup',
                FRA = 'Paramètres utilisateur RH';
    PageType = List;
    SourceTable = 91;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("User ID"; "User ID")
                {
                }
                field("Allow Posting From"; "Allow Posting From")
                {
                    Visible = false;
                }
                field("Allow Posting To"; "Allow Posting To")
                {
                    Visible = false;
                }
                field("Company Business Unit"; "Company Business Unit")
                {
                }
                field("Register Time"; "Register Time")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin

        CurrPage.EDITABLE := FALSE;
        IF USERID IN ['SOUMMAM\AMEL.TAALBA', 'SOUMMAM\ILIES.SEBKHI', 'SOUMMAM\AHCEN.HAMIDOUCHE'
          , 'SOUMMAM\HAKIM.BENMEZIANE', 'SOUMMAM\ASSIA.HAMITOUCHE', 'SOUMMAM\HMIMI.ADALOU', 'SOUMMAM\MEBROUK.HAMIDOUCHE'
          , 'SOUMMAM\MOKHTAR.SALHI']
         THEN
            CurrPage.EDITABLE := TRUE;

    end;

    var

}

