page 81160 "MICA Purchasing Data Exports"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Purchasing Data Exports2";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                }
                field("Export Date"; Rec."Export Date")
                {
                    ApplicationArea = All;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Export)
            {
                Caption = 'Export';
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                var
                    Flow: Record "MICA Flow";
                begin
                    Flow.Get(Rec."Flow Code");
                    Flow.TestField("Send Codeunit ID");
                    Codeunit.Run(flow."Send Codeunit ID", Rec);
                end;
            }
        }
    }
}