/// <summary>
/// Page Saisie des vaccins maj (ID 52182426).
/// </summary>
page 52182426 "Saisie des vaccins maj"
{
    // version HALRHPAIE

    PageType = List;
    SourceTable = "Employee Medical shots";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field(Comptage; Comptage)
                {
                }
                field("Examination Date"; "Examination Date")
                {
                }
                field("01 DT"; "01 DT")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("02 DT"; "02 DT")
                {
                }
                field("1er R DT"; "1er R DT")
                {
                }
                field("Structure code"; "Structure code")
                {
                }
                field("Structure description"; "Structure description")
                {
                }
                field("Hépatite C"; "Hépatite C")
                {
                }
                field("deuxième Rappel  Hépatite C"; "deuxième Rappel  Hépatite C")
                {
                }
                field("Rappel Hépatite C"; "Rappel Hépatite C")
                {
                }
                field("Groupe statistique"; "Groupe statistique")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        //---01---

        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            IF ParamUtilisateur."Company Business Unit" = '' THEN
                ERROR(Text02);
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            SETRANGE(Status, Status::Active);
            FILTERGROUP(0);
        END;

        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Unité non paramétrée pour l''utilisateur %1 !';

}

