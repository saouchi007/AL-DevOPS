page 80870 "MICA Flow Buffer List"
{

    PageType = List;
    SourceTable = "MICA Flow Buffer";
    Caption = 'Interface Flow Buffers';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Time Creation"; Rec."Date Time Creation")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                    Editable = SkipLineEditable;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        MICAFlow: Record "MICA Flow";
    begin
        Rec.CalcFields("Flow Code");
        if MICAFlow.Get(Rec."Flow Code") then
            SkipLineEditable := MICAFlow."Allow Skip Line";
    end;

    var
        SkipLineEditable: Boolean;

}
