/// <summary>
/// Report Etat des mouv des salariés (ID 52182447).
/// </summary>
report 52182447 "Etat des mouv des salariés"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat des mouv des salariés.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            DataItemTableView = SORTING("No.");
            column(per; per)
            {
            }
            column("Année"; année)
            {
            }
            column(Adresse; Adresse)
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Titre; Titre)
            {
            }
            column(Employee__First_Name_; "First Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(Employee__Social_Security_No__; "Social Security No.")
            {
            }
            column(Employee__Birth_Date_; "Birth Date")
            {
            }
            column(Employee_Employee__Employment_Date_; DataItem7528."Employment Date")
            {
            }
            column(Employee__Birth_Date__Control1000000012; "Birth Date")
            {
            }
            column(Employee__First_Name__Control1000000013; "First Name")
            {
            }
            column(Employee__Last_Name__Control1000000014; "Last Name")
            {
            }
            column(Employee__Social_Security_No___Control1000000015; "Social Security No.")
            {
            }
            column(Employee_Employee__Termination_Date_; DataItem7528.Dateexit)
            {
            }
            column(Employee_Employee__Grounds_for_Term__Code_; DataItem7528."Grounds for Term. Code")
            {
            }
            column(TODAY; TODAY)
            {
            }
            column(Unite_City_Control1000000062; Unite.City)
            {
            }
            column(Date_de_Naissance_Caption; Date_de_Naissance_CaptionLbl)
            {
            }
            column("Nom_et_PrénomCaption"; Nom_et_PrénomCaptionLbl)
            {
            }
            column("N__Immatriculation_Sécurite_SocialeCaption"; N__Immatriculation_Sécurite_SocialeCaptionLbl)
            {
            }
            column(E_SCaption; E_SCaptionLbl)
            {
            }
            column("Date_Entrée_SortieCaption"; Date_Entrée_SortieCaptionLbl)
            {
            }
            column(ObservationsCaption; ObservationsCaptionLbl)
            {
            }
            column("Période__Mois_ou_Trimestre___Caption"; Période__Mois_ou_Trimestre___CaptionLbl)
            {
            }
            column(N__SS_EmployeurCaption; N__SS_EmployeurCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ECaption; ECaptionLbl)
            {
            }
            column(SCaption; SCaptionLbl)
            {
            }
            column("Etabli_à__Caption"; Etabli_à__CaptionLbl)
            {
            }
            column(Cachet_de_l_EmployeurCaption; Cachet_de_l_EmployeurCaptionLbl)
            {
            }
            column(Le__Caption; Le__CaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(datd; datd)
            {
            }
            column(datf; datf)
            {
            }
            column("CodeUnit"; CodeUnite)
            {
            }
            column(EmployeeCompanyBusinessCodeUnit; DataItem7528."Company Business Unit Code")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Adresse := Unite.Address + ' ' + Unite."Address 2";
            end;

            trigger OnPreDataItem();
            begin
                IF (année = 0) THEN ERROR('Veuillez entrer l Année');
                IF (année < 1900) OR (année > 2100) THEN ERROR('Année incorrecte');
                IF (mode = 0) THEN
                    ERROR('veuillez selectionner le mode')
                ELSE BEGIN
                    IF (mode = 1) AND (mois = 0) THEN ERROR('veuillez selectionner le mois');
                    IF (mode = 2) AND (trimestre = 0) THEN ERROR('veuillez selectionner le trimestre');
                END;
                IF mode = 1 THEN BEGIN
                    md := mois;
                    mf := mois;
                    CASE mois OF
                        1:
                            BEGIN
                                per := 'Janvier'
                            END;
                        2:
                            BEGIN
                                per := 'Février'
                            END;
                        3:
                            BEGIN
                                per := 'Mars'
                            END;
                        4:
                            BEGIN
                                per := 'Avril'
                            END;
                        5:
                            BEGIN
                                per := 'Mai'
                            END;
                        6:
                            BEGIN
                                per := 'Juin'
                            END;
                        7:
                            BEGIN
                                per := 'Juillet'
                            END;
                        8:
                            BEGIN
                                per := 'Aout'
                            END;
                        9:
                            BEGIN
                                per := 'Septembre'
                            END;
                        10:
                            BEGIN
                                per := 'Octobre'
                            END;
                        11:
                            BEGIN
                                per := 'Novembre'
                            END;
                        12:
                            BEGIN
                                per := 'Décembre'
                            END;
                    END;

                END;
                IF mode = 2 THEN BEGIN
                    per := 'Trimestre ' + FORMAT(trimestre);
                    CASE trimestre OF
                        1:
                            BEGIN
                                md := 1;
                                mf := 3
                            END;
                        2:
                            BEGIN
                                md := 4;
                                mf := 6
                            END;
                        3:
                            BEGIN
                                md := 7;
                                mf := 9
                            END;
                        4:
                            BEGIN
                                md := 10;
                                mf := 12
                            END;
                    END;
                END;
                datd := DMY2DATE(1, md, année);
                IF (mf = 1) OR (mf = 3) OR (mf = 5) OR (mf = 8) OR (mf = 7) OR (mf = 10) OR (mf = 12) THEN
                    datf := DMY2DATE(31, mf, année);
                IF (mf = 4) OR (mf = 6) OR (mf = 9) OR (mf = 11) THEN
                    datf := DMY2DATE(30, mf, année);
                IF (mf = 2) THEN
                    datf := DMY2DATE(28, mf, année);

                CompanyInformation.GET;
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
                    field("Mode:"; mode)
                    {
                    }
                    field("Exercice:"; année)
                    {
                    }
                    field("Le mois:"; mois)
                    {
                    }
                    field("Le trimestre:"; trimestre)
                    {
                    }
                    field("L'unité"; CodeUnite)
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

    trigger OnInitReport();
    begin
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(text06, USERID);

        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);

        mode := 1;
        année := DATE2DMY(TODAY, 3);
        mois := DATE2DMY(TODAY, 2);
        CodeUnite := PayrollManager."Company Business Unit Code";
    end;

    trigger OnPreReport();
    begin
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
    end;

    var
        CompanyInformation: Record 79;
        mode: Option " ",mois,trimestre;
        mois: Option " ","1","2","3","4","5","6","7","8","9","10","11","12";
        trimestre: Option " ","1","2","3","4";
        md: Integer;
        mf: Integer;
        "année": Integer;
        datd: Date;
        datf: Date;
        per: Text[30];
        Unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        InfoSociete: Record 79;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        PayrollManager: Record "Payroll Manager";
        text06: Text[30];
        Adresse: Text[100];
        CodeUnite: Code[10];
        Date_de_Naissance_CaptionLbl: Label '"Date de Naissance "';
        "Nom_et_PrénomCaptionLbl": Label 'Nom et Prénom';
        "N__Immatriculation_Sécurite_SocialeCaptionLbl": Label 'N° Immatriculation Sécurite Sociale';
        E_SCaptionLbl: Label 'E/S';
        "Date_Entrée_SortieCaptionLbl": Label 'Date Entrée/Sortie';
        ObservationsCaptionLbl: Label 'Observations';
        "Période__Mois_ou_Trimestre___CaptionLbl": Label 'Période (Mois ou Trimestre) :';
        N__SS_EmployeurCaptionLbl: Label 'N° SS Employeur';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        ECaptionLbl: Label 'E';
        SCaptionLbl: Label 'S';
        "Etabli_à__CaptionLbl": Label 'Etabli à :';
        Cachet_de_l_EmployeurCaptionLbl: Label 'Cachet de l''Employeur';
        Le__CaptionLbl: Label 'Le :';
}

