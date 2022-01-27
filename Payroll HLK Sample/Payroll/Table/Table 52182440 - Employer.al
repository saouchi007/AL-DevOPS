/// <summary>
/// Table Employer (ID 52182440).
/// </summary>
table 52182440 Employer
//table 39108411 Employer
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employer',
                FRA = 'Employeur';
    //DrillDownPageID = 39108415;
    //LookupPageID = 39108415;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Employer Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'N° Série';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD(HumanResSetup."Employer Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Employer Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        Employer: Record 52182440;
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldEmployer">Record 51411.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldEmployer: Record Employer): Boolean;
    begin
        WITH Employer DO BEGIN
            COPY(Rec);
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Employer Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Employer Nos.", OldEmployer."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := Employer;
                EXIT(TRUE);
            END;
        END;
    end;
}

