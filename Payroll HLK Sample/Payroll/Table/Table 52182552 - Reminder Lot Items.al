/// <summary>
/// Table Reminder Lot Items (ID 52182552).
/// </summary>
table 52182552 "Reminder Lot Items"
//table 39108643 "Reminder Lot Items"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'N°';
            TableRelation = "Payroll Reminder Lot";
        }
        field(2; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
            TableRelation = "Payroll Item";

            trigger OnValidate();
            begin
                IF "Item Code" = '' THEN BEGIN
                    "Item Description" := '';
                    Type := Type::"Libre saisie";
                    Rate := 0;
                    Amount := 0;
                    Number := 0;
                    "Add if Inexistant" := FALSE;
                END
                ELSE BEGIN
                    Rubrique.GET("Item Code");
                    "Item Description" := Rubrique.Description;
                    Type := Rubrique."Item Type";
                    Rate := Rubrique."Calculation Rate";
                    Amount := Rubrique.Tarification;
                    Number := 0;
                    "Add if Inexistant" := FALSE;
                END;
            end;
        }
        field(3; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
            Editable = false;
        }
        field(4; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";
        }
        field(5; Rate; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Coefficient/Taux';
            DecimalPlaces = 1 : 4;
        }
        field(6; Amount; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant/Base';
        }
        field(7; Number; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre/Points';
        }
        field(8; "Add if Inexistant"; Boolean)
        {
            Caption = 'Ajouter si inexistant';
        }
        field(9; Calculation; Option)
        {
            Caption = 'Calcul';
            OptionCaption = 'Appliquer un coefficient,Ajouter une valeur,Remplacer la valeur';
            OptionMembers = "Appliquer un coefficient","Ajouter une valeur","Remplacer la valeur";
        }
        field(10; Value; Option)
        {
            Caption = 'Valeur';
            OptionCaption = 'Taux,Nombre,Base,Montant,Nbre&Base';
            OptionMembers = Taux,Nombre,Base,Montant,"Nbre&Base";
        }
    }

    keys
    {
        key(Key1; "No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Rubrique: Record 52182481;
        Text01: Label 'Le champ [Coefficient] ne peut pas être renseigné quand le type est [%1] !';
}

