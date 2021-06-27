codeunit 82762 "MICA Upd. Appl. SL Disc. Dates"
{
    trigger OnRun()
    begin
        Code();
    end;

    local procedure Code()
    var
        MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
        SalesLineDiscount: Record "Sales Line Discount";
    begin
        MICANewAppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
        MICANewAppliedSLDiscount.SetRange("Rebates Type", MICANewAppliedSLDiscount."Rebates Type"::Rebate);
        MICANewAppliedSLDiscount.SetRange("Document Type", MICANewAppliedSLDiscount."Document Type"::Order);
        MICANewAppliedSLDiscount.SetRange(Type, MICANewAppliedSLDiscount.Type::"Item Disc. Group");
        MICANewAppliedSLDiscount.SetFilter("Sales Discount %", '<>%1', 0);
        if MICANewAppliedSLDiscount.IsEmpty() then
            exit;

        if MICANewAppliedSLDiscount.FindSet() then
            repeat
                CheckAndModifyDates(SalesLineDiscount, MICANewAppliedSLDiscount);
            until MICANewAppliedSLDiscount.Next() = 0;
    end;

    local procedure CheckAndModifyDates(SalesLineDiscount: Record "Sales Line Discount"; MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount")
    var
        UpdateNewAppliedSLDiscount: Record "MICA New Applied SL Discount";
    begin
        SalesLineDiscount.SetCurrentKey(Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        SalesLineDiscount.SetRange("Sales Type", MICANewAppliedSLDiscount."Sales Type");
        SalesLineDiscount.SetRange("Sales Code", MICANewAppliedSLDiscount."Sales Code");
        SalesLineDiscount.SetRange(Type, MICANewAppliedSLDiscount.Type);
        SalesLineDiscount.SetRange(Code, MICANewAppliedSLDiscount.Code);
        SalesLineDiscount.SetRange("Line Discount %", MICANewAppliedSLDiscount."Sales Discount %");
        SalesLineDiscount.SetRange("Unit of Measure Code", MICANewAppliedSLDiscount."Unit of Measure Code");
        if SalesLineDiscount.IsEmpty() then
            exit;

        if SalesLineDiscount.FindFirst() then
            if (SalesLineDiscount."Starting Date" <> MICANewAppliedSLDiscount."Starting Date") or
                (MICANewAppliedSLDiscount."Ending Date" <> SalesLineDiscount."Ending Date")
            then
                if UpdateNewAppliedSLDiscount.Get(MICANewAppliedSLDiscount."Entry No.") then begin
                    UpdateNewAppliedSLDiscount."Starting Date" := SalesLineDiscount."Starting Date";
                    UpdateNewAppliedSLDiscount."Ending Date" := SalesLineDiscount."Ending Date";
                    UpdateNewAppliedSLDiscount.Modify();
                end;
    end;
}