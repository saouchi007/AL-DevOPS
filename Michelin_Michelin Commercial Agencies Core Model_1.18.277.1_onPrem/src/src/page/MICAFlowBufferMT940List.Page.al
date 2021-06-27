page 80920 "MICA Flow Buffer MT940 List"
{
    //EDD-FIN-007 Format MT940 for Bank Statement   
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA Flow Buffer MT940-2";
    Caption = 'Flow Buffer MT940';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
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
                field("Date Time Creation"; Rec."Date Time Creation")
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
                field("Error"; Rec."Error")
                {
                    ApplicationArea = All;
                }
                field("Date Time Last Modified"; Rec."Date Time Last Modified")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = All;
                }
                field("Raw Closing Balance Date"; Rec."Raw Closing Balance Date")
                {
                    ApplicationArea = All;
                }
                field("Closing Balance Date"; Rec."Closing Balance Date")
                {
                    ApplicationArea = All;
                }
                field("Open Balance D/C"; Rec."Open Balance D/C")
                {
                    ApplicationArea = All;
                }
                field("Raw Open Balance Amount"; Rec."Raw Open Balance Amount")
                {
                    ApplicationArea = All;
                }
                field("Open Balance Amount"; Rec."Open Balance Amount")
                {
                    ApplicationArea = All;
                }
                field("Closing Balance D/C"; Rec."Closing Balance D/C")
                {
                    ApplicationArea = All;
                }
                field("Raw Closing Balance Amount"; Rec."Raw Closing Balance Amount")
                {
                    ApplicationArea = All;
                }
                field("Closing Balance Amount"; Rec."Closing Balance Amount")
                {
                    ApplicationArea = All;
                }
                field("Header Entry No."; Rec."Header Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Raw Line Date"; Rec."Raw Line Date")
                {
                    ApplicationArea = All;
                }
                field("Line Date"; Rec."Line Date")
                {
                    ApplicationArea = All;
                }
                field("Raw Line Entry Date"; Rec."Raw Line Entry Date")
                {
                    ApplicationArea = All;
                }
                field("Line Entry Date"; Rec."Line Entry Date")
                {
                    ApplicationArea = All;
                }
                field("Line Amount D/C"; Rec."Line Amount D/C")
                {
                    ApplicationArea = All;
                }
                field("Raw Line Amount"; Rec."Raw Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Transaction Text"; Rec."Transaction Text")
                {
                    ApplicationArea = All;
                }
                field("Additional Transaction Info"; Rec."Additional Transaction Info")
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
                Visible = false;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Extract: Codeunit "MICA Flow Extract MT940";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Extract.Run(FlowEntry);
                end;
            }
            action("Import to Bank Reconcilation")
            {
                Caption = 'Import to Bank Reconcilation';
                ApplicationArea = All;
                Image = ImportDatabase;
                Visible = false;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    GTC: Codeunit "MICA Flow Process MT940";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    GTC.Run(FlowEntry);
                end;
            }

        }
    }

}