page 50154 PAutomateSetup
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PowerAutomateSetup;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Power Automate Setup';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';
                field(SetupField; Rec.SetupField)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}