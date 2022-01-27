/// <summary>
/// Table Employee Working Days (ID 52182508).
/// </summary>
table 52182508 "Employee Working Days"
//table 39108481 "Employee Working Days"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Working Days',
                FRA = 'Jours de travail du salarié';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                Employee.GET("Employee No.");
                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
            end;
        }
        field(2; Day; Option)
        {
            CaptionML = ENU = 'Day',
                        FRA = 'Jour';
            OptionCaptionML = ENU = 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday',
                              FRA = 'Samedi,Dimanche,Lundi,Mardi,Mercredi,Jeudi,Vendredi';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(4; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Starting Time',
                        FRA = 'Heure début';
        }
        field(5; "Ending Time"; Time)
        {
            CaptionML = ENU = 'Ending Time',
                        FRA = 'Heure fin';

            trigger OnValidate();
            begin
                IF ("Ending Time" < "Starting Time") AND
                   ("Ending Time" <> 000000T)
                THEN
                    ERROR(Text000, FIELDCAPTION("Ending Time"), FIELDCAPTION("Starting Time"));
            end;
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
    }

    keys
    {
        key(Key1; "Employee No.", Day, "Starting Time", "Ending Time")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: TextConst ENU = '%1 must be higher than %2.', FRA = '%1 doit être supérieur(e) à %2.';
        Text001: TextConst ENU = 'There is redundancy in the Shop Calendar. Actual work shift %1 from : %2 to %3. Conflicting work shift %4 from : %5 to %6.', FRA = 'Incohérence dans le calendrier usine. Equipe actuelle (%1)  : de %2 à %3. Equipe à l''origine du conflit (%4) : de %5 à %6.';
        Employee: Record 5200;
}

