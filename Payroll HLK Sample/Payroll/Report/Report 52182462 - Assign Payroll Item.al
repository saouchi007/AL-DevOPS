/// <summary>
/// Report Assign Payroll Item (ID 5152182462492).
/// </summary>
report 52182462 "Assign Payroll Item"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Attribuer une rubrique de paie';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem9911; "Payroll Item")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
        }
        dataitem(DataItem4380; Structure)
        {
            RequestFilterFields = "Code";
            dataitem(DataItem7528; 5200)
            {
                DataItemLink = "Structure Code" = FIELD(Code);
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Function Code", "Statistics Group Code";

                trigger OnAfterGetRecord();
                begin
                    IF (Employee."Company Business Unit Code" = CodeUnite)
                    AND (Employee.Status = Employee.Status::Active) THEN BEGIN
                        IF RubriqueSalarie.GET(Employee."No.", Rubrique2.Code) THEN
                            RubriqueSalarie.DELETE;
                        RubriqueSalarie2.INIT;
                        RubriqueSalarie2."Employee No." := Employee."No.";
                        RubriqueSalarie2."Item Code" := Rubrique2.Code;
                        RubriqueSalarie2."Item Description" := Rubrique2.Description;
                        RubriqueSalarie2.Type := Rubrique2."Item Type";
                        RubriqueSalarie2."Submitted To Leave" := Rubrique2."Submitted To Leave";
                        RubriqueSalarie2."TIT Out of Grid" := Rubrique2."TIT Out of Grid";
                        RubriqueSalarie2.Taxable := Rubrique2.Taxable;
                        RubriqueSalarie2.Regularization := Rubrique2.Regularization;
                        CASE Rubrique2."Item Type" OF
                            Rubrique2."Item Type"::"Libre saisie":
                                BEGIN
                                    RubriqueSalarie2.Basis := MontantBase;
                                    IF (CoeffEnfants) AND (Employee."No. of Children" > 0) THEN BEGIN
                                        RubriqueSalarie2.Number := Nombre * Employee."No. of Children";
                                        RubriqueSalarie2.Amount := Nombre * MontantBase * Employee."No. of Children";
                                    END
                                    ELSE BEGIN
                                        RubriqueSalarie2.Number := Nombre;
                                        RubriqueSalarie2.Amount := Nombre * MontantBase;
                                    END;
                                END;
                            Rubrique2."Item Type"::Pourcentage:
                                RubriqueSalarie2.Rate := Taux;
                            Rubrique2."Item Type"::"Au prorata":
                                RubriqueSalarie2.Rate := Taux;
                        END;
                        IF (CoeffEnfants) AND (Employee."No. of Children" > 0) OR (NOT CoeffEnfants) THEN BEGIN
                            RubriqueSalarie2.INSERT;
                            NbreSalaries := NbreSalaries + 1;
                        END;
                    END;
                end;
            }
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
                    field(Nombre; Nombre)
                    {
                        Caption = 'Nombre';
                    }
                    field(MontantBase; MontantBase)
                    {
                        Caption = 'Montant de base';
                    }
                    field(Taux; Taux)
                    {
                        Caption = 'Taux';
                    }
                    field(CoeffEnfants; CoeffEnfants)
                    {
                        Caption = 'AF/Scolrité';
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
        GestionnairePaie.RESET;
        GestionnairePaie.SETRANGE("User ID", USERID);
        IF NOT GestionnairePaie.FINDSET THEN
            ERROR(Text03, USERID);
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        Nombre := 1;
    end;

    trigger OnPostReport();
    begin
        MESSAGE(Text07, Rubrique2.Code, NbreSalaries);
    end;

    trigger OnPreReport();
    begin
        IF "Payroll Item".GETFILTERS = '' THEN
            ERROR(Text05, 'Rubrique de paie');
        Rubrique2.COPYFILTERS("Payroll Item");
        IF Rubrique2.COUNT > 1 THEN
            ERROR(Text06);
        Rubrique2.FINDFIRST;
        CASE Rubrique2."Item Type" OF
            Rubrique2."Item Type"::"Libre saisie":
                BEGIN
                    IF Nombre = 0 THEN
                        ERROR(Text05, 'Nombre');
                    IF MontantBase = 0 THEN
                        ERROR(Text05, 'Montant de la base');
                END;
            Rubrique2."Item Type"::Pourcentage:
                BEGIN
                    Rubrique2.TESTFIELD("Basis of Calculation");
                    IF (Rubrique2."Calculation Rate" = 0) AND (Taux = 0) THEN
                        ERROR(Text05, 'Taux');
                END;
            Rubrique2."Item Type"::Formule:
                ERROR(Text08, 'Formule');
        END;
        Structure2.COPYFILTERS(Structure);
        NbreSalaries := 0;
    end;

    var


        Employee: Record 5200;
        "Payroll Item": Record "Payroll Item";
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Attribution de la rubrique %1 effectué avec succès.\Attribution pour %2 salariés.';
        Text02: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text03: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text04: Label 'Code de direction manquant pour la paie %1 !';
        Rubrique2: Record "Payroll Item";
        Text05: Label 'Information manquante ! %1.';
        Text06: Label 'Une seule rubrique doit être sélectionnée.';
        Structure2: Record Structure;
        Structure: Record Structure;
        Text07: Label 'Attribution de la rubrique %1 effectuée avec succès : %2 salariés.\Lancez un calcul de paie.';
        NbreSalaries: Integer;
        CodeUnite: Code[10];
        RubriqueSalarie: Record "Employee Payroll Item";
        RubriqueSalarie2: Record "Employee Payroll Item";
        Traiter: Boolean;
        MontantBase: Decimal;
        Text08: Label 'La rubrique ne peut pas être de type %1 !';
        Taux: Decimal;
        Nombre: Decimal;
        CoeffEnfants: Boolean;

}

