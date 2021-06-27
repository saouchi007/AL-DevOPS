codeunit 80970 "MICA Pick Worskheet Mgt"
{
    procedure PickCreate(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
        WhseWorksheetTemplate: Record "Whse. Worksheet Template";
        WhsePickRequest: Record "Whse. Pick Request";
        FoundWhseWorksheetLine: Record "Whse. Worksheet Line";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WhseCreatePick: Report "Create Pick";
        CardWarehousePick: Page "Warehouse Pick";
        CurrentWkshName: Code[10];
        CurrentWkshLocation: Code[10];
        WhseWkshSelected: Boolean;
        WhseActivityFilter: Text;
    begin
        if WarehouseShipmentLine.IsEmpty() then
            exit;
        //Check if lines with multiple locations have been selected
        //Check Whse Shipment status must be released
        //Retrieve Whse ship location
        CurrentWkshLocation := CheckAndRetrieveWhseShipment(WarehouseShipmentLine);

        TemplateSelection(PAGE::"Pick Worksheet", 1, WhseWorksheetLine, WhseWorksheetTemplate, WhseWkshSelected);
        if not WhseWkshSelected then
            Error('');

        GetTemplateName(WhseWorksheetTemplate.Name, CurrentWkshName, CurrentWkshLocation);
        //WhseShipLine.FindSet();

        //Clear Worksheet lines before insert
        ClearWorksheetLines(WhseWorksheetTemplate.Name, CurrentWkshName);

        // Retrieve the warehouse pick request for ech whse shipment
        //CurrentWkshLocation := WhseShipLine."Location Code";
        GetWhsePickRequest(WarehouseShipmentLine, WhsePickRequest, WhseWorksheetTemplate.Name, CurrentWkshName, CurrentWkshLocation);


        //Create Pick from Whse Worksheet lines        
        FoundWhseWorksheetLine.SetRange("Worksheet Template Name", WhseWorksheetTemplate.Name);
        FoundWhseWorksheetLine.SetRange(Name, CurrentWkshName);
        FoundWhseWorksheetLine.SetRange("Location Code", CurrentWkshLocation);

        WhseCreatePick.SetWkshPickLine(FoundWhseWorksheetLine);
        WhseCreatePick.UseRequestPage(false);
        WhseCreatePick.RunModal();
        if WhseCreatePick.GetResultMessage() then
            WhseWorksheetLine.AutofillQtyToHandle(WhseWorksheetLine);

        //Delete non selected whse shipment lines from warehouse pick 
        RemoveUnselectedWhseShipmentLinesFromPick(WarehouseShipmentLine, WhseActivityFilter);

        //Open Whse Pick page
        WarehouseActivityHeader.Reset();
        WarehouseActivityHeader.SetFilter("No.", WhseActivityFilter);
        if WarehouseActivityHeader.FindFirst() then begin
            CardWarehousePick.SetTableView(WarehouseActivityHeader);
            CardWarehousePick.Run();
        end;

    end;

    local procedure CheckAndRetrieveWhseShipment(var WarehouseShipmentLine: Record "Warehouse Shipment Line"): Code[10]
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        Location: Record Location;
        PreviousLocation: Code[10];
        PreviousDoc: Code[20];
    begin
        PreviousDoc := '';
        WarehouseShipmentLine.FindSet();
        Location.Get(WarehouseShipmentLine."Location Code");
        Location.TestField("Require Pick", true);
        PreviousLocation := WarehouseShipmentLine."Location Code";
        repeat
            if PreviousDoc <> WarehouseShipmentLine."No." then begin
                WarehouseShipmentHeader.Get(WarehouseShipmentLine."No.");
                WarehouseShipmentHeader.TestField(Status, WarehouseShipmentHeader.Status::Released);
                PreviousDoc := WarehouseShipmentLine."No.";
            end;
            if PreviousLocation <> WarehouseShipmentLine."Location Code" then
                Error(LocationError_Lbl);
        until WarehouseShipmentLine.Next() = 0;
        exit(PreviousLocation);
    end;

    local procedure TemplateSelection(PageID: Integer; PageTemplate: Option "Put-away",Pick,Movement; var WhseWorksheetLine: Record "Whse. Worksheet Line"; var WhseWorksheetTemplate: Record "Whse. Worksheet Template"; var WhseWkshSelected: Boolean)
    var
        Wksht_Lbl: Label '%1 Worksheet';
    begin
        WhseWkshSelected := true;

        WhseWorksheetTemplate.Reset();
        WhseWorksheetTemplate.SetRange("Page ID", PageID);
        WhseWorksheetTemplate.SetRange(Type, PageTemplate);

        case WhseWorksheetTemplate.Count of
            0:
                begin
                    WhseWorksheetTemplate.Init();
                    WhseWorksheetTemplate.Validate(Type, PageTemplate);
                    WhseWorksheetTemplate.Validate("Page ID");
                    WhseWorksheetTemplate.Name :=
                      Format(WhseWorksheetTemplate.Type, MaxStrLen(WhseWorksheetTemplate.Name));
                    WhseWorksheetTemplate.Description := StrSubstNo(Wksht_Lbl, WhseWorksheetTemplate.Type);
                    WhseWorksheetTemplate.Insert();
                    Commit();
                end;
            1:
                WhseWorksheetTemplate.FindFirst();
            else
                WhseWkshSelected := PAGE.RunModal(0, WhseWorksheetTemplate) = ACTION::LookupOK;
        end;
        if WhseWkshSelected then begin
            WhseWorksheetLine.FilterGroup := 2;
            WhseWorksheetLine.SetRange("Worksheet Template Name", WhseWorksheetTemplate.Name);
            WhseWorksheetLine.FilterGroup := 0;
        end;
    end;

    /*local procedure GetTemplateName(CurrentWkshTemplateName: Code[10]; var CurrentWkshName: Code[10]; var CurrentLocationCode: Code[10])
    var
        WhseWkshTemplate: Record "Whse. Worksheet Template";
        WhseWkshName: Record "Whse. Worksheet Name";
        WhseEmployee: Record "Warehouse Employee";
        WmsMgt: Codeunit "WMS Management";
        FoundLocation: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        WhseWkshTemplate.Get(CurrentWkshTemplateName);
        WhseWkshName.SetRange("Worksheet Template Name", CurrentWkshTemplateName);
        if not WhseWkshName.Get(CurrentWkshTemplateName, CurrentWkshName, CurrentLocationCode) or
           ((UserId <> '') and not WhseEmployee.Get(UserId, CurrentLocationCode))
        then begin
            if UserId <> '' then begin
                CurrentLocationCode := WmsMgt.GetDefaultLocation();
                WhseWkshName.SetRange("Location Code", CurrentLocationCode);
            end;
            if not WhseWkshName.FindFirst() then begin
                if UserId <> '' then begin
                    WhseEmployee.SetCurrentKey(Default);
                    WhseEmployee.SetRange(Default, false);
                    WhseEmployee.SetRange("User ID", UserId);
                    if WhseEmployee.Find('-') then
                        repeat
                            WhseWkshName.SetRange("Location Code", WhseEmployee."Location Code");
                            FoundLocation := WhseWkshName.FindFirst();
                        until (WhseEmployee.Next() = 0) or FoundLocation;
                end;
                if not FoundLocation then begin
                    WhseWkshName.Init();
                    WhseWkshName."Worksheet Template Name" := CurrentWkshTemplateName;
                    WhseWkshName.SetupNewName();
                    WhseWkshName.Name := Dflt_Lbl;
                    WhseWkshName.Description :=
                      StrSubstNo(DfltWksht_Lbl, WhseWkshTemplate.Type);
                    WhseWkshName.Insert(true);
                end;
                CurrentLocationCode := WhseWkshName."Location Code";
                Commit();
            end;
            CurrentWkshName := WhseWkshName.Name;
            CurrentLocationCode := WhseWkshName."Location Code";
        end;
    end;*/
    local procedure GetTemplateName(CurrentWkshTemplateName: Code[10]; var CurrentWkshName: Code[10]; CurrentLocationCode: Code[10])
    var
        FoundWhseWorksheetTemplate: Record "Whse. Worksheet Template";
        FoundWhseWorksheetName: Record "Whse. Worksheet Name";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        FoundWhseWorksheetTemplate.Get(CurrentWkshTemplateName);
        FoundWhseWorksheetName.SetRange("Location Code", CurrentLocationCode);
        if not FoundWhseWorksheetName.FindFirst() then begin

            FoundWhseWorksheetName.Init();
            FoundWhseWorksheetName."Worksheet Template Name" := CurrentWkshTemplateName;
            FoundWhseWorksheetName.Name := CurrentLocationCode;
            FoundWhseWorksheetName.Description := CurrentLocationCode;
            FoundWhseWorksheetName."Location Code" := CurrentLocationCode;
            FoundWhseWorksheetName.Insert(true);

            Commit();
        end;
        CurrentWkshName := FoundWhseWorksheetName.Name;
    end;

    local procedure ClearWorksheetLines(CurrentWkshTemplateName: Code[10]; CurrentWkshName: Code[10])
    var
        DeleteWhseWorksheetLine: Record "Whse. Worksheet Line";
    begin
        DeleteWhseWorksheetLine.SetRange("Worksheet Template Name", CurrentWkshTemplateName);
        DeleteWhseWorksheetLine.SetRange(Name, CurrentWkshName);
        DeleteWhseWorksheetLine.DeleteAll();
    end;

    local procedure GetWhsePickRequest(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var WhsePickRequest: Record "Whse. Pick Request"; CurrentWhseWkshTemplate: Code[10]; CurrentWhseWkshName: Code[10]; LocationCode: Code[10])
    var
        PreviousDocNo: Code[20];
    begin
        PreviousDocNo := '';
        if WarehouseShipmentLine.FindSet() then
            repeat
                if (WarehouseShipmentLine."No." <> PreviousDocNo) then begin
                    WhsePickRequest.Reset();
                    WhsePickRequest.SetRange("Document Type", WhsePickRequest."Document Type"::Shipment);
                    WhsePickRequest.SetRange("Document No.", WarehouseShipmentLine."No.");
                    if WhsePickRequest.FindFirst() then
                        CreateWhseWkshtLines(WhsePickRequest, CurrentWhseWkshTemplate, CurrentWhseWkshName, LocationCode)
                end;
                PreviousDocNo := WarehouseShipmentLine."No.";
            until WarehouseShipmentLine.Next() = 0;
        //WhsePickRqst.MarkedOnly(true);
    end;

    local procedure CreateWhseWkshtLines(var WhsePickRequest: Record "Whse. Pick Request"; CurrentWhseWkshTemplate: Code[10]; CurrentWhseWkshName: Code[10]; LocationCode: Code[10])
    var
        GetOutboundSourceDocuments: Report "Get Outbound Source Documents";
    begin
        GetOutboundSourceDocuments.SetPickWkshName(
          CurrentWhseWkshTemplate, CurrentWhseWkshName, LocationCode);
        GetOutboundSourceDocuments.UseRequestPage(false);
        GetOutboundSourceDocuments.SetTableView(WhsePickRequest);
        GetOutboundSourceDocuments.RunModal();
    end;

    local procedure RemoveUnselectedWhseShipmentLinesFromPick(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var WhseActivityFilter: Text)
    var
        TempWarehouseShipmentLine: Record "Warehouse Shipment Line" temporary;
        WarehouseActivityLine: Record "Warehouse Activity Line";
        WhseActivityDocNo: Code[20];
    begin
        WhseActivityDocNo := '';
        if WarehouseShipmentLine.FindSet() then
            repeat
                Clear(TempWarehouseShipmentLine);
                TempWarehouseShipmentLine := WarehouseShipmentLine;
                TempWarehouseShipmentLine.Insert();
                WarehouseActivityLine.Reset();
                WarehouseActivityLine.SetCurrentKey("Activity Type", "No.", "Whse. Document Type", "Whse. Document No.", "Whse. Document Line No.");
                WarehouseActivityLine.SetRange("Whse. Document Type", WarehouseActivityLine."Whse. Document Type"::Shipment);
                WarehouseActivityLine.SetRange("Whse. Document No.", WarehouseShipmentLine."No.");
                WarehouseActivityLine.SetRange("Whse. Document Line No.", WarehouseShipmentLine."Line No.");
                if WarehouseActivityLine.FindFirst() then
                    if WarehouseActivityLine."No." <> WhseActivityDocNo then begin
                        if WhseActivityFilter = '' then
                            WhseActivityFilter := WarehouseActivityLine."No."
                        else
                            WhseActivityFilter += WarehouseActivityLine."No." + '|';
                        WhseActivityDocNo := WarehouseActivityLine."No.";
                    end;

            until WarehouseShipmentLine.Next() = 0;

        if WhseActivityFilter <> '' then begin
            WarehouseActivityLine.Reset();
            WarehouseActivityLine.SetFilter("No.", WhseActivityFilter);
            if WarehouseActivityLine.FindSet() then
                repeat
                    TempWarehouseShipmentLine.Reset();
                    TempWarehouseShipmentLine.SetRange("No.", WarehouseActivityLine."Whse. Document No.");
                    TempWarehouseShipmentLine.SetRange("Line No.", WarehouseActivityLine."Whse. Document Line No.");
                    if TempWarehouseShipmentLine.IsEmpty() then
                        WarehouseActivityLine.Delete();
                until WarehouseActivityLine.Next() = 0;

        end;
    end;


    var
        LocationError_Lbl: Label 'You can choose only one location to create a pick';

}