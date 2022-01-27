/// <summary>
/// Table Cause of Overtime (ID 52182493).
/// </summary>
table 52182493 "Cause of Overtime"
//table 39108466 "Cause of Overtime"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Cause of Overtime',
                FRA = 'Motif d''heure supp.';
    // DrillDownPageID = 39108514;
    //LookupPageID = 39108514;

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
        field(3; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code',
                        FRA = 'Code unité';
            TableRelation = "Unit of Measure";
        }
        field(4; "Total Overtime (Base)"; Decimal)
        {
            CalcFormula = Sum("Employee Overtime"."Quantity (Base)" WHERE("Employee No." = FIELD("Employee No. Filter"),
                                                                           "Cause of Overtime Code" = FIELD(Code),
                                                                           "Overtime Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Total Overtime (Base)',
                        FRA = 'Total heures supp. (Bases)';
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

