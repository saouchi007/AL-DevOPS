/// <summary>
/// Table Payroll Unit of Measure (ID 52182494).
/// </summary>
table 52182494 "Payroll Unit of Measure"
//table 39108467 "Payroll Unit of Measure"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Unit of Measure',
                FRA = 'Unité de mesure paie';
    DataCaptionFields = "Code";
    //DrillDownPageID = 39108515;
    //LookupPageID = 39108515;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
            TableRelation = "Unit of Measure";
        }
        field(2; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure',
                        FRA = 'Quantité par unité';
            DecimalPlaces = 0 : 5;
            InitValue = 1;

            trigger OnValidate();
            begin
                IF "Qty. per Unit of Measure" <= 0 THEN
                    FIELDERROR("Qty. per Unit of Measure", Text000);
                PayrollSetup.GET;
                IF PayrollSetup."Base Unit of Measure" = Code THEN
                    TESTFIELD("Qty. per Unit of Measure", 1);
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: TextConst ENU = 'must be greater than 0', FRA = 'doit être supérieur(e) à 0';
        PayrollSetup: Record 5218;
}

