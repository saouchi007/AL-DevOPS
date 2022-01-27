/// <summary>
/// Table Professional Expances (ID 52182504).
/// </summary>
table 52182504 "Professional Expances"
//table 39108477 "Professional Expances"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Contribution Payment',
                FRA = 'Frais de mission';
    //DrillDownPageID = 39108532;
    //LookupPageID = 39108532;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
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
                "Employee Structure Code" := Salarie."Structure Code";
                "Employee Structure Description" := Salarie."Structure Description";
                "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
            end;
        }
        field(2; Contribution; Option)
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Cotisation';
            NotBlank = true;
            OptionCaptionML = ENU = 'FA,Union',
                              FRA = 'FM,RFM';
            OptionMembers = FM,RFM;
        }
        field(4; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            Editable = true;
        }
        field(5; "Payroll Code"; Code[20])
        {
            Caption = 'Code paie';
            NotBlank = false;
            TableRelation = Payroll;
        }
        field(6; "Deduction Payroll Code"; Code[20])
        {
            Caption = 'Code paie retenue';
            TableRelation = Payroll;
        }
        field(7; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(8; "First Name"; Text[30])
        {
            Caption = 'Prénom';
            Editable = false;
        }
        field(9; "Last Name"; Text[30])
        {
            Caption = 'Nom';
            Editable = false;
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(17)
                                                                     "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Date; Date)
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
        field(95004; "Employee Structure Code"; Text[30])
        {
            Caption = 'Code Structure';
            Description = 'HALRHPAIE';
        }
        field(95005; "Employee Structure Description"; Text[50])
        {
            Caption = 'Structure';
            Description = 'HALRHPAIE';
        }
        field(95006; Destination; Text[50])
        {
            Description = 'HALRHPAIE';
            Editable = false;
            FieldClass = Normal;
        }
        field(95007; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code postal';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                IF "Post Code" = '' THEN BEGIN
                    Destination := '';
                    EXIT;
                END;
                PostCode.RESET;
                PostCode.SETRANGE(Code, "Post Code");
                IF PostCode.FINDFIRST THEN BEGIN
                    Destination := PostCode.City;
                    Amount := PostCode.Amount;
                END;
            end;
        }
        field(95008; Quantity; Decimal)
        {
            Caption = 'Quantité';
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Employee No.")
        {
        }
        key(Key2; "Employee No.", Contribution, "Deduction Payroll Code", Date)
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        ContributionPayment.SETCURRENTKEY("Entry No.");
        IF ContributionPayment.FIND('+') THEN
            "Entry No." := ContributionPayment."Entry No." + 1
        ELSE
            "Entry No." := 1;
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text04);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text05);
    end;

    var
        PayrollSetup: Record 52182483;
        PayrollItem: Record 52182481;
        Text01: Label 'Nature de la rubrique doit être "Calculée" !';
        Salarie: Record 5200;
        ContributionPayment: Record 52182504;
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text07: Label 'Salarié %1 inexistant !';
        Text08: Label 'Salarié %1 inactif !';
        ParamUtilisateur: Record 91;
        PostCode: Record 225;
}

