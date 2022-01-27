/// <summary>
/// TableExtension Job Cue Ext (ID 59057) extends Record Job Cue.
/// </summary>
tableextension 52182441 "Job Cue Ext" extends "Job Cue"
{
    fields
    {
        field(50000; "Responsibility Center Filter"; Code[10])
        {
            CaptionML = ENU = 'Responsibility Center Filter',
                        FRA = 'Filtre centre de gestion';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50001; "Salaries Actifs"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = CONST(Active)));
            Caption = 'Salariés Actifs';
            FieldClass = FlowField;
        }
        field(50002; "Absences journee"; Integer)
        {
            CalcFormula = Count("Employee Absence" WHERE("From Date" = FIELD("Date Filter")));
            Caption = 'Absences de la journée';
            FieldClass = FlowField;
        }
        field(50003; "Fin de contrat"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Termination Date" = FIELD("Next Date Fin de contrat"),
                                                Status = CONST(Active)));
            Caption = 'Fin de contrat';
            FieldClass = FlowField;
        }
        field(50004; "Next Date Fin de contrat"; Date)
        {
            Caption = 'Next Date Fin de contrat';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50005; "Fin de Période d'essai"; Integer)
        {
            CalcFormula = Count(Employee WHERE(DateFinPEss = FIELD("Next Date Fin de contrat"),
                                                Status = CONST(Active)));
            Caption = 'Fin de Période d''essai';
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}