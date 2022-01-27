/// <summary>
/// Table Payroll Template Line (ID 52182500).
/// </summary>
table 52182500 "Payroll Template Line"
//table 39108473 "Payroll Template Line"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Payroll Template Line',
                FRA = 'Ligne modèle de paie';

    fields
    {
        field(1; "Template No."; Code[20])
        {
            CaptionML = ENU = 'Template No.',
                        FRA = 'N° modèle';
            TableRelation = "Payroll Template Header";
        }
        field(2; "Item Code"; Code[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
            TableRelation = "Payroll Item";

            trigger OnValidate();
            begin
                IF "Item Code" = '' THEN
                    "Item Description" := ''
                ELSE BEGIN
                    PayrollSetup.GET;
                    PayrollItem.GET("Item Code");
                    IF (PayrollItem.Nature = PayrollItem.Nature::Calculated) AND ("Item Code" <> PayrollSetup."Base Salary") THEN
                        ERROR(Text001);
                    "Item Description" := PayrollItem.Description;
                    "Item Type" := PayrollItem."Item Type";
                END;
            end;
        }
        field(3; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
        }
        field(4; "Item Type"; Option)
        {
            CaptionML = ENU = 'Item Type',
                        FRA = 'Type rubrique';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage';
            OptionMembers = "Libre saisie",Formule,Pourcentage;
        }
        field(5; Amount; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
        }
    }

    keys
    {
        key(Key1; "Template No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Nature de la rubrique doit pas être "Calculée".';
        PayrollItem: Record 52182481;
        PayrollSetup: Record 52182483;
}

