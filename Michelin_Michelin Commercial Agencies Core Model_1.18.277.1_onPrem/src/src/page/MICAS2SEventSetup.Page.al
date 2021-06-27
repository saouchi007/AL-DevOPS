page 82867 "MICA S2S Event Setup"
{
    Caption = 'S2S Event Setup';
    PageType = Card;
    SourceTable = "MICA S2S Event Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Event Count On Refresh"; Rec."Event Count On Refresh")
                {
                    ApplicationArea = All;
                }
                field("Keep Events For"; Rec."Keep Events For")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then
            Rec.Insert();
    end;

}
