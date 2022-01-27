/// <summary>
/// Page Training Comment Sheet (ID 52182468).
/// </summary>
page 52182468 "Training Comment Sheet"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Training Comment Sheet',
                FRA = 'Feuille de commentaires formation';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable = "Training Comment Line";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
                field(Code; Code)
                {
                    Visible = false;
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

