codeunit 80981 "MICA Whse.-Receipt Release"
{
    trigger OnRun()
    begin

    end;

    procedure Release(var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        Location: Record Location;
        //ATOLink: Record "Assemble-to-Order Link";
        //AsmLine: Record "Assembly Line";
        NothingToRekeaseErr: Label 'There is nothing to release for %1 %2.';
    begin
        with WarehouseReceiptHeader do begin
            if "MICA Status" = "MICA Status"::Released then
                exit;

            //OnBeforeRelease(WhseShptHeader);

            WarehouseReceiptLine.SETRANGE("No.", WarehouseReceiptHeader."No.");
            WarehouseReceiptLine.SETFILTER(Quantity, '<>0');
            if NOT WarehouseReceiptLine.FIND('-') then
                ERROR(NothingToRekeaseErr, WarehouseReceiptHeader.TableCaption(), WarehouseReceiptHeader."No.");

            if "Location Code" <> '' then
                Location.GET("Location Code");

            repeat
                WarehouseReceiptLine.TESTFIELD("Item No.");
                WarehouseReceiptLine.TESTFIELD("Unit of Measure Code");
                if Location."Directed Put-away and Pick" then
                    WarehouseReceiptLine.TESTFIELD("Zone Code");
                if Location."Bin Mandatory" then
                    WarehouseReceiptLine.TESTFIELD("Bin Code");
            until WarehouseReceiptLine.Next() = 0;

            //OnAfterTestWhseShptLine(WhseShptHeader, WhseShptLine);

            "MICA Status" := "MICA Status"::Released;
            MODIFY(false);

            Commit();
        end;

    end;

    procedure Reopen(var WarehouseReceiptHeader: Record "Warehouse Receipt Header");
    var
        //WarehousePickRqst: Record "Whse. Pick Request";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowMgt: Codeunit "MICA Flow Mgt";
        StatusPreparedErrorLbl: Label 'Send Last Flow status is Prepared';
        StatusSentZeroErrorLbl: Label 'Send Last Flow status is Sent with 0 errors';
        InfoType: option Information,Warning,Error;
    begin
        with WarehouseReceiptHeader do begin
            if "MICA Status" = "MICA Status"::Open then
                exit;

            if WarehouseReceiptHeader.NotClientTypeExcepted() then begin
                MICAFlowMgt.GetFlowEntry(WarehouseReceiptHeader."MICA Send Last Flow Entry No.", MICAFlowEntry);
                if MICAFlowEntry."Send Status" = MICAFlowEntry."Send Status"::Prepared then
                    Error(StatusPreparedErrorLbl);
                if MICAFlowEntry."Send Status" = MICAFlowEntry."Send Status"::Sent then
                    if MICAFlowMgt.CountFlowInformation(InfoType::Error, WarehouseReceiptHeader."MICA Send Last Flow Entry No.", WarehouseReceiptHeader."MICA Record ID") = 0 then
                        Error(StatusSentZeroErrorLbl)
            end;

            "MICA Status" := "MICA Status"::Open;
            Modify(false);

        end;
    end;
}