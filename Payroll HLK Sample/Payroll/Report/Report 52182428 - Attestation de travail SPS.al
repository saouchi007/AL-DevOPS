/// <summary>
/// Report Attestation de travail SPS (ID 51397).
/// </summary>
report 52182428 "Attestation de travail SPS"
{
    // version HALRHPAIE.6.2.00

    // Karim Boumaaraf
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Attestation de travail SPS.rdl';


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
                    Nom := Employee."Last Name" + ' ' + Employee."First Name";
                END;

                IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                    IF Employee."Middle Name" <> '' THEN BEGIN
                        Nom := Employee."Last Name" + ' ' + '(N??e' + ' ' + Employee."Middle Name" + ') ' + Employee."First Name";
                    END
                    ELSE BEGIN
                        Nom := Employee."Last Name" + ' ' + Employee."First Name";
                    END;
                END;

                Texte1 := '         Je soussign??, Mr(Mme) ' + Signataire + ' agissant en ma qualit?? de ' + d??partement + ' /SARL SPS, Syst??me Panneaux Sandwichs atteste par la pr??sente que ' + Sexe + ' ' + Nom + ' n??(e)';
                Texte1 := Texte1 + ' le ' + FORMAT(Employee."Birth Date") + ' ?? ' + Employee."Birthplace City";
                Texte1 := Texte1 + ' fait partie de nos effectifs en qualit?? de ';
                Texte1 := Texte1 + ' ' + Employee."Job Title" + ' depuis ';
                Texte1 := Texte1 + ' le ' + FORMAT(Employee."Employment Date") + ' ?? ce jour.';
                Texte4 := 'Cette attestation est d??livr??e ?? la demande de l''int??r??ss?? (e) pour servir ce que de droit.';
                //************** </Code section 2> ************************************//



                //*********** <Code Section Footer> *****************//

                footer1 := CompanyInfo."Legal Form" + ' Au capital social de '
                            + CompanyInfo."Stock Capital"
                            + ' - '
                            + CompanyInfo.Address
                            + '  '
                            + CompanyInfo."Address 2"
                            + ' - '
                            + 'R.C N?? '
                            + CompanyInfo."Registration No."
                            + 'N?? ART: ' + CompanyInfo."VAT Registration No.";
                footer2 := 'NIS & Matricule fiscal: ' + CompanyInfo."Trade Register"
                            + '-' + ' Agr??ment sanitaire N?? 06802'
                            + ' - Compte bancaire ' + CompanyInfo."Bank Name" + ' N?? ' + CompanyInfo."Bank Account No.";

                footer3 := 'T??l: ' + CompanyInfo."Phone No." + '&' + CompanyInfo."Phone No. 2"
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
                    field("Date d'??tablissement"; ImpDate)
                    {
                    }
                    field("Lieu d'??tablissement"; Lieu)
                    {
                    }
                    field(Motif; Motif)
                    {
                        Visible = false;
                    }
                    field(Signataire; Signataire)
                    {
                    }
                    field(Fonction; d??partement)
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
            ERROR('Veuillez saisir le lieu et la Date d''??dition dans l''onglet Options');



        //************** <Code section 1 (header)> ***************//
        NomEntreprise := CompanyInfo.Name;

        NumRef := 'REF : N??             /SP/' + FORMAT(DATE2DMY(TODAY, 3));
        //************** </Code section 1 (header)> ***************//

        //************** <Code section 3> **********************//
        TexteDate := 'Fait ?? ' + Lieu + ', le ' + FORMAT(ImpDate);
        //************** </Code section 3> *********************//
    end;

    var
        Text01: Label '"Fait ?? Alger, le "';
        Employee: Record 5200;
        CompanyInfo: Record 79;
        Text02: Label 'Nous soussign??s, %1 sise ?? %2,  attestons que %3 %4 n??(e) le %5 ?? %6  est employ?? au sein de notre institution depuis le %7 ?? ce jour.';
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
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DEPARTEMENT DES RESSOURCES HUMAINES';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        L_employeurCaptionLbl: Label 'L''employeur';
        Signataire: Text[50];
        "d??partement": Text[100];

}

