/// <summary>
/// Codeunit cod ressources hum (ID 52182445).
/// </summary>
codeunit 52182445 "cod ressources hum"
//codeunit 39108418 "cod ressources hum"
{
    // version HALRHPAIE.6.1.01


    trigger OnRun();
    begin
        traitement('PA2002-01');
    end;

    var
        CompanyBusinessUnit: Record "Company Business Unit";
        tab: Record "Tab ressources hum";
        PayrollArchiveHeader: Record "Payroll Archive Header";
        SocioprofessionalCategory: Record "Socio-professional Category";
        compt: Integer;
        EmploymentContractType: Record 5211;
        tab2: Record "Tab ressources hum";
        employee: Record 5200;
        tabb: Record "Tab ressources hum2";
        tabb2: Record "Tab ressources hum2";
        cod: Codeunit "Fiche fiscale";
        a: Code[10];
        m: Code[10];
        x: Integer;

    /// <summary>
    /// traitement.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    procedure traitement(P_codepaie: Code[20]);
    begin
        tab.DELETEALL;

        CompanyBusinessUnit.RESET;
        CompanyBusinessUnit.FINDSET;
        REPEAT
            tab.INIT;
            tab.codDir := CompanyBusinessUnit.Code;
            tab.NameDir := CompanyBusinessUnit.Name;
            tab.INSERT;
            PayrollArchiveHeader.RESET;
            PayrollArchiveHeader.SETRANGE("Payroll Code", P_codepaie);
            PayrollArchiveHeader.SETRANGE("Company Business Unit Code", CompanyBusinessUnit.Code);
            IF (PayrollArchiveHeader.FINDSET) THEN BEGIN
                PayrollArchiveHeader.FINDFIRST;
                REPEAT
                    inserer(PayrollArchiveHeader."Emplymt. Contract Type Code", PayrollArchiveHeader."Socio-Professional Category",
                    CompanyBusinessUnit.Code);

                UNTIL PayrollArchiveHeader.NEXT = 0;

            END;
        UNTIL CompanyBusinessUnit.NEXT = 0;

        /////////replir tableau 2
        tabb.DELETEALL;
        CompanyBusinessUnit.RESET;
        CompanyBusinessUnit.FINDSET;
        REPEAT
            tabb.INIT;
            tabb.codDir := CompanyBusinessUnit.Code;
            tabb.NameDir := CompanyBusinessUnit.Name;
            tabb.INSERT;

            employee.RESET;
            employee.SETRANGE("Company Business Unit Code", CompanyBusinessUnit.Code);
            IF (employee.FINDSET) THEN BEGIN
                employee.FINDFIRST;
                REPEAT
                    cod.RecupAM(P_codepaie, a, m);
                    x := 0;
                    //message('%1 %2',copystr(format(employee."Employment Date"),4,strlen(format(employee."Employment Date"))-3), m+'/'+copystr(a,3,2));

                    IF FORMAT(employee."Employment Date") <> '' THEN
                        IF (COPYSTR(FORMAT(employee."Employment Date"), 4, STRLEN(FORMAT(employee."Employment Date")) - 3) = m + '/' + COPYSTR(a, 3, 2)) THEN
                            x := 1;
                    IF FORMAT(employee."Termination Date") <> '' THEN
                        IF (COPYSTR(FORMAT(employee."Termination Date"), 4, STRLEN(FORMAT(employee."Termination Date")) - 3) = m + '/' + COPYSTR(a, 3, 2)) THEN
                            x := 2;
                    IF x <> 0 THEN inserer2(x, employee."Socio-Professional Category", CompanyBusinessUnit.Code);
                //message('%1    %2',employee."no.",x);


                UNTIL employee.NEXT = 0;
            END;
        UNTIL CompanyBusinessUnit.NEXT = 0;
    end;

    /// <summary>
    /// inserer.
    /// </summary>
    /// <param name="P_codetype">Code[10].</param>
    /// <param name="P_codecat">Code[10].</param>
    /// <param name="P_codedir">Code[20].</param>
    procedure inserer(P_codetype: Code[10]; P_codecat: Code[10]; P_codedir: Code[20]);
    begin
        SocioprofessionalCategory.RESET;
        //MESSAGE('coucou');
        SocioprofessionalCategory.FINDFIRST;
        compt := 0;
        REPEAT
            compt := compt + 1;
            //message('%1  ===   %2',SocioprofessionalCategory.Code,P_codecat);
            IF SocioprofessionalCategory.Code = P_codecat THEN BEGIN
                tab2.GET(P_codedir);
                CASE compt OF
                    1:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi1 := tab2.cdi1 + 1
                        ELSE
                            tab2.cdd1 := tab2.cdd1 + 1;
                    2:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi2 := tab2.cdi2 + 1
                        ELSE
                            tab2.cdd2 := tab2.cdd2 + 1;
                    3:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi3 := tab2.cdi3 + 1
                        ELSE
                            tab2.cdd3 := tab2.cdd3 + 1;
                    4:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi4 := tab2.cdi4 + 1
                        ELSE
                            tab2.cdd4 := tab2.cdd4 + 1;
                    5:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi5 := tab2.cdi5 + 1
                        ELSE
                            tab2.cdd5 := tab2.cdd5 + 1;
                    6:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi6 := tab2.cdi6 + 1
                        ELSE
                            tab2.cdd6 := tab2.cdd6 + 1;
                    7:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi7 := tab2.cdi7 + 1
                        ELSE
                            tab2.cdd7 := tab2.cdd7 + 1;
                    8:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi8 := tab2.cdi8 + 1
                        ELSE
                            tab2.cdd8 := tab2.cdd8 + 1;
                    9:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi9 := tab2.cdi9 + 1
                        ELSE
                            tab2.cdd9 := tab2.cdd9 + 1;
                    10:
                        IF (P_codetype = 'CDI') THEN
                            tab2.cdi10 := tab2.cdi10 + 1
                        ELSE
                            tab2.cdd10 := tab2.cdd10 + 1;
                END;
                tab2.MODIFY;


            END;
        UNTIL SocioprofessionalCategory.NEXT = 0;
    end;

    /// <summary>
    /// inserer2.
    /// </summary>
    /// <param name="P_x">Integer.</param>
    /// <param name="P_codecat">Code[10].</param>
    /// <param name="P_codedir">Code[20].</param>
    procedure inserer2(P_x: Integer; P_codecat: Code[10]; P_codedir: Code[20]);
    begin
        SocioprofessionalCategory.RESET;
        //MESSAGE('coucou');
        SocioprofessionalCategory.FINDFIRST;
        compt := 0;
        REPEAT
            compt := compt + 1;
            //message('%1  ===   %2',SocioprofessionalCategory.Code,P_codecat);
            IF SocioprofessionalCategory.Code = P_codecat THEN BEGIN
                tabb2.GET(P_codedir);
                CASE compt OF
                    1:
                        IF (x = 1) THEN
                            tabb2.A1 := tabb2.A1 + 1
                        ELSE
                            tabb2.D1 := tabb2.D1 + 1;
                    2:
                        IF (x = 1) THEN
                            tabb2.A2 := tabb2.A2 + 1
                        ELSE
                            tabb2.D2 := tabb2.D2 + 1;
                    3:
                        IF (x = 1) THEN
                            tabb2.A3 := tabb2.A3 + 1
                        ELSE
                            tabb2.D3 := tabb2.D3 + 1;
                    4:
                        IF (x = 1) THEN
                            tabb2.A4 := tabb2.A4 + 1
                        ELSE
                            tabb2.D4 := tabb2.D4 + 1;
                    5:
                        IF (x = 1) THEN
                            tabb2.A5 := tabb2.A5 + 1
                        ELSE
                            tabb2.D5 := tabb2.D5 + 1;
                    6:
                        IF (x = 1) THEN
                            tabb2.A6 := tabb2.A6 + 1
                        ELSE
                            tabb2.D6 := tabb2.D6 + 1;
                    7:
                        IF (x = 1) THEN
                            tabb2.A7 := tabb2.A7 + 1
                        ELSE
                            tabb2.D7 := tabb2.D7 + 1;
                    8:
                        IF (x = 1) THEN
                            tabb2.A8 := tabb2.A8 + 1
                        ELSE
                            tabb2.D8 := tabb2.D8 + 1;
                    9:
                        IF (x = 1) THEN
                            tabb2.A9 := tabb2.A9 + 1
                        ELSE
                            tabb2.D9 := tabb2.D9 + 1;
                    10:
                        IF (x = 1) THEN
                            tabb2.A10 := tabb2.A10 + 1
                        ELSE
                            tabb2.D10 := tabb2.D10 + 1;
                END;
                tabb2.MODIFY;


            END;
        UNTIL SocioprofessionalCategory.NEXT = 0;
    end;
}

