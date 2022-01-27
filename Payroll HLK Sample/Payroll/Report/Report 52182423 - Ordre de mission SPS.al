/// <summary>
/// Report Ordre de mission SPS (ID 52182423).
/// </summary>
report 52182423 "Ordre de mission SPS"
{
    // version HALRHPAIE.6.2.00

    // Karim Boumaaraf
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Ordre de mission SPS.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
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
            column(Texte4; Texte4)
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
                AutoCalcField = true;
            }
            column(Texte1; Texte1)
            {
            }
            column(Texte2; Texte2)
            {
            }
            column(Texte3; Texte3)
            {
            }
            column("AdressDeDépart"; AdressEntreprise)
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
            column(MoyenDeTransport; MoyenDeTransport)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Employee.Get("No.");
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

                //************** </Code section 2> ************************************//



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
                    field(Destination; Destination)
                    {
                    }
                    field(Motif; Motif)
                    {
                        Caption = 'Motif du déplacement';
                    }
                    field("DateDeDépart"; DateDeDépart)
                    {
                        Caption = 'Date de départ';
                    }
                    field(DateDeRetour; DateDeRetour)
                    {
                        Caption = 'Date de retour';
                    }
                    field(MoyenDeTransport; MoyenDeTransport)
                    {
                        Caption = 'Moyen de transport';
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

        IF Destination = ''
        THEN
            ERROR('Veuillez saisir la destination dans l''onglet Options');

        IF Motif = ''
        THEN
            ERROR('Veuillez saisir le Motif du déplacement dans l''onglet Options');

        IF FORMAT(DateDeDépart) = ''
        THEN
            ERROR('Veuillez saisir la date de départ dans l''onglet Options');

        IF FORMAT(DateDeRetour) = ''
        THEN
            ERROR('Veuillez saisir la date de retour dans l''onglet Options');

        IF MoyenDeTransport = ''
        THEN
            ERROR('Veuillez saisir moyen de transport dans l''onglet Options');
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
        MoyenDeTransport: Text[50];
        Prenom: Text[50];
        MoyenTransport: Text[50];
        AdressEntreprise: Text[150];

}

