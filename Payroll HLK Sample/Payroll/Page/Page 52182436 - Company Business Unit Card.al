/// <summary>
/// Page Company Business Unit Card (ID 52182436).
/// </summary>
page 52182436 "Company Business Unit Card"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Company Business Unit Card',
                FRA = 'Fiche unité de société';
    PageType = Card;
    SourceTable = "Company Business Unit";

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
                field("CNAS Center"; "CNAS Center")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Current Payroll"; "Current Payroll")
                {
                }
                field("Current Leave Perid"; "Current Leave Perid")
                {
                }
                field("Leave Nbre of Days by Month"; "Leave Nbre of Days by Month")
                {
                }
                field("Nbre de jours de congé par an"; "Nbre de jours de congé par an")
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
            group(Comptabilisation)
            {
                Caption = 'Comptabilisation';
                field("Payroll Bank Account"; "Payroll Bank Account")
                {
                }
                field("Payroll Journal Template Name"; "Payroll Journal Template Name")
                {
                }
                field("Payroll Journal Batch Name"; "Payroll Journal Batch Name")
                {
                }
            }
            group(CNAS)
            {
                Caption = 'CNAS';
                field("Agence CNAS"; "Agence CNAS")
                {
                }
                field("Adresse CNAS"; "Adresse CNAS")
                {
                }
                field("Ville CNAS"; "Ville CNAS")
                {
                }
                field("N° CCP CNAS"; "N° CCP CNAS")
                {
                }
                field("N° Cpte Trésor CNAS"; "N° Cpte Trésor CNAS")
                {
                }
                field("N° Tél. CNAS"; "N° Tél. CNAS")
                {
                }
                field("Code Agence CNAS"; "Code Agence CNAS")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Business Unit")
            {
                CaptionML = ENU = '&Business Unit',
                            FRA = '&Unité';
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = 'A&xes analytiques';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(90011),
                                  "No." = FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            Unite.GET(ParamUtilisateur."Company Business Unit");
            IF ParamUtilisateur."Company Business Unit" = '' THEN
                ERROR(Text02);
            FILTERGROUP(2);
            SETRANGE(Code, ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
    end;

    var
        Mail: Codeunit 397;
        ParamUtilisateur: Record 91;
        Unite: Record "Company Business Unit";
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Unité non paramétrée pour l''utilisateur %1 !';
}

