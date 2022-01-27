/// <summary>
/// Report Payroll Calculation (ID 52182460).
/// </summary>
report 52182460 "Payroll Calculation"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Calculation',
                FRA = 'Calcul de la paie';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                IF ("Company Business Unit Code" <> CodeUnite) OR (Status = Status::Inactive) THEN
                    CurrReport.SKIP;
                NumSalarie := NumSalarie + 1;
                Progression.UPDATE(1, Employee."No.");
                IF NumSalarie MOD 10 = 0 THEN
                    Progression.UPDATE(2, ROUND(NumSalarie * 100 / NbreSalaries));
                GestionPaie.ControlerParametres("No.");
                GestionPaie.CalcPaieSalarie("No.");
            end;

            trigger OnPostDataItem();
            begin
                Progression.CLOSE;
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
            ERROR(Text04, USERID);
        UniteSociete.GET(GestionnairePaie."Company Business Unit Code");
        CodeUnite := UniteSociete.Code;
        Salarie.RESET;
        Salarie.SETRANGE("Company Business Unit Code", CodeUnite);
        Salarie.SETRANGE(Status, Salarie.Status::Active);
        NbreSalaries := Salarie.COUNT;
        NumSalarie := 0;
    end;

    trigger OnPostReport();
    begin
        MESSAGE(Text03, UniteSociete."Current Payroll", NbreSalaries);
    end;

    trigger OnPreReport();
    begin
        IF NOT CONFIRM(STRSUBSTNO('%1 %2 ?', Text02, UniteSociete."Current Payroll"), FALSE) THEN
            EXIT;
        Progression.OPEN('Traitement de la paie du salarié #1#######\Progression                      #2### %');
    end;

    var
        GestionPaie: Codeunit "Payroll Managemen ExtHLK";
        Text01: Label 'Code de la paie manquant !';
        Text02: Label 'Calculer la paie';
        Text03: Label 'Calcul de la paie %1 effectué avec succès.\Traitement pour %2 salariés.';
        Text06: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text04: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text07: Label 'Aucun salarié n''est affecté à la direction %1 !';
        Text05: Label 'L''utilisateur %1 n''est pas autorisé à calculer la paie %2 !';
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        Text09: Label '%1 %2 est clôturé(e) !';
        GestionnairePaie: Record "Payroll Manager";
        Paie2: Record Payroll;
        CodePaie: Code[20];
        NbreSalaries: Integer;
        NumSalarie: Integer;
        UniteSociete: Record "Company Business Unit";
        Progression: Dialog;
        Salarie: Record 5200;
        Employee: Record 5200;
        CodeUnite: Code[10];

}

