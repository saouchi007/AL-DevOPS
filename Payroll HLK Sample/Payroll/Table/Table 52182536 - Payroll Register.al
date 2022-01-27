/// <summary>
/// Table Payroll Register (ID 52182536).
/// </summary>
table 52182536 "Payroll Register"
//table 39108621 "Payroll Register"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Register',
                FRA = 'Hist. transactions paie';
    // DrillDownPageID = 39108496;
    // LookupPageID = 39108496;

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
            TableRelation = "Payroll Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            CaptionML = ENU = 'To Entry No.',
                        FRA = 'N° séquence fin';
            TableRelation = "Payroll Entry";
        }
        field(4; "Creation Date"; Date)
        {
            CaptionML = ENU = 'Creation Date',
                        FRA = 'Date création';
        }
        field(5; "User ID"; Code[40])
        {
            CaptionML = ENU = 'User ID',
                        FRA = 'Code utilisateur';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                LoginMgt: Record 52182503;///*** LoginMgt : Codeunit 418 ***\\\ AK
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
        field(11; "Recorded By"; Code[40])
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
                        FRA = 'Code unité';
            Editable = true;
            TableRelation = "Company Business Unit";
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

