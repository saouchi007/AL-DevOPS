/// <summary>
/// Report Leave Right Calculation (ID 51444).
/// </summary>
report 52182456 "Leave Right Calculation"
{
    // version HALRHPAIE.6.1.07

    CaptionML = ENU = 'Leave Right Calculation',
                FRA = 'Calcul du droit au congé';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem8290; "Leave Period")
        {
            DataItemTableView = SORTING(Code)
                                WHERE(Closed = CONST(false));
            RequestFilterFields = "Code";
        }
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                IF (DataItem7528."Company Business Unit Code" <> StructureCode)
                OR (DataItem7528."Employment Date" > LeavePeriodEndingDate) THEN
                    CurrReport.SKIP;
                IF DataItem7528."Termination Date" <> 0D THEN
                    IF DataItem7528."Termination Date" < LeavePeriodStartingDate THEN
                        CurrReport.SKIP;
                ProgressWindow.UPDATE(1, DataItem7528."No.");
                SLEEP(50);
                EmployeesNumber := EmployeesNumber + 1;
                LeaveRight.RESET;
                LeaveRight.SETRANGE(LeaveRight."Leave Period Code", LeavePeriodCode);
                LeaveRight.SETRANGE(LeaveRight."Employee No.", DataItem7528."No.");
                LeaveRight.DELETEALL;
                EmploymentDay := DATE2DMY(DataItem7528."Employment Date", 1);
                EmploymentMonth := DATE2DMY(DataItem7528."Employment Date", 2);
                EmploymentYear := DATE2DMY(DataItem7528."Employment Date", 3);
                LeaveRight.INIT;
                LeaveRight."Leave Period Code" := LeavePeriodCode;
                LeaveRight."Employee No." := DataItem7528."No.";
                LeaveRight."No. of Days" := CalcLeaveRight * (UniteSociete."Nbre de jours de congé par an" / 12);
                LeaveRight."Employment Date" := DataItem7528."Employment Date";
                LeaveRight."Termination Date" := DataItem7528."Termination Date";
                LeaveRight.INSERT;
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
                    field(StructureCode; StructureCode)
                    {
                        Caption = 'Code Direction';
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
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text01, USERID);
        StructureCode := PayrollManager."Company Business Unit Code";
        UniteSociete.GET(StructureCode);
        IF StructureCode = '' THEN
            ERROR(Text02, USERID);
        PayrollSetup.GET;
        PayrollSetup.TESTFIELD(PayrollSetup."Leave Nbre of Days by Month");
        Employee2.RESET;
        Employee2.SETRANGE("Company Business Unit Code", StructureCode);
        Employee2.SETRANGE(Status, Employee2.Status::Active);
        IF NOT Employee2.FIND('-') THEN
            ERROR(Text03, StructureCode);
    end;

    trigger OnPostReport();
    begin
        MESSAGE(Text04, EmployeesNumber);
    end;

    trigger OnPreReport();
    begin
        IF DataItem8290.GETFILTERS = '' THEN
            ERROR(Text05);
        DataItem8290.COPYFILTER(Code, LeavePeriod2.Code);
        LeavePeriod2.FINDFIRST;
        LeavePeriodCode := LeavePeriod2.Code;
        IF LeavePeriod2.Closed THEN
            ERROR(Text06);
        LeavePeriodStartingDate := LeavePeriod2."Starting Date";
        LeavePeriodEndingDate := LeavePeriod2."Ending Date";
        LeavePeriodStartingMonth := DATE2DMY(LeavePeriodStartingDate, 2);
        LeavePeriodEndingMonth := DATE2DMY(LeavePeriodEndingDate, 2);
        LeavePeriodStartingYear := DATE2DMY(LeavePeriodStartingDate, 3);
        LeavePeriodEndingYear := DATE2DMY(LeavePeriodEndingDate, 3);
        Employee2.RESET;
        DataItem7528.COPYFILTER("No.", Employee2."No.");
        Employee2.SETRANGE(Employee2."Company Business Unit Code", StructureCode);
        IF Employee2.FIND('-') THEN
            REPEAT
                Employee2.TESTFIELD(Employee2."Employment Date");
            UNTIL Employee2.NEXT = 0
        ELSE
            ERROR(Text03, StructureCode);
        LeaveRight.RESET;
        LeaveRight.SETRANGE(LeaveRight."Leave Period Code", LeavePeriodCode);
        LeaveRight.DELETEALL;
        ProgressWindow.OPEN('Calcul des droits au congé du salarié #1#######');
    end;

    var
        PayrollManager: Record "Payroll Manager";
        StructureCode: Code[10];
        Text02: Label 'Code de direction manquant dans la table des gestionnaires de paie pour l''utilisateur %1';
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie';
        Text03: Label 'Aucun salarié n''est affecté à la direction %1';
        //Employee: Record 5200;
        Employee2: Record 5200;
        Text04: Label 'Calcul du droit au congé effectué avec succès.\Calcul pour %1 salariés.';
        EmployeesNumber: Integer;
        ProgressWindow: Dialog;
        LeaveRight: Record "Leave Right";
        EmploymentDay: Integer;
        EmploymentMonth: Integer;
        EmploymentYear: Integer;
        LeavePeriod2: Record "Leave Period";
        //"Leave Period": Record "Leave Period";
        Text05: Label 'Code de période de congé manquant';
        LeavePeriodCode: Code[10];
        LeavePeriodStartingMonth: Integer;
        LeavePeriodEndingMonth: Integer;
        PayrollSetup: Record Payroll_Setup;
        Text06: Label 'Période de congé clôturée';
        LeavePeriodStartingYear: Integer;
        LeavePeriodEndingYear: Integer;
        LeavePeriodStartingDate: Date;
        LeavePeriodEndingDate: Date;
        TerminationMonth: Integer;
        TerminationYear: Integer;
        TerminationDay: Integer;
        UniteSociete: Record "Company Business Unit";


    /// <summary>
    /// CalcLeaveRight.
    /// </summary>
    /// <returns>Return variable NbreofMonths of type Integer.</returns>
    procedure CalcLeaveRight() NbreofMonths: Integer;
    var
        EmployeePayrollItem2: Record "Employee Payroll Item";
        NbrePlus: Integer;
        NbreMinus: Integer;
    begin
        IF EmploymentYear < LeavePeriodStartingYear THEN
            NbrePlus := 12;
        IF EmploymentYear = LeavePeriodStartingYear THEN BEGIN
            IF EmploymentMonth <= LeavePeriodStartingMonth THEN
                NbrePlus := 12;
            IF EmploymentMonth > LeavePeriodStartingMonth THEN BEGIN
                NbrePlus := 12 - EmploymentMonth + 6;
                IF EmploymentDay < 15 THEN
                    NbrePlus := NbrePlus + 1;
            END;
        END;
        IF EmploymentYear = LeavePeriodEndingYear THEN BEGIN
            NbrePlus := 6 - EmploymentMonth;
            IF EmploymentDay < 15 THEN
                NbrePlus := NbrePlus + 1;
        END;
        IF DataItem7528."Termination Date" = 0D THEN
            NbreMinus := 0
        ELSE BEGIN
            TerminationDay := DATE2DMY(DataItem7528."Termination Date", 1);
            TerminationMonth := DATE2DMY(DataItem7528."Termination Date", 2);
            TerminationYear := DATE2DMY(DataItem7528."Termination Date", 3);
            IF TerminationYear = LeavePeriodStartingYear THEN BEGIN
                NbreMinus := 12 - TerminationMonth + 6;
                IF TerminationDay < 15 THEN
                    NbreMinus := NbreMinus + 1;
            END;
            IF TerminationYear = LeavePeriodEndingYear THEN BEGIN
                IF TerminationMonth <= LeavePeriodEndingMonth THEN BEGIN
                    NbreMinus := LeavePeriodEndingMonth - TerminationMonth;
                    IF TerminationDay < 15 THEN
                        NbreMinus := NbreMinus + 1;
                END;
            END;
        END;
        NbreofMonths := NbrePlus - NbreMinus;
        IF (EmploymentYear = TerminationYear) AND (EmploymentMonth = TerminationMonth) THEN BEGIN
            NbrePlus := TerminationDay - EmploymentDay;
            IF NbrePlus > 15 THEN
                NbreofMonths := 1
            ELSE
                NbreofMonths := 0;
        END;
    end;
}

