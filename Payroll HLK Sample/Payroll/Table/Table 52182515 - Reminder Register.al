/// <summary>
/// Table Reminder Register (ID 51584).
/// </summary>
table 52182515 "Reminder Register"
//table 39108584 "Reminder Register"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Reminder Register',
                FRA = 'Hist. transactions rappel';
    //DrillDownPageID = 39108496;
    //LookupPageID = 39108496;

    fields
    {
        field(1; "No."; Integer)
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
        }
        field(2; "From Entry No."; Integer)
        {
            CaptionML = ENU = 'From Entry No.',
                        FRA = 'N° séquence début';
            //TableRelation = Table39108580;
        }
        field(3; "To Entry No."; Integer)
        {
            CaptionML = ENU = 'To Entry No.',
                        FRA = 'N° séquence fin';
            //TableRelation = Table39108580;
        }
        field(4; "Creation Date"; Date)
        {
            CaptionML = ENU = 'Creation Date',
                        FRA = 'Date création';
        }
        field(5; "User ID"; Code[20])
        {
            CaptionML = ENU = 'User ID',
                        FRA = 'Code utilisateur';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                LoginMgt: record 52182503;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(6; "Payroll Code"; Code[20])
        {
            CaptionML = ENU = 'Payroll Code',
                        FRA = 'Code paie';
            TableRelation = Payroll;
        }
        field(7; "No. of employees"; Integer)
        {
            CaptionML = ENU = 'No. of employees',
                        FRA = 'Nbre de salariés';
        }
        field(8; "No. of Entries"; Integer)
        {
            CaptionML = ENU = 'No. of Entries',
                        FRA = 'Nbre d''écritures';
        }
        field(9; Recorded; Boolean)
        {
            CaptionML = ENU = 'Recorded',
                        FRA = 'Comptabilisé';
        }
        field(10; "Recording Date"; Date)
        {
            CaptionML = ENU = 'Recording Date',
                        FRA = 'Date comptabilisation';
        }
        field(11; "Recorded By"; Code[20])
        {
            CaptionML = ENU = 'Recorded By',
                        FRA = 'Comptabilisé par';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(12; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code direction';
            TableRelation = "Company Business Unit";
        }
        field(13; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            TableRelation = Employee;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Creation Date")
        {
        }
    }

    fieldgroups
    {
    }


}

