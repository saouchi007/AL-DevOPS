page 80140 "MICA Commit/Split Line Setup"
{
    // version NAVW113.00

    ApplicationArea = Basic, Suite;
    Caption = 'Commitment/Split Line Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "MICA Commit/Split Line Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Disable Latest Shipment Date"; Rec."Disable Latest Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Back Order Default Ship. Date"; Rec."Back Order Default Ship. Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.RESET();
        IF NOT Rec.GET() THEN BEGIN
            Rec.INIT();
            Rec."Back Order Default Ship. Date" := 20991231D;
            Rec.INSERT();
        END;
    end;
}

