/// <summary>
/// Report Fiche fiscale (ID 52182439).
/// </summary>
report 52182439 "Fiche fiscale"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Fiche fiscale.rdl';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column("année"; année)
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Adresse; Adresse)
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Titre; Titre)
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
            column(Employee_Employee__Last_Name_; Employee."Last Name")
            {
            }
            column(Employee_Employee__First_Name_; Employee."First Name")
            {
            }
            column(Employee_Employee__Function_Description_; Employee."Job Title")
            {
            }
            column(Employee_Employee_Address; Employee.Address)
            {
            }
            column(Employee_Employee__Address_2_; Employee."Address 2")
            {
            }
            column(Employee__Birth_Date_; "Birth Date")
            {
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
            }
            column(Employee__Termination_Date_; "Termination Date")
            {
            }
            column(Employee__Payroll_Bank_Account_No__; "Payroll Bank Account No.")
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column("année_Control1000000001"; année)
            {
            }
            column("année_Control1000000003"; année)
            {
            }
            column("année_Control1000000005"; année)
            {
            }
            column("année_Control1000000007"; année)
            {
            }
            column("année_Control1000000009"; année)
            {
            }
            column("année_Control1000000011"; année)
            {
            }
            column("année_Control1000000013"; année)
            {
            }
            column("année_Control1000000015"; année)
            {
            }
            column("année_Control1000000017"; année)
            {
            }
            column("année_Control1000000032"; année)
            {
            }
            column("année_Control1000000033"; année)
            {
            }
            column("année_Control1000000075"; année)
            {
            }
            column(Employee_Employee__Structure_Description_; Employee."Structure Description")
            {
            }
            column(Employee_Employee__Section_Grid_Section_; Employee."Section Grid Section")
            {
            }
            column(Employee_Employee__Section_Grid_Level_; Employee."Section Grid Level")
            {
            }
            column(Employee_Employee__Social_Security_No__; Employee."Social Security No.")
            {
            }
            column(Employee_Employee__Marital_Status_; Employee."Marital Status")
            {
            }
            column(Rib_Key_; Employee."RIB Key")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FonctionCaption; FonctionCaptionLbl)
            {
            }
            column(Adresse_RueCaption; Adresse_RueCaptionLbl)
            {
            }
            column(Suite_AdresseCaption; Suite_AdresseCaptionLbl)
            {
            }
            column(AffectationCaption; AffectationCaptionLbl)
            {
            }
            column("Nom___PrénomCaption"; Nom___PrénomCaptionLbl)
            {
            }
            column("Né_e__le_Caption"; Né_e__le_CaptionLbl)
            {
            }
            column("EntréeCaption"; EntréeCaptionLbl)
            {
            }
            column(SortieCaption; SortieCaptionLbl)
            {
            }
            column(CH___ECHCaption; CH___ECHCaptionLbl)
            {
            }
            column(Situation_familleCaption; Situation_familleCaptionLbl)
            {
            }
            column("N__Sécurité_SocialeCaption"; N__Sécurité_SocialeCaptionLbl)
            {
            }
            column(N__de_CompteCaption; N__de_CompteCaptionLbl)
            {
            }
            column(MatriculeCaption; MatriculeCaptionLbl)
            {
            }
            column("Période_payéeCaption"; Période_payéeCaptionLbl)
            {
            }
            column(V02_Caption; V02_CaptionLbl)
            {
            }
            column(V01_Caption; V01_CaptionLbl)
            {
            }
            column(V03_Caption; V03_CaptionLbl)
            {
            }
            column(V04_Caption; V04_CaptionLbl)
            {
            }
            column(V05_Caption; V05_CaptionLbl)
            {
            }
            column(V06_Caption; V06_CaptionLbl)
            {
            }
            column(V07_Caption; V07_CaptionLbl)
            {
            }
            column(V08_Caption; V08_CaptionLbl)
            {
            }
            column(V09_Caption; V09_CaptionLbl)
            {
            }
            column(V10_Caption; V10_CaptionLbl)
            {
            }
            column(V11_Caption; V11_CaptionLbl)
            {
            }
            column(V12_Caption; V12_CaptionLbl)
            {
            }
            column(TOTAUXCaption; TOTAUXCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            dataitem(DataItem6639; Rubrique)
            {
                DataItemTableView = SORTING("No.");
                column(Rubrique_Description; Description)
                {
                }
                column(Rubrique_Rub1; Rub1)
                {
                }
                column(Rubrique_Rub2; Rub2)
                {
                }
                column(Rubrique_Rub3; Rub3)
                {
                }
                column(Rubrique_Rub4; Rub4)
                {
                }
                column(Rubrique_Rub5; Rub5)
                {
                }
                column(Rubrique_Rub6; Rub6)
                {
                }
                column(Rubrique_Rub7; Rub7)
                {
                }
                column(Rubrique_Rub8; Rub8)
                {
                }
                column(Rubrique_Rub9; Rub9)
                {
                }
                column(Rubrique_Rub10; Rub10)
                {
                }
                column(Rubrique_Rub11; Rub11)
                {
                }
                column(Rubrique_Rub12; Rub12)
                {
                }
                column(Rubrique_Rubrique_total; DataItem6639.total)
                {
                }
                column(Rubrique_No_; "No.")
                {
                }
                column(cond1; cond1)
                {
                }
                column(cond2; cond2)
                {
                }
                column(cond3; cond3)
                {
                }
                column(cond4; cond4)
                {
                }
                column(cond5; cond5)
                {
                }
                column(cond6; cond6)
                {
                }
                column(cond7; cond7)
                {
                }
                column(cond8; cond8)
                {
                }
                column(cond9; cond9)
                {
                }
                column(cond10; cond10)
                {
                }
                column(cond11; cond11)
                {
                }
                column(cond12; cond12)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    cond1 := (DataItem6639.Rub1 <> '') AND (DataItem6639.Rub1 <> '0') AND (DataItem6639.Rub1 <> '0,00');
                    cond2 := (DataItem6639.Rub2 <> '') AND (DataItem6639.Rub2 <> '0') AND (DataItem6639.Rub2 <> '0,00');
                    cond3 := (DataItem6639.Rub3 <> '') AND (DataItem6639.Rub3 <> '0') AND (DataItem6639.Rub3 <> '0,00');
                    cond4 := (DataItem6639.Rub4 <> '') AND (DataItem6639.Rub4 <> '0') AND (DataItem6639.Rub4 <> '0,00');
                    cond5 := (DataItem6639.Rub5 <> '') AND (DataItem6639.Rub5 <> '0') AND (DataItem6639.Rub5 <> '0,00');
                    cond6 := (DataItem6639.Rub6 <> '') AND (DataItem6639.Rub6 <> '0') AND (DataItem6639.Rub6 <> '0,00');
                    cond7 := (DataItem6639.Rub7 <> '') AND (DataItem6639.Rub7 <> '0') AND (DataItem6639.Rub7 <> '0,00');
                    cond8 := (DataItem6639.Rub8 <> '') AND (DataItem6639.Rub8 <> '0') AND (DataItem6639.Rub8 <> '0,00');
                    cond9 := (DataItem6639.Rub9 <> '') AND (DataItem6639.Rub9 <> '0') AND (DataItem6639.Rub9 <> '0,00');
                    cond10 := (DataItem6639.Rub10 <> '') AND (DataItem6639.Rub10 <> '0') AND (DataItem6639.Rub10 <> '0,00');
                    cond11 := (DataItem6639.Rub11 <> '') AND (DataItem6639.Rub11 <> '0') AND (DataItem6639.Rub11 <> '0,00');
                    cond12 := (DataItem6639.Rub12 <> '') AND (DataItem6639.Rub12 <> '0') AND (DataItem6639.Rub12 <> '0,00');
                end;

                trigger OnPostDataItem();
                begin
                    CurrReport.NEWPAGE;
                end;

                trigger OnPreDataItem();
                begin

                    //cond1:=(DataItem6639.Rub1<>'')AND(DataItem6639.Rub1<>'0')AND(DataItem6639.Rub1<>'0,00');
                    //cond2:=(DataItem6639.Rub2<>'')AND(DataItem6639.Rub2<>'0')AND(DataItem6639.Rub2<>'0,00');
                    //cond3:=(DataItem6639.Rub3<>'')AND(DataItem6639.Rub3<>'0')AND(DataItem6639.Rub3<>'0,00');
                    //cond4:=(DataItem6639.Rub4<>'')AND(DataItem6639.Rub4<>'0')AND(DataItem6639.Rub4<>'0,00');
                    //cond5:=(DataItem6639.Rub5<>'')AND(DataItem6639.Rub5<>'0')AND(DataItem6639.Rub5<>'0,00');
                    //cond6:=(DataItem6639.Rub6<>'')AND(DataItem6639.Rub6<>'0')AND(DataItem6639.Rub6<>'0,00');
                    //cond7:=(DataItem6639.Rub7<>'')AND(DataItem6639.Rub7<>'0')AND(DataItem6639.Rub7<>'0,00');
                    //cond8:=(DataItem6639.Rub8<>'')AND(DataItem6639.Rub8<>'0')AND(DataItem6639.Rub8<>'0,00');
                    //cond9:=(DataItem6639.Rub9<>'')AND(DataItem6639.Rub9<>'0')AND(DataItem6639.Rub9<>'0,00');
                    //cond10:=(DataItem6639.Rub10<>'')AND(DataItem6639.Rub10<>'0')AND(DataItem6639.Rub10<>'0,00');
                    //cond11:=(DataItem6639.Rub11<>'')AND(DataItem6639.Rub11<>'0')AND(DataItem6639.Rub11<>'0,00');
                    //cond12:=(DataItem6639.Rub12<>'')AND(DataItem6639.Rub12<>'0')AND(DataItem6639.Rub12<>'0,00');
                end;
            }

            trigger OnAfterGetRecord();
            begin

                IF Employee.GETFILTERS <> '' THEN
                    ficheFiscale.RepTabSalarié(Employee."No.")
                ELSE
                    ERROR('veuillez selectionner un salarié dans l onglet salarié');
            end;

            trigger OnPreDataItem();
            begin

                IF (Md = 0) OR (Mf = 0) OR (année = 0) THEN ERROR('Veuillez introduire Mois début, moid fin et année dans l onglet option');
                IF (Md < 1) OR (Md > 12) THEN ERROR('Mois début inccorecte');
                IF (Mf < 1) OR (Mf > 12) THEN ERROR('Mois fin inccorecte');
                IF (année < 1900) OR (année > 2100) THEN ERROR('Année inccorecte');
                IF Md > Mf THEN ERROR('Mois début superieur à mois fin');
                //MESSAGE('%1 & %2 &%3 & %4',année,Md,année,Mf);
                ficheFiscale.RemplirTable(année, Md, année, Mf);


                CompanyInformation.GET;
                Adresse := Unite.Address + ' ' + Unite."Address 2";
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
                    field(année; année)
                    {
                        Caption = 'période :';
                    }
                    field(Md; Md)
                    {
                        Caption = 'Du mois de :';
                    }
                    field(Mf; Mf)
                    {
                        Caption = 'au mois de :';
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

        année := DATE2DMY(TODAY, 3);
        Md := 1;
        Mf := 12;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        CompanyInformation.CALCFIELDS("Right Logo");
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
    end;

    var
        ficheFiscale: Codeunit "Fiche fiscale";
        cond1: Boolean;
        cond2: Boolean;
        cond3: Boolean;
        cond4: Boolean;
        cond5: Boolean;
        cond6: Boolean;
        cond7: Boolean;
        cond8: Boolean;
        cond9: Boolean;
        cond10: Boolean;
        cond11: Boolean;
        cond12: Boolean;
        "année": Integer;
        Md: Integer;
        Mf: Integer;
        CompanyInformation: Record 79;
        ParamUtilisateur: Record 91;
        Unite: Record "Company Business Unit";
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        PayrollManager: Record "Payroll Manager";
        text06: Text[30];
        Adresse: Text[100];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FonctionCaptionLbl: Label 'Fonction';
        Adresse_RueCaptionLbl: Label 'Adresse Rue';
        Suite_AdresseCaptionLbl: Label 'Suite Adresse';
        AffectationCaptionLbl: Label 'Affectation';
        "Nom___PrénomCaptionLbl": Label 'Nom - Prénom';
        "Né_e__le_CaptionLbl": Label '"Né(e) le "';
        "EntréeCaptionLbl": Label 'Entrée';
        SortieCaptionLbl: Label 'Sortie';
        CH___ECHCaptionLbl: Label 'CH / ECH';
        Situation_familleCaptionLbl: Label 'Situation famille';
        "N__Sécurité_SocialeCaptionLbl": Label 'N° Sécurité Sociale';
        N__de_CompteCaptionLbl: Label 'N° de Compte';
        MatriculeCaptionLbl: Label 'Matricule';
        "Période_payéeCaptionLbl": Label 'Période payée';
        V02_CaptionLbl: Label '02/';
        V01_CaptionLbl: Label '01/';
        V03_CaptionLbl: Label '03/';
        V04_CaptionLbl: Label '04/';
        V05_CaptionLbl: Label '05/';
        V06_CaptionLbl: Label '06/';
        V07_CaptionLbl: Label '07/';
        V08_CaptionLbl: Label '08/';
        V09_CaptionLbl: Label '09/';
        V10_CaptionLbl: Label '10/';
        V11_CaptionLbl: Label '11/';
        V12_CaptionLbl: Label '12/';
        TOTAUXCaptionLbl: Label 'TOTAUX';
        EmptyStringCaptionLbl: Label '/';

}

