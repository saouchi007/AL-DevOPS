/// <summary>
/// Codeunit ATS (ID 52182448).
/// </summary>
codeunit 52182448 ATS
//codeunit 39108421 ATS
{
    // version HALRHPAIE.6.2.00


    trigger OnRun();
    begin
    end;

    var
        TableData: Record ATS;
        ParamPaie: Record Payroll_Setup;
        DateDebut: Date;
        DateFin: Date;
        Paie: Record Payroll;
        DatePaie: Text[30];
        FicheFiscale: Codeunit "Fiche fiscale";
        i: Integer;
        j: Integer;
        k: Integer;
        a: Text[30];
        Annee: Integer;
        Mois: Integer;
        EnteteArchivePaie: Record "Payroll Archive Header";
        LigneArchivePaie: Record "Payroll Archive Line";
        MotifAbsence: Record 5206;
        AbsenceConge: Decimal;
        GestionnairePaie: Record "Payroll Manager";
        PaieCompl: Text[30];
        Motif: Text[50];
        NbrTrav: Decimal;
        Rubrique: Record "Payroll Item";

    /// <summary>
    /// Inserer.
    /// </summary>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Mois">Integer.</param>
    /// <param name="P_Base">Decimal.</param>
    /// <param name="P_Retenue">Decimal.</param>
    /// <param name="P_Date">Text[30].</param>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_PaieCompl">Text[30].</param>
    /// <param name="P_Motif">Text[30].</param>
    procedure Inserer(P_Annee: Integer; P_Mois: Integer; P_Base: Decimal; P_Retenue: Decimal; P_Date: Text[30]; P_Paie: Code[20]; P_Salarie: Code[20]; P_PaieCompl: Text[30]; P_Motif: Text[30]);
    begin
        TableData.RESET;
        IF TableData.GET(P_Annee, P_Mois) THEN BEGIN
            TableData.FINDFIRST;
            TableData.Base := TableData.Base + P_Base;
            TableData.Retenue := TableData.Retenue + P_Retenue;
            TableData.MODIFY;
        END
        ELSE BEGIN
            TableData.INIT;
            TableData.Annee := P_Annee;
            TableData.Mois := P_Mois;
            TableData.Base := P_Base;
            TableData.Retenue := P_Retenue;
            TableData.Description := P_Date + ' ' + P_PaieCompl;
            TableData.PaieCompl := P_PaieCompl;
            TableData.Motif := P_Motif;
            EnteteArchivePaie.GET(P_Paie, P_Salarie);
            MotifAbsence.GET(ParamPaie."Leave Cause of Absence");
            AbsenceConge := 0;
            /*IF LigneArchivePaie.GET(P_Salarie,P_Paie,MotifAbsence."Item Code")THEN
              BEGIN
                AbsenceConge:=LigneArchivePaie.Number;
                LigneArchivePaie.GET(P_Salarie,P_Paie,ParamPaie."Base Salary");
                IF LigneArchivePaie.Basis=ROUND(LigneArchivePaie.Amount/ParamPaie."No. of Worked Days")THEN
                  AbsenceConge:=AbsenceConge*ParamPaie."No. of Worked Days";
              END;*/
            //TableData.Duree:=ParamPaie."No. of Worked Days"-EnteteArchivePaie."Total Absences Days"
            //-EnteteArchivePaie."Total Absences Hours"/ParamPaie."No. of Hours By Day"+AbsenceConge;

            // PM ADD
            IF LigneArchivePaie.GET(P_Salarie, P_Paie, ParamPaie."Base Salary") THEN BEGIN
                NbrTrav := LigneArchivePaie.Number;
            END;
            TableData.Duree := NbrTrav - EnteteArchivePaie."Total Absences Days"
             - EnteteArchivePaie."Total Absences Hours" / ParamPaie."No. of Hours By Day" + AbsenceConge;

            IF LigneArchivePaie.GET(P_Salarie, P_Paie, ParamPaie."No. of Days (Daily Vacatary)") THEN BEGIN
                NbrTrav := LigneArchivePaie.Number;
            END;
            TableData.Duree := NbrTrav - EnteteArchivePaie."Total Absences Days" + AbsenceConge;

            //pm
            IF LigneArchivePaie.GET(P_Salarie, P_Paie, '045')
            OR LigneArchivePaie.GET(P_Salarie, P_Paie, '145')
            OR LigneArchivePaie.GET(P_Salarie, P_Paie, '050')
            OR LigneArchivePaie.GET(P_Salarie, P_Paie, '053')
            OR LigneArchivePaie.GET(P_Salarie, P_Paie, '055')

            THEN BEGIN
                Motif := LigneArchivePaie."Item Description" + ' (' + FORMAT(LigneArchivePaie.Number) + ' Jours)';
            END;


            // PM ADD
            //souhila add
            TableData.Motif := Motif;
            //fin souhila add



            IF NOT Paie."Regular Payroll"
              THEN
                IF LigneArchivePaie.GET(P_Salarie, P_Paie, '222') THEN BEGIN
                    NbrTrav := LigneArchivePaie.Number;
                END;
            TableData.Duree := NbrTrav - EnteteArchivePaie."Total Absences Days" + AbsenceConge;
            //souhila add

            IF NOT Paie."Regular Payroll"
               THEN BEGIN
                Motif := 'Indemnité de congé Annuel';
            END;
            TableData.Motif := Motif;
            // TableData.Motif:=EnteteArchivePaie.Observation;
            //fin souhila add


            TableData.INSERT;
            Motif := '';
        END;

    end;

    /// <summary>
    /// Traitement.
    /// </summary>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_MoisDebut">Integer.</param>
    /// <param name="P_MoisFin">Integer.</param>
    /// <param name="P_AnneeDebut">Integer.</param>
    /// <param name="P_AnneeFin">Integer.</param>
    procedure Traitement(P_Salarie: Code[20]; P_MoisDebut: Integer; P_MoisFin: Integer; P_AnneeDebut: Integer; P_AnneeFin: Integer);
    begin
        ParamPaie.GET;
        GestionnairePaie.GET(USERID);
        TableData.DELETEALL;
        DateDebut := DMY2DATE(1, P_MoisDebut, P_AnneeDebut);
        CASE P_MoisFin OF
            1, 3, 5, 7, 8, 10, 12:
                i := 31;
            4, 6, 9, 11:
                i := 30;
            2:
                IF P_AnneeFin MOD 4 = 0 THEN
                    i := 29
                ELSE
                    i := 28;
        END;
        DateFin := DMY2DATE(i, P_MoisFin, P_AnneeFin);
        Paie.RESET;
        Paie.SETFILTER("Ending Date", '%1..%2', DateDebut, DateFin);
        //Paie.SETRANGE("Regular Payroll",TRUE);
        Paie.FINDFIRST;
        REPEAT
            DatePaie := FORMAT(Paie."Ending Date", 0, 4);
            DatePaie := COPYSTR(DatePaie, 4, STRLEN(DatePaie) - 3);
            Mois := DATE2DMY(Paie."Ending Date", 2);
            Annee := DATE2DMY(Paie."Ending Date", 3);
            IF Paie."Regular Payroll" THEN
                PaieCompl := '.'
            ELSE
                PaieCompl := 'Congé';
            IF LigneArchivePaie.GET(P_Salarie, Paie.Code, ParamPaie."Employee SS Deduction") THEN
                Inserer(Annee, Mois, LigneArchivePaie.Basis, -LigneArchivePaie.Amount, DatePaie,
              Paie.Code, P_Salarie, PaieCompl, Motif);
        UNTIL Paie.NEXT = 0;
        /*
     IF Paie."Regular Payroll"THEN
       BEGIN
         Paie.SETRANGE("Regular Payroll",FALSE);
         Paie.FINDFIRST;
         REPEAT
           DatePaie:=FORMAT(Paie."Ending Date",0,4);
           DatePaie:=COPYSTR(DatePaie,4,STRLEN(DatePaie)-3);
           Mois:=DATE2DMY(Paie."Ending Date",2);
           Annee:=DATE2DMY(Paie."Ending Date",3);
           PaieCompl:='Congé';
           IF LigneArchivePaie.GET(P_Salarie,Paie.Code,ParamPaie."Employee SS Deduction")THEN
           Inserer(Annee,Mois,LigneArchivePaie.Basis,-LigneArchivePaie.Amount,DatePaie,
           Paie.Code,P_Salarie,PaieCompl,Motif);
         UNTIL Paie.NEXT=0;
       END;    */

    end;
}

