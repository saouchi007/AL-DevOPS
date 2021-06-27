page 82840 "MICA Ship-to Addr. PTY"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    SourceTable = "Ship-to Address";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                field("MICA Time Zone"; Rec."MICA Time Zone")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM ID"; Rec."MICA MDM ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}