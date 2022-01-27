/// <summary>
/// Report Employee Data Control (ID 51451).
/// </summary>
report 52182458 "Employee Data Control"
{
    // version HALRHPAIEKarim

    Caption = 'Contrôle des données salarié';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem7528; 5200)
        {

            trigger OnAfterGetRecord();
            begin
                //CALCFIELDS("Function Description");
                //CALCFIELDS("Structure Description");
                IF (Status = Employee.Status::Inactive) OR (Employee."Company Business Unit Code" <> CodeUnite) THEN
                    CurrReport.SKIP;
                NomSalarie := Employee."Last Name" + ' ' + Employee."First Name";
                IF Address = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION(Address));
                IF "Last Name" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Last Name"));
                IF "Job Title" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Job Title"));
                IF "First Name" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("First Name"));
                IF "Social Security No." = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Social Security No."));
                IF "Emplymt. Contract Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Emplymt. Contract Code"));
                IF "Birth Date" = 0D THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Birth Date"));
                IF "Employment Date" = 0D THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Employment Date"));
                IF "Global Dimension 1 Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Global Dimension 1 Code"));
                IF "Global Dimension 2 Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Global Dimension 2 Code"));
                IF "Marital Status" = 0 THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Marital Status"));
                IF "Company Business Unit Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Company Business Unit Code"));
                IF "Section Grid Class" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Section Grid Class"));
                IF "Section Grid Section" = 0 THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Section Grid Section"));
                IF "Structure Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Structure Code"));
                IF "Function Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Function Code"));
                IF "Structure Description" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Structure Description"));
                IF "Socio-Professional Category" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Socio-Professional Category"));
                IF "Payment Method Code" = '' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION("Payment Method Code"));
                IF Employee.StatutPay <> 'CALCULÉ' THEN
                    CreateWarning("No.", NomSalarie, FIELDCAPTION(StatutPay));
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
        accesspay.accesstopay;
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(TEXT04, USERID);
        UniteSociete.GET(GestionnairePaie."Company Business Unit Code");
        CodeUnite := UniteSociete.Code;
    end;

    trigger OnPostReport();
    begin
        MESSAGE('Traitement terminé, veuillez vérifier les résultats dans le Journal d''erreurs');
    end;

    trigger OnPreReport();
    begin
        ConstatationWarning.RESET;
        ConstatationWarning.DELETEALL;
    end;

    var
        Employee: Record 5200;
        GestionnairePaie: Record "Payroll Manager";
        UniteSociete: Record "Company Business Unit";
        CodeUnite: Code[10];
        TEXT04: Label 'UTILISATEUR NON CONFIGURE';
        ConstatationWarning: Record "Payroll Constatation Warning";
        NomSalarie: Text[100];
        accesspay: Codeunit "Tools Library";

    procedure CreateWarning(P_Salarie: Code[20]; P_NomSalarie: Text[200]; P_Warning: Text[200]);
    begin
        ConstatationWarning.INIT;
        ConstatationWarning."Employee No." := P_Salarie;
        ConstatationWarning.Field := P_Warning;
        ConstatationWarning.Name := P_NomSalarie;
        ConstatationWarning.INSERT;
    end;
}

