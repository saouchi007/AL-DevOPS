/// <summary>
/// Page Payroll Closing (ID 52182583).
/// </summary>
page 52182583 "Payroll Closing"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Clôture de la paie';
    PageType = Card;

    layout
    {
        area(content)
        {
            field(CodePaie; CodePaie)
            {
                Caption = 'Paie actuelle :';
                Editable = false;
            }
            field(CodeUniteSociete; CodeUniteSociete)
            {
                Caption = 'Unité :';
                Editable = false;
            }
            field(Text19062641; '')
            {
                CaptionClass = Text19062641;
                MultiLine = true;
            }
            field(Text19071778; '')
            {
                CaptionClass = Text19071778;
                MultiLine = true;
            }
            field(Text19012287; '')
            {
                CaptionClass = Text19012287;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Clôture")
            {
                Caption = 'Clôture';
                Image = Close;
                action("Clôturer la paie")
                {
                    Caption = 'Clôturer la paie';
                    Image = ClosePeriod;

                    trigger OnAction();
                    begin
                        //IF USERID IN ['SOUMMAM\ASSIA.HAMITOUCHE','SOUMMAM\mokhtar.salhi'] THEN
                        //BEGIN
                        Paie.GET(CodePaie);
                        IF Paie.Closed THEN
                            ERROR(Text03, CodePaie, 'clôturée');
                        Paie.Closed := TRUE;
                        Paie.MODIFY;
                        MESSAGE(Text04, CodePaie, 'clôturée');
                        IF CONFIRM(Text07) THEN BEGIN
                            Paie.GET(CodePaie);
                            IF NOT Paie.Closed THEN
                                ERROR(Text06, CodePaie);
                            RubriquePaie.RESET;
                            RubriquePaie.SETRANGE(Variable, TRUE);
                            IF RubriquePaie.FINDFIRST THEN
                                REPEAT
                                    RubriqueSalarie.RESET;
                                    RubriqueSalarie.SETRANGE("Item Code", RubriquePaie.Code);
                                    IF RubriqueSalarie.FINDSET THEN
                                        REPEAT
                                            Salarie.GET(RubriqueSalarie."Employee No.");
                                            //001MK*****************************************
                                            Salarie.StatutPay := '';
                                            Salarie.UserPay := '';
                                            Salarie.MODIFY;
                                            //001MK*****************************************
                                            IF Salarie."Company Business Unit Code" = CodeUniteSociete THEN
                                                RubriqueSalarie.DELETE;
                                        UNTIL RubriqueSalarie.NEXT = 0;
                                UNTIL RubriquePaie.NEXT = 0;
                            MESSAGE(Text05, CodeUniteSociete);
                        END;
                        //END;
                    end;
                }

                action("Constater le droit à congé")
                {
                    Caption = 'Constater le droit à congé';
                    Image = MoveToNextPeriod;

                    trigger OnAction();
                    begin
                        REPORT.RUNMODAL(51494, FALSE);
                        /*
                        Paie.GET(CodePaie);
                        IF Paie."Starting Date"=0D THEN
                          ERROR(Text12,CodePaie,'Date de début');
                        IF Paie."Ending Date"=0D THEN
                          ERROR(Text12,CodePaie,'Date de fin');
                        PeriodeConge.RESET;
                        PeriodeConge.SETFILTER("Starting Date",'<=%1',Paie."Ending Date");
                        PeriodeConge.SETFILTER("Ending Date",'>=%1',Paie."Ending Date");
                        IF NOT PeriodeConge.FINDFIRST THEN
                          ERROR(Text13);
                        ArchivePaieEntete.RESET;
                        ArchivePaieEntete.SETRANGE("Payroll Code",CodePaie);
                        IF ArchivePaieEntete.FINDFIRST THEN
                          REPEAT
                            IF(ArchivePaieEntete."Leave Indemnity No."<>0)OR(ArchivePaieEntete."Leave Indemnity Amount"<>0)THEN
                              BEGIN
                                IF EcritureCongeExercice.GET(ArchivePaieEntete."No.",PeriodeConge.Code)THEN
                                  BEGIN
                                    EcritureCongeExercice.Assiette:=EcritureCongeExercice.Assiette+ArchivePaieEntete."Leave Indemnity Amount";
                                    EcritureCongeExercice.Taux:=EcritureCongeExercice.Taux+ArchivePaieEntete."Leave Indemnity No.";
                                    EcritureCongeExercice.Sortie:=EcritureCongeExercice.Sortie
                                    +ArchivePaieEntete."Leave Indemnity Amount";
                                    EcritureCongeExercice.Effectif:=EcritureCongeExercice.Effectif
                                    +ArchivePaieEntete."Leave Indemnity No.";
                                    EcritureCongeExercice.MODIFY;
                                  END
                                ELSE
                                  BEGIN
                                    EcritureCongeExercice2.INIT;
                                    EcritureCongeExercice2.Code:=ArchivePaieEntete."No.";
                                    EcritureCongeExercice2.Description:=PeriodeConge.Code;
                                    EcritureCongeExercice2.Assiette:=ArchivePaieEntete."Leave Indemnity Amount";
                                    EcritureCongeExercice2.Taux:=ArchivePaieEntete."Leave Indemnity No.";
                                    EcritureCongeExercice2.Sortie:=ArchivePaieEntete."Leave Indemnity Amount";
                                    EcritureCongeExercice2.Effectif:=ArchivePaieEntete."Leave Indemnity No.";
                                    EcritureCongeExercice2.INSERT;
                                  END;
                              END;
                          UNTIL ArchivePaieEntete.NEXT=0;
                        MESSAGE(Text14);
                        */

                    end;
                }
                action("Supprimer les rubriques variables")
                {
                    Caption = 'Supprimer les rubriques variables';
                    Image = DeleteRow;

                    trigger OnAction();
                    begin
                        //IF( USERID= 'ASSIA.HAMITOUCHE') THEN
                        //BEGIN

                        Paie.GET(CodePaie);
                        //IF NOT Paie.Closed THEN
                        //ERROR(Text06,CodePaie);
                        RubriquePaie.RESET;
                        RubriquePaie.SETRANGE(Variable, TRUE);
                        IF RubriquePaie.FINDFIRST THEN
                            REPEAT
                                RubriqueSalarie.RESET;
                                RubriqueSalarie.SETRANGE("Item Code", RubriquePaie.Code);
                                IF RubriqueSalarie.FINDSET THEN
                                    REPEAT
                                        Salarie.GET(RubriqueSalarie."Employee No.");
                                        IF Salarie."Company Business Unit Code" = CodeUniteSociete THEN
                                            RubriqueSalarie.DELETE;
                                    UNTIL RubriqueSalarie.NEXT = 0;
                            UNTIL RubriquePaie.NEXT = 0;
                        MESSAGE(Text05, CodeUniteSociete);
                        //END;
                    end;
                }

                action("Rouvrir la paie")
                {
                    Caption = 'Rouvrir la paie';
                    Image = ReOpen;

                    trigger OnAction();
                    begin
                        //IF( USERID= 'ASSIA.HAMITOUCHE') THEN
                        //BEGIN

                        Paie.GET(CodePaie);
                        IF NOT Paie.Closed THEN
                            ERROR(Text03, CodePaie, 'ouverte');
                        Paie.Closed := FALSE;
                        Paie.MODIFY;
                        MESSAGE(Text04, CodePaie, 'ouverte');
                        //END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        GestionnairePaie.RESET;
        GestionnairePaie.SETRANGE("User ID", USERID);
        IF NOT GestionnairePaie.FINDSET THEN
            ERROR(Text02, USERID);
        UniteSociete.GET(GestionnairePaie."Company Business Unit Code");
        CodeUniteSociete := UniteSociete.Code;
        CodePaie := UniteSociete."Current Payroll";
    end;

    var
        NbreJours: Decimal;
        MntIndemnite: Decimal;
        PaieConsommation: Code[20];
        CodePaie: Code[20];
        Paie: Record Payroll;
        CodeUniteSociete: Code[10];
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        UniteSociete: Record "Company Business Unit";
        Text03: Label 'Paie %1 déjà %2  !';
        Text04: Label 'La paie %1 est %2.';
        RubriquePaie: Record "Payroll Item";
        RubriqueSalarie: Record "Employee Payroll Item";
        Text05: Label 'Suppression des rubriques variables effectuée avec succès pour l''unité %1.';
        Salarie: Record 5200;
        Text06: Label 'Paie %1 doit être clôturée !';
        EcritureConge: Record "Leave Entry";
        EcritureConge2: Record "Leave Entry";
        EcritureConge3: Record "Leave Entry";
        NumEcritureConge: Integer;
        ArchivePaieEntete: Record "Payroll Archive Header";
        Text10: Label 'Incohérence de données : Salarié %1 !';
        Text11: Label 'Veuillez exécuter le traitement d''actualisation des congés.';
        Text12: Label '"Information manquante : Paie %1 ; Information %2 !"';
        Text13: Label 'Périodes de congé à réviser !';
        PeriodeConge: Record "Leave Period";
        EcritureCongeExercice: Record "Leave Right By Years";
        EcritureCongeExercice2: Record "Leave Right By Years";
        Text14: Label 'Constat du droit à congé effectué.';
        Text07: Label 'Confirmez-vous la suppression des rubriques variables ?';
        Text19012287: Label 'Pour clôturer la paie actuelle, suivez les étapes ci-dessous :';
        Text19071778: Label 'La fonction "Clôturer la paie" marque la paie actuelle comme clôturée et empêche sa suppression et son recalcul.';
        Text19062641: Label 'De plus, un message s''affiche permettant la suppression des rubriques variables pour effacer les éléments variables de la saisie de paie.';

}

