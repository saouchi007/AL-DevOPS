/// <summary>
/// Page Cue (ID 50146).
/// </summary>
page 50146 Cues
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            cuegroup(GroupAlpha)
            {
                Caption = 'Customers Cue Groups';
                field(Balance; Rec.Balance)
                {
                    StyleExpr = 'unfavorable';
                    ApplicationArea = All;
                }
                field("Balance Due"; Rec."Balance Due")
                {
                    ApplicationArea = All;
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ApplicationArea = All;
                }
                field(myInt; myInt)
                {
                    ApplicationArea = All;
                    Caption = 'Number';
                    trigger OnDrillDown()
                    begin
                        Message('Nobody expects the spanish inquesition !');
                    end;
                }
            }

            cuegroup(GroupBeta)
            {
                Caption = 'Even more actions ...';
                actions
                {
                    action(HelloWorld)
                    {
                        Caption = 'Spanish Inquesition';
                        ApplicationArea = All;
                        Image = TileReport;
                        trigger OnAction()
                        var
                        begin
                            Message('Nobody expects the spanish inquesition !');
                        end;
                        //it renders differently between the role center "Business Manager" and the page where cues are defined
                    }

                }
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        myInt := 0;
    end;

    var
        myInt: Integer;
}