/// <summary>
/// Page Post Duties (ID 52182443).
/// </summary>
page 52182443 "Post Duties"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Post Duties',
                FRA = 'Missions du poste';
    DataCaptionFields = "Post Code";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = Duty;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine;
    end;


}

