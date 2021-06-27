page 82929 "MICA CAI Availability"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'CAI Availability';
    PageType = List;
    SourceTableTemporary = true;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("MICA CAI"; Rec."MICA CAI")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("MICA Commited Quantity"; Rec."MICA Commited Quantity")
                {
                    ApplicationArea = All;
                }
                field("MICA Last Commitment DateTime"; Rec."MICA Last Commitment DateTime")
                {
                    ApplicationArea = All;
                }
                field(AvailableQuantity; AvailableQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Available Quantity';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchaseLine: Record "Purchase Line";
        myAvailableQuantity: Decimal;
        CriticalValue: Decimal;
    begin
        SalesReceivablesSetup.Get();
        if UserSetup.Get(UserId) then
            if UserSetup."MICA 3rd Party Vendor No." <> '' then
                PurchaseLine.SetRange("Buy-from Vendor No.", UserSetup."MICA 3rd Party Vendor No.");
        PurchaseLine.SetRange("Document Type", Rec."Document Type"::"Blanket Order");
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.CalcFields("MICA 3rd Party");
                myAvailableQuantity := PurchaseLine.GetAvailableQuantity();
                CriticalValue := PurchaseLine."Quantity (Base)" * (SalesReceivablesSetup."MICA 3rd Party Avail. Warn. %" / 100);
                if SalesReceivablesSetup."MICA 3rd Party Avail. Warn. %" = 0 then begin
                    Rec.TransferFields(PurchaseLine);
                    Rec.Insert();
                end else
                    if PurchaseLine."MICA 3rd Party" and (myAvailableQuantity < CriticalValue) then begin
                        Rec.TransferFields(PurchaseLine);
                        Rec.Insert();
                    end
            until PurchaseLine.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    begin
        AvailableQuantity := Rec.GetAvailableQuantity();
    end;

    var
        AvailableQuantity: Decimal;
}
