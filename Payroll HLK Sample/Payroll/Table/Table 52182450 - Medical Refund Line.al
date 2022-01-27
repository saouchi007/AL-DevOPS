/// <summary>
/// Table Medical Refund Line (ID 51421).
/// </summary>
table 52182450 "Medical Refund Line"
//table 39108421 "Medical Refund Line"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Medical Refund Line',
                FRA = 'Ligne remboursement médical';

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type',
                        FRA = 'Type de document';
            OptionCaptionML = ENU = 'Blank',
                              FRA = ' ';
            OptionMembers = Blank;
        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.',
                        FRA = 'N° document';
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(4; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaption = '" ,Salarié"';
            OptionMembers = " Blank",Employee;
        }
        field(5; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
            TableRelation = IF (Type = CONST(Employee)) "Employee"."No.";

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF Type = Type::Employee THEN BEGIN
                    IF "No." = '' THEN BEGIN
                        "First Name" := '';
                        "Last Name" := '';
                        EXIT;
                    END;
                    GetReimbursHeader;
                    Employee.GET("No.");
                    "First Name" := Employee."First Name";
                    "Last Name" := Employee."Last Name";
                    "Social Security No." := Employee."Social Security No.";
                    GetEmployee;
                    "Shortcut Dimension 1 Code" := ReimbursHeader."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := ReimbursHeader."Shortcut Dimension 2 Code";
                    "Collection Date" := WORKDATE;
                END;
            end;
        }
        field(6; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
        field(7; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(8; "Collection Date"; Date)
        {
            CaptionML = ENU = 'Collection Date',
                        FRA = 'Date de collecte';

            trigger OnValidate();
            begin
                ValidateDates;
            end;
        }
        field(9; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            OptionCaptionML = ENU = 'Received,Submitted,Canceled,Reimbursed',
                              FRA = 'Reçu,Déposé,Annulé,Remboursé';
            OptionMembers = Received,Submitted,Canceled,Reimbursed;
        }
        field(10; "Refund Date"; Date)
        {
            CaptionML = ENU = 'Refund Date',
                        FRA = 'Date de remboursement';

            trigger OnValidate();
            begin
                ValidateDates;
            end;
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code',
                        FRA = 'Code raccourci axe 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code',
                        FRA = 'Code raccourci axe 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
        }
        field(14; "Refund Amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Refund Amount',
                        FRA = 'Montant remboursé';
        }
        field(21; "Social Security No."; Text[30])
        {
            CaptionML = ENU = 'Social Security No.',
                        FRA = 'N° sécurité sociale';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            SumIndexFields = Amount;
        }
        key(Key2; "No.", "Refund Date")
        {
            SumIndexFields = "Refund Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestStatusOpen;
        /*DocDim.LOCKTABLE;
        LOCKTABLE;
        DimMgt.DeleteDocDim(DATABASE::"Medical Refund Line","Document Type","Document No.","Line No.");*/

    end;

    trigger OnInsert();
    begin
        TestStatusOpen;
        /*DocDim.LOCKTABLE;
        LOCKTABLE;
        ReimbursHeader."No." := '';
        
        DimMgt.InsertDocDim(DATABASE::"Medical Refund Line","Document Type","Document No.","Line No.",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");*/

    end;

    trigger OnModify();
    begin
        TestStatusOpen;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;

    var
        DimMgt: Codeunit 408;
        Employee: Record 5200;
        StatusCheckSuspended: Boolean;
        ReimbursHeader: Record 52182449;
        ReimbursLine2: Record 52182450;
        Text000: Label 'Vous ne pouvez pas renommer %1.';
        Text001: Label 'La date de début doit être antérieure à la date de fin';

    procedure ShowDimensions();
    var
        DocDimensions: Page 652;
    begin
        /*TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        DocDim.SETRANGE("Table ID",DATABASE::"Medical Refund Line");
        DocDim.SETRANGE("Document Type","Document Type");
        DocDim.SETRANGE("Document No.","Document No.");
        DocDim.SETRANGE("Line No.","Line No.");
        DocDimensions.SETTABLEVIEW(DocDim);
        DocDimensions.RUNMODAL;*/

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        /*DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        IF "Line No." <> 0 THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Medical Refund Line","Document Type","Document No.",
            "Line No.",FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
          */

    end;

    procedure ValidateDates();
    begin
        IF ("Collection Date" = 0D) OR ("Refund Date" = 0D) THEN
            EXIT;
        IF "Collection Date" > "Refund Date" THEN
            ERROR(Text001);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        /*IF "Line No." <> 0 THEN
          DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(DATABASE::"Medical Refund Line","Document Type","Document No.","Line No.",ShortcutDimCode)
        ELSE
          DimMgt.ShowTempDim(ShortcutDimCode);*/

    end;

    procedure GetEmployee();
    begin
        TESTFIELD("No.");
        IF Employee."No." <> "No." THEN
            Employee.GET("No.");
    end;

    procedure GetReimbursHeader();
    begin
        TESTFIELD("No.");
        IF (Type <> ReimbursHeader."Document Type") OR ("No." <> ReimbursHeader."No.") THEN
            ReimbursHeader.GET("Document Type", "Document No.");
    end;

    procedure TestStatusOpen();
    begin
        IF StatusCheckSuspended THEN
            EXIT;
        GetReimbursHeader;
        IF Type IN [Type::Employee] THEN
            ReimbursHeader.TESTFIELD(Status, ReimbursHeader.Status::Open);
    end;
}

