/// <summary>
/// Table Payroll (ID 51457).
/// </summary>
table 52182484 Payroll
//table 51457 Payroll
{
    // version HALRHPAIE.6.1.07

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Payroll',
                FRA = 'Paie';
    DrillDownPageID = 52182534;
    LookupPageID = 52182562;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
            Caption = 'Désignation';
        }
        field(3; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';
        }
        field(4; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';
        }
        field(5; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(6; Closed; Boolean)
        {
            CaptionML = ENU = 'Closed',
                        FRA = 'Clôturée';
            Editable = false;
        }
        field(7; Reminder; Boolean)
        {
            Caption = 'Rappel';
        }
        field(8; "Regular Payroll"; Boolean)
        {
            Caption = 'Paie régulière';
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

    trigger OnInsert();
    begin
        //---01---

        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text02);
        "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
}

