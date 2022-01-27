/// <summary>
/// Table Training Comment Line (ID 52182446).
/// </summary>
table 52182446 "Training Comment Line"
//table 39108417 "Training Comment Line"
{

    CaptionML = ENU = 'Training Comment Line',
                FRA = 'Ligne commentaire formation';
    // DrillDownPageID = 39108433;
    // LookupPageID = 39108433;

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type',
                        FRA = 'Type document';
            OptionCaptionML = ENU = 'Request,Registration,Action',
                              FRA = 'Demande,Inscription,Action';
            OptionMembers = Request,Registration,"Action";
        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(4; "Document Line No."; Integer)
        {
            CaptionML = ENU = 'Document Line No.',
                        FRA = 'N° ligne document';
        }
        field(5; Date; Date)
        {
            CaptionML = ENU = 'Date',
                        FRA = 'Date';
        }
        field(6; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
        }
        field(7; Comment; Text[80])
        {
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", Comment, "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    /// <summary>
    /// SetUpNewLine.
    /// </summary>
    procedure SetUpNewLine();
    var
        TrainingCommentLine: Record 52182446;
    begin
        TrainingCommentLine.SETRANGE("Document Type", "Document Type");
        TrainingCommentLine.SETRANGE("No.", "No.");
        TrainingCommentLine.SETRANGE(Comment, Comment);
        TrainingCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT TrainingCommentLine.FIND('-') THEN
            Date := WORKDATE;
    end;
}

