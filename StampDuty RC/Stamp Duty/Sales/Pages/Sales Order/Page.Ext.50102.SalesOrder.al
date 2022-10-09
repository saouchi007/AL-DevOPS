/// <summary>
/// PageExtension ISA_SalesOrderSubform (ID 50102) extends Record Sales Order.
/// </summary>
pageextension 50102 ISA_SalesOrder_Ext extends "Sales Order"
{
    layout
    {
        modify("Payment Method Code")
        {
            trigger OnAfterAfterLookup(Selected: RecordRef)
            var
                ToolBox: Codeunit ISA_ToolBox;
            begin
                ProcessSaleStampDuty();
            end;
        }
    }
    /// <summary>
    /// ProcessSaleStampDuty.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure ProcessSaleStampDuty(): Decimal
    var
        SalesHeader: Record "Sales Header";
        CheckStampDuty: Decimal;
        DocType: Enum "Sales Document Type";

    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", Rec."No.");
        SalesHeader.SetRange("Document Type", DocType::Order);

        if SalesHeader.FindSet then begin

            SalesHeader.CalcFields("Amount Including VAT");
            CheckStampDuty := (SalesHeader."Amount Including VAT" * 0.01);


            if CheckStampDuty < 5 then begin
                SalesHeader.ISA_StampDuty := 5;
                SalesHeader.ISA_AmountIncludingStampDuty := SalesHeader.ISA_StampDuty + SalesHeader."Amount Including VAT";
                SalesHeader.Modify();
            end;
            if CheckStampDuty > 2500 then begin
                SalesHeader.ISA_StampDuty := 2500;
                SalesHeader.ISA_AmountIncludingStampDuty := SalesHeader.ISA_StampDuty + SalesHeader."Amount Including VAT";
                SalesHeader.Modify();
            end;
            if (CheckStampDuty > 5) and (CheckStampDuty < 2500) then begin
                SalesHeader.ISA_StampDuty := Round(CheckStampDuty, 0.01, '=');
                SalesHeader.ISA_AmountIncludingStampDuty := SalesHeader.ISA_StampDuty + SalesHeader."Amount Including VAT";
                SalesHeader.Modify();
            end;

        end;
        exit(SalesHeader.ISA_StampDuty);
    end;

}