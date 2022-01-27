/// <summary>
/// Table Payroll Reminder Lot (ID 52182549).
/// </summary>
table 52182549 "Payroll Reminder Lot"
//table 39108639 "Payroll Reminder Lot"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Reminder Header',
                FRA = 'Entête rappel de paie';
    //LookupPageID = 39108573;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ParamPaie.GET;
                    Numerotation.TestManual(ParamPaie."Reminder Nos.");
                    "No. Series" := '';
                    MESSAGE(ParamPaie."Reminder Nos.");
                END;
            end;
        }
        field(2; "Cumulate Reminder Items"; Boolean)
        {
            Caption = 'Cumuler les rubriques de rappel';
        }
        field(3; "Payroll Dimension 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Axe de paie 1';
        }
        field(4; "Payroll Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Axe de paie 2';
        }
        field(5; Comment; Boolean)
        {
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
        }
        field(6; "No. of Employees"; Integer)
        {
            CalcFormula = Count("Reminder Lot Employees" WHERE("No." = FIELD("No.")));
            Caption = 'Nbre de salariés';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = true;
        }
        field(8; "No. of Months"; Integer)
        {
            CalcFormula = Count("Reminder Lot Payrolls" WHERE("No." = FIELD("No.")));
            Caption = 'Nbre de mois';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Reminder Days"; Integer)
        {
            Caption = 'Nbre jours de rappel';
        }
        field(10; Observation; Text[250])
        {
            Caption = 'Observation';
        }
        field(11; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'Souches de n°';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            Editable = true;
            OptionCaptionML = ENU = ' ,Signed,Canceled',
                              FRA = 'En cours,Archivé,Suspendu';
            OptionMembers = "En cours","Archivé",Suspendu;

            trigger OnValidate();
            var
                AnyServItemInOtherContract: Boolean;
            begin
            end;
        }
        field(13; "Change Status"; Option)
        {
            CaptionML = ENU = 'Change Status',
                        FRA = 'Modifier statut';
            Editable = false;
            OptionCaptionML = ENU = 'Open,Locked',
                              FRA = 'En cours,Verrouillé,Archivé';
            OptionMembers = Open,Locked,Final;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        T39108641.RESET;
        T39108641.SETRANGE("No.", "No.");
        T39108641.DELETEALL;

        T39108642.RESET;
        T39108642.SETRANGE("No.", "No.");
        T39108642.DELETEALL;

        T39108643.RESET;
        T39108643.SETRANGE("No.", "No.");
        T39108643.DELETEALL;

        T39108644.RESET;
        T39108644.SETRANGE("Reminder Lot No.", "No.");
        T39108644.DELETEALL;

        T39108478.RESET;
        T39108478.SETRANGE("Reminder Lot No.", "No.");
        T39108478.DELETEALL;

        T39108479.RESET;
        T39108479.SETRANGE("Reminder Lot No.", "No.");
        T39108479.DELETEALL;
    end;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            ParamPaie.GET;
            ParamPaie.TESTFIELD("Reminder Nos.");
            Numerotation.InitSeries(ParamPaie."Reminder Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text06, USERID);
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        IF CodeUnite = '' THEN
            ERROR(Text05, USERID);
        Direction.GET(GestionnairePaie."Company Business Unit Code");
        "Company Business Unit Code" := GestionnairePaie."Company Business Unit Code";
        "Reminder Days" := ParamPaie."No. of Worked Days";
    end;

    var
        EnteteArchivePaie: Record 52182530;
        LigneArchivePaie: Record 52182531;
        LigneRappelPaie: Record 52182506;
        Salarie: Record 5200;
        GestionnairePaie: Record 52182503;
        Direction: Record 52182429;
        ParamPaie: Record 52182483;
        Numerotation: Codeunit 396;
        LotRappel: Record 52182549;
        AncienLotRappel: Record 52182549;
        Text05: Label 'Unité non configurée pour le gestionnaires de paie %1 !';
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        CodeUnite: Code[10];
        Paie: Record 52182484;
        T39108641: Record 52182550;
        T39108642: Record 52182551;
        T39108643: Record 52182552;
        T39108644: Record 52182553;
        T39108478: Record 52182505;
        T39108479: Record 52182506;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="AncienLotRappel">Record 51639.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(AncienLotRappel: Record 52182549): Boolean;
    begin
        WITH LotRappel DO BEGIN
            LotRappel := Rec;
            ParamPaie.GET;
            ParamPaie.TESTFIELD("Reminder Nos.");
            IF Numerotation.SelectSeries(ParamPaie."Reminder Nos.", AncienLotRappel."No. Series", "No. Series") THEN BEGIN
                MESSAGE(ParamPaie."Reminder Nos.");
                ParamPaie.GET;
                ParamPaie.TESTFIELD("Reminder Nos.");
                Numerotation.SetSeries("No.");
                Rec := LotRappel;
                EXIT(TRUE);
            END;
        END;
    end;
}

