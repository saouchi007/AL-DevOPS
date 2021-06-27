page 80925 "MICA Flow Buf. CFM Exch. Rates"
{
    Caption = 'Flow Buffer CFM Exchange Rates';
    PageType = List;
    SourceTable = "MICA Flow Buf. CFM Exch. Rates";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Creation Date/time"; Rec."Creation Date/time")
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date/Time"; Rec."Last Modified Date/Time")
                {
                    ApplicationArea = All;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                }
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                }
                field("Error"; Rec.Error)
                {
                    ApplicationArea = All;
                }
                field("Bloc Type"; Rec."Bloc Type")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate Date Raw"; Rec."Exchange Rate Date Raw")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate Date"; Rec."Exchange Rate Date")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate Receipt Date Raw"; Rec."Exchange Rate Receipt Date Raw")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate Receipt Date"; Rec."Exchange Rate Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Base Currency Code Raw"; Rec."Base Currency Code Raw")
                {
                    ApplicationArea = All;
                }
                field("Base Currency Code"; Rec."Base Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Description"; Rec."Country/Region Description")
                {
                    ApplicationArea = All;
                }
                field("Currency Code Raw"; Rec."Currency Code Raw")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Direct Cross Rate Raw"; Rec."Direct Cross Rate Raw")
                {
                    ApplicationArea = All;
                }
                field("Direct Cross Rate"; Rec."Direct Cross Rate")
                {
                    ApplicationArea = All;
                }
                field("Indirect Cross Rate Raw"; Rec."Indirect Cross Rate Raw")
                {
                    ApplicationArea = All;
                }
                field("Indirect Cross Rate"; Rec."Indirect Cross Rate")
                {
                    ApplicationArea = All;
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code Raw"; Rec."Country/Region Code Raw")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
