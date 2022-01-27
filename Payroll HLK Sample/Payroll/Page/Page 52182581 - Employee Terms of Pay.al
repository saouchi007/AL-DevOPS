/// <summary>
/// Page Employee Terms of Pay (ID 51563).
/// </summary>
page 52182581 "Employee Terms of Pay"
{
    // version HALRHPAIE.6.2.00

    AutoSplitKey = true;
    CaptionML = ENU = 'Employee Terms of Pay',
                FRA = 'Clauses de rémunération du salarié';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Terms of pay";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Description; Description)
                {
                }
                field(Amount; Amount)
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

