page 82841 "MICA Flow Buff. StP PTY List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Flow Buffer Ship-to Address PTY';
    SourceTable = "MICA Flow Buffer StA PTY";
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
                    Editable = false;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field("Date Time Last Modified"; Rec."Date Time Last Modified")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Linked Record ID"; Rec."Linked Record ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Ship-to Addr. Exec. DateTime"; Rec."Ship-to Addr. Exec. DateTime")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Time Zone Raw"; Rec."MICA Time Zone Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM ID"; Rec."MICA MDM ID")
                {
                    ApplicationArea = All;
                }
                field("MICA Status Raw"; Rec."MICA Status Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA RPL Status"; Rec."MICA RPL Status")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM Ship-to Use ID"; Rec."MICA MDM Ship-to Use ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}