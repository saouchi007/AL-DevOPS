/// <summary>
/// Report Certificat de travail SPS (ID 52182429).
/// </summary>
report 52182429 "Certificat de travail SPS"
{
    // version HALRHPAIE.6.1.01

    // Karim Boumaaraf
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Certificat de travail SPS.rdl';


    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(NumRef; NumRef)
            {
            }
            column(NomEntreprise; NomEntreprise)
            {
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
            column(Texte4; Texte4)
            {
            }
            column(TexteDate; TexteDate)
            {
            }
            column(CERTIFICAT_DE_TRAVAILCaption; CERTIFICAT_DE_TRAVAILCaptionLbl)
            {
            }
            column(DIRECTION_DES_RESSOURCES_HUMAINESCaption; DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl)
            {
            }
            column(SERVICE_DU_PERSONNELCaption; SERVICE_DU_PERSONNELCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(NomETS; CompanyInfo.Name)
            {
            }
            column(Logo; CompanyInfo.Picture)
            {
            }
            column(lemployeur; CPT_Lemployeur)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Employee.Get("No.");
                IF "Termination Date" = 0D THEN
                    ERROR('Edition impossible du certificat de travail : la date de fin de relation de travail n''est pas renseignée !');

                IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                    IF Employee."Marital Status" = Employee."Marital Status"::Married THEN BEGIN
                        Sexe := 'Madame :';
                    END
                    ELSE BEGIN
                        Sexe := 'Mlle';
                    END;
                END;

                IF Employee.Gender = Employee.Gender::Male THEN
                    Sexe := 'Monsieur :';

                EmployeeAssignment.RESET;
                EmployeeAssignment.SETRANGE(EmployeeAssignment."Employee No.", Employee."No.");
                Texte1 := '         Je soussigné, Mr(Mme) ' + Signataire + ' agissant en qualité de ' + département + ' sise à ' + CompanyInfo.Address + ' ' + CompanyInfo."Address 2"
                + ', Que ' + Sexe + ' ' + Employee."First Name" + ' ' + Employee."Last Name" + ' né(e) ';
                Texte1 := Texte1 + ' le ' + FORMAT(Employee."Birth Date") + ' à ' + Employee."Birthplace City" + ',';
                Texte1 := Texte1 + 'a été employé(e) au sein de la société comme suit : ';
                Texte2 := 'Du' + ' ' + FORMAT(Employee."Employment Date") + ' ' + 'Au' + ' ' + FORMAT(Employee."Termination Date") + ' en qualité ' + Employee."Job Title" + '.';
                Texte3 := 'L''intéressé(e) quitte la société libre de tout engagement.';
                Texte4 := 'Le présent certificat est délivré à l’intéressé(e) pour servir et valoir ce que de droit.';
            end;

            trigger OnPreDataItem();
            begin

                NomEntreprise := CompanyInfo.Name;
                NumRef := 'N°     /RH/' + FORMAT(DATE2DMY(TODAY, 3));


                CompanyInfo.GET;
                //TexteDate:='Fait à ' + Lieu + ', le '+FORMAT(ImpDate);


                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                Lieu := CompanyInfo.City;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(ImpDate; ImpDate)
                    {
                        Caption = 'Date d''établissement';
                        Visible = false;
                    }
                    field(Lieu; Lieu)
                    {
                        Caption = 'Lieu d''établissement';
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
    end;

    var
        Text01: Label '"Fait à Alger, le "';
        Employee: Record 5200;
        CompanyInfo: Record 79;
        Texte1: Text[250];
        Texte2: Text[1000];
        Texte3: Text[250];
        Texte4: Text[250];
        EmployeeAssignment: Record "Employee Assignment";
        NumRef: Text[50];
        NomEntreprise: Text[50];
        Sexe: Text[50];
        footer1: Text[200];
        footer2: Text[200];
        footer3: Text[200];
        ImpDate: Date;
        Lieu: Text[50];
        TexteDate: Text[50];
        chr10: Char;
        chr13: Char;
        CERTIFICAT_DE_TRAVAILCaptionLbl: Label 'CERTIFICAT DE TRAVAIL';
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        CPT_Lemployeur: Label 'L''Employeur';
        Signataire: Text[50];
        "département": Text[100];

}

