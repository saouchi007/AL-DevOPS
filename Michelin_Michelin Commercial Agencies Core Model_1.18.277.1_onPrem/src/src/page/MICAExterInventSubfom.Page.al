page 82924 "MICA Exter. Invent. Subfom"
{
    UsageCategory = None;
    Caption = 'External Inventory Card Part';
    PageType = ListPart;
    SourceTable = "Purchase Line";
    DelayedInsert = true;
    AutoSplitKey = true;
    MultipleNewLines = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("MICA CAI"; Rec."MICA CAI")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'CAD';
                    Editable = false;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("MICA Commited Quantity"; Rec."MICA Commited Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("MICA Last Commitment DateTime"; Rec."MICA Last Commitment DateTime")
                {
                    ApplicationArea = All;
                }
                field(AvailableQuantity; AvailableQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Available Quantity';
                    Editable = false;
                }
                field("MICA 3rd Party"; Rec."MICA 3rd Party")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AvailableQuantity := Rec.GetAvailableQuantity();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate(Type, Rec.Type::Item);
    end;

    var
        AvailableQuantity: Decimal;
}
