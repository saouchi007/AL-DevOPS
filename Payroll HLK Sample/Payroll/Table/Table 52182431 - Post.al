/// <summary>
/// Table Post (ID 52182431).
/// </summary>
table 52182431 Post
//table 39108402 Post

{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post',
                FRA = 'Poste';
    DataCaptionFields = "No.", Description;
    //DrillDownPageID = 51404;
    //LookupPageID = 51404;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Post Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; Category; Code[10])
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie';
            TableRelation = "Socio-professional Category";
        }
        field(5; Blocked; Boolean)
        {
            CaptionML = ENU = 'Blocked',
                        FRA = 'Bloqué';
        }
        field(6; "No. of Posts"; Integer)
        {
            CaptionML = ENU = 'No. of Posts',
                        FRA = 'Nbre de postes';
        }
        field(7; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'N° Série';
            TableRelation = "No. Series";
        }
        /*field(8; Comment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(16), "No." = FIELD("No.")));
            Editable = false;

        }*/
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

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD(HumanResSetup."Post Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Post Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        Post: Record 52182431;

        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldPost">Record 51402.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldPost: Record 52182431): Boolean;
    begin
        WITH Post DO BEGIN
            COPY(Rec);
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Post Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Post Nos.", OldPost."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := Post;
                EXIT(TRUE);
            END;
        END;
    end;
}

