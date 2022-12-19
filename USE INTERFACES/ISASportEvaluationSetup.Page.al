/// <summary>
/// Page ISA_SportEvaluationSetup (ID 503010).
/// </summary>
page 50311 ISA_SportEvaluationSetup
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ISA_SportsEvaluationSetup;
    Caption = 'Sports Evaluation';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Handler; Rec.Handler)
                {
                    ApplicationArea = All;
                    Caption = 'Selected Sport';

                }
            }
        }
    }
}