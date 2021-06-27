pageextension 80880 "MICA Vendor Card" extends "Vendor Card"
{
    layout
    {

        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA English Name"; Rec."MICA English Name")
                {
                    ApplicationArea = All;
                }
                field("MICA Offtaker Code"; Rec."MICA Offtaker Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Party Ownership"; Rec."MICA Party Ownership")
                {
                    ApplicationArea = All;
                }
                field("MICA GTC Pricelist Code"; Rec."MICA GTC Pricelist Code")
                {
                    ApplicationArea = All;
                }
            }
            group("MICA Flow Integration")
            {
                Caption = 'Flow Integration';
                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;

                }
            }
        }
        Addlast(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}