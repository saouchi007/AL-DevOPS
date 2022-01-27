/// <summary>
/// Page Employee Contract List (ID 52182461).
/// </summary>
page 52182461 "Employee Contract List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Contract List',
                FRA = 'Liste des contrats salarié';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Contract";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Employment Contract Code"; "Employment Contract Code")
                {
                }
                field(Nature; Nature)
                {
                }
                field(Period; Period)
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Trial Period"; "Trial Period")
                {
                }
                field("Cause of Contract Termination"; "Cause of Contract Termination")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        EXIT(Employee.GET("Employee No."));
    end;



    var
        Employee: Record 5200;

}

