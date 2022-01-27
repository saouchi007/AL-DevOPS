/// <summary>
/// Table Overtime Category (ID 52182502).
/// </summary>
table 52182502 "Overtime Category"
//table 39108475 "Overtime Category"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Overtime Category',
                FRA = 'Catégorie heures supp.';
    //LookupPageID = 39108529;

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
        field(3; "Item Code"; Code[10])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code Rubrique';
            TableRelation = "Payroll Item";

            trigger OnValidate();
            begin
                IF "Item Code" = '' THEN
                    "Item Description" := ''
                ELSE BEGIN
                    PayrollItem.GET("Item Code");
                    "Item Description" := PayrollItem.Description;
                END;
            end;
        }
        field(4; "Majoration %"; Decimal)
        {
            CaptionML = ENU = 'Majoration %',
                        FRA = '% Majoration';
        }
        field(5; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
            Editable = false;
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

    var
        PayrollItem: Record 52182481;
}

