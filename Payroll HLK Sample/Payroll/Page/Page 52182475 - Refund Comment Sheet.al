/// <summary>
/// Page Refund Comment Sheet (ID 51440).
/// </summary>
page 52182475 "Refund Comment Sheet"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Refund Comment Sheet',
                FRA = 'Feuille de commentaires remboursement';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable = "Refund Comment Line";

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

