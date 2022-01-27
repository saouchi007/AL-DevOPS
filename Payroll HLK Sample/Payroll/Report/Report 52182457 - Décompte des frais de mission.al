/// <summary>
/// Report Décompte des frais de mission (ID 51448).
/// </summary>
report 52182457 "Décompte des frais de mission"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Décompte des frais de mission.rdl';

    dataset
    {
        dataitem(DataItem1000000009; 79)
        {
            column(Periode; Periode)
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(CompanyInformation_Picture; "Company Information".Picture)
            {
            }
        }
        dataitem(DataItem6551; "Professional Expances")
        {
            DataItemTableView = SORTING("Entry No.");
            column(Professional_Expances_Destination; Destination)
            {
            }
            column(Professional_Expances_Date; Date)
            {
            }
            column(Professional_Expances_Amount; Amount)
            {
            }
            column(Professional_Expances__Employee_No__; "Employee No.")
            {
            }
            column(Professional_Expances__First_Name_; "First Name")
            {
            }
            column(Professional_Expances__Last_Name_; "Last Name")
            {
            }
            column(Professional_Expances__Professional_Expances__Contribution; "Professional Expances".Contribution)
            {
            }
            column(TotalMontant; TotalMontant)
            {
            }
            column("Décompte_des_frais_de_missionCaption"; Décompte_des_frais_de_missionCaptionLbl)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column("DéstinationCaption"; DéstinationCaptionLbl)
            {
            }
            column(NomCaption; NomCaptionLbl)
            {
            }
            column("PrénomCaption"; PrénomCaptionLbl)
            {
            }
            column(MontantCaption; MontantCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Professional_Expances_Entry_No_; "Entry No.")
            {
            }
            column(GestionnairePaie_Company_Business_Unit_Code; GestionnairePaie."Company Business Unit Code")
            {
            }
            column(ProfessionalExpances_Company_Business_Unit_Code; "Professional Expances"."Company Business Unit Code")
            {
            }
            column(DebutPeriode; DebutPeriode)
            {
            }
            column(FinPeriode; FinPeriode)
            {
            }

            trigger OnAfterGetRecord();
            begin


                IF (Date >= DebutPeriode) AND (Date <= FinPeriode) AND ("Company Business Unit Code" = GestionnairePaie."Company Business Unit Code") THEN BEGIN

                    TotalMontant := TotalMontant + Amount;
                END
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
                    field(DebutPeriode; DebutPeriode)
                    {
                        Caption = 'Date Début';
                    }
                    field(FinPeriode; FinPeriode)
                    {
                        Caption = 'Date Fin';
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

        "Company Information".CALCFIELDS(Picture);
        //InfoSociete.CALCFIELDS(InfoSociete."Right Logo");

        GestionnairePaie.GET(USERID);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
    end;

    trigger OnPreReport();
    begin
        IF DebutPeriode = 0D THEN
            ERROR(Text01);
        IF FinPeriode = 0D THEN
            ERROR(Text02);
        Periode := 'DU ' + FORMAT(DebutPeriode) + ' AU ' + FORMAT(FinPeriode);
    end;

    var
        InfoSociete: Record 79;
        "Professional Expances": Record "Professional Expances";
        "Company Information": Record 79;
        Periode: Text[30];
        DebutPeriode: Date;
        FinPeriode: Date;
        Text01: Label 'Date de début période manquante !';
        Text02: Label 'Date de fin période manquante !';
        ParamUtilisateur: Record 91;
        Unite: Record "Company Business Unit";
        TotalMontant: Decimal;
        GestionnairePaie: Record "Payroll Manager";
        "Décompte_des_frais_de_missionCaptionLbl": Label 'Décompte des frais de mission';
        N_CaptionLbl: Label 'N°';
        DateCaptionLbl: Label 'Date';
        "DéstinationCaptionLbl": Label 'Déstination';
        NomCaptionLbl: Label 'Nom';
        "PrénomCaptionLbl": Label 'Prénom';
        MontantCaptionLbl: Label 'Montant';
        TypeCaptionLbl: Label 'Type';
        TotalCaptionLbl: Label 'Total';

}

