/// <summary>
/// Report Titre de congé (ID 52182455).
/// </summary>
report 52182455 "Titre de congé"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Titre de congé.rdl';

    dataset
    {
        dataitem(DataItem8820; "Employee Leave")
        {
            column(NumRef; NumRef)
            {
            }
            column(Employee__Last_Name_; Employee."Last Name")
            {
            }
            column(Employee__Function_Description_; Employee."Job Title")
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(TODAY; TODAY)
            {
            }
            column(Employee__No__; Employee."No.")
            {
            }
            column(StDate; StDate)
            {
            }
            column(ReDate; ReDate)
            {
            }
            column(Motif; Motif)
            {
            }
            column(Employee__First_Name_; Employee."First Name")
            {
            }
            column(Qty; Qty)
            {
            }
            column(Droit_Conso; Droit - Conso)
            {
            }
            column(Conso_Qty; Conso - Qty)
            {
            }
            column(DIRECTION_DES_RESSOURCES_HUMAINESCaption; DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl)
            {
            }
            column(SERVICE_DU_PERSONNELCaption; SERVICE_DU_PERSONNELCaptionLbl)
            {
            }
            column(SARL_LAITERIE_SOUMMAMCaption; SARL_LAITERIE_SOUMMAMCaptionLbl)
            {
            }
            column("Fait_à_Caption"; Fait_à_CaptionLbl)
            {
            }
            column(le___Caption; le___CaptionLbl)
            {
            }
            column(Matricule__Caption; Matricule__CaptionLbl)
            {
            }
            column(Fonction__Caption; Fonction__CaptionLbl)
            {
            }
            column("Date_de_départ__Caption"; Date_de_départ__CaptionLbl)
            {
            }
            column(Date_de_retour__Caption; Date_de_retour__CaptionLbl)
            {
            }
            column(Le_DRHCaption; Le_DRHCaptionLbl)
            {
            }
            column(Beneficie_d_un__Caption; Beneficie_d_un__CaptionLbl)
            {
            }
            column(TITRE_DE_CONGECaption; TITRE_DE_CONGECaptionLbl)
            {
            }
            column(Nom__Caption; Nom__CaptionLbl)
            {
            }
            column("Prénom__Caption"; Prénom__CaptionLbl)
            {
            }
            column(Prend__Caption; Prend__CaptionLbl)
            {
            }
            column(jours_Caption; jours_CaptionLbl)
            {
            }
            column(Reliquat__Caption; Reliquat__CaptionLbl)
            {
            }
            column(jours_Caption_Control1000000030; jours_Caption_Control1000000030Lbl)
            {
            }
            column(jours_Caption_Control1000000010; jours_Caption_Control1000000010Lbl)
            {
            }
            column("A_déjà_pris__Caption"; A_déjà_pris__CaptionLbl)
            {
            }
            column(Employee_Leave_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Unite.FINDFIRST;
                Employee.GET("Employee No.");
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


                Nom := Employee."Last Name" + ' ' + Employee."First Name";

                //conge.SETRANGE("Employee No.",Employee."No.");
                //IF conge.FINDFIRST THEN
                BEGIN
                    Qty := Quantity;
                    Droit := "Leave Right";
                    CALCFIELDS("No. of Consumed Days");
                    Conso := "No. of Consumed Days";
                    StDate := "Starting Date";
                    EnDate := "Ending Date";
                    ReDate := "Recovery Date";
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        //accesspay.accesstopay;
    end;

    trigger OnPreReport();
    begin
        Infosociete.GET;
        Infosociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
        Infosociete.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record 79;
        Infosociete: Record 79;
        Unite: Record "Company Business Unit";
        Sexe: Code[10];
        Nom: Text[30];
        Fonction: Text[50];
        Affect: Text[50];
        EmployeeAssig: Record "Employee Assignment";
        Texte1: Text[120];
        parampaye: Record Payroll_Setup;
        Texte2: Text[80];
        Texte3: Text[120];
        Texte4: Text[30];
        Texte5: Text[50];
        Date: Date;
        ParamUtilisateur: Record 91;
        conge: Record "Employee Leave";
        Qty: Decimal;
        StDate: Date;
        EnDate: Date;
        ReDate: Date;
        Motif: Text[100];
        NumRef: Text[30];
        NomEntreprise: Text[30];
        Employee: Record 5200;
        Reste: Decimal;
        Droit: Decimal;
        Conso: Decimal;
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        SARL_LAITERIE_SOUMMAMCaptionLbl: Label 'SARL LAITERIE SOUMMAM';
        "Fait_à_CaptionLbl": Label 'Fait à ';
        le___CaptionLbl: Label 'le : ';
        Matricule__CaptionLbl: Label 'Matricule :';
        Fonction__CaptionLbl: Label 'Fonction :';
        "Date_de_départ__CaptionLbl": Label 'Date de départ :';
        Date_de_retour__CaptionLbl: Label 'Date de retour :';
        Le_DRHCaptionLbl: Label 'Le DRH';
        Beneficie_d_un__CaptionLbl: Label 'Beneficie d''un  ';
        TITRE_DE_CONGECaptionLbl: Label 'TITRE DE CONGE';
        Nom__CaptionLbl: Label 'Nom :';
        "Prénom__CaptionLbl": Label 'Prénom :';
        Prend__CaptionLbl: Label 'Prend :';
        jours_CaptionLbl: Label 'jours.';
        Reliquat__CaptionLbl: Label 'Reliquat :';
        jours_Caption_Control1000000030Lbl: Label 'jours.';
        jours_Caption_Control1000000010Lbl: Label 'jours.';
        "A_déjà_pris__CaptionLbl": Label 'A déjà pris :';

}

