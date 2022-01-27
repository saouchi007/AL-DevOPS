/// <summary>
/// Report Bordereau des Cotisations (ID 52182443).
/// </summary>
report 52182443 "Bordereau des Cotisations"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Bordereau des Cotisations.rdl';

    dataset
    {
        dataitem(DataItem1240; TabBordereau)
        {
            DataItemTableView = SORTING(Matricule);
            column(CompanyInformation__Employer_SS_No__; CompanyInformation."Employer SS No.")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(Exer; Exer)
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
            column(TabBordereau__Num_SS_; "Num SS")
            {
            }
            column(TabBordereau_NomPrenom; NomPrenom)
            {
            }
            column(TabBordereau_J1; J1)
            {
            }
            column(TabBordereau_b1; b1)
            {
            }
            column(TabBordereau_r1; r1)
            {
            }
            column(TabBordereau_J2; J2)
            {
            }
            column(TabBordereau_b2; b2)
            {
            }
            column(TabBordereau_r2; r2)
            {
            }
            column(TabBordereau_J3; J3)
            {
            }
            column(TabBordereau_b3; b3)
            {
            }
            column(TabBordereau_r3; r3)
            {
            }
            column(TabBordereau_J4; J4)
            {
            }
            column(TabBordereau_b4; b4)
            {
            }
            column(TabBordereau_r4; r4)
            {
            }
            column(TabBordereau_J5; J5)
            {
            }
            column(TabBordereau_b5; b5)
            {
            }
            column(TabBordereau_r5; r5)
            {
            }
            column(TabBordereau_J6; J6)
            {
            }
            column(TabBordereau_b6; b6)
            {
            }
            column(TabBordereau_r6; r6)
            {
            }
            column(TabBordereau_J7; J7)
            {
            }
            column(TabBordereau_b7; b7)
            {
            }
            column(TabBordereau_r7; r7)
            {
            }
            column(TabBordereau_J8; J8)
            {
            }
            column(TabBordereau_b8; b8)
            {
            }
            column(TabBordereau_r8; r8)
            {
            }
            column(TabBordereau_J9; J9)
            {
            }
            column(TabBordereau_b9; b9)
            {
            }
            column(TabBordereau_r9; r9)
            {
            }
            column(TabBordereau_J10; J10)
            {
            }
            column(TabBordereau_b10; b10)
            {
            }
            column(TabBordereau_r10; r10)
            {
            }
            column(TabBordereau_J11; J11)
            {
            }
            column(TabBordereau_b11; b11)
            {
            }
            column(TabBordereau_r11; r11)
            {
            }
            column(TabBordereau_J12; J12)
            {
            }
            column(TabBordereau_b12; b12)
            {
            }
            column(TabBordereau_r12; r12)
            {
            }
            column(bs12; bs12)
            {
            }
            column(bs11; bs11)
            {
            }
            column(bs10; bs10)
            {
            }
            column(bs8; bs8)
            {
            }
            column(bs7; bs7)
            {
            }
            column(bs6; bs6)
            {
            }
            column(bs5; bs5)
            {
            }
            column(bs4; bs4)
            {
            }
            column(bs3; bs3)
            {
            }
            column(bs2; bs2)
            {
            }
            column(bs1; bs1)
            {
            }
            column(bs9; bs9)
            {
            }
            column(T12; T12)
            {
            }
            column(T11; T11)
            {
            }
            column(T10; T10)
            {
            }
            column(T9; T9)
            {
            }
            column(T8; T8)
            {
            }
            column(T7; T7)
            {
            }
            column(T6; T6)
            {
            }
            column(T5; T5)
            {
            }
            column(T4; T4)
            {
            }
            column(T3; T3)
            {
            }
            column(T2; T2)
            {
            }
            column(T1; T1)
            {
            }
            column(TabBordereau_NomPrenomCaption; FIELDCAPTION(NomPrenom))
            {
            }
            column(JanvierCaption; JanvierCaptionLbl)
            {
            }
            column("FévrierCaption"; FévrierCaptionLbl)
            {
            }
            column(MarsCaption; MarsCaptionLbl)
            {
            }
            column(AvrilCaption; AvrilCaptionLbl)
            {
            }
            column(MaiCaption; MaiCaptionLbl)
            {
            }
            column(JuinCaption; JuinCaptionLbl)
            {
            }
            column(juilletCaption; juilletCaptionLbl)
            {
            }
            column(AoutCaption; AoutCaptionLbl)
            {
            }
            column(SeptembreCaption; SeptembreCaptionLbl)
            {
            }
            column(OctobreCaption; OctobreCaptionLbl)
            {
            }
            column(NovembreCaption; NovembreCaptionLbl)
            {
            }
            column(DecembreCaption; DecembreCaptionLbl)
            {
            }
            column(N__Employeur__Caption; N__Employeur__CaptionLbl)
            {
            }
            column(Secteur_act__Caption; Secteur_act__CaptionLbl)
            {
            }
            column(Nom___Raison__Caption; Nom___Raison__CaptionLbl)
            {
            }
            column(Exercice__Caption; Exercice__CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Total_Bsae_SSCaption; Total_Bsae_SSCaptionLbl)
            {
            }
            column(Total_Ret_SSCaption; Total_Ret_SSCaptionLbl)
            {
            }
            column(TabBordereau_Matricule; Matricule)
            {
            }
            column(AfficherDetail; AfficherDetail)
            {
            }

            trigger OnAfterGetRecord();
            begin
                T1 := T1 + DataItem1240.r1;
                T2 := T2 + DataItem1240.r2;
                T3 := T3 + DataItem1240.r3;
                T4 := T4 + DataItem1240.r4;
                T5 := T5 + DataItem1240.r5;
                T6 := T6 + DataItem1240.r6;
                T7 := T7 + DataItem1240.r7;
                T8 := T8 + DataItem1240.r8;
                T9 := T9 + DataItem1240.r9;
                T10 := T10 + DataItem1240.r10;
                T11 := T11 + DataItem1240.r11;
                T12 := T12 + DataItem1240.r12;

                bs1 := bs1 + DataItem1240.b1;
                bs2 := bs2 + DataItem1240.b2;
                bs3 := bs3 + DataItem1240.b3;
                bs4 := bs4 + DataItem1240.b4;
                bs5 := bs5 + DataItem1240.b5;
                bs6 := bs6 + DataItem1240.b6;
                bs7 := bs7 + DataItem1240.b7;
                bs8 := bs8 + DataItem1240.b8;
                bs9 := bs9 + DataItem1240.b9;
                bs10 := bs10 + DataItem1240.b10;
                bs11 := bs11 + DataItem1240.b11;
                bs12 := bs12 + DataItem1240.b12;
            end;

            trigger OnPreDataItem();
            begin
                IF Exer <> 0 THEN BEGIN
                    CodBordereau.traitement(FORMAT(Exer), v);
                    IF v = FALSE THEN ERROR('aucune paie calculée durant lexercice %1', FORMAT(Exer));
                END
                ELSE
                    ERROR('veuillez introduire l exercice dans Options');

                CompanyInformation.GET;

                AfficherDetail := FALSE;
                IF Salarie.GET(DataItem1240.Matricule) THEN BEGIN
                    IF Salarie."Company Business Unit Code" = CodeUnite THEN
                        AfficherDetail := TRUE;
                END;
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
                    field(Exer; Exer)
                    {
                        Caption = 'Excercice';
                    }
                    field(CodeUnite; CodeUnite)
                    {
                        Caption = 'Unité';
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
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);

        Exer := DATE2DMY(TODAY, 3)
    end;

    var
        T1: Decimal;
        T2: Decimal;
        T3: Decimal;
        T4: Decimal;
        T5: Decimal;
        T6: Decimal;
        T7: Decimal;
        T8: Decimal;
        T9: Decimal;
        T10: Decimal;
        T11: Decimal;
        T12: Decimal;
        Exer: Integer;
        CodBordereau: Codeunit CodBordereau;
        bs1: Decimal;
        bs2: Decimal;
        bs3: Decimal;
        bs4: Decimal;
        bs5: Decimal;
        bs6: Decimal;
        bs7: Decimal;
        bs8: Decimal;
        bs9: Decimal;
        bs10: Decimal;
        bs11: Decimal;
        bs12: Decimal;
        CompanyInformation: Record 79;
        MoisDebut: Integer;
        MoisFin: Integer;
        v: Boolean;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        CodeUnite: Code[10];
        Salarie: Record 5200;
        AfficherDetail: Boolean;
        JanvierCaptionLbl: Label 'Janvier';
        "FévrierCaptionLbl": Label 'Février';
        MarsCaptionLbl: Label 'Mars';
        AvrilCaptionLbl: Label 'Avril';
        MaiCaptionLbl: Label 'Mai';
        JuinCaptionLbl: Label 'Juin';
        juilletCaptionLbl: Label 'juillet';
        AoutCaptionLbl: Label 'Aout';
        SeptembreCaptionLbl: Label 'Septembre';
        OctobreCaptionLbl: Label 'Octobre';
        NovembreCaptionLbl: Label 'Novembre';
        DecembreCaptionLbl: Label 'Decembre';
        N__Employeur__CaptionLbl: Label 'N° Employeur :';
        Secteur_act__CaptionLbl: Label 'Secteur act :';
        Nom___Raison__CaptionLbl: Label 'Nom / Raison :';
        Exercice__CaptionLbl: Label 'Exercice :';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Total_Bsae_SSCaptionLbl: Label 'Total Bsae SS';
        Total_Ret_SSCaptionLbl: Label 'Total Ret SS';
}

