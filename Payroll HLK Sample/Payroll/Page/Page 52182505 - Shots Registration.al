/// <summary>
/// Page Shots Registration (ID 52182505).
/// </summary>
page 52182505 "Shots Registration"
{
    // version HALRHPAIE.6.2.01

    CaptionML = ENU = 'Examination Registration',
                FRA = 'Saisie des vaccins';
    Editable = true;
    PageType = Card;
    SourceTable = "Employee Medical shots";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Status; Status)
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("01 DT"; "01 DT")
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
                field("Groupe statistique"; "Groupe statistique")
                {
                }
                field("Hépatite C"; "Hépatite C")
                {
                }
                field(Comptage; Comptage)
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

