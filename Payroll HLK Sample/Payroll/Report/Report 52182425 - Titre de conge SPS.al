/// <summary>
/// Report Titre de conge SPS (ID 52182425).
/// </summary>
report 52182425 "Titre de conge SPS"
{
    // version HALRHPAIE.6.2.00

    // Karim Boumaaraf
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Titre de conge SPS.rdl';


    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(Texte1; Texte1)
            {
            }
            column(Texte2; Texte2)
            {
            }
            column(Texte3; Texte3)
            {
            }
            column(Texte4; Texte4)
            {
            }
            column(Texte5; Texte5)
            {
            }
            column(Texte6; Texte6)
            {
            }
            column(Texte7; Texte7)
            {
            }
            column(Texte8; Texte8)
            {
            }
            column(Texte9; Texte9)
            {
            }
            column(Texte10; Texte10)
            {
            }
            column(Texte11; Texte11)
            {
            }
            column("AdressDeDépart"; AdressEntreprise)
            {
            }
            column(CompanyInformation_Picture; InfoSociete.Picture)
            {
                AutoCalcField = true;
            }
            column(NomEntreprise; NomEntreprise)
            {
            }
            column(NumRef; NumRef)
            {
            }
            column(TexteDate; TexteDate)
            {
            }
            column(ATTESTATION_DE_TRAVAILCaption; ATTESTATION_DE_TRAVAILCaptionLbl)
            {
            }
            column(DIRECTION_DES_RESSOURCES_HUMAINESCaption; DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl)
            {
            }
            column(SERVICE_DU_PERSONNELCaption; SERVICE_DU_PERSONNELCaptionLbl)
            {
            }
            column(L_employeurCaption; L_employeurCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(footer1; footer1)
            {
            }
            column(footer2; footer2)
            {
            }
            column(footer3; footer3)
            {
            }
            column(footer4; footer4)
            {
            }
            column(Logo; CompanyInfo.Picture)
            {
            }
            column(Destination; Destination)
            {
            }
            column(MotifDuDeplacement; Motif)
            {
            }
            column("DateDeDépart"; DateDeDépart)
            {
            }
            column(DateDeRetour; DateDeRetour)
            {
            }
            column(PeriodeConge; PeriodeConge)
            {
            }

            trigger OnAfterGetRecord();
            begin

                Employee.Get("No.");
                EmployeeLeave.SETRANGE("Employee No.", Employee."No.");
                EmployeeLeave.SETRANGE("Leave Period", PeriodeConge);
                EmployeeLeave.FINDFIRST;

                //************** <Code section 2> ************************************//
                IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                    IF Employee."Marital Status" = Employee."Marital Status"::Married THEN BEGIN
                        Sexe := 'Madame :';
                    END
                    ELSE BEGIN
                        Sexe := 'Mlle';
                    END;
                END;

                IF Employee.Gender = Employee.Gender::Male THEN BEGIN
                    Sexe := 'Monsieur :';
                    Nom := Employee."Last Name";
                    Prenom := Employee."First Name";
                END;

                IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                    IF Employee."Middle Name" <> '' THEN BEGIN
                        Nom := Employee."Last Name" + ' ' + '(Née' + ' ' + Employee."Middle Name" + ') ';
                        Prenom := Employee."First Name";
                    END
                    ELSE BEGIN
                        Nom := Employee."Last Name";
                        Prenom := Employee."First Name";
                    END;
                END;

                Texte1 := Sexe + ' ' + Nom;
                Texte2 := Prenom;
                Texte3 := Employee."Job Title" + ' depuis ';
                Texte4 := Employee."Structure Description";
                Texte5 := FORMAT(EmployeeLeave.Quantity);
                Texte6 := ' CONGE ANNUEL (' + PeriodeConge + ').';
                Texte7 := FORMAT(EmployeeLeave."Starting Date");
                Texte8 := FORMAT(EmployeeLeave."Ending Date");
                Texte9 := FORMAT(EmployeeLeave."Recovery Date");
                Texte10 := Employee.Address + ' ' + Employee."Address 2";
                Texte11 := 'Ce Titre est délivré à l''intéressé(e) pour servir et valoir ce que de droit.';
                //*********** <Code Section Footer> *****************//

                footer1 := CompanyInfo."Legal Form" + ' Au capital social de '
                            + CompanyInfo."Stock Capital"
                            + ' - '
                            + CompanyInfo.Address
                            + '  '
                            + CompanyInfo."Address 2"
                            + ' - '
                            + 'R.C N° '
                            + CompanyInfo."Registration No."
                            + 'N° ART: ' + CompanyInfo."VAT Registration No.";
                footer2 := 'NIS & Matricule fiscal: ' + CompanyInfo."Trade Register"
                            + '-' + ' Agrément sanitaire N° 06802'
                            + ' - Compte bancaire ' + CompanyInfo."Bank Name" + ' N° ' + CompanyInfo."Bank Account No.";

                footer3 := 'Tél: ' + CompanyInfo."Phone No." + '&' + CompanyInfo."Phone No. 2"
                            + ' - '
                            + 'Fax: ' + CompanyInfo."Fax No.";
                footer4 := CompanyInfo."Home Page";
                //*********** </Code Section Footer> *****************//
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Date d'établissement"; ImpDate)
                    {
                    }
                    field("Lieu d'établissement"; Lieu)
                    {
                    }
                    field("Période de congé"; PeriodeConge)
                    {
                        TableRelation = "Leave Period";
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }



    trigger OnPreReport();
    begin



        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);


        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");

        IF Lieu = ''
        THEN
            ERROR('Veuillez saisir le lieu et la Date d''édition dans l''onglet Options');

        IF PeriodeConge = ''
        THEN
            ERROR('Veuillez saisir la période de congé dans l''onglet Options');


        //************** <Code section 1 (header)> ***************//
        NomEntreprise := CompanyInfo.Name;
        AdressEntreprise := CompanyInfo.Address + ' ' + CompanyInfo."Address 2";
        NumRef := 'REF : N°             /RH/' + FORMAT(DATE2DMY(TODAY, 3));
        //************** </Code section 1 (header)> ***************//

        //************** <Code section 3> **********************//
        TexteDate := 'Fait à ' + Lieu + ', le ' + FORMAT(ImpDate);
        //************** </Code section 3> *********************//
    end;

    var
        Text01: Label '"Fait à Alger, le "';
        CompanyInfo: Record 79;
        Employee: Record 5200;
        Text02: Label 'Nous soussignés, %1 sise à %2, attestons que %3 %4 né(e) le %5 à %6 est employé au sein de notre institution depuis le %7 à ce jour.';
        Texte1: Text[400];
        Texte2: Text[400];
        Texte3: Text[400];
        Texte4: Text[250];
        Texte5: Text[250];
        Texte6: Text[250];
        Texte7: Text[250];
        Texte8: Text[250];
        Texte9: Text[250];
        Texte10: Text[250];
        Texte11: Text[250];
        TexteDate: Text[50];
        InfoSociete: Record 79;
        Unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        Sexe: Text[30];
        footer1: Text[200];
        footer2: Text[200];
        footer3: Text[200];
        footer4: Text[200];
        NumRef: Text[50];
        NomEntreprise: Text[50];
        Nom: Text[250];
        Chn: Text[30];
        ImpDate: Date;
        Lieu: Text[30];
        Motif: Text[100];
        ATTESTATION_DE_TRAVAILCaptionLbl: Label 'ATTESTATION DE TRAVAIL';
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        L_employeurCaptionLbl: Label 'L''employeur';
        Destination: Text[50];
        "DateDeDépart": Date;
        DateDeRetour: Date;
        PeriodeConge: Code[200];
        Prenom: Text[50];
        MoyenTransport: Text[50];
        AdressEntreprise: Text[150];
        EmployeeLeave: Record "Employee Leave";

}

