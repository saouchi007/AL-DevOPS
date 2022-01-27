/// <summary>
/// Table Payroll Template Header (ID 51472).
/// </summary>
table 52182499 "Payroll Template Header"
//table 39108472 "Payroll Template Header"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Template Header',
                FRA = 'Entête modèle de paie';
    //LookupPageID = 39108525;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PayrollSetup.GET;
                    NoSeriesMgt.TestManual(PayrollSetup."Payroll Template No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(8; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'N° Série';
            TableRelation = "No. Series";
        }
        field(9; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(18),
                                                      "No." = FIELD("No.")));
            /*CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("Bank Account"), //replaced Enum text value, "filter" can be used as well
                                                      "No." = FIELD("No.")));*/
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
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
            PayrollSetup.GET;
            PayrollSetup.TESTFIELD(PayrollSetup."Payroll Template No.");
            NoSeriesMgt.InitSeries(PayrollSetup."Payroll Template No.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        TemplateHeader: Record 52182499;
        PayrollSetup: Record 52182483;
        NoSeriesMgt: Codeunit 396;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldTemplateHeader">Record 51472.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldTemplateHeader: Record 52182499): Boolean;
    begin
        WITH TemplateHeader DO BEGIN
            COPY(Rec);
            PayrollSetup.GET;
            PayrollSetup.TESTFIELD(PayrollSetup."Payroll Template No.");
            IF NoSeriesMgt.SelectSeries(PayrollSetup."Payroll Template No.", OldTemplateHeader."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := TemplateHeader;
                EXIT(TRUE);
            END;
        END;
    end;
}

