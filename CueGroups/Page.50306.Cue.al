/// <summary>
/// Page ISA_Cue (ID 50306).
/// </summary>
page 50306 ISA_Cue
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Customer;
    Caption = 'Cue';
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {
            cuegroup(CueGroup001)
            {
                Caption = 'Available Cues';
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    StyleExpr = 'Unfavorable';
                    ApplicationArea = All;

                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Number; Number)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        Message('Booya !');
                    end;
                }
            }
            cuegroup(CueGroup002)
            {
                caption = 'Action Cues';
                actions
                {
                    action(Booya)
                    {
                        Caption = 'Booya';
                        ApplicationArea = All;
                        Image = TileOrange;

                        trigger OnAction()
                        begin
                            Error('Booya !');
                        end;
                    }
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.SetFilter("Balance (LCY)", '>0');
        Number := -99;
    end;

    var
        Number: Integer;

}