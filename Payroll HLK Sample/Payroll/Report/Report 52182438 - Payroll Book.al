/// <summary>
/// Report Payroll Book (ID 52182438).
/// </summary>
report 52182438 "Payroll Book"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Payroll Book.rdl';
    Caption = 'Journal de Paie';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem7528; 5200)
        {
            DataItemTableView = SORTING("No.");
            column(dat; dat)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(Employee__First_Name_; "First Name")
            {
            }
            column(Employee__Function_Description_; "Job Title")
            {
            }
            column(Mois__Caption; Mois__CaptionLbl)
            {
            }
            column(JOURNAL_DE_PAIECaption; JOURNAL_DE_PAIECaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem(DataItem6518; "Payroll Entry")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Employee No.", "Item Code");
                column(Payroll_Entry__Item_Code_; "Item Code")
                {
                }
                column(Payroll_Entry__Item_Description_; "Item Description")
                {
                }
                column(bas; bas)
                {
                }
                column(Payroll_Entry_Rate; Rate)
                {
                }
                column(Gain; Gain)
                {
                }
                column(Retenue; Retenue)
                {
                }
                column(Payroll_Entry_Number; Number)
                {
                }
                column(TotalGain; TotalGain)
                {
                }
                column(TotalRetenue_____1_; TotalRetenue * (-1))
                {
                }
                column(net; net)
                {
                }
                column(RetenuesCaption; RetenuesCaptionLbl)
                {
                }
                column(GainsCaption; GainsCaptionLbl)
                {
                }
                column(TauxCaption; TauxCaptionLbl)
                {
                }
                column(BaseCaption; BaseCaptionLbl)
                {
                }
                column("LibelléCaption"; LibelléCaptionLbl)
                {
                }
                column(RubCaption; RubCaptionLbl)
                {
                }
                column(NbreCaption; NbreCaptionLbl)
                {
                }
                column(Total_gains_et_retenuesCaption; Total_gains_et_retenuesCaptionLbl)
                {
                }
                column(Salaire_NetCaption; Salaire_NetCaptionLbl)
                {
                }
                column(Payroll_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Payroll_Entry_Employee_No_; "Employee No.")
                {
                }
                column(Base_Salary_Without_Indemnity_____1; PayrollSetup."Base Salary Without Indemnity")
                {
                }
                column(Taxable_Salary_____2; PayrollSetup."Taxable Salary")
                {
                }
                column(Employer_Cotisation_____3; PayrollSetup."Employer Cotisation")
                {
                }
                column(Post_Salary_________4; PayrollSetup."Post Salary")
                {
                }
                column(Net_Salary________5; PayrollSetup."Net Salary")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PayrollSetup.GET;
                    IF "Item Code" = PayrollSetup."Employer Cotisation" THEN
                        PartPatronale := Amount;
                    IF "Item Code" = PayrollSetup."Post Salary" THEN
                        SalairePoste := Amount;
                    IF (Category = DataItem6518.Category::Employer)
                    OR (DataItem6518."Document No." <> DataItem8955.Code) THEN
                        CurrReport.SKIP;
                    IF Amount < 0 THEN
                        TotalRetenue := TotalRetenue + Amount
                    ELSE
                        IF ("Item Code" <> PayrollSetup."Post Salary") AND ("Item Code" <> PayrollSetup."Net Salary")
                        AND ("Item Code" <> PayrollSetup."Brut Salary") AND ("Item Code" <> PayrollSetup."Employer Cotisation")
                        AND ("Item Code" <> PayrollSetup."Taxable Salary") AND ("Item Code" <> PayrollSetup."Base Salary Without Indemnity") THEN
                            TotalGain := TotalGain + Amount;

                    IF ("Item Code" = PayrollSetup."Net Salary") THEN net := Amount;
                    ;



                    IF Amount < 0 THEN BEGIN
                        Gain := 0;
                        IF OptRetenueNegative1 THEN
                            Retenue := Amount
                        ELSE
                            Retenue := -1 * Amount;
                    END
                    ELSE BEGIN
                        Gain := Amount;
                        Retenue := 0;
                    END;

                    IF Basis < 0 THEN
                        bas := Basis * (-1)
                    ELSE
                        bas := Basis;


                    //*************
                    IF PrintToExcel AND CurrReport.SHOWOUTPUT THEN
                        MakeExcelDataBody;



                    //*************
                    IF PrintToExcel THEN
                        MakeExcelDataFooter;
                end;
            }

            trigger OnAfterGetRecord();
            begin

                TotalRetenue := 0;
                TotalGain := 0;
                /*
                IF (DataItem7528."Company Business Unit Code"<> coddir.direction) THEN
                  CurrReport.SKIP;
                 */
                IF PayrollManager."Company Business Unit Code" <> '' THEN
                    IF DataItem7528."Company Business Unit Code" <> StructureCode THEN
                        CurrReport.SKIP;
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE(PayrollEntry."Document No.", CodePaie);
                PayrollEntry.SETRANGE(PayrollEntry."Employee No.", "No.");
                IF PayrollEntry.ISEMPTY THEN
                    CurrReport.SKIP;
                StructureDescription := '';
                IF "Structure Code" <> '' THEN
                    IF Structure.GET("Structure Code") THEN
                        StructureDescription := Structure.Description;

                SituationF := "Marital Status";
                IF SituationF = 0 THEN SituationFM := 'C';
                IF SituationF = 1 THEN SituationFM := 'M';
                IF SituationF = 2 THEN SituationFM := 'D';
                IF SituationF = 3 THEN SituationFM := 'V';
                IF "No. of Children" < 10 THEN
                    SituationFM := SituationFM + ' 0' + FORMAT("No. of Children")
                ELSE
                    SituationFM := SituationFM + ' ' + FORMAT("No. of Children");

                //calcul du solde congé
                /*
                LeaveRight.RESET;
                LeaveRight.SETRANGE("Employee No.",DataItem7528."No.");
                LeaveRight.FINDFIRST;
                REPEAT
                SoldeCongé:= SoldeCongé+LeaveRight.Difference;
                UNTIL LeaveRight.NEXT=0;  */


                dat := FORMAT(DataItem8955."Ending Date", 0, 4);
                dat := COPYSTR(dat, 4, STRLEN(dat) - 3);
                CompanyInformation.GET;


                IF PrintToExcel THEN
                    MakeExcelDataHeader;


                IF OptRetenueNegative1 THEN
                    TotalRetenueAffiche := TotalRetenue
                ELSE
                    TotalRetenueAffiche := -1 * TotalRetenue;

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
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Imprimer dans Excel';
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
            ERROR(Text06, USERID);
    end;

    trigger OnPostReport();
    begin
        IF PrintToExcel THEN
            CreateExcelbook;
    end;

    trigger OnPreReport();
    begin
        IF DataItem8955.GETFILTERS = '' THEN
            ERROR(Text01);
        DataItem8955.COPYFILTER(Code, Payroll2.Code);
        DataItem8955.COPYFILTER(Code, PayrollEntry."Document No.");
        Payroll2.FINDFIRST;
        CodePaie := Payroll2.Code;
        PayrollDescription := Payroll2.Description;
        IF PayrollEntry.ISEMPTY THEN
            ERROR(Text07, CodePaie);
        StructureCode := Payroll2."Company Business Unit Code";
        IF StructureCode = '' THEN
            ERROR(Text08, CodePaie);
        Employee2.RESET;
        DataItem7528.COPYFILTER("No.", Employee2."No.");
        Employee2.SETRANGE(Employee2."Company Business Unit Code", StructureCode);
        ParamCompta.GET;
        Employee2.SETRANGE(Status, Employee2.Status::Active);
        IF Employee2.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF ParamCompta."Global Dimension 1 Code" <> '' THEN
                    Employee2.TESTFIELD(Employee2."Global Dimension 1 Code");
                IF ParamCompta."Global Dimension 2 Code" <> '' THEN
                    Employee2.TESTFIELD(Employee2."Global Dimension 2 Code");
            UNTIL Employee2.NEXT = 0
        ELSE
            ERROR(Text02, StructureCode);
        CompanyBusinessUnit.GET(StructureCode);
        BusinessUnitDescription := CompanyBusinessUnit.Code + ' - ' + CompanyBusinessUnit.Name;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        CompanyInfo.CALCFIELDS("Right Logo");
        "EmployerSSNo." := CompanyInfo."Employer SS No.";
        TauxPartPatronale := '[' + FORMAT(PayrollSetup."Employer Cotisation %") + ' %]';



        /////////
        IF PrintToExcel THEN BEGIN
            /*ExcelBuf.DELETEALL;*/
            MakeExcelInfo;
        END;

    end;

    var
        Text01: Label 'Code de paie manquant !';
        Text02: Label 'Aucun salarié n''est affecté à la direction %1 !';
        Text04: Label 'A Monsieur le Directeur de :';
        Text05: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text07: Label 'Paie %1 non encore calculée  !';
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        PayrollManager: Record "Payroll Manager";
        StructureCode: Code[10];
        Payroll2: Record Payroll;
        CodePaie: Code[20];
        PayrollEntry: Record "Payroll Entry";
        Employee2: Record 5200;
        CompanyBusinessUnit: Record "Company Business Unit";
        BusinessUnitDescription: Text[50];
        CompanyInfo: Record 79;
        PayrollDescription: Text[60];
        "EmployerSSNo.": Text[30];
        PayrollSetup: Record Payroll_Setup;
        StructureDescription: Text[50];
        Structure: Record Structure;
        TotalGain: Decimal;
        TotalRetenue: Decimal;
        SalairePoste: Decimal;
        PartPatronale: Decimal;
        TauxPartPatronale: Text[30];
        OptAnciennete: Boolean;
        OptDateEntree: Boolean;
        OptRetenueNegative1: Boolean;
        Anciennete: Text[30];
        Gain: Decimal;
        Retenue: Decimal;
        TotalRetenueAffiche: Decimal;
        SituationF: Integer;
        SituationFM: Text[30];
        "SoldeCongé": Decimal;
        LeaveRight: Record "Leave Right";
        net: Decimal;
        dat: Text[30];
        bas: Decimal;
        CompanyInformation: Record 79;
        ParamCompta: Record 98;
        coddir: Codeunit "cod direction";
        PrintToExcel: Boolean;
        Text001: Label 'Nom de l''etat';
        Text002: Label 'Journal de paie';
        Text003: Label 'Données';
        Text004: Label 'Mois :';
        Mois__CaptionLbl: Label 'Mois :';
        JOURNAL_DE_PAIECaptionLbl: Label 'JOURNAL DE PAIE';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        RetenuesCaptionLbl: Label 'Retenues';
        GainsCaptionLbl: Label 'Gains';
        TauxCaptionLbl: Label 'Taux';
        BaseCaptionLbl: Label 'Base';
        "LibelléCaptionLbl": Label 'Libellé';
        RubCaptionLbl: Label 'Rub';
        NbreCaptionLbl: Label 'Nbre';
        Total_gains_et_retenuesCaptionLbl: Label 'Total gains et retenues';
        Salaire_NetCaptionLbl: Label 'Salaire Net';


    procedure MakeExcelInfo();
    begin

        /*ExcelBuf.SetUseInfoSheed;
        ExcelBuf.AddInfoColumn(FORMAT(Text001),FALSE,'',TRUE,FALSE,FALSE,'');
        ExcelBuf.AddInfoColumn(FORMAT(Text002),FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text004),FALSE,'',TRUE,FALSE,FALSE,'');
        //ExcelBuf.AddInfoColumn(dat,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.ClearNewRow;*/

    end;

    procedure MakeExcelDataHeader();
    begin
        /*ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(DataItem7528."No.",FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(DataItem7528."Last Name" +'  '+ DataItem7528."First Name",FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(DataItem7528."Function Description",FALSE,'',TRUE,FALSE,TRUE,'');
        
        MakeExcelDataHeader2;*/

    end;

    procedure MakeExcelDataHeader2();
    begin
        /*ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Rubrique',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Libellé',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Base',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Taux',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Nombre',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Gains',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Retenues',FALSE,'',TRUE,FALSE,TRUE,'');*/

    end;

    procedure MakeExcelDataBody();
    var
        GETFILTER: Integer;
    begin

        /*ExcelBuf.NewRow;
        ExcelBuf.AddColumn(DataItem6518."Item Code",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(DataItem6518."Item Description",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(bas,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(DataItem6518.Rate,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(DataItem6518.Number,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(Gain,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(Retenue,FALSE,'',FALSE,FALSE,FALSE,'');*/

    end;

    procedure MakeExcelDataFooter();
    begin
        /*ExcelBuf.NewRow;
        
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Salaire Net',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(net,FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Total Gains Et Retenues',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(TotalGain,FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(TotalRetenue,FALSE,'',TRUE,FALSE,TRUE,'');*/

    end;

    procedure CreateExcelbook();
    begin

        /*ExcelBuf.CreateBook;
        ExcelBuf.CreateSheet(Text003,Text001,COMPANYNAME,USERID);
        ExcelBuf.GiveUserControl;
        ERROR('');*/

    end;
}

