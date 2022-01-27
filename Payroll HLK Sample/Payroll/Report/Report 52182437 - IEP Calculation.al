/// <summary>
/// Report IEP Calculation (ID 51416).
/// </summary>
report 52182437 "IEP Calculation"
{

    CaptionML = ENU = 'Leave Right Calculation',
                FRA = 'Calcul de l''IEP';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code", "Company Business Unit Code";
        }
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                CASE ModeMaJ OF
                    ModeMaJ::"Début d'année":
                        IF ("Company Business Unit Code" = CodeDirection)
                        OR ("Employment Date Init" < DateCalcul) THEN BEGIN
                            CalcIEP(IEP);
                            "Current IEP" := IEP;
                            MODIFY;
                        END;
                    ModeMaJ::"Anniversaire recrutement":
                        BEGIN
                            IF "Employment Date Init" <> 0D THEN
                                DateAnniversaire := DMY2DATE(DATE2DMY("Employment Date Init", 1),
                                DATE2DMY("Employment Date Init", 2), DATE2DMY(Paie."Ending Date", 3));
                            IF ("Company Business Unit Code" = CodeDirection)
                            AND (DateAnniversaire >= Paie."Starting Date")
                            AND (DateAnniversaire <= Paie."Ending Date")
                            //  AND("Termination Date"=0D)
                            AND ((NOT OptInclureInactifs) AND (Status = Status::Active) AND ("Employment Date Init" <> 0D))
                            OR ((OptInclureInactifs) AND ("Employment Date Init" <> 0D)) THEN BEGIN
                                CalcIEP(IEP);
                                "Current IEP" := IEP;
                                MODIFY;
                                //001MK *********************************************************************
                                IF NOT RubriqueSalarie.GET("No.", ParamPaie.IEP) THEN BEGIN
                                    IF DataItem7528."Section Grid Class" <> 'HG' THEN BEGIN
                                        RubriqueSalarie."Employee No." := "No.";
                                        RubriqueSalarie.VALIDATE("Item Code", '400');
                                        RubriqueSalarie.INSERT;
                                    END;
                                END;
                                //001MK *********************************************************************
                                IF RubriqueSalarie.GET("No.", ParamPaie.IEP) THEN BEGIN
                                    RubriqueSalarie.Rate := IEP + DataItem7528."Previous IEP";
                                    RubriqueSalarie.Amount := RubriqueSalarie.Rate * RubriqueSalarie.Basis / 100;
                                    RubriqueSalarie.MODIFY;
                                END;
                            END;
                        END;
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

        GestionnairePaie.RESET;
        GestionnairePaie.SETRANGE("User ID", USERID);
        IF NOT GestionnairePaie.FINDSET THEN
            ERROR(Text01, USERID);
        CodeDirection := GestionnairePaie."Company Business Unit Code";
        IF CodeDirection = '' THEN
            ERROR(Text02, USERID);
        ParamPaie.GET;
        ParamPaie.TESTFIELD(ParamPaie."Leave Nbre of Days by Month");
        Salarie2.RESET;
        Salarie2.SETRANGE("Company Business Unit Code", CodeDirection);
        Salarie2.SETRANGE(Status, Salarie2.Status::Active);
        IF NOT Salarie2.FIND('-') THEN
            ERROR(Text03, CodeDirection);
        IF Salarie2.FIND('-') THEN
            REPEAT
                Salarie2.TESTFIELD(Salarie2."Employment Date");
            UNTIL Salarie2.NEXT = 0;
        DateCalcul := 0D;
    end;

    trigger OnPostReport();
    begin
        MESSAGE(Text04, NbreSalaries);
    end;

    trigger OnPreReport();
    begin

        BaremeIEP.RESET;
        IF BaremeIEP.ISEMPTY THEN
            ERROR(Text05, BaremeIEP.TABLECAPTION);
        FenetreProcess.OPEN('Calcul de l''IEP du salarié #1#######');
        CASE ModeMaJ OF
            ModeMaJ::"Début d'année":
                BEGIN
                    IF (DATE2DMY(DateCalcul, 1) <> 1) OR (DATE2DMY(DateCalcul, 2) <> 1) THEN
                        ERROR(Text06);
                    DateCalcul := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                END;
            ModeMaJ::"Anniversaire recrutement":
                BEGIN
                    IF DataItem8955.GETFILTERS = '' THEN
                        ERROR(Text07);
                    Paie.COPYFILTERS(Payroll);
                    Paie.FINDFIRST;
                    CodePaie := Paie.Code;
                    DateCalcul := DMY2DATE(1, DATE2DMY(Paie."Ending Date", 2),
                    DATE2DMY(Paie."Ending Date", 3));
                END;
        END;
    end;

    var
        GestionnairePaie: Record "Payroll Manager";
        CodeDirection: Code[10];
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie';
        Text02: Label 'Code de direction manquant dans la table des gestionnaires de paie pour l''utilisateur %1';
        Text03: Label 'Aucun salarié n''est affecté à la direction %1';
        Salarie2: Record 5200;
        //Employee: Record 5200;
        Text04: Label 'Calcul et Mise à jour de l''IEP effectués avec succès pour %1 salariés.';
        FenetreProcess: Dialog;
        ParamPaie: Record Payroll_Setup;
        BaremeIEP: Record "IEP Grid";
        Payroll: Record Payroll;
        DateCalcul: Date;
        DateAnniversaire: Date;
        NbreMoisExperience: Integer;
        NbreAnneesExperience: Decimal;
        Salarie: Record 5200;
        IEP: Decimal;
        NbreAnnees: Decimal;
        Text05: Label 'La table %1 n''''est pas paramétrée !';
        i: Integer;
        ModeMaJ: Option "Anniversaire recrutement","Début d'année";
        Text06: Label 'Date doit être celle du début d''année';
        Text07: Label 'Code de la paie manquant !';
        Paie: Record Payroll;
        CodePaie: Code[20];
        NbreSalaries: Integer;
        OptInclureInactifs: Boolean;
        RubriqueSalarie: Record "Employee Payroll Item";


    procedure CalcIEP(var P_IEP: Decimal);
    begin
        NbreSalaries := NbreSalaries + 1;
        FenetreProcess.UPDATE(1, DataItem7528."No.");
        SLEEP(10);
        CASE ModeMaJ OF
            ModeMaJ::"Début d'année":
                BEGIN
                    NbreAnneesExperience := DATE2DMY(DateCalcul, 3) - DATE2DMY(DataItem7528."Employment Date Init", 3) - 1;
                    NbreMoisExperience := 12 - DATE2DMY(DataItem7528."Employment Date Init", 2);
                    IF DATE2DMY(DataItem7528."Employment Date Init", 1) < 15 THEN
                        NbreMoisExperience := NbreMoisExperience + 1;
                    NbreAnneesExperience := ROUND(NbreAnneesExperience + NbreMoisExperience / 12);
                END;
            ModeMaJ::"Anniversaire recrutement":
                BEGIN
                    NbreAnneesExperience := DATE2DMY(DateCalcul, 3) - DATE2DMY(DataItem7528."Employment Date Init", 3);
                    IF NbreAnneesExperience < 0 THEN
                        NbreAnneesExperience := 0;
                    NbreMoisExperience := 0;
                END;
        END;
        P_IEP := 0;
        BaremeIEP.FINDFIRST;
        REPEAT
            NbreAnnees := BaremeIEP."Ending Period" - BaremeIEP."Starting period" + 1;
            IF NbreAnneesExperience > NbreAnnees THEN BEGIN
                IF NbreAnneesExperience MOD (NbreAnneesExperience DIV 1) > 0 THEN
                    NbreAnnees := NbreAnnees - 1 + (NbreAnneesExperience MOD (NbreAnneesExperience DIV 1));
                P_IEP := P_IEP + NbreAnnees * BaremeIEP.Rate;
                NbreAnneesExperience := NbreAnneesExperience - NbreAnnees;
            END
            ELSE BEGIN
                P_IEP := P_IEP + NbreAnneesExperience * BaremeIEP.Rate;
                NbreAnneesExperience := 0;
            END;
            IF NbreAnneesExperience > 0 THEN
                IF BaremeIEP.NEXT = 0 THEN
                    ERROR(Text05, BaremeIEP.TABLECAPTION);
        UNTIL NbreAnneesExperience = 0;
    end;
}

