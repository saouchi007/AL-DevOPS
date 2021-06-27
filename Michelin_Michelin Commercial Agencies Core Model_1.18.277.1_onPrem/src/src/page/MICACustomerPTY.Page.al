page 82820 "MICA Customer PTY"
{
    Caption = 'Customer PTY';
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    DeleteAllowed = false;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                field("MICA Type"; Rec."MICA Type")
                {
                    ApplicationArea = All;
                }
                field("MICA Segmentation Code"; Rec."MICA Segmentation Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Status"; Rec."MICA Status")
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
                field("MICA Party Ownership"; Rec."MICA Party Ownership")
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
                field("MICA Time Zone"; Rec."MICA Time Zone")
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
            }
        }
    }
}