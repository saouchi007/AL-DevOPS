/// <summary>
/// Table Refund Comment Line (ID 52182452).
/// </summary>
table 52182452 "Refund Comment Line"
//table 39108423 "Refund Comment Line"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Refund Comment Line',
                FRA = 'Ligne commentaire remboursement';
    // DrillDownPageID = 39108440;
    //LookupPageID = 39108440;

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
        ReimbursCommentLine: Record 52182452;
    begin
        ReimbursCommentLine.SETRANGE("Document Type", "Document Type");
        ReimbursCommentLine.SETRANGE("No.", "No.");
        ReimbursCommentLine.SETRANGE(Comment, Comment);
        ReimbursCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT ReimbursCommentLine.FIND('-') THEN
            Date := WORKDATE;
    end;
}

