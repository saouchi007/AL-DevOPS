/// <summary>
/// Page Antenna List (ID 51555).
/// </summary>
page 52182577 "Antenna List"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Novembre 2009
    // Rajout du champ "Company Business Unit"

    CaptionML = ENU = 'Company Business Unit List',
                FRA = 'Liste des antennes de directions';
    Editable = false;
    PageType = Card;
    SourceTable = Antenna;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Company Business Unit"; "Company Business Unit")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Antenna")
            {
                CaptionML = ENU = '&Antenna',
                            FRA = '&Antenne';
                Image = Stop;
                action(Card)
                {
                    CaptionML = ENU = 'Card',
                                FRA = 'Fiche';
                    Image = EditLines;
                    RunObject = Page "Antenna Card";
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Company Business Unit", ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré !';

}

