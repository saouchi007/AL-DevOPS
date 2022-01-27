/// <summary>
/// TableExtension Cause of Inactivity Ext (ID 52182435) extends Record Cause of Inactivity.
/// </summary>
tableextension 52182435 "Cause of Inactivity Ext" extends "Cause of Inactivity"
{
    fields
    {
        field(90000; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code',
                        FRA = 'Code unité';
            TableRelation = "Unit of Measure";
        }
        field(90001; "Total Unavailabilities (Base)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Unavailability"."Quantity (Base)" WHERE("Cause of Inactivity Code" = FIELD(Code),
                                                                                 "Employee No." = FIELD("Employee No. Filter"),
                                                                                 "Starting Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Total Unavailabilities (Base)',
                        FRA = 'Total indisponibilités (Bases)';
            Editable = false;

        }
        field(90002; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Global Dimension 1 Filter',
                        FRA = 'Filtre axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(90003; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Global Dimension 2 Filter',
                        FRA = 'Filtre axe principal 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(90004; "Employee No. Filter"; Code[20])
        {
            CaptionML = ENU = 'Employee No. Filter',
                        FRA = 'Filtre n° salarié';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(90005; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter',
                        FRA = 'Filtre date';
            FieldClass = FlowFilter;
        }
    }

    var
        myInt: Integer;
}