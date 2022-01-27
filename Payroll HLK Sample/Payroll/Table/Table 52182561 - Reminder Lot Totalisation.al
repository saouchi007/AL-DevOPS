/// <summary>
/// Table Reminder Lot Totalisation (ID 52182561).
/// </summary>
table 52182561 "Reminder Lot Totalisation"
//table 39108652 "Reminder Lot Totalisation"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Line Archive',
                FRA = 'Totalisation du lot de rappel';

    fields
    {
        field(1; "Reminder Lot No."; Code[20])
        {
            Caption = 'N° Lot de rappel';
            TableRelation = "Payroll Reminder Lot";
        }
        field(3; "Item Code"; Text[20])
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
                    Rubrique.GET("Item Code");
                    "Item Description" := Rubrique.Description;
                END;
            end;
        }
        field(4; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
        }
        field(5; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";
        }
        field(6; "Total Reminder"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Total Reminder" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                 "Item Code" = FIELD("Item Code")));
            Caption = 'Total rappel';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Reminder Amount 1"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 1" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Reminder Amount 2"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 2" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Reminder Amount 3"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 3" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Reminder Amount 4"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 4" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Reminder Amount 5"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 5" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 5';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(12; "Reminder Amount 6"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 6" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 6';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(13; "Reminder Amount 7"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 7" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 7';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(14; "Reminder Amount 8"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 8" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 8';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(15; "Reminder Amount 9"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 9" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                    "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 9';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(16; "Reminder Amount 10"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 10" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                     "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 10';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(17; "Reminder Amount 11"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 11" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                     "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 11';
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(18; "Reminder Amount 12"; Decimal)
        {
            CalcFormula = Sum("Reminder Payroll Archive"."Reminder Amount 12" WHERE("Reminder Lot No." = FIELD("Reminder Lot No."),
                                                                                     "Item Code" = FIELD("Item Code")));
            Caption = 'Mnt rappel 12';
            FieldClass = FlowField;
            NotBlank = false;
        }
    }

    keys
    {
        key(Key1; "Reminder Lot No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Rubrique: Record "Payroll Item";
        ParamPaie: Record 52182483;
        Text01: Label 'Nature de la rubrique doit être "Calculée" !';
        Text02: Label '%1 ne doit pas dépasser %2 !';
        Text03: Label '%1 doit être positif !';
        Employee: Record 5200;
        NbreJoursTravailles: Decimal;
        Text04: Label 'Suppression impossible de la rubrique %1';
        GestionRappel: Codeunit 52182433;
        LigneRappel: Record "Payroll Reminder Line";
        LigneRappel2: Record "Payroll Reminder Line";
        Montant: Decimal;
        LigneArchive: Record "Payroll Archive Line";
        Text05: Label 'Rubrique [%1] manquante !';

    procedure CalcItemAmount();
    begin
    end;
}

