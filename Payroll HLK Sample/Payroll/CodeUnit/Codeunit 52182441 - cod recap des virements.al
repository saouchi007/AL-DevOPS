/// <summary>
/// Codeunit cod recap des virements (ID 52182441).
/// </summary>
codeunit 52182441 "cod recap des virements"
//codeunit 39108414 "cod recap des virements"
{
    // version HALRHPAIE


    trigger OnRun();
    begin

        //insererligne('S000002','PA2009-01','LC','001');
        //Traitement('PA2009-01');
    end;

    var
        PyrollArchiveLine: Record "Payroll Archive Line";
        payrollsetup: Record Payroll_Setup;
        tab: Record "tab recap des virements";
        PaymentMethod: Record 289;
        PayrollBankAccount: Record "Payroll Bank Account";
        compteur: Integer;
        PayrollArchiveHeader: Record "Payroll Archive Header";
        s: Text[30];

    procedure InsererLigne("P_salarié": Code[20]; P_codepaie: Code[20]; P_modepaie: Code[10]; CompteBank: Code[10]);
    begin
        payrollsetup.GET;
        PyrollArchiveLine.RESET;
        PyrollArchiveLine.SETRANGE("Employee No.", P_salarié);
        PyrollArchiveLine.SETRANGE("Payroll Code", P_codepaie);
        PyrollArchiveLine.SETRANGE("Item Code", payrollsetup."Net Salary");
        PyrollArchiveLine.FINDFIRST;


        tab.RESET;
        tab.SETRANGE(modepaie, P_modepaie);
        IF (P_modepaie <> 'ESPECE') AND (P_modepaie <> 'CHEQUE') THEN tab.SETRANGE("No agence", CompteBank);
        IF tab.FINDSET THEN BEGIN
            tab.FINDFIRST;
            tab.montant := tab.montant + PyrollArchiveLine.Amount;
            tab.MODIFY;
        END
        ELSE BEGIN
            PaymentMethod.GET(P_modepaie);

            // compteur:=compteur+1;
            tab.INIT;
            //tab.No:=compteur;
            tab.modepaie := P_modepaie;
            tab.NomMode := PaymentMethod.Description;

            IF (P_modepaie <> 'ESPECE') AND (P_modepaie <> 'CHEQUE') THEN BEGIN
                PayrollBankAccount.GET(CompteBank);
                tab."No agence" := CompteBank;

                tab."Nom agence" := PayrollBankAccount.Name;
            END;

            tab.montant := PyrollArchiveLine.Amount;
            tab.INSERT;
        END;
    end;

    procedure Traitement(P_codepaie: Code[20]);
    begin
        tab.DELETEALL;
        PayrollArchiveHeader.RESET;
        PayrollArchiveHeader.SETRANGE("Payroll Code", P_codepaie);
        PayrollArchiveHeader.FINDFIRST;
        REPEAT
            IF PayrollArchiveHeader."Payment Method Code" <> '' THEN
                IF ((PayrollArchiveHeader."Payment Method Code" <> 'ESPECE') AND (PayrollArchiveHeader."Payment Method Code" <> 'CHEQUE') AND
                   (PayrollArchiveHeader."Payroll Bank Account" <> '')) OR (PayrollArchiveHeader."Payment Method Code" = 'ESPECE') OR
                   (PayrollArchiveHeader."Payment Method Code" = 'CHEQUE') THEN
                    InsererLigne(PayrollArchiveHeader."No.", P_codepaie, PayrollArchiveHeader."Payment Method Code",
                      PayrollArchiveHeader."Payroll Bank Account");
        UNTIL PayrollArchiveHeader.NEXT = 0;

        reglage;
    end;

    procedure reglage();
    begin
        tab.RESET;
        tab.FINDFIRST;
        s := tab.NomMode;
        tab.NEXT;
        REPEAT
            IF (tab.NomMode = s) THEN BEGIN
                tab.NomMode := '';
                tab.MODIFY;
            END
            ELSE
                s := tab.NomMode;
        UNTIL tab.NEXT = 0;
    end;
}

