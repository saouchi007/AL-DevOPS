codeunit 80361 "MICA CheckItemCommercialPeriod"
{
    trigger OnRun()
    begin
        CheckComPeriodForAllItems();
    end;

    local procedure CheckComPeriodForAllItems()
    var
        Item: Record Item;
    begin
        with Item do begin
            SetRange("SC Visible in Webshop", true);
            if FindSet() then
                repeat
                    if IsOverRangeOfCommercializationDate(Today()) then begin
                        validate("SC Visible in Webshop", false);
                        Modify();
                    end;
                until Next() = 0;
        end;
    end;
}