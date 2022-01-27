/// <summary>
/// Report Procès-Verbal installation SPS (ID 52182424).
/// </summary>
report 52182424 "Procès-Verbal installation SPS"
{
    // version HALRHPAIE.6.2.00

    // Karim Boumaaraf
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Procès-Verbal installation SPS.rdl';


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
            column(Texte1; Texte1)
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
            }
            column(Signataire; Signataire)
            {
            }
            column("département"; département)
            {
            }

            trigger OnAfterGetRecord();
            begin
                //************** <Code section 2> ************************************//
                Employee.Get("No.");
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
                    Nom := Employee."Last Name" + ' ' + Employee."First Name";
                END;

                IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                    IF Employee."Middle Name" <> '' THEN BEGIN
                        Nom := Employee."Last Name" + ' ' + '(Née' + ' ' + Employee."Middle Name" + ') ' + Employee."First Name";
                    END
                    ELSE BEGIN
                        Nom := Employee."Last Name" + ' ' + Employee."First Name";
                    END;
                END;

                Texte1 := '         Je soussigné, Mr(Mme) ' + Signataire + ' ' + département + ' /SARL SPS, Système Panneaux Sandwichs, certifie que ' + Sexe + ' ' + Nom + ' Prendra ses fonctions au sein de l''entreprise SPS au niveau du ';
                Texte1 := Texte1 + Employee."Structure Description";
                Texte1 := Texte1 + ' le ' + FORMAT(Employee."Employment Date");
                Texte1 := Texte1 + ' en qualité ';
                Texte1 := Texte1 + ' ' + Employee."Job Title" + '.';

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
                    field(Motif; Motif)
                    {
                        Visible = false;
                    }
                    field(Signataire; Signataire)
                    {
                    }
                    field(Fonction; département)
                    {
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
        IF Signataire = ''
        THEN
            ERROR('Veuillez saisir le nom et le prénom du signataire dans l''onglet Options');
        IF département = ''
        THEN
            ERROR('Veuillez saisir département du signataire dans l''onglet Options');


        //************** <Code section 1 (header)> ***************//
        NomEntreprise := CompanyInfo.Name;

        NumRef := 'REF : N°             /RH/' + FORMAT(DATE2DMY(TODAY, 3));
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
        Signataire: Text[50];
        "département": Text[100];

}

