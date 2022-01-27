/// <summary>
/// Table Cause of Recovery (ID 52182471).
/// </summary>
table 52182471 "Cause of Recovery"
//table 39108443 "Cause of Recovery"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = FRA = 'Code', ENU = 'Code';

        }
        field(2; "Description"; Text[30])
        {
            CaptionML = FRA = 'Désignation', ENU = 'Description';

        }
        field(3; "Unit of Measure Code"; Code[10])
        {
            CaptionML = FRA = 'Code unité', ENU = 'Unit of Measure Code';

            TableRelation = "Unit of Measure";

        }
        field(4; "Total Recovery (Base)"; Decimal)
        {
            CaptionML = FRA = 'Total récupération (Bases)', ENU = 'Total Recovery (Base)';

        }
        field(5; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionML = FRA = 'Filtre axe principal 1', ENU = 'Global Dimension 1 Filter';

        }
        field(6; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionML = FRA = 'Filtre axe principal 2', ENU = 'Global Dimension 2 Filter';

        }
        field(7; "Employee No. Filter"; Code[20])
        {
            CaptionML = FRA = 'Filtre n° salarié', ENU = 'Employee No. Filter';

        }
        field(8; "Date Filter"; Date)
        {
            CaptionML = FRA = 'Filtre date', ENU = 'Date Filter';

        }
        field(50000; "Item Code"; Text[20])
        {
            CaptionML = FRA = 'Code rubrique', ENU = 'Item Code';

        }
        field(50001; "Authorised"; Boolean)
        {
            CaptionML = FRA = 'Autorisée', ENU = 'Authorised';

        }
        field(50002; "To Be Deducted"; Boolean)
        {
            CaptionML = FRA = 'A retenir', ENU = 'To Be Deducted';

        }

    }

    keys
    {
        key(key1; "code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}