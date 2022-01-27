/// <summary>
/// Table HR Payroll Report Selections (ID 52182545).
/// </summary>
table 52182545 "HR Payroll Report Selections"
//table 39108634 "HR Payroll Report Selections"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Report Selections',
                FRA = 'Sélection des états RH Paie';

    fields
    {
        field(1; "Report ID"; Integer)
        {
            CaptionML = ENU = 'Report ID',
                        FRA = 'ID état';
            TableRelation = Object.ID where(Type=const(Report));

            trigger OnValidate();
            begin
                Objet.RESET;
                Objet.SETRANGE(Type, Objet.Type::Report);
                Objet.SETRANGE("Company Name", '');
                Objet.SETRANGE(ID, "Report ID");
                IF Objet.FINDFIRST THEN
                    "Report Name" := Objet.Name;
            end;
        }
        field(2; "Report Name"; Text[80])
        {
            CaptionML = ENU = 'Report Name',
                        FRA = 'Nom de l''état';
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Report ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ReportSelection2: Record 77;
        Objet: Record 2000000001;

    procedure NewRecord();
    begin
        ReportSelection2.SETRANGE(Usage, "Report ID");
        IF ReportSelection2.FIND('+') AND (ReportSelection2.Sequence <> '') THEN
            "Report Name" := INCSTR(ReportSelection2.Sequence)
        ELSE
            "Report Name" := '1';
    end;
}

