/// <summary>
/// Table Training Session (ID 52182433).
/// </summary>
table 52182433 "Training Session"
//table 39108404 "Training Session"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Session',
                FRA = 'Session de formation';
    //DrillDownPageID = 39108407;
    //LookupPageID = 39108407;

    fields
    {
        field(1; "Institution No."; Code[20])
        {
            CaptionML = ENU = 'Institution No.',
                        FRA = 'N° Etablissement';
            NotBlank = true;
            TableRelation = "Training Institution";
        }
        field(2; "Training No."; Code[20])
        {
            CaptionML = ENU = 'Training No.',
                        FRA = 'N° Formation';
            NotBlank = true;
            TableRelation = "Training"."No." //WHERE("No." = FIELD("Institution No."))
            ;
        }
        field(3; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
            NotBlank = true;
        }
        field(4; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';

            trigger OnValidate();
            begin
                CalcPeriod;
            end;
        }
        field(5; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';

            trigger OnValidate();
            begin
                CalcPeriod;
            end;
        }
        field(6; "Minimum participants"; Integer)
        {
            CaptionML = ENU = 'Minimum Participants',
                        FRA = 'Minimum Participants';
        }
        field(7; "Maximum participants"; Integer)
        {
            CaptionML = ENU = 'Maximum Participants',
                        FRA = 'Maximum Participants';
        }
        field(8; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Starting Time',
                        FRA = 'Heure début';

            trigger OnValidate();
            begin
                //IF "No. of Hours"<>0 THEN
                //  "Ending Time":="Starting Time"+"No. of Hours"*(60*60)
                //ELSE
                IF "Ending Time" <> 0T THEN
                    "No. of Hours" := ("Ending Time" - "Starting Time") DIV (60 * 60 * 1000);
            end;
        }
        field(9; "Ending Time"; Time)
        {
            CaptionML = ENU = 'Ending Time',
                        FRA = 'Heure fin';

            trigger OnValidate();
            begin
                //IF "No. of Hours"<>0 THEN
                //  "Starting Time":="Ending Time"-"No. of Hours"*(60*60)
                //ELSE
                IF "Starting Time" <> 0T THEN
                    "No. of Hours" := ("Ending Time" - "Starting Time") DIV (60 * 60 * 1000);
            end;
        }
        field(10; "No. of Days"; Integer)
        {
            CaptionML = ENU = 'No. of Days',
                        FRA = 'Nbre de jours';
            Editable = false;

            trigger OnValidate();
            begin
                //CalcPeriod;
            end;
        }
        field(11; "No. of Hours"; Integer)
        {
            CaptionML = ENU = 'No. of Hours',
                        FRA = 'Nbre d''heures';
            Editable = false;

            trigger OnValidate();
            begin
                /*
                IF "Starting Time"<>0T THEN
                  "Ending Time":="Starting Time"+"No. of Hours"*(60*60)
                ELSE
                  "Starting Time":="Ending Time"-"No. of Hours"*(60*60);
                 */

            end;
        }
    }

    keys
    {
        key(Key1; "Institution No.", "Training No.", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'La date de début doit être antérieure à la date de fin';
        Text002: Label 'L''heure de début doit être antérieure à l''heure de fin';

    procedure CalcPeriod();
    begin
        IF ("Starting Date" <> 0D) AND ("Ending Date" <> 0D) THEN
            IF "Starting Date" > "Ending Date" THEN
                ERROR(Text001);
        /*
        IF ("Starting Date"<>0D)AND("No. of Days"<>0)THEN
          BEGIN
            "Ending Date":="Starting Date"+"No. of Days";EXIT;
          END;
        */
        IF ("Starting Date" <> 0D) AND ("Ending Date" <> 0D) THEN BEGIN
            "No. of Days" := "Ending Date" - "Starting Date" + 1;
            EXIT;
        END;
        /*
        IF ("Ending Date"<>0D)AND("No. of Days"<>0)THEN
          BEGIN
            "Starting Date":="Ending Date"-"No. of Days";EXIT;
          END;
        */

    end;
}

