/// <summary>
/// Codeunit Charges patronales (ID 52182438).
/// </summary>
codeunit 52182438 "Charges patronales"
//codeunit 39108411 "Charges patronales"
{
    // version HALRHPAIE.6.1.05


    trigger OnRun();
    begin
    end;

    var
        ParamPaie: Record Payroll_Setup;
        RecapCharges: Record "Tab Recap des charges sociale";
        RecapChargesBis: Record "Tab Recap des charges sociale";
        Rubrique: Record "Payroll Item";
        EcriturePaie: Record "Payroll Entry";
        EcriturePaieBis: Record "Payroll Entry";
        nb: Integer;
        bs: Decimal;
        t: Decimal;
        ouv: Decimal;
        pat: Decimal;
        NbreSalaries: Integer;
        MntBase: Decimal;
        MntCharge: Decimal;
        NumLigne: Integer;

    /// <summary>
    /// CalcRub.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="P_NRub">Code[20].</param>
    /// <param name="P_bas">VAR Decimal.</param>
    /// <param name="P_Tx">VAR Decimal.</param>
    /// <param name="P_Nb">VAR Integer.</param>
    /// <param name="P_Ouv">VAR Decimal.</param>
    /// <param name="P_Pat">VAR Decimal.</param>
    /// <param name="bt">Boolean.</param>
    /// <param name="P_t">Decimal.</param>
    procedure CalcRub(P_codepaie: Code[20]; P_NRub: Code[20]; var P_bas: Decimal; var P_Tx: Decimal; var P_Nb: Integer; var P_Ouv: Decimal; var P_Pat: Decimal; bt: Boolean; P_t: Decimal);
    begin
        /*
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Payroll Code",P_codepaie);
        EcriturePaie.SETRANGE("Item Code",P_NRub);
        IF bt=TRUE THEN
        PayrollArchiveLine.SETRANGE(Rate,P_t);
        
        
        P_Nb:=0;
        P_Ouv:=0;
        P_bas:=0;
        P_Tx:=0;
        P_Pat:=0;
        IF PayrollArchiveLine.FINDSET THEN
        BEGIN
        PayrollArchiveLine.FINDFIRST;
        REPEAT
        P_Nb:=P_Nb+1;
        IF  PayrollArchiveLine.Amount<0 THEN
            P_Ouv:=P_Ouv-PayrollArchiveLine.Amount
        ELSE
            P_Pat:=P_Pat+PayrollArchiveLine.Amount;
        IF PayrollArchiveLine.Basis < 0 THEN P_bas:=P_bas - PayrollArchiveLine.Basis
        ELSE  P_bas:=P_bas + PayrollArchiveLine.Basis ;
        P_Tx:=PayrollArchiveLine.Rate;
        UNTIL  PayrollArchiveLine.NEXT=0;
        END
        ELSE
          IF bt=TRUE THEN  P_Tx:=t;
                              */

    end;

    /// <summary>
    /// Traitement.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    procedure Traitement(P_Paie: Code[20]);
    begin
        ParamPaie.GET;
        RecapCharges.RESET;
        RecapCharges.DELETEALL;
        Rubrique.GET(ParamPaie."Employer Cotisation");
        NumLigne := 0;
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Document No.", P_Paie);
        EcriturePaie.SETRANGE("Item Code", ParamPaie."Employer Cotisation");
        IF EcriturePaie.FINDFIRST THEN
            REPEAT
                RecapChargesBis.RESET;
                RecapChargesBis.SETRANGE(Taux, EcriturePaie.Rate);
                IF NOT RecapChargesBis.FINDFIRST THEN BEGIN
                    EcriturePaieBis.RESET;
                    EcriturePaieBis.SETRANGE("Document No.", P_Paie);
                    EcriturePaieBis.SETRANGE("Item Code", ParamPaie."Employer Cotisation");
                    EcriturePaieBis.SETRANGE(Rate, EcriturePaie.Rate);
                    MntBase := 0;
                    MntCharge := 0;
                    EcriturePaieBis.FINDFIRST;
                    REPEAT
                        MntBase := MntBase + EcriturePaieBis.Basis;
                        MntCharge := MntCharge + EcriturePaieBis.Amount;
                    UNTIL EcriturePaieBis.NEXT = 0;
                    RecapCharges.INIT;
                    NumLigne := NumLigne + 1;
                    RecapCharges.Numéro := NumLigne;
                    RecapCharges.Rubrique := ParamPaie."Employer Cotisation";
                    RecapCharges.Désignation := Rubrique.Description;
                    RecapCharges.Base := MntBase;
                    RecapCharges.Taux := EcriturePaie.Rate;
                    RecapCharges.Nombre := EcriturePaieBis.COUNT;
                    //RecapCharges."Part ouvrière"
                    RecapCharges."Charge patronale" := MntCharge;
                    RecapCharges."Nbre salariés" := EcriturePaieBis.COUNT;
                    RecapCharges.INSERT;
                END;
            UNTIL EcriturePaie.NEXT = 0;
    end;
}

