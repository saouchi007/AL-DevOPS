page 82821 "MICA Flow Buff. Cust. PTY List"
{
    Caption = 'Flow Buffer Customer PTY';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Flow Buffer Cust. PTY";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
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
                    Editable = True;
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
                field("Cust. PTY Execution DateTime"; Rec."Cust. PTY Execution DateTime")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
                field("MICA Type Raw"; Rec."MICA Type Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA Status Raw"; Rec."MICA Status Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA Market Code"; Rec."MICA Market Code")
                {
                    ApplicationArea = All;
                }
                field("MICA English Name"; Rec."MICA English Name")
                {
                    ApplicationArea = All;
                }
                field("MICA Party Ownership Raw"; Rec."MICA Party Ownership Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA Channel"; Rec."MICA Channel")
                {
                    ApplicationArea = All;
                }
                field("MICA Business Orientation"; Rec."MICA Business Orientation")
                {
                    ApplicationArea = All;
                }
                field("MICA Partnership"; Rec."MICA Partnership")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM ID LE"; Rec."MICA MDM ID LE")
                {
                    ApplicationArea = All;
                }
                field("MICA TimeZone Raw"; Rec."MICA TimeZone Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM ID BT"; Rec."MICA MDM ID BT")
                {
                    ApplicationArea = All;
                }
                field("MICA RPL Status"; Rec."MICA RPL Status")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM Bill-to Site Use ID"; Rec."MICA MDM Bill-to Site Use ID")
                {
                    ApplicationArea = All;
                }
                field("MICA Customer Type Raw"; Rec."MICA Customer Type Raw")
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
            action("Ship-to Buffer PTY")
            {
                Caption = 'Ship-to Address Buffer PTY';
                ApplicationArea = All;
                Image = Open;
                RunObject = page "MICA Flow Buff. StP PTY List";
                ToolTip = 'Open Ship-to Address Buffer PTY page';
            }
        }

    }
}