/// <summary>
/// Table Medical Refund Header (ID 52182449).
/// </summary>
table 52182449 "Medical Refund Header"
//table 39108420 "Medical Refund Header"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Medical Refund Header',
                FRA = 'Entête remboursement médical';
    //LookupPageID = 39108438;

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type',
                        FRA = 'Type document';
            OptionCaptionML = ENU = 'Blank',
                              FRA = ' ';
            OptionMembers = Blank;
        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PayrollSetup.GET;
                    NoSeriesMgt.TestManual(PayrollSetup."Medical Reimbursement No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(3; "Collection Date"; Date)
        {
            CaptionML = ENU = 'Collection Date',
                        FRA = 'Date de collecte';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                UpdateLinesDates;
            end;
        }
        field(4; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'Souches de n°';
            TableRelation = "No. Series";
        }
        field(5; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(6; Comment; Boolean)
        {
            CalcFormula = Exist("Refund Comment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                             "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Refund Date"; Date)
        {
            CaptionML = ENU = 'Refund Date',
                        FRA = 'Date de remboursement';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                LigneRemboursement.SETRANGE("Document Type", "Document Type");
                LigneRemboursement.SETRANGE("Document No.", "No.");
                LigneRemboursement.SETRANGE(Status, LigneRemboursement.Status::Submitted);
                IF LigneRemboursement.FINDSET THEN BEGIN
                    REPEAT
                        IF LigneRemboursement."Refund Date" <> 0D THEN BEGIN
                            LigneRemboursement."Refund Date" := "Refund Date";
                            LigneRemboursement.MODIFY;
                        END;
                    UNTIL LigneRemboursement.NEXT = 0;
                END;
            end;
        }
        field(8; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            Editable = false;
            OptionCaptionML = ENU = 'Open,Released',
                              FRA = 'Ouvert,Lancé';
            OptionMembers = Open,Released;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
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
        field(10; "Shortcut Dimension 2 Code"; Code[20])
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
        field(11; "No. of Documents"; Integer)
        {
            CalcFormula = Count("Medical Refund Line" WHERE("Document Type" = FIELD("Document Type"),
                                                             "Document No." = FIELD("No.")));
            CaptionML = ENU = 'No. of Documents',
                        FRA = 'Nbre de documents';
            FieldClass = FlowField;
        }
        field(12; "Submittion Date"; Date)
        {
            CaptionML = ENU = 'Submission Date',
                        FRA = 'Date de remise';
        }
        field(13; "Total Amount"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("Medical Refund Line".Amount WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Amount',
                        FRA = 'Montant total';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        /*DimMgt.DeleteDocDim(DATABASE::"Medical Refund Header","Document Type","No.",0);
        DeleteReimbursLines;*/
        ReimbursCommentLine.SETRANGE("Document Type", "Document Type");
        ReimbursCommentLine.SETRANGE("No.", "No.");
        ReimbursCommentLine.DELETEALL;

    end;

    trigger OnInsert();
    begin
        PayrollSetup.GET;
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Collection Date", "No.", "No. Series");
        END;
        "Collection Date" := WORKDATE;
    end;

    var
        PayrollSetup: Record 52182483;
        EnteteRemboursement: Record 52182449;
        NoSeriesMgt: Codeunit 396;
        LigneRemboursement: Record 52182450;
        DimMgt: Codeunit 408;
        ReimbursCommentLine: Record 52182452;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldReimbursHeader">Record 51420.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldReimbursHeader: Record 52182449): Boolean;
    begin
        WITH EnteteRemboursement DO BEGIN
            COPY(Rec);
            PayrollSetup.GET;
            PayrollSetup.TESTFIELD("Medical Reimbursement No.");
            IF NoSeriesMgt.SelectSeries(PayrollSetup."Medical Reimbursement No.", OldReimbursHeader."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := EnteteRemboursement;
                EXIT(TRUE);
            END;
        END;
    end;

    /// <summary>
    /// GetNoSeriesCode.
    /// </summary>
    /// <returns>Return value of type Code[10].</returns>
    procedure GetNoSeriesCode(): Code[10];
    begin
        EXIT(PayrollSetup."Medical Reimbursement No.");
    end;

    /// <summary>
    /// TestNoSeries.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure TestNoSeries(): Boolean;
    begin
        PayrollSetup.TESTFIELD("Medical Reimbursement No.");
    end;

    /// <summary>
    /// DeleteReimbursLines.
    /// </summary>
    procedure DeleteReimbursLines();
    begin
        LigneRemboursement.SETRANGE("Document Type", "Document Type");
        LigneRemboursement.SETRANGE("Document No.", "No.");
        IF LigneRemboursement.FINDSET THEN BEGIN
            REPEAT
                LigneRemboursement.DELETE(TRUE);
            UNTIL LigneRemboursement.NEXT = 0;
        END;
    end;

    /// <summary>
    /// UpdateLinesDates.
    /// </summary>
    procedure UpdateLinesDates();
    begin
        LigneRemboursement.SETRANGE("Document Type", "Document Type");
        LigneRemboursement.SETRANGE("Document No.", "No.");
        LigneRemboursement.SETRANGE(Status, LigneRemboursement.Status::Received);
        IF LigneRemboursement.FINDSET THEN BEGIN
            REPEAT
                LigneRemboursement."Collection Date" := "Collection Date";
                LigneRemboursement.MODIFY;
            UNTIL LigneRemboursement.NEXT = 0;
        END;
    end;

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        /*DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        IF "No." <> '' THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Medical Refund Header","Document Type","No.",0,FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);*/

    end;

    /// <summary>
    /// ShowDocDim.
    /// </summary>
    procedure ShowDocDim();
    var
        DocDims: Page 652;
    begin
        /*DocDim.SETRANGE("Table ID",DATABASE::"Medical Refund Header");
        DocDim.SETRANGE("Document Type","Document Type");
        DocDim.SETRANGE("Document No.","No.");
        DocDim.SETRANGE("Line No.",0);
        DocDims.SETTABLEVIEW(DocDim);
        DocDims.RUNMODAL;
        GET("Document Type","No.");
        */

    end;
}

