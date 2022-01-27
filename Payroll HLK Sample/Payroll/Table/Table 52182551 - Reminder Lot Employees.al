/// <summary>
/// Table Reminder Lot Employees (ID 52182551).
/// </summary>
table 52182551 "Reminder Lot Employees"
//table 39108642 "Reminder Lot Employees"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Rubriques de lot de rappel';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'N°';
            TableRelation = "Payroll Reminder Lot";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N° Salarié';
            TableRelation = Employee;

            trigger OnValidate();
            begin
                //Salarie.CALCFIELDS(Salarie."Function Description");
                //Salarie.CALCFIELDS(Salarie."Structure Description");
                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                IF ParamUtilisateur."Company Business Unit" = '' THEN
                    ERROR(Text05);
                IF NOT Salarie.GET("Employee No.") THEN
                    ERROR(Text01, "Employee No.")
                ELSE
                    /*
                      IF Salarie."Company Business Unit Code"<>ParamUtilisateur."Company Business Unit"THEN
                        ERROR(Text02,"Employee No.",ParamUtilisateur."Company Business Unit");
                    */
                    IF "Employee No." = '' THEN BEGIN
                        "First Name" := '';
                        "Last Name" := '';
                        "Function Description" := '';
                        "Structure Description" := '';
                    END
                    ELSE BEGIN
                        Salarie.GET("Employee No.");
                        "First Name" := Salarie."First Name";
                        "Last Name" := Salarie."Last Name";
                        "Function Description" := Salarie."Job Title";
                        "Structure Description" := Salarie."Structure Description";
                    END;

            end;
        }
        field(3; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(4; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
        }
        field(5; "Function Description"; Text[80])
        {
            CaptionML = ENU = 'Function Description',
                        FRA = 'Fonction';
            Editable = false;
        }
        field(6; "Structure Description"; Text[50])
        {
            CaptionML = ENU = 'Structure Description',
                        FRA = 'Structure';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Salarie: Record 5200;
        Text01: Label 'Salarié %1 inexistant !';
        Text02: Label 'Salarié %1 n''appartient pas à l''unité %2 !';
        ParamUtilisateur: Record 91;
        Text04: Label 'Utilisateur %1 non configuré dans la table des gestionnaire de paie !';
        Text05: Label 'Unité non paramétrée pour l''utilisateur %1 !';
}

