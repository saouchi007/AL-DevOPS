/// <summary>
/// Page Leave Indemnity (By Years) (ID 52182584).
/// </summary>
page 52182584 "Leave Indemnity (By Years)"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Leave Indemnity',
                FRA = 'Indemnité de congé';
    PageType = Card;
    SourceTable = 5200;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Editable = false;
            }
            field("First Name"; "First Name")
            {
                Editable = false;
            }
            field("Last Name"; "Last Name")
            {
                Caption = 'Nom';
                Editable = false;
            }
            part("leave inde"; 52182585)
            {
                SubPageLink = "Employee No." = FIELD("No.");
            }
            field("Total Leave Indem. Amount"; "Total Leave Indem. Amount")
            {
                Caption = 'Total indemnité de congé';
                Editable = false;
            }
            field("Total Leave Indem. No."; "Total Leave Indem. No.")
            {
                Caption = 'Total droits à congé';
                Editable = false;
            }
            field(NbreDemande; NbreDemande)
            {
                Caption = 'Nbre de jours à prendre';
                DecimalPlaces = 2 : 6;
                MinValue = 0;

                trigger OnValidate();
                begin
                    IF NbreDemande > NbreJoursDispo THEN
                        ERROR(Text01, NbreJoursDispo);
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OK)
            {
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    //Ctrl des champs
                    IF NbreDemande <= 0 THEN
                        ERROR(Text02, 'Nombre de jours à prendre');
                    //***Création de la rubrique d'indemnité de congé si besoin***
                    IF NOT Rubrique.GET('222') THEN BEGIN
                        Rubrique.INIT;
                        Rubrique.Code := '222';
                        Rubrique.Description := 'Indemnité de congé';
                        Rubrique.Nature := Rubrique.Nature::Calculated;
                        Rubrique.INSERT;
                    END;
                    //***Génération de la rubrique de congé***
                    RubriqueSalarie.RESET;
                    RubriqueSalarie.SETRANGE("Employee No.", "No.");
                    RubriqueSalarie.SETRANGE("Item Code", '222');
                    IF RubriqueSalarie.FINDFIRST THEN
                        RubriqueSalarie.DELETE;
                    //***Indemnité de congé***
                    EcritureCongeExercice.RESET;
                    EcritureCongeExercice.SETRANGE("Employee No.", "No.");
                    EcritureCongeExercice.SETFILTER("Remaining Days", '>0');
                    EcritureCongeExercice.FINDFIRST;
                    TotalNbreJours := NbreDemande;
                    TotalMontant := 0;
                    REPEAT
                        IF TotalNbreJours <= EcritureCongeExercice."Remaining Days" THEN BEGIN
                            TotalMontant := TotalMontant + EcritureCongeExercice."Remaining Amount" / EcritureCongeExercice."Remaining Days" * TotalNbreJours;
                            TotalNbreJours := 0;
                        END
                        ELSE BEGIN
                            TotalMontant := TotalMontant + EcritureCongeExercice."Remaining Amount";
                            TotalNbreJours := TotalNbreJours - EcritureCongeExercice."Remaining Days";
                        END;
                        EcritureCongeExercice.NEXT;
                    UNTIL TotalNbreJours = 0;
                    RubriqueSalarie.INIT;
                    RubriqueSalarie."Employee No." := "No.";
                    RubriqueSalarie."Item Code" := '222';
                    Rubrique.GET('222');
                    RubriqueSalarie."Item Description" := Rubrique.Description;
                    RubriqueSalarie.Basis := TotalMontant / NbreDemande;
                    RubriqueSalarie.Number := NbreDemande;
                    RubriqueSalarie.Amount := TotalMontant;
                    RubriqueSalarie.Type := Rubrique."Item Type";
                    RubriqueSalarie.INSERT;
                    //***Suppression du SALAIRE BASE MENSUEL***
                    RubriqueSalarie.RESET;
                    RubriqueSalarie.SETRANGE("Employee No.", "No.");
                    RubriqueSalarie.SETRANGE("Item Code", ParamPaie."Base Salary");
                    IF RubriqueSalarie.FINDFIRST THEN
                        RubriqueSalarie.DELETE;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage();
    begin

    end;

    var
        TotalNbreJours: Decimal;
        Text01: Label 'Le nombre de jours de congé ne doit pas dépasser %1 !';
        NbreDemande: Decimal;
        Rubrique: Record "Payroll Item";
        RubriqueSalarie: Record "Employee Payroll Item";
        Text02: Label '%1 doit être positif !';
        EnteteArchivePaie: Record "Payroll Archive Header";
        Direction: Record "Company Business Unit";
        PeriodeConge: Record "Leave Period";
        Paie: Record Payroll;
        Text03: Label 'Période congé courante non paramétrée pour la direction %1 !';
        ParamPaie: Record Payroll_Setup;
        TotalMontant: Decimal;
        EcritureCongeExercice: Record "Leave Right By Years";
        NbreJoursDispo: Decimal;


    local procedure OnAfterGetCurrRecord();
    begin
        xRec := Rec;
        CALCFIELDS("Total Leave Indem. No.");
        NbreJoursDispo := "Total Leave Indem. No.";
        NbreJoursDispo := NbreJoursDispo + 0.0000000001;
    end;
}

