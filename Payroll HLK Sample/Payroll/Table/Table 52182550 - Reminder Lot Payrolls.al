/// <summary>
/// Table Reminder Lot Payrolls (ID 52182550).
/// </summary>
table 52182550 "Reminder Lot Payrolls"
//table 39108641 "Reminder Lot Payrolls"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Paies de lot de rappel';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'N°';
            TableRelation = "Payroll Reminder Lot";
        }
        field(2; "Payroll Code"; Code[20])
        {
            Caption = 'Code paie';
            TableRelation = Payroll;

            trigger OnValidate();
            begin
                IF "Payroll Code" = '' THEN BEGIN
                    Description := '';
                    "Starting Date" := 0D;
                    "Ending Date" := 0D;
                    "Regular Payroll" := FALSE;
                END
                ELSE BEGIN
                    Paie.GET("Payroll Code");
                    Description := Paie.Description;
                    "Starting Date" := Paie."Starting Date";
                    "Ending Date" := Paie."Ending Date";
                    "Regular Payroll" := Paie."Regular Payroll";
                END;
            end;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Désignation';
            Editable = false;
        }
        field(4; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';
            Editable = false;
        }
        field(5; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';
            Editable = false;
        }
        field(6; "Regular Payroll"; Boolean)
        {
            Caption = 'Paie régulière';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Payroll Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Paie: Record 52182484;
}

