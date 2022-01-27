/// <summary>
/// Report Déclaration ATS Page 1 (ID 52182466).
/// </summary>
report 52182466 "Déclaration ATS Page 1"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Déclaration ATS Page 1.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(Tab_Releve_des_emoluments_base; "Social Security No.")
            {
            }
            column(Adresse; Adresse)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
            {
            }
            column(Companyadress; Companyadress)
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(Employee__First_Name_; "First Name")
            {
            }
            column(Employee__Birth_Date_; "Birth Date")
            {
            }
            column(Employee__Birthplace_City_; "Birthplace City")
            {
            }
            column(Employee__Function_Description_; "Job Title")
            {
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
            }
            column(Unite__Agence_CNAS_; Unite."Agence CNAS")
            {
            }
            column(Unite__CNAS_Center_; Unite."CNAS Center")
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(NomPrenom; NomPrenom)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Employee.Get("No.");
                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                IF ParamUtilisateur."Company Business Unit" = '' THEN
                    ERROR(Text05);
                IF NOT Employee.GET("No.") THEN
                    ERROR(Text07, "No.")
                ELSE
                    IF Employee."Company Business Unit Code" <> ParamUtilisateur."Company Business Unit" THEN
                        ERROR(Text06, "No.", ParamUtilisateur."Company Business Unit");
                IF Employee.Status = Employee.Status::Inactive THEN
                    ERROR(Text08, "No.");
                //Employee.CALCFIELDS("Function Description");


                NomPrenom := Employee."Last Name" + ' ' + Employee."First Name";
                Adresse := Employee.Address + ' ' + Employee."Address 2" + ' ' + Employee.City + ' ' + Employee."Post Code";
                Companyadress := CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + ' ' + CompanyInformation.City;
            end;

            trigger OnPostDataItem();
            begin
                Employee.Get("No.");
                //IF Employee.GETFILTERS = '' THEN
                //  ERROR('veuillez selectionner un salarié dans l onglet salarié');
            end;

            trigger OnPreDataItem();
            begin

                //CALCFIELDS("Function Description");
                Adresse := CompanyInformation.Address;
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

        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);

        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text06, USERID);
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        CompanyInformation.CALCFIELDS("Right Logo");
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
    end;

    var
        CompanyInformation: Record 79;
        Employee: Record 5200;
        ParamUtilisateur: Record 91;
        Unite: Record "Company Business Unit";
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        PayrollManager: Record "Payroll Manager";
        NomPrenom: Text[80];
        Adresse: Text[100];
        Companyadress: Text[100];
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text07: Label 'Salarié %1 inexistant !';
        Text08: Label 'Salarié %1 inactif !';

}

