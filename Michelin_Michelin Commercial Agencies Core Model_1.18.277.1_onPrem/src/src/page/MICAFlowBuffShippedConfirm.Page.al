page 81190 "MICA FlowBuff Shipped Confirm."
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA FlowBuff Shipped Confirm2";
    Caption = 'Flow Buffer Shipped Confirmation';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
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

                //Shipment Confirmation (in) Fields
                field("Driver Info"; Rec."Driver Info")
                {
                    ApplicationArea = All;
                }
                field("License Plate-Truck"; Rec."License Plate")
                {
                    ApplicationArea = All;
                }
                field("License Plate Type"; Rec."License Plate Type")
                {
                    ApplicationArea = All;
                }
                field("RAW Actual Ship DateTime"; Rec."RAW Actual Ship DateTime")
                {
                    ApplicationArea = All;
                }
                field("Actual Ship DateTime"; Rec."Actual Ship DateTime")
                {
                    ApplicationArea = All;
                }
                field("RAW Shipped Quantity"; Rec."RAW Shipped Quantity")
                {
                    ApplicationArea = All;
                }
                field("Shipped Quantity"; Rec."Shipped Quantity")
                {
                    ApplicationArea = All;
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                }
                field("RAW Document Line Number"; Rec."RAW Document Line Number")
                {
                    ApplicationArea = All;
                }
                field("Document Line Number"; Rec."Document Line Number")
                {
                    ApplicationArea = All;
                }
                field("RAW Planned Ship Quantity"; Rec."RAW Planned Ship Quantity")
                {
                    ApplicationArea = All;
                }
                field("Planned Ship Quantity"; Rec."Planned Ship Quantity")
                {
                    ApplicationArea = All;
                }
                field("RAW Country Of Origin"; Rec."RAW Country Of Origin")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Country Of Origin"; Rec."Country Of Origin")
                {
                    ApplicationArea = All;

                }
                field("RAW DOT Value"; Rec."RAW DOT Value")
                {
                    ApplicationArea = All;

                }
                field("DOT Value"; Rec."DOT Value")
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
                    Extract: Codeunit "MICA Flow Extract Shipped Conf";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Extract.Run(FlowEntry);
                end;
            }
            action("Import Shipped Confirmation")
            {
                Caption = 'Import Shipped Confirmation';
                ApplicationArea = All;
                Image = ImportDatabase;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    Receive: Codeunit "MICA Flow Process Shipped Conf";
                begin
                    FlowEntry.Get(Rec."Entry No.");
                    Receive.Run(FlowEntry);
                end;
            }

        }
    }

}
