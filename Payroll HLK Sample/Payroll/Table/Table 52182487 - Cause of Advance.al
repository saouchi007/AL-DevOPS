/// <summary>
/// Table Cause of Advance (ID 52182487).
/// </summary>
table 52182487 "Cause of Advance"
//table 39108460 "Cause of Advance"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Cause of Advance',
                FRA = 'Motif d''avance';
    //DrillDownPageID = 39108505;
    //LookupPageID = 39108505;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(4; "Total Advance"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("Employee Advance".Amount WHERE("Cause of Advance Code" = FIELD(Code),
                                                               "Employee No." = FIELD("Employee No. Filter"),
                                                               "Advance Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Total Advance',
                        FRA = 'Total avances';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Global Dimension 1 Filter',
                        FRA = 'Filtre axe principal 1';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Global Dimension 2 Filter',
                        FRA = 'Filtre axe principal 2';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(7; "Employee No. Filter"; Code[20])
        {
            CaptionML = ENU = 'Employee No. Filter',
                        FRA = 'Filtre n° salarié';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(8; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter',
                        FRA = 'Filtre date';
            FieldClass = FlowFilter;
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
}

