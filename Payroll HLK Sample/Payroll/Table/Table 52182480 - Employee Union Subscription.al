/// <summary>
/// Table Employee Union Subscription (ID 51453).
/// </summary>
table 52182480 "Employee Union Subscription"
//table 39108453 "Employee Union Subscription"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Union Subscription',
                FRA = 'Souscription salarié mutuelle';

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
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                Salarie.GET("Employee No.");
                "First Name" := Salarie."First Name";
                "Last Name" := Salarie."Last Name";
            end;
        }
        field(2; "Union/Insurance Code"; Code[10])
        {
            CaptionML = ENU = 'Union/Insurance Code',
                        FRA = 'Code mutuelle/assurance';
            NotBlank = true;
            TableRelation = Union;
        }
        field(3; "Subscription Amount"; Decimal)
        {
            CaptionML = ENU = 'Subscription Amount',
                        FRA = 'Montant souscription';

            trigger OnValidate();
            begin
                IF "Subscription Amount" <= 0 THEN
                    ERROR(Text01);
            end;
        }
        field(4; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date début';

            trigger OnValidate();
            begin
                ValidatePeriod;
            end;
        }
        field(5; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date fin';

            trigger OnValidate();
            begin
                ValidatePeriod;
            end;
        }
        field(6; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(7; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Union/Insurance Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text01: Label 'Nombre doit être positif !';
        Text02: Label 'La date de début doit être antérieure à la date de fin !';
        Salarie: Record 5200;

    /// <summary>
    /// ValidatePeriod.
    /// </summary>
    procedure ValidatePeriod();
    begin
        IF ("Starting Date" = 0D) OR ("Ending Date" = 0D) THEN
            EXIT;
        IF "Starting Date" > "Ending Date" THEN
            ERROR(Text02);
    end;
}

