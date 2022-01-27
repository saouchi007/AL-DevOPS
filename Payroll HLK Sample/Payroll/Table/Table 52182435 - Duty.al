/// <summary>
/// Table Duty (ID 52182435).
/// </summary>
table 52182435 Duty
//table 39108406 Duty
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Duty',
                FRA = 'Mission';

    fields
    {
        field(1; "Post Code"; Code[20])
        {
            TableRelation = Post;
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(3; Description; Text[80])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
    }

    keys
    {
        key(Key1; "Post Code", "Line No.")
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
        DutyLine: Record 52182435;
    begin
        DutyLine.SETRANGE("Post Code", "Post Code");
    end;
}

