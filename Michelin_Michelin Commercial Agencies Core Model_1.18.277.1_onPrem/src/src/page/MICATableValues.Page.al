page 81531 "MICA Table Values"
{
    PageType = List;
    SourceTable = "MICA Table Value";
    Caption = 'Table Values';
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table Type"; Rec."Table Type")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec."Blocked")
                {
                    ApplicationArea = All;
                }
                field("CT2 Referential Code"; Rec."CT2 Referential Code")
                {
                    ApplicationArea = All;
                }
                field("Allow Recalc."; Rec."Allow Recalc.")
                {
                    ApplicationArea = All;
                }
                field("Block Value"; Rec."Block Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    procedure GetSelectionFilter(var MICATableValue: Record "MICA Table Value"): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(MICATableValue);
        RecRef.GetTable(MICATableValue);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, 10))
    end;
}
