/// <summary>
/// Codeunit cod Etat de paiement (ID 52182442).
/// </summary>
codeunit 52182442 "cod Etat de paiement"
//codeunit 39108415 "cod Etat de paiement"
{
    // version HALRHPAIE


    trigger OnRun();
    begin
        //traitement('PA2009-01','ESPECE',montant);
        //MESSAGE('%1',montant);
    end;

    var
        payrollsetup: Record Payroll_Setup;
        payrollarchiveheader: Record "Payroll Archive Header";
        payrollarchiveline: Record "Payroll Archive Line";
        employee: Record 5200;
        montant: Decimal;
        Tab: Record "Tab Etat de paiement";

    /// <summary>
    /// traitement.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="P_mode">Text[30].</param>
    /// <param name="P_montant">VAR Decimal.</param>
    procedure traitement(P_codepaie: Code[20]; P_mode: Text[30]; var P_montant: Decimal);
    begin
        Tab.DELETEALL;
        Tab.INIT;

        P_montant := 0;
        payrollsetup.GET;
        payrollarchiveheader.RESET;
        payrollarchiveheader.SETRANGE("Payroll Code", P_codepaie);
        payrollarchiveheader.SETRANGE("Payment Method Code", P_mode);
        IF payrollarchiveheader.FINDSET THEN BEGIN
            payrollarchiveheader.FINDFIRST;
            REPEAT
                payrollarchiveline.GET(payrollarchiveheader."No.", P_codepaie, payrollsetup."Net Salary");
                employee.GET(payrollarchiveheader."No.");
                P_montant := P_montant + payrollarchiveline.Amount;
                //message('%1  %2  %3  %4',payrollarchiveheader."No.",employee."Last Name",employee."first Name",payrollarchiveline.amount);
                Tab.matricule := payrollarchiveheader."No.";
                Tab.Nomprenom := employee."Last Name" + '   ' + employee."First Name";
                Tab.Montant := payrollarchiveline.Amount;
                Tab.INSERT;
            UNTIL payrollarchiveheader.NEXT = 0;
        END;
    end;
}

