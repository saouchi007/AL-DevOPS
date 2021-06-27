pageextension 80021 "MICA Ship-To Card" extends "Ship-to Address"
{
    layout
    {
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                }

                field("MICA Last Modification Date"; Rec."MICA Last Modification Date")
                {
                    ApplicationArea = All;
                }

                field("MICA Base Calendar Code"; Rec."MICA Base Calendar Code")
                {
                    ApplicationArea = All;
                }

                field("MICA Express Order"; Rec."MICA Express Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Internal Code"; Rec."MICA Internal Code")
                {
                    ApplicationArea = All;
                }

                field("MICA MDM ID"; Rec."MICA MDM ID")
                {
                    ApplicationArea = All;
                }

                field("MICA MDM Ship-to Use ID"; Rec."MICA MDM Ship-to Use ID")
                {
                    ApplicationArea = all;
                }
                field("MICA Base Calendar Code Express Order"; Rec."MICA Base Cal. Code Exp. Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Shipping Agent Express Order"; Rec."MICA Ship. Agent Exp. Order")
                {
                    ApplicationArea = All;
                }
                field("MICA Shipping Agent Service Express Order"; Rec."MICA Ship Agent Serv Exp Order")
                {
                    ApplicationArea = All;
                }
                field("MICA RPL Status"; Rec."MICA RPL Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec."MICA RPL Status" <> xRec."MICA RPL Status" then
                            CurrPage.Update();
                    end;
                }
                field("MICA RPL Status Description"; Rec."MICA RPL Status Description")
                {
                    ApplicationArea = All;
                }
                field("MICA S2S External Ref."; Rec."MICA S2S External Ref.")
                {
                    ApplicationArea = All;
                }
                field("MICA Time Zone Name"; Rec."MICA Time Zone Name")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        TimeZone: Record "Time Zone";
                    begin
                        TimeZone.Reset();
                        TimeZone.SetCurrentKey("No.");
                        TimeZone."No." := Rec."MICA Time Zone";
                        if TimeZone.FIND('=><') then;
                        if PAGE.RUNMODAL(PAGE::"MICA Time Zone List", TimeZone) = ACTION::LookupOK then
                            Rec.Validate("MICA Time Zone", TimeZone."No.");
                    end;
                }

            }
        }
        addlast(content)
        {
            group("MICA Flow Integration")
            {
                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
    }
}