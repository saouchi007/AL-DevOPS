page 80940 "MICA Flow Buffer GTC List"
{

    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA Flow Buffer GTCPricelist2";
    Caption = 'Flow Buffer GTC Pricelist';
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Date Time Creation"; Rec."Date Time Creation")
                {
                    ApplicationArea = All;
                }
                field("Date Time Last Modified"; Rec."Date Time Last Modified")
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
                field("Bloc Type"; Rec."Bloc Type")
                {
                    ApplicationArea = All;
                }
                field("Header Raw File Date"; Rec."Header Raw File Date")
                {
                    ApplicationArea = All;
                }
                field("Header File Date"; Rec."Header File Date")
                {
                    ApplicationArea = All;
                }
                field("Line Price List Code"; Rec."Line Price List Code")
                {
                    ApplicationArea = All;
                }
                field("Line Item Type"; Rec."Line Item Type")
                {
                    ApplicationArea = All;
                }
                field("Line Item Code"; Rec."Line Item Code")
                {
                    ApplicationArea = All;
                }
                field("Line Invoicing Unit"; Rec."Line Invoicing Unit")
                {
                    ApplicationArea = All;
                }
                field("Line Price Code"; Rec."Line Price Code")
                {
                    ApplicationArea = All;
                }
                field("Line Raw Start Date"; Rec."Line Raw Start Date")
                {
                    ApplicationArea = All;
                }
                field("Line Start Date"; Rec."Line Start Date")
                {
                    ApplicationArea = All;
                }
                field("Line Raw End Date"; Rec."Line Raw End Date")
                {
                    ApplicationArea = All;
                }
                field("Line End Date"; Rec."Line End Date")
                {
                    ApplicationArea = All;
                }
                field("Line Raw Transfer Price"; Rec."Line Raw Transfer Price")
                {
                    ApplicationArea = All;
                }
                field("Line Transfer Price"; Rec."Line Transfer Price")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 2;
                }
                field("Line Currency Code"; Rec."Line Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Raw Record Counter"; Rec."Raw Record Counter")
                {
                    ApplicationArea = All;
                }
                field("Record Counter"; Rec."Record Counter")
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
            action("Import to Buffer")
            {
                Caption = 'Import to Buffer';
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Extract: Codeunit "MICA Flow Extract";
                begin
                    FlowEntry.Get(1);
                    Extract.Run(FlowEntry);
                end;
            }
            action("Import to Purchase Price")
            {
                Caption = 'Import to Purchase Price';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    GTC: Codeunit "MICA Flow Process GTCPriceLst";
                begin
                    FlowEntry.Get(1);
                    GTC.Run(FlowEntry);
                end;
            }

        }
    }
}