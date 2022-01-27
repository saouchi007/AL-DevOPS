/// <summary>
/// Page Antenna Card (ID 51554).
/// </summary>
page 52182576 "Antenna Card"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement des souches

    CaptionML = ENU = 'Company Business Unit Card',
                FRA = 'Fiche antenne de direction';
    PageType = Card;
    SourceTable = Antenna;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            FRA = 'Général';
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    CaptionML = ENU = 'Post Code/City',
                                FRA = 'CP/Ville';
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Employer SS No."; "Employer SS No.")
                {
                }
                field("Company Business Unit"; "Company Business Unit")
                {
                }
                field("Payroll Bank Account"; "Payroll Bank Account")
                {
                }
                field("Current Payroll Code"; "Current Payroll Code")
                {
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication',
                            FRA = 'Communication';
                field("Phone No."; "Phone No.")
                {
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Home Page"; "Home Page")
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
            ERROR(Text02);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Company Business Unit", ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        Mail: Codeunit 397;
        ParamUtilisateur: Record 91;
        Text02: Label 'Utilisateur %1 non configuré !';

}

