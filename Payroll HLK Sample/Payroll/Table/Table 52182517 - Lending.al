/// <summary>
/// Table Lending (ID 52182517).
/// </summary>
table 52182517 Lending
//table 39108600 Lending
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction
    // 
    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Renseignements des champs

    Caption = 'Prêt';
    //LookupPageID = 39108553;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
            NotBlank = false;

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ParamRH.GET;
                    NoSeriesMgt.TestManual(ParamRH."Social Lending Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee No."; Code[10])
        {
            Caption = 'N° salarié';
            TableRelation = Employee WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    "Middle Name" := '';
                    EXIT;
                END;
                Salarie.GET("Employee No.");
                "First Name" := Salarie."First Name";
                "Last Name" := Salarie."Last Name";
                "Middle Name" := Salarie."Middle Name";
            end;
        }
        field(3; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(4; "Middle Name"; Text[30])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
            Editable = false;
        }
        field(5; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
        field(6; "Lending Amount"; Decimal)
        {
            Caption = 'Montant du prêt';
        }
        field(7; "Grant Date"; Date)
        {
            Caption = 'Date d''octroi';
        }
        field(8; "Monthly Amount"; Decimal)
        {
            Caption = 'Mensualité';

            trigger OnValidate();
            begin
                CalcChamps()
            end;
        }
        field(9; "Previous Refund"; Decimal)
        {
            Caption = 'Remboursement antérieur';
        }
        field(10; "Total Refund"; Decimal)
        {
            Caption = 'Total remboursements';
            Editable = false;
            FieldClass = Normal;
        }
        field(11; "End Date"; Date)
        {
            Caption = 'Date fin de remboursement';
        }
        field(12; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'N° Série';
            TableRelation = "No. Series";
        }
        field(13; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified',
                        FRA = 'Date dern. modification';
            Editable = false;
        }
        field(14; "Refund Calculation"; Option)
        {
            Caption = 'Calcul du remboursement';
            OptionCaptionML = FRA = 'Mensualité=Prêt/Durée,Durée=Prêt/Mensualité,Sans relation';
            OptionMembers = "Mensualité=Prêt/Durée","Durée=Prêt/Mensualité","Sans relation";
        }
        field(15; Period; Decimal)
        {
            Caption = 'Durée';

            trigger OnValidate();
            begin
                CalcChamps();
            end;
        }
        field(16; "Lending Type"; Code[10])
        {
            Caption = 'Type prêt';
            TableRelation = "Lending Type";

            trigger OnValidate();
            begin
                IF "Lending Type" = '' THEN
                    "Lending Deduction (Capital)" := ''
                ELSE BEGIN
                    TypePret.GET("Lending Type");
                    "Lending Deduction (Capital)" := TypePret."Lending Deduction (Capital)";
                    "Lending Deduction (Interest)" := TypePret."Lending Deduction (Interest)";
                END;
                MODIFY;
            end;
        }
        field(17; Status; Option)
        {
            Caption = 'Statut';
            OptionCaption = 'En cours,Clôturé';
            OptionMembers = "En cours","Clôturé";
        }
        field(18; "No. of Monthly Payments"; Integer)
        {
            Caption = 'Nbre de mensualités payées';
            Editable = false;
            FieldClass = Normal;
        }
        field(19; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(20)
                                                                     "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95001; "Deduct From Payroll"; Boolean)
        {
            Caption = 'Retenir de la paie';
        }
        field(95002; "Lending Deduction (Capital)"; Code[10])
        {
            Caption = 'Code retenue prêt (Capital)';
            TableRelation = "Payroll Item";
        }
        field(95003; "Lending Deduction (Interest)"; Code[10])
        {
            Caption = 'Code retenue prêt (Intérêt)';
            Editable = false;
            TableRelation = "Payroll Item";
        }
        field(95004; "Total Refund for landing"; Decimal)
        {
            CalcFormula = - Sum("Payroll Entry".Amount WHERE("Lending Code" = FIELD("No."),
                                                             "Employee No." = FIELD("Employee No."),
                                                            "Item Code" = CONST('860')));
            Caption = 'Total remboursements Prêt';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Employee No.", "Grant Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin


        IF "No." = '' THEN BEGIN
            ParamRH.GET;
            ParamRH.TESTFIELD("Social Lending Nos.");
            NoSeriesMgt.InitSeries(ParamRH."Social Lending Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text04);
        "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
        //+++01+++

        //---02---
        ParamPaie.GET;
        "Deduct From Payroll" := ParamPaie."Deduct Lending From Payroll";
        //+++02+++
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Salarie: Record 5200;
        ParamRH: Record 5218;
        NoSeriesMgt: Codeunit 396;
        Lending: Record 52182517;
        Text01: Label 'La durée du prêt a changé. Voulez-vous mettre à jour la date fin de remboursement ?';
        ParamUtilisateur: Record 91;
        Direction: Record 52182429;
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        ParamPaie: Record 52182483;
        TypePret: Record 52182518;


    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldLending">Record 52182517.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldLending: Record 52182517): Boolean;
    begin
        WITH Lending DO BEGIN
            COPY(Rec);
            ParamRH.GET;
            ParamRH.TESTFIELD("Social Lending Nos.");
            IF NoSeriesMgt.SelectSeries(ParamRH."Social Lending Nos.", OldLending."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := Lending;
                EXIT(TRUE);
            END;
        END;
    end;

    procedure CalcChamps();
    begin
        IF "Lending Amount" = 0 THEN
            EXIT;
        CASE "Refund Calculation" OF
            "Refund Calculation"::"Durée=Prêt/Mensualité":
                BEGIN
                    IF "Monthly Amount" = 0 THEN
                        EXIT;
                    Period := "Lending Amount" / "Monthly Amount";
                END;
            "Refund Calculation"::"Mensualité=Prêt/Durée":
                BEGIN
                    IF Period = 0 THEN
                        EXIT;
                    "Monthly Amount" := "Lending Amount" / Period;
                END;
        END;
    end;
}

