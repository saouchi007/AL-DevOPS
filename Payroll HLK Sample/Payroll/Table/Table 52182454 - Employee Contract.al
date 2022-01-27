/// <summary>
/// Table Employee Contract (ID 51425).
/// </summary>
table 52182454 "Employee Contract"
//table 39108425 "Employee Contract"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Employee Contract',
                FRA = 'Contrat salarié';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'No. Salarié';
            TableRelation = Employee WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                IF ParamUtilisateur."Company Business Unit" = '' THEN
                    ERROR(Text05);
                IF NOT Salarie.GET("Employee No.") THEN
                    ERROR(Text07, "Employee No.")
                ELSE
                    IF Salarie."Company Business Unit Code" <> ParamUtilisateur."Company Business Unit" THEN
                        ERROR(Text06, "Employee No.", ParamUtilisateur."Company Business Unit");
                IF Salarie.Status = Salarie.Status::Inactive THEN
                    ERROR(Text08, "Employee No.");
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                "First Name" := Salarie."First Name";
                "Last Name" := Salarie."Last Name";
                "Stucture code" := Salarie."Structure Code";
                "Designation structure" := Salarie."Structure Description";
            end;
        }
        field(3; "Employment Contract Code"; Code[10])
        {
            CaptionML = ENU = 'Employment Contract Code',
                        FRA = 'Type contrat de travail';
            TableRelation = "Employment Contract";

            trigger OnValidate();
            begin
                IF "Employment Contract Code" = '' THEN
                    Description := ''
                ELSE BEGIN
                    EmploymentContract.GET("Employment Contract Code");
                    Description := EmploymentContract.Description;
                    Nature := EmploymentContract.Nature;
                END;
                IF Salarie.GET("Employee No.") THEN BEGIN
                    Salarie.VALIDATE("Emplymt. Contract Code", "Employment Contract Code");
                    Salarie.MODIFY;
                END;
                IF "Employment Contract Code" = 'CDI' THEN BEGIN
                    Nature := Nature::Permanent;
                END ELSE BEGIN
                    Nature := Nature::Contractual;
                END;

                //Contractual,Permanent
            end;
        }
        field(4; "From Date"; Date)
        {
            CaptionML = ENU = 'From Date',
                        FRA = 'Date début';
        }
        field(5; "To Date"; Date)
        {
            CaptionML = ENU = 'To Date',
                        FRA = 'Date fin';
        }
        field(6; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(7; "Cause of Contract Termination"; Code[10])
        {
            CaptionML = ENU = 'Contract End Cause',
                        FRA = 'Motif fin de contrat';
            TableRelation = "Cause of Contract Termination";
        }
        field(8; "Trial Period"; Integer)
        {
            CaptionML = ENU = 'Trial Period',
                        FRA = 'Période d''essai';
        }
        field(9; Nature; Option)
        {
            OptionCaptionML = ENU = 'Contractual,Permanent',
                              FRA = 'Contractuel,Permanent';
            OptionMembers = Contractual,Permanent;
        }
        field(10; Period; Integer)
        {
            CaptionML = ENU = 'Period',
                        FRA = 'Durée';
        }
        field(11; "Unit of Measure"; Option)
        {
            CaptionML = ENU = 'Unit of Measure',
                        FRA = 'Unité de mesure';
            OptionCaptionML = ENU = 'Day,Month,Year',
                              FRA = 'Jour,Mois,An';
            OptionMembers = Hour,Day,Month,Year;
        }
        field(12; "Contract Reference"; Text[30])
        {
            Caption = 'Référence contrat';
        }
        field(13; "Installation Date"; Date)
        {
            Caption = 'Date instalation';
        }
        field(14; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(11)
                                                                     "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(50003; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
        field(50004; "Date fin de période d'essai"; Date)
        {
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95001; "Stucture code"; Code[10])
        {
        }
        field(95002; "Designation structure"; Text[50])
        {
        }
        field(95013; Status; Option)
        {
            CalcFormula = Lookup(Employee.Status WHERE("No." = FIELD("Employee No.")));
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            Editable = false;
            FieldClass = FlowField;
            OptionCaptionML = ENU = 'Active,Inactive',
                              FRA = 'Actif,Inactif,Bloqué';
            OptionMembers = Active,Inactive,Bloqued;

            trigger OnValidate();
            begin
                //EmployeeQualification.SETRANGE("Employee No.","No.");
                //EmployeeQualification.MODIFYALL("Employee Status",Status);
                MODIFY;
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "To Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeContract.SETCURRENTKEY("Entry No.");
        IF EmployeeContract.FIND('+') THEN
            "Entry No." := EmployeeContract."Entry No." + 1
        ELSE
            "Entry No." := 1;
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text04);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text05);
        "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
    end;

    var
        EmployeeContract: Record 52182454;
        Salarie: Record 5200;
        EmploymentContract: Record 5211;
        ParamUtilisateur: Record 91;
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text07: Label 'Salarié %1 inexistant !';
        Text08: Label 'Salarié %1 inactif !';
}

