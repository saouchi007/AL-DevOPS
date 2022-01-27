/// <summary>
/// Table Reminder Payroll Archive (ID 52182553).
/// </summary>
table 52182553 "Reminder Payroll Archive"
//table 39108644 "Reminder Payroll Archive"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Line Archive',
                FRA = 'Rappel - Paies archivées';

    fields
    {
        field(1; "Reminder Lot No."; Code[20])
        {
            Caption = 'N° Lot de rappel';
            TableRelation = "Payroll Reminder Lot";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
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
        field(5; "Number 1"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 1';
        }
        field(6; "Basis 1"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 1';
        }
        field(7; "Rate 1"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 1';
        }
        field(8; "Amount 1"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 1';
        }
        field(9; "Number 2"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 2';
        }
        field(10; "Basis 2"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 2';
        }
        field(11; "Rate 2"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 2';
        }
        field(12; "Amount 2"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 2';
        }
        field(13; "Number 3"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 3';
        }
        field(14; "Basis 3"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 3';
        }
        field(15; "Rate 3"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 3';
        }
        field(16; "Amount 3"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 3';
        }
        field(17; "Number 4"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 4';
        }
        field(18; "Basis 4"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 4';
        }
        field(19; "Rate 4"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 4';
        }
        field(20; "Amount 4"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 4';
        }
        field(21; "Number 5"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 5';
        }
        field(22; "Basis 5"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 5';
        }
        field(23; "Rate 5"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 5';
        }
        field(24; "Amount 5"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 5';
        }
        field(25; "Number 6"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 6';
        }
        field(26; "Basis 6"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 6';
        }
        field(27; "Rate 6"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 6';
        }
        field(28; "Amount 6"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 6';
        }
        field(29; "Number 7"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 7';
        }
        field(30; "Basis 7"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 7';
        }
        field(31; "Rate 7"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 7';
        }
        field(32; "Amount 7"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 7';
        }
        field(33; "Number 8"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 8';
        }
        field(34; "Basis 8"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 8';
        }
        field(35; "Rate 8"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 8';
        }
        field(36; "Amount 8"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 8';
        }
        field(37; "Number 9"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 9';
        }
        field(38; "Basis 9"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 9';
        }
        field(39; "Rate 9"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 9';
        }
        field(40; "Amount 9"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 9';
        }
        field(41; "Number 10"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 10';
        }
        field(42; "Basis 10"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 10';
        }
        field(43; "Rate 10"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 10';
        }
        field(44; "Amount 10"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 10';
        }
        field(45; "Number 11"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 11';
        }
        field(46; "Basis 11"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 11';
        }
        field(47; "Rate 11"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 11';
        }
        field(48; "Amount 11"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 11';
        }
        field(49; "Number 12"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre 12';
        }
        field(50; "Basis 12"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base 12';
        }
        field(51; "Rate 12"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux 12';
        }
        field(52; "Amount 12"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant 12';
        }
        field(53; "Payroll Number 1"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 1';
        }
        field(54; "Payroll Basis 1"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 1';
        }
        field(55; "Payroll Rate 1"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 1';
        }
        field(56; "Payroll Amount 1"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 1';
        }
        field(57; "Payroll Number 2"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 2';
        }
        field(58; "Payroll Basis 2"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 2';
        }
        field(59; "Payroll Rate 2"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 2';
        }
        field(60; "Payroll Amount 2"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 2';
        }
        field(61; "Payroll Number 3"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 3';
        }
        field(62; "Payroll Basis 3"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 3';
        }
        field(63; "Payroll Rate 3"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 3';
        }
        field(64; "Payroll Amount 3"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 3';
        }
        field(65; "Payroll Number 4"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 4';
        }
        field(66; "Payroll Basis 4"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 4';
        }
        field(67; "Payroll Rate 4"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 4';
        }
        field(68; "Payroll Amount 4"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 4';
        }
        field(69; "Payroll Number 5"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 5';
        }
        field(70; "Payroll Basis 5"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 5';
        }
        field(71; "Payroll Rate 5"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 5';
        }
        field(72; "Payroll Amount 5"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 5';
        }
        field(73; "Payroll Number 6"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 6';
        }
        field(74; "Payroll Basis 6"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 6';
        }
        field(75; "Payroll Rate 6"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 6';
        }
        field(76; "Payroll Amount 6"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 6';
        }
        field(77; "Payroll Number 7"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 7';
        }
        field(78; "Payroll Basis 7"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 7';
        }
        field(79; "Payroll Rate 7"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 7';
        }
        field(80; "Payroll Amount 7"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 7';
        }
        field(81; "Payroll Number 8"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 8';
        }
        field(82; "Payroll Basis 8"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 8';
        }
        field(83; "Payroll Rate 8"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 8';
        }
        field(84; "Payroll Amount 8"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 8';
        }
        field(85; "Payroll Number 9"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 9';
        }
        field(86; "Payroll Basis 9"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 9';
        }
        field(87; "Payroll Rate 9"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 9';
        }
        field(88; "Payroll Amount 9"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 9';
        }
        field(89; "Payroll Number 10"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 10';
        }
        field(90; "Payroll Basis 10"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 10';
        }
        field(91; "Payroll Rate 10"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 10';
        }
        field(92; "Payroll Amount 10"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 10';
        }
        field(93; "Payroll Number 11"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 11';
        }
        field(94; "Payroll Basis 11"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 11';
        }
        field(95; "Payroll Rate 11"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 11';
        }
        field(96; "Payroll Amount 11"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 11';
        }
        field(97; "Payroll Number 12"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre paie 12';
        }
        field(98; "Payroll Basis 12"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base paie 12';
        }
        field(99; "Payroll Rate 12"; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux paie 12';
        }
        field(100; "Payroll Amount 12"; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant paie 12';
        }
        field(101; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";
        }
        field(102; "Total Reminder"; Decimal)
        {
            Caption = 'Total rappel';
        }
        field(103; "Reminder Amount 1"; Decimal)
        {
            Caption = 'Mnt rappel 1';
        }
        field(104; "Reminder Amount 2"; Decimal)
        {
            Caption = 'Mnt rappel 2';
        }
        field(105; "Reminder Amount 3"; Decimal)
        {
            Caption = 'Mnt rappel 3';
        }
        field(106; "Reminder Amount 4"; Decimal)
        {
            Caption = 'Mnt rappel 4';
        }
        field(107; "Reminder Amount 5"; Decimal)
        {
            Caption = 'Mnt rappel 5';
        }
        field(108; "Reminder Amount 6"; Decimal)
        {
            Caption = 'Mnt rappel 6';
        }
        field(109; "Reminder Amount 7"; Decimal)
        {
            Caption = 'Mnt rappel 7';
        }
        field(110; "Reminder Amount 8"; Decimal)
        {
            Caption = 'Mnt rappel 8';
        }
        field(111; "Reminder Amount 9"; Decimal)
        {
            Caption = 'Mnt rappel 9';
        }
        field(112; "Reminder Amount 10"; Decimal)
        {
            Caption = 'Mnt rappel 10';
        }
        field(113; "Reminder Amount 11"; Decimal)
        {
            Caption = 'Mnt rappel 11';
        }
        field(114; "Reminder Amount 12"; Decimal)
        {
            Caption = 'Mnt rappel 12';
        }
    }

    keys
    {
        key(Key1; "Reminder Lot No.", "Employee No.", "Item Code")
        {
            SumIndexFields = "Total Reminder", "Reminder Amount 1", "Reminder Amount 2", "Reminder Amount 3", "Reminder Amount 4", "Reminder Amount 5", "Reminder Amount 6", "Reminder Amount 7", "Reminder Amount 8", "Reminder Amount 9", "Reminder Amount 10", "Reminder Amount 11", "Reminder Amount 12";
        }
    }

    fieldgroups
    {
    }

    var
        Rubrique: Record 52182481;
        ParamPaie: Record "Payroll Setup";
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

    /// <summary>
    /// CalcItemAmount.
    /// </summary>
    procedure CalcItemAmount();
    begin
    end;
}

