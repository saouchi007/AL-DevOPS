/// <summary>
/// Report Payroll Generation (ID 52182432).
/// </summary>
report 52182432 "Payroll Generation"
{
    // version HALRHPAIE.6.2.00

    // //Axe Analytique

    CaptionML = ENU = 'Payroll Calculation',
                FRA = 'Génération de la paie';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.", "Payroll Type Code", Status;

            trigger OnAfterGetRecord();
            begin
                IF (DataItem7528."Company Business Unit Code" <> StructureCode) OR (DataItem7528.Status = DataItem7528.Status::Inactive) THEN
                    CurrReport.SKIP;
                NumSalarie := NumSalarie + 1;
                ProgressWindow.UPDATE(1, DataItem7528."No.");
                IF NumSalarie MOD 10 = 0 THEN
                    ProgressWindow.UPDATE(2, ROUND(NumSalarie * 100 / NbreSalaries));
                EmployeePayrollItem.RESET;
                EmployeePayrollItem.SETFILTER("Employee No.", DataItem7528."No.");
                IF NOT EmployeePayrollItem.FIND('-') THEN
                    CurrReport.SKIP;
                REPEAT
                    //Création des écritures de paie
                    EcriturePaie.INIT;
                    EcriturePaie."Entry No." := NextEntryNo;
                    EcriturePaie."Document No." := CodePaie;
                    EcriturePaie."Document Date" := Paie."Ending Date";
                    EcriturePaie."Employee No." := EmployeePayrollItem."Employee No.";
                    EcriturePaie."Item Code" := EmployeePayrollItem."Item Code";
                    EcriturePaie."Item Description" := EmployeePayrollItem."Item Description";
                    EcriturePaie.Amount := EmployeePayrollItem.Amount;
                    EcriturePaie."Global Dimension 1 Code" := DataItem7528."Global Dimension 1 Code";
                    //Axe Analytique
                    EcriturePaie."Global Dimension 2 Code" := DataItem7528."Global Dimension 2 Code";
                    //Axe Analytique
                    EcriturePaie."User ID" := USERID;
                    EcriturePaie.Basis := EmployeePayrollItem.Basis;
                    EcriturePaie.Rate := EmployeePayrollItem.Rate;
                    EcriturePaie.Type := EmployeePayrollItem.Type;
                    EcriturePaie.Number := EmployeePayrollItem.Number;
                    EcriturePaie."Company Business Unit Code" := StructureCode;
                    PayrollItem.GET(EmployeePayrollItem."Item Code");
                    EcriturePaie."Account No." := PayrollItem."Account No.";
                    EcriturePaie."Bal. Account No." := PayrollItem."Bal. Account No.";
                    EcriturePaie.Category := PayrollItem.Category;
                    EcriturePaie."Lending Code" := EmployeePayrollItem."Lending code";
                    EcriturePaie.INSERT;
                    CreateLedgEntryDim;
                    HistTransactPaie."To Entry No." := NextEntryNo;
                    HistTransactPaie.MODIFY;
                    NextEntryNo := NextEntryNo + 1;
                    //Archivage des lignes de la paie
                    PayrollLineArchive.INIT;
                    PayrollLineArchive."Employee No." := EmployeePayrollItem."Employee No.";
                    PayrollLineArchive."Item Code" := EmployeePayrollItem."Item Code";
                    PayrollLineArchive."Item Description" := EmployeePayrollItem."Item Description";
                    PayrollLineArchive.Basis := EmployeePayrollItem.Basis;
                    PayrollLineArchive.Rate := EmployeePayrollItem.Rate;
                    PayrollLineArchive.Amount := EmployeePayrollItem.Amount;
                    PayrollLineArchive.Type := EmployeePayrollItem.Type;
                    PayrollLineArchive.Number := EmployeePayrollItem.Number;
                    PayrollLineArchive."Payroll Code" := CodePaie;
                    PayrollLineArchive.Category := PayrollItem.Category;
                    PayrollLineArchive."First Name" := DataItem7528."First Name";
                    PayrollLineArchive."Last Name" := DataItem7528."Last Name";
                    PayrollLineArchive.INSERT;
                UNTIL EmployeePayrollItem.NEXT = 0;
                //Archivage de l'entête de la paie
                DataItem7528.SETFILTER("Date Filter", '%1..%2', Payroll."Starting Date", Payroll."Ending Date");
                DataItem7528.CALCFIELDS("Total Advance");
                DataItem7528.CALCFIELDS("Total Overtime (Base)");
                DataItem7528.CALCFIELDS("Total Recovery (Base)");
                DataItem7528.CALCFIELDS("Total Medical Refund");
                DataItem7528.CALCFIELDS("Total Medical Refund");
                //DataItem7528.CALCFIELDS("No. of Children");
                DataItem7528.CALCFIELDS("Total Absences Days");
                DataItem7528.CALCFIELDS("Total Absences Hours");
                DataItem7528.CALCFIELDS("Total Professional Expances");
                DataItem7528.CALCFIELDS("Total Profess. Expances Refund");
                DataItem7528.CALCFIELDS(Comment);
                DataItem7528.CALCFIELDS(Sanctioned);
                ArchivePaieEntete.INIT;
                ArchivePaieEntete."Payroll Code" := CodePaie;
                ArchivePaieEntete."No." := DataItem7528."No.";
                ArchivePaieEntete."First Name" := DataItem7528."First Name";
                ArchivePaieEntete."Middle Name" := DataItem7528."Middle Name";
                ArchivePaieEntete."Last Name" := DataItem7528."Last Name";
                ArchivePaieEntete.Initials := DataItem7528.Initials;
                ArchivePaieEntete."Function Description" := DataItem7528."Job Title";
                ArchivePaieEntete.Address := DataItem7528.Address;
                ArchivePaieEntete."Address 2" := DataItem7528."Address 2";
                ArchivePaieEntete.City := DataItem7528.City;
                ArchivePaieEntete."Post Code" := DataItem7528."Post Code";
                ArchivePaieEntete.County := DataItem7528.County;
                ArchivePaieEntete."Social Security No." := DataItem7528."Social Security No.";
                ArchivePaieEntete."Union Code" := DataItem7528."Union Code";
                ArchivePaieEntete."Union Membership No." := DataItem7528."Union Membership No.";
                ArchivePaieEntete."Country/Region Code" := DataItem7528."Country/Region Code";
                ArchivePaieEntete."Emplymt. Contract Type Code" := DataItem7528."Emplymt. Contract Code";
                ArchivePaieEntete."Statistics Group Code" := DataItem7528."Statistics Group Code";
                ArchivePaieEntete."Employment Date" := DataItem7528."Employment Date";
                ArchivePaieEntete.Status := DataItem7528.Status;
                ArchivePaieEntete."Global Dimension 1 Code" := DataItem7528."Global Dimension 1 Code";
                ArchivePaieEntete."Global Dimension 2 Code" := DataItem7528."Global Dimension 2 Code";
                ArchivePaieEntete."Marital Status" := DataItem7528."Marital Status";
                ArchivePaieEntete."Company Business Unit Code" := DataItem7528."Company Business Unit Code";
                ArchivePaieEntete."Section Grid Class" := DataItem7528."Section Grid Class";
                ArchivePaieEntete."Section Grid Section" := DataItem7528."Section Grid Section";
                ArchivePaieEntete."Section Grid Level" := DataItem7528."Section Grid Level";
                ArchivePaieEntete."Hourly Index Grid Function No." := DataItem7528."Hourly Index Grid Function No.";
                ArchivePaieEntete."Hourly Index Grid Function" := DataItem7528."Hourly Index Grid Function";
                ArchivePaieEntete."Hourly Index Grid CH" := DataItem7528."Hourly Index Grid CH";
                ArchivePaieEntete."Hourly Index Grid Index" := DataItem7528."Hourly Index Grid Index";
                ArchivePaieEntete."Payroll Bank Account" := DataItem7528."Payroll Bank Account";
                ArchivePaieEntete."RIB Key" := DataItem7528."RIB Key";
                ArchivePaieEntete."Structure Code" := DataItem7528."Structure Code";
                ArchivePaieEntete."Payroll Bank Account No." := DataItem7528."Payroll Bank Account No.";
                ArchivePaieEntete."Military Situation" := DataItem7528."Military Situation";
                ArchivePaieEntete."Payroll Template No." := DataItem7528."Payroll Template No.";
                ArchivePaieEntete."Function Code" := DataItem7528."Function Code";
                ArchivePaieEntete."Structure Description" := DataItem7528."Structure Description";
                ArchivePaieEntete.Confirmed := DataItem7528.Confirmed;
                ArchivePaieEntete."Socio-Professional Category" := DataItem7528."Socio-Professional Category";
                ArchivePaieEntete."Confirmation Date" := DataItem7528."Confirmation Date";
                ArchivePaieEntete.Comment := DataItem7528.Comment;
                ArchivePaieEntete."Total Advance" := DataItem7528."Total Advance";
                ArchivePaieEntete.Sanctioned := DataItem7528.Sanctioned;
                ArchivePaieEntete."Total Overtime (Base)" := DataItem7528."Total Overtime (Base)";
                ArchivePaieEntete."Total Recovery (Base)" := DataItem7528."Total Recovery (Base)";
                ArchivePaieEntete."Total Medical Refund" := DataItem7528."Total Medical Refund";
                ArchivePaieEntete."Total Leave (Base)" := DataItem7528."Total Leave (Base)";
                ArchivePaieEntete."No. of Children" := DataItem7528."No. of Children";
                ArchivePaieEntete."Total Absences Days" := DataItem7528."Total Absences Days";
                ArchivePaieEntete."Total Absences Hours" := DataItem7528."Total Absences Hours";
                ArchivePaieEntete."Total Family Allowance Contr." := DataItem7528."Total Professional Expances";
                ArchivePaieEntete."Total Union Contr." := DataItem7528."Total Profess. Expances Refund";
                ArchivePaieEntete."Payroll Type Code" := DataItem7528."Payroll Type Code";
                ArchivePaieEntete."Payment Method Code" := DataItem7528."Payment Method Code";
                ArchivePaieEntete."Leave Indemnity Amount" := DataItem7528."Leave Indemnity Amount";
                ArchivePaieEntete."Leave Indemnity No." := DataItem7528."Leave Indemnity No.";
                ArchivePaieEntete."STC Payroll" := DataItem7528."STC Payroll";
                ArchivePaieEntete.Regime := DataItem7528.Regime;
                ArchivePaieEntete."N ° CCP" := DataItem7528."CCP N";
                ArchivePaieEntete.INSERT;
            end;

            trigger OnPostDataItem();
            begin
                ProgressWindow.CLOSE;
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

        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text04, USERID);
    end;

    trigger OnPreReport();
    begin

        //Payroll.FindFirst();
        IF DataItem8955.GETFILTERS = '' THEN
            ERROR(Text01);
        Payroll2.COPYFILTERS(DataItem8955);
        Payroll2.FINDFIRST;
        CodePaie := Payroll2.Code;
        StructureCode := Payroll2."Company Business Unit Code";
        IF StructureCode = '' THEN
            ERROR(Text08, CodePaie);
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        PayrollManager.SETRANGE("Company Business Unit Code", StructureCode);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text05, USERID, CodePaie);
        IF Payroll2.Closed THEN
            ERROR(Text09, 'la paie', CodePaie);
        DataItem8955.COPYFILTER(Code, EcriturePaie."Document No.");
        IF EcriturePaie.FINDSET THEN
            ERROR(Text02, EcriturePaie."Document No.");
        HistTransactPaie.RESET;
        IF HistTransactPaie.FINDSET THEN BEGIN
            HistTransactPaie.FINDLAST;
            IF HistTransactPaie."Payroll Code" = CodePaie THEN
                PayrollEntriesMgt.SupprimerPaie(CodePaie);
        END;
        Employee2.RESET;
        DataItem7528.COPYFILTER("No.", Employee2."No.");
        Employee2.SETRANGE("Company Business Unit Code", StructureCode);
        Employee2.SETRANGE(Status, Employee2.Status::Active);
        NbreSalaries := Employee2.COUNT;
        NumSalarie := 0;
        ParametresCompta.GET;
        IF Employee2.ISEMPTY THEN
            ERROR(Text07, StructureCode)
        ELSE
            REPEAT
                IF Employee2."First Name" <> '' THEN BEGIN
                    IF ParametresCompta."Global Dimension 1 Code" <> '' THEN
                        Employee2.TESTFIELD(Employee2."Global Dimension 1 Code");
                    IF ParametresCompta."Global Dimension 2 Code" <> '' THEN
                        Employee2.TESTFIELD(Employee2."Global Dimension 2 Code");
                END;
            UNTIL Employee2.NEXT = 0;
        PayrollStartingPeriod := Payroll2."Starting Date";
        PayrollEndingPeriod := Payroll2."Ending Date";
        PayrollSetup.GET;
        PayrollSetup.TESTFIELD(PayrollSetup."Base Salary");
        PayrollSetup.TESTFIELD(PayrollSetup."Post Salary");
        PayrollItem.GET(PayrollSetup."Post Salary");
        PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
        PayrollItem.TESTFIELD(PayrollItem."Item Type", PayrollItem."Item Type"::Formule);
        PayrollItem.TESTFIELD(PayrollItem."Calculation Formula");
        PayrollSetup.TESTFIELD(PayrollSetup."Taxable Salary");
        PayrollItem.GET(PayrollSetup."Taxable Salary");
        PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
        PayrollItem.TESTFIELD(PayrollItem."Item Type", PayrollItem."Item Type"::Formule);
        PayrollItem.TESTFIELD(PayrollItem."Calculation Formula");
        PayrollSetup.TESTFIELD(PayrollSetup."Net Salary");
        PayrollItem.GET(PayrollSetup."Net Salary");
        PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
        PayrollItem.TESTFIELD(PayrollItem."Item Type", PayrollItem."Item Type"::Formule);
        PayrollItem.TESTFIELD(PayrollItem."Calculation Formula");
        PayrollSetup.TESTFIELD(PayrollSetup."SS Basis");
        PayrollSetup.TESTFIELD(PayrollSetup."Employee SS Deduction");
        PayrollSetup.TESTFIELD(PayrollSetup."Employee SS %");
        PayrollSetup.TESTFIELD(PayrollSetup."TIT Deduction");
        EcriturePaie.RESET;
        IF NextEntryNo = 0 THEN BEGIN
            EcriturePaie.LOCKTABLE;
            IF EcriturePaie.FINDLAST THEN
                NextEntryNo := EcriturePaie."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        END;
        HistTransactPaie.LOCKTABLE;
        IF (NOT HistTransactPaie.FINDLAST) OR (HistTransactPaie."To Entry No." <> 0) THEN BEGIN
            HistTransactPaie.INIT;
            HistTransactPaie."No." := HistTransactPaie."No." + 1;
            HistTransactPaie."From Entry No." := NextEntryNo;
            HistTransactPaie."To Entry No." := NextEntryNo;
            HistTransactPaie."Creation Date" := TODAY;
            HistTransactPaie."User ID" := USERID;
            HistTransactPaie."Payroll Code" := CodePaie;
            HistTransactPaie."Company Business Unit Code" := StructureCode;
            HistTransactPaie.INSERT;
        END;
        HistTransactPaie."To Entry No." := NextEntryNo;
        HistTransactPaie.MODIFY;
        ProgressWindow.OPEN('Traitement de la paie du salarié #1#######\Progression                      #2### %');
        ParametresCompta.GET;
        NumEcritureConge := 0;
        EcritureConge.RESET;
        IF EcritureConge.FINDLAST THEN
            NumEcritureConge := EcritureConge."Entry No.";
        Paie.GET(CodePaie);
        IF Paie."Starting Date" = 0D THEN
            ERROR(Text12, CodePaie, 'Date de début');
        IF Paie."Ending Date" = 0D THEN
            ERROR(Text12, CodePaie, 'Date de fin');
    end;

    trigger OnPostReport();
    begin
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Document No.", CodePaie);
        HistTransactPaie."No. of employees" := NbreSalaries;
        HistTransactPaie."No. of Entries" := EcriturePaie.COUNT;
        HistTransactPaie.MODIFY;

        //A REACTIVER POUR JUILLET 2011
        /*
  //Actualisation des congés
  ArchivePaieEntete.RESET;
  ArchivePaieEntete.SETRANGE("Payroll Code",CodePaie);
  IF ArchivePaieEntete.FINDFIRST THEN
    REPEAT
      ArchivePaieEntete2.RESET;
      ArchivePaieEntete2.SETRANGE("No.",ArchivePaieEntete."No.");
      ArchivePaieEntete2.FINDFIRST;
      EcritureCongeExercice.RESET;
      EcritureCongeExercice.SETRANGE("Employee No.",ArchivePaieEntete."No.");
      EcritureCongeExercice.DELETEALL;
      REPEAT
        Paie.GET(ArchivePaieEntete2."Payroll Code");
        PeriodeConge.RESET;
        PeriodeConge.SETFILTER("Starting Date",'<=%1',Paie."Ending Date");
        PeriodeConge.SETFILTER("Ending Date",'>=%1',Paie."Ending Date");
        IF NOT PeriodeConge.FINDFIRST THEN
          ERROR(Text13);
        IF((ArchivePaieEntete2."Leave Indemnity No."<>0)OR(ArchivePaieEntete2."Leave Indemnity Amount"<>0))
        AND((ArchivePaieEntete2."STC Payroll")OR(ArchivePaieEntete2."Payroll Code"<>CodePaie))THEN
          IF EcritureCongeExercice.GET(ArchivePaieEntete2."No.",PeriodeConge.Code)THEN
            BEGIN
              EcritureCongeExercice.Amount:=EcritureCongeExercice.Amount+ArchivePaieEntete2."Leave Indemnity Amount";
              EcritureCongeExercice.Days:=EcritureCongeExercice.Days+ArchivePaieEntete2."Leave Indemnity No.";
              EcritureCongeExercice."Remaining Amount":=EcritureCongeExercice."Remaining Amount"
              +ArchivePaieEntete2."Leave Indemnity Amount";
              EcritureCongeExercice."Remaining Days":=EcritureCongeExercice."Remaining Days"
              +ArchivePaieEntete2."Leave Indemnity No.";
              EcritureCongeExercice.MODIFY;
            END
          ELSE
            BEGIN
              EcritureCongeExercice2.INIT;
              EcritureCongeExercice2."Employee No.":=ArchivePaieEntete2."No.";
              EcritureCongeExercice2."Leave Period Code":=PeriodeConge.Code;
              EcritureCongeExercice2.Amount:=ArchivePaieEntete2."Leave Indemnity Amount";
              EcritureCongeExercice2.Days:=ArchivePaieEntete2."Leave Indemnity No.";
              EcritureCongeExercice2."Remaining Amount":=ArchivePaieEntete2."Leave Indemnity Amount";
              EcritureCongeExercice2."Remaining Days":=ArchivePaieEntete2."Leave Indemnity No.";
              EcritureCongeExercice2.INSERT;
            END;
      UNTIL ArchivePaieEntete2.NEXT=0;
    UNTIL ArchivePaieEntete.NEXT=0;
  //Génération des écritures de consommation
  ArchivePaieEntete.RESET;
  ArchivePaieEntete.SETRANGE("Payroll Code",CodePaie);
  IF ArchivePaieEntete.FINDFIRST THEN
    REPEAT
      ArchivePaieLigne.RESET;
      ArchivePaieLigne.SETRANGE("Payroll Code",CodePaie);
      ArchivePaieLigne.SETRANGE("Employee No.",ArchivePaieEntete."No.");
      ArchivePaieLigne.SETRANGE("Item Code",'222');
      IF ArchivePaieLigne.FINDFIRST THEN
        REPEAT
          Salarie.GET(ArchivePaieEntete."No.");
          Salarie.CALCFIELDS("Total Leave Indem. No.");
          NbreJours:=ArchivePaieLigne.Number;
          TotalNbreJours:=NbreJours;
          EcritureCongeExercice.RESET;
          EcritureCongeExercice.SETRANGE("Employee No.",Salarie."No.");
          EcritureCongeExercice.SETFILTER("Remaining Days",'>0');
          EcritureCongeExercice.FINDFIRST;
          REPEAT
            IF NbreJours<=EcritureCongeExercice."Remaining Days"THEN
              BEGIN
                MntIndemnite:=EcritureCongeExercice."Remaining Amount"/EcritureCongeExercice."Remaining Days"
                *NbreJours;
              END
            ELSE
              BEGIN
                MntIndemnite:=EcritureCongeExercice."Remaining Amount";
                NbreJours:=EcritureCongeExercice."Remaining Days";
              END;
            EcritureCongeExercice."Consumed Amount":=EcritureCongeExercice."Consumed Amount"+MntIndemnite;
            EcritureCongeExercice."Consumed Days":=EcritureCongeExercice."Consumed Days"+NbreJours;
            EcritureCongeExercice."Remaining Amount":=EcritureCongeExercice.Amount-EcritureCongeExercice."Consumed Amount";
            EcritureCongeExercice."Remaining Days":=EcritureCongeExercice.Days-EcritureCongeExercice."Consumed Days";
            EcritureCongeExercice.MODIFY;
            TotalNbreJours:=TotalNbreJours-NbreJours;
            NbreJours:=TotalNbreJours;
            EcritureCongeExercice.NEXT;
          UNTIL TotalNbreJours=0;
        UNTIL ArchivePaieLigne.NEXT=0;
    UNTIL ArchivePaieEntete.NEXT=0;
        */
        NbreEcritures := EcriturePaie.COUNT;
        //Actualisation des prêts
        Pret.RESET;
        IF Pret.FINDFIRST THEN
            REPEAT
                EcriturePaie.RESET;
                EcriturePaie.SETRANGE("Employee No.", Pret."Employee No.");
                EcriturePaie.SETRANGE("Item Code", Pret."Lending Deduction (Capital)");
                EcriturePaie.SETFILTER("Document Date", '%1..%2', Pret."Grant Date", Pret."End Date");
                Montant := 0;
                IF EcriturePaie.FINDFIRST THEN
                    REPEAT
                        Montant := Montant - EcriturePaie.Amount;
                    UNTIL EcriturePaie.NEXT = 0;
                Pret."Total Refund" := Montant;
                Pret."No. of Monthly Payments" := EcriturePaie.COUNT;
                Pret.MODIFY;
            UNTIL Pret.NEXT = 0;
        MESSAGE(Text03, CodePaie, NbreEcritures, NbreSalaries);

    end;


    var
        EcriturePaie: Record "Payroll Entry";
        EcriturePaie2: Record "Payroll Entry";
        EmployeePayrollItem: Record "Employee Payroll Item";
        CodePaie: Code[20];
        Text01: Label 'Code de la paie manquant !';
        Text02: Label 'Paie %1 déjà calculée ! Veuillez l''annuler avant de relancer le calcul.';
        Payroll2: Record Payroll;
        Text03: Label 'Calcul de la paie %1 effectué avec succès.\Génération de %2 écritures pour %3 salariés.';
        PayrollItem: Record "Payroll Item";
        Montant: Decimal;
        ProgressWindow: Dialog;
        NextEntryNo: Integer;
        Employee2: Record 5200;
        //Employee: Record 5200;
        ParametresCompta: Record 98;
        NbreSalaries: Integer;
        NumSalarie: Integer;
        PayrollSetup: Record Payroll_Setup;
        StructureCode: Code[10];
        Text06: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        PayrollManager: Record "Payroll Manager";
        Text04: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text07: Label 'Aucun salarié n''est affecté à la direction %1 !';
        EmployeeUnionSubscription: Record "Employee Union Subscription";
        Text05: Label 'L''utilisateur %1 n''est pas autorisé à calculer la paie %2 !';
        PayrollStartingPeriod: Date;
        PayrollEndingPeriod: Date;
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        NbreWorkedDays: Decimal;
        SalaireImposable: Decimal;
        PayrollEntriesMgt: Codeunit "Payroll Managemen ExtHLK";
        PayrollLineArchive: Record "Payroll Archive Line";
        ArchivePaieEntete: Record "Payroll Archive Header";
        Payroll: Record Payroll;
        ArchivePaieLigne: Record "Payroll Archive Line";
        ArchivePaieEntete2: Record "Payroll Archive Header";
        HistTransactPaie: Record "Payroll Register";
        Text09: Label '%1 %2 est clôturé(e) !';
        EcritureConge: Record "Leave Entry";
        NumEcritureConge: Integer;
        PaieConsommation: Code[20];
        NbreJours: Decimal;
        MntIndemnite: Decimal;
        EcritureConge2: Record "Leave Entry";
        EcritureConge3: Record "Leave Entry";
        DateJournee: Date;
        Chn: Text[30];
        Text10: Label 'Incohérence de données : Salarié %1 !';
        Salarie: Record 5200;
        Paie: Record Payroll;
        Text12: Label '"Information manquante : Paie %1 ; Information %2 !"';
        PeriodeConge: Record "Leave Period";
        Text13: Label 'Périodes de congé à réviser !';
        EcritureCongeExercice7: Record "Leave Right By Years";
        EcritureCongeExercice2: Record "Leave Right By Years";
        TotalNbreJours: Decimal;
        Text14: Label 'Incohérence de données : Salarié %1, Consommation %2 !';
        Pret: Record Lending;
        NbreEcritures: Integer;


    /// <summary>
    /// CreateLedgEntryDim.
    /// </summary>
    procedure CreateLedgEntryDim();
    begin
        /*LedgEntryDim.INIT;
        LedgEntryDim."Table ID" :="Payroll Entry";
        LedgEntryDim."Entry No.":=NextEntryNo;
        IF ParametresCompta."Global Dimension 1 Code"<>''THEN
          BEGIN
            DataItem7528.TESTFIELD("Payroll Dimension 1");
            LedgEntryDim."Dimension Code":=ParametresCompta."Global Dimension 1 Code";
            LedgEntryDim."Dimension Value Code":=DataItem7528."Payroll Dimension 1";
            LedgEntryDim.INSERT;
          END;
        IF ParametresCompta."Global Dimension 2 Code"<>''THEN
          BEGIN
            DataItem7528.TESTFIELD("Payroll Dimension 2");
            LedgEntryDim."Dimension Code":=ParametresCompta."Global Dimension 2 Code";
            LedgEntryDim."Dimension Value Code":=DataItem7528."Payroll Dimension 2";
            LedgEntryDim.INSERT;
          END;
          */

    end;
}

