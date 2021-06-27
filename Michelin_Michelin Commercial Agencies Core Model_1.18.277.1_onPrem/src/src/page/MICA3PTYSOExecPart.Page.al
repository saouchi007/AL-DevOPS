page 82927 "MICA 3PTY SO Exec. Part"
{

    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Sales Line";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("MICA CAI"; Rec."MICA CAI")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. Shipped (Base)"; Rec."Qty. Shipped (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                }
                field("MICA Last Commitment DateTime"; Rec."MICA Last Commitment DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

}
