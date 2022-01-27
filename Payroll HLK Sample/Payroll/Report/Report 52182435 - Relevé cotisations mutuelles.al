/// <summary>
/// Report Relevé cotisations mutuelles (ID 52182435).
/// </summary>
report 52182435 "Relevé cotisations mutuelles"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Relevé cotisations mutuelles.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";

            trigger OnPostDataItem();
            begin
                IF DataItem8955.GETFILTERS = '' THEN
                    ERROR(Text01, 'Code paie');
            end;

            trigger OnPreDataItem();
            begin
                InfoSociete.GET;
                InfoSociete.CALCFIELDS(Picture);
            end;
        }
        dataitem(DataItem6949; 5209)
        {
            DataItemTableView = SORTING(Code);
            PrintOnlyIfDetail = true;
            column(Union_Insurance__Union_Insurance__Name; DataItem6949.Name)
            {
            }
            column(Date; Date)
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
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Unite__Address_2_; Unite."Address 2")
            {
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Cotisation_MutuelleCaption; Cotisation_MutuelleCaptionLbl)
            {
            }
            column(Relative_au_mois_de_Caption; Relative_au_mois_de_CaptionLbl)
            {
            }
            column(Agents_RelevantCaption; Agents_RelevantCaptionLbl)
            {
            }
            column(De_____________________________________________________________Caption; De_____________________________________________________________CaptionLbl)
            {
            }
            column(Chapitre__________________________________________________Caption; Chapitre__________________________________________________CaptionLbl)
            {
            }
            column(Section______________________________________________________Caption; Section______________________________________________________CaptionLbl)
            {
            }
            column(ObservationCaption; ObservationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(N__SS_EmployeurCaption; N__SS_EmployeurCaptionLbl)
            {
            }
            column(Union_Insurance_Code; Code)
            {
            }
            dataitem(DataItem4144; "Payroll Archive Header")
            {
                DataItemLink = "Union Code" = FIELD(Code);
                DataItemTableView = SORTING("Union Code");
                PrintOnlyIfDetail = false;
                column(Payroll_Archive_Header__Union_Membership_No__; "Union Membership No.")
                {
                }
                column(Payroll_Archive_Header__Last_Name_; "Last Name")
                {
                }
                column(Payroll_Archive_Header__First_Name_; "First Name")
                {
                }
                column(Payroll_Archive_Header__No__; "No.")
                {
                }
                column(Numero; Numero)
                {
                }
                column(Montant; -Montant)
                {
                }
                column(TotalMutuelle; TotalMutuelle)
                {
                }
                column(DescriptionLine_1_; DescriptionLine[1])
                {
                }
                column(DescriptionLine_2_; DescriptionLine[2])
                {
                }
                column(MontantCaption; MontantCaptionLbl)
                {
                }
                column("N__AdhérentCaption"; N__AdhérentCaptionLbl)
                {
                }
                column("PrénomCaption"; PrénomCaptionLbl)
                {
                }
                column(NomCaption; NomCaptionLbl)
                {
                }
                column(MatriculeCaption; MatriculeCaptionLbl)
                {
                }
                column(N_Caption; N_CaptionLbl)
                {
                }
                column(Total_cotisations__Caption; Total_cotisations__CaptionLbl)
                {
                }
                column("Arrêter_le_présent_relevé_à_la_somme_de__Caption"; Arrêter_le_présent_relevé_à_la_somme_de__CaptionLbl)
                {
                }
                column(Payroll_Archive_Header_Payroll_Code; "Payroll Code")
                {
                }
                column(Payroll_Archive_Header_Union_Code; "Union Code")
                {
                }
                column(PayrollMembershipNo; DataItem4144."Union Membership No.")
                {
                }
                column(FirstName; DataItem4144."First Name")
                {
                }
                column(LastName; DataItem4144."Last Name")
                {
                }
                column(No; DataItem4144."No.")
                {
                }
                column("NbreAdhérents"; NbreAdherents)
                {
                }
                column(CodePaie; CodePaie)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF ("Union Code" <> DataItem6949.Code) OR ("Payroll Code" <> CodePaie) THEN
                        EXIT;
                    Montant := 0;
                    IF ArchivePaieLigne.GET(DataItem4144."No.", DataItem4144."Payroll Code",
                    ParamPaie."Union Subscription Deduction") THEN BEGIN
                        Numero := Numero + 1;
                        Montant := ArchivePaieLigne.Amount;
                        TotalMutuelle := TotalMutuelle - Montant;
                    END;
                    //***** <Code Section 2> *******//
                    Numero := 0;
                    //***** </Code Section 2> *******//

                    //***** <Code Section 4> *******//
                    /// --- 000

                    /*PayrollArchiveHeader.RESET ;
                    PayrollArchiveHeader.SETFILTER(PayrollArchiveHeader."No.",DataItem4144."No.");
                    
                    IF PayrollArchiveHeader.FIND('-') THEN
                      REPEAT
                      BEGIN
                      TotalOrder += PayrollArchiveHeader."Amount Including VAT";
                          END;
                      UNTIL (PayrollArchiveHeader.NEXT = 0) ;*/

                    CLEAR(DescriptionLine);
                    CheckReport.InitTextVariable;
                    CheckReport.FormatNoTextFR(DescriptionLine, TotalMutuelle, '');
                    //***** </Code Section 4> *******//

                end;
            }

            trigger OnAfterGetRecord();
            begin
                NbreAdherents := 0;
                DataItem4144.RESET;
                DataItem4144.SETRANGE("Payroll Code", CodePaie);
                DataItem4144.SETRANGE("Union Code", DataItem6949.Code);
                NbreAdherents := DataItem4144.COUNT;
                TotalMutuelle := 0;
                //Numero:=0;
                //message('%1 et %2 : %3',"Union/Insurance".Code,NbreAdherents,
                //DataItem4144.getfilters);

                //********** <Code Section 1 (Header>*****************//
                Date := FORMAT(DataItem8955."Ending Date", 0, 4);
                Date := COPYSTR(Date, 4, STRLEN(Date) - 3);
                //********** </Code Section 1 (Header>*****************//
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
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text02, USERID);
        Unite.GET(GestionnairePaie."Company Business Unit Code");
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
        ParamPaie.GET;
    end;

    trigger OnPreReport();
    begin
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        InfoSociete.CALCFIELDS("Right Logo");
        IF DataItem8955.GETFILTERS = '' THEN
            ERROR(Text01, 'Code paie');
        Paie.COPYFILTERS(DataItem8955);
        Paie.FINDFIRST;
        CodePaie := Paie.Code;
    end;

    var
        Salarie: Record "Payroll Archive Header";
        Montant: Decimal;
        ParamPaie: Record Payroll_Setup;
        TotalMutuelle: Decimal;
        DescriptionLine: array[2] of Text[80];
        Numero: Integer;
        ToolsLibrary: Codeunit "Tools Library";
        CheckReport: Report 1401;
        InfoSociete: Record 79;
        BusinessUnitDescription: Text[50];
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        Unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        Date: Text[30];
        Text01: Label 'Information manquante ! %1';
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie';
        GestionnairePaie: Record "Payroll Manager";
        ArchivePaieLigne: Record "Payroll Archive Line";
        NbreAdherents: Integer;
        Paie: Record Payroll;
        CodePaie: Code[20];
        Cotisation_MutuelleCaptionLbl: Label 'Cotisation Mutuelle';
        Relative_au_mois_de_CaptionLbl: Label '"Relative au mois de "';
        Agents_RelevantCaptionLbl: Label 'Agents Relevant';
        De_____________________________________________________________CaptionLbl: Label '"De . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . "';
        Chapitre__________________________________________________CaptionLbl: Label 'Chapitre . . . . . . . . . . . . . . . . . . . . . . . . .';
        Section______________________________________________________CaptionLbl: Label '"Section . . . . . . . . . . . . . . . . . . . . . . . . . .  "';
        ObservationCaptionLbl: Label 'Observation';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        N__SS_EmployeurCaptionLbl: Label 'N° SS Employeur';
        MontantCaptionLbl: Label 'Montant';
        "N__AdhérentCaptionLbl": Label 'N° Adhérent';
        "PrénomCaptionLbl": Label 'Prénom';
        NomCaptionLbl: Label 'Nom';
        MatriculeCaptionLbl: Label 'Matricule';
        N_CaptionLbl: Label 'N°';
        Total_cotisations__CaptionLbl: Label 'Total cotisations :';
        "Arrêter_le_présent_relevé_à_la_somme_de__CaptionLbl": Label 'Arrêter le présent relevé à la somme de :';
        PayrollArchiveHeader: Record "Payroll Archive Header";
        TotalOrder: Decimal;
}

