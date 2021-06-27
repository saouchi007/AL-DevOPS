codeunit 82580 "MICA Calc. Inv. Availability"
{
    trigger OnRun()
    begin
        CalculateAvailability();
    end;

    var
        EntryNo: Integer;

    local procedure CalculateAvailability()
    var
        MICAInventoryAvailability: Record "MICA Inventory Availability";
    begin
        if not MICAInventoryAvailability.IsEmpty() then
            MICAInventoryAvailability.DeleteAll();

        EntryNo := 1;
        GetInventory();
    end;

    local procedure GetInventory()
    var
        CalcMICAInventoryAvailability: Query "MICA Inventory Availability";
    begin
        CalcMICAInventoryAvailability.Open();
        while CalcMICAInventoryAvailability.Read() do begin
            InsertInventoryAvailability(CalcMICAInventoryAvailability, CalcMICAInventoryAvailability.Quantity, 0);
            if CalcMICAInventoryAvailability.MICA_Allocation_Detail then
                GetAllocationDetails(CalcMICAInventoryAvailability.Code, CalcMICAInventoryAvailability.No_);
        end;
        CalcMICAInventoryAvailability.Close();
    end;

    local procedure InsertInventoryAvailability(CalcMICAInventoryAvailability: Query "MICA Inventory Availability"; Qty: decimal; CalcType: Integer)
    var
        MICAInventoryAvailability: Record "MICA Inventory Availability";
    begin
        MICAInventoryAvailability.Init();
        MICAInventoryAvailability."Entry No." := EntryNo;
        MICAInventoryAvailability."Item No." := CalcMICAInventoryAvailability.No_;
        MICAInventoryAvailability."Location Code" := CalcMICAInventoryAvailability.Code;
        MICAInventoryAvailability.Description := CalcMICAInventoryAvailability.Description;
        MICAInventoryAvailability.CAI := CalcMICAInventoryAvailability.No__2;
        MICAInventoryAvailability."Product Line" := CalcMICAInventoryAvailability.Item_Category_Code;
        MICAInventoryAvailability."Business Line" := CalcMICAInventoryAvailability.MICA_Business_Line;
        MICAInventoryAvailability."Market Code" := CalcMICAInventoryAvailability.MICA_Market_Code;
        MICAInventoryAvailability."User Item Type" := CalcMICAInventoryAvailability.MICA_User_Item_Type;
        MICAInventoryAvailability."Item Class" := CalcMICAInventoryAvailability.MICA_Item_Class;
        MICAInventoryAvailability.Brand := CalcMICAInventoryAvailability.MICA_Brand;
        MICAInventoryAvailability."Calculation Type" := CalcType;
        MICAInventoryAvailability.Quantity := Qty;
        MICAInventoryAvailability."Unit Cost" := CalcMICAInventoryAvailability.Unit_Cost;
        MICAInventoryAvailability.Insert();
        EntryNo += 1;
    end;

    local procedure GetAllocationDetails(LocationCode: Code[20]; ItemNo: Code[20])
    begin
        InsertAllocationDetails(LocationCode, ItemNo, 1);
        InsertAllocationDetails(LocationCode, ItemNo, 2);
        InsertAllocationDetails(LocationCode, ItemNo, 3);
        InsertAllocationDetails(LocationCode, ItemNo, 4);
        InsertAllocationDetails(LocationCode, ItemNo, 5);
    end;

    local procedure InsertAllocationDetails(LocationCode: Code[20]; ItemNo: Code[20]; CalcType: Integer)
    var
        MICAAllocationDetails: Query "MICA Allocation Details";
    begin
        MICAAllocationDetails.SetRange(No_Filter, ItemNo);
        MICAAllocationDetails.SetRange(Location_Code_Filter, LocationCode);
        case CalcType of
            1:
                MICAAllocationDetails.SetRange(MICA_Status_Filter, MICAAllocationDetails.MICA_Status::"Reserve OnHand");
            2:
                MICAAllocationDetails.SetRange(MICA_Status_Filter, MICAAllocationDetails.MICA_Status::"Reserve InTransit");
            3:
                MICAAllocationDetails.SetRange(MICA_Status_Filter, MICAAllocationDetails.MICA_Status::"Waiting Allocation");
            4:
                MICAAllocationDetails.SetRange(MICA_Status_Filter, MICAAllocationDetails.MICA_Status::"Send to Execution");
            5:
                begin
                    InsertAllocationDetailsTransferOrder(LocationCode, ItemNo);
                    exit;
                end;
        end;
        MICAAllocationDetails.Open();
        if MICAAllocationDetails.Read() then
            InsertInventoryAvailability(MICAAllocationDetails)
        else
            InsertInventoryAvailability(LocationCode, ItemNo, CalcType);
        MICAAllocationDetails.Close();
    end;

    local procedure InsertInventoryAvailability(MICAAllocationDetails: Query "MICA Allocation Details")
    var
        MICAInventoryAvailability: Record "MICA Inventory Availability";
    begin
        MICAInventoryAvailability.Init();
        MICAInventoryAvailability."Entry No." := EntryNo;
        MICAInventoryAvailability."Item No." := MICAAllocationDetails.No_;
        MICAInventoryAvailability."Location Code" := MICAAllocationDetails.Location_Code;
        MICAInventoryAvailability.Description := MICAAllocationDetails.Description;
        MICAInventoryAvailability.CAI := MICAAllocationDetails.No__2;
        MICAInventoryAvailability."Product Line" := MICAAllocationDetails.Item_Category_Code;
        MICAInventoryAvailability."Business Line" := MICAAllocationDetails.MICA_Business_Line;
        MICAInventoryAvailability."Market Code" := MICAAllocationDetails.MICA_Market_Code;
        MICAInventoryAvailability."User Item Type" := MICAAllocationDetails.MICA_User_Item_Type;
        MICAInventoryAvailability."Item Class" := MICAAllocationDetails.MICA_Item_Class;
        MICAInventoryAvailability.Brand := MICAAllocationDetails.MICA_Brand;
        MICAInventoryAvailability."Calculation Type" := MICAAllocationDetails.MICA_Status;
        MICAInventoryAvailability.Quantity := MICAAllocationDetails.Quantity;
        MICAInventoryAvailability."Unit Cost" := MICAAllocationDetails.Unit_Cost;
        MICAInventoryAvailability.Insert();
        EntryNo += 1;
    end;

    local procedure InsertInventoryAvailability(LocationCode: Code[20]; ItemNo: Code[20]; CalcType: Integer)
    var
        MICAInventoryAvailability: Record "MICA Inventory Availability";
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        MICAInventoryAvailability.Init();
        MICAInventoryAvailability."Entry No." := EntryNo;
        MICAInventoryAvailability."Item No." := ItemNo;
        MICAInventoryAvailability."Location Code" := LocationCode;
        MICAInventoryAvailability.Description := Item.Description;
        MICAInventoryAvailability.CAI := Item."No. 2";
        MICAInventoryAvailability."Product Line" := Item."Item Category Code";
        MICAInventoryAvailability."Business Line" := Item."MICA Business Line";
        MICAInventoryAvailability."Market Code" := Item."MICA Market Code";
        MICAInventoryAvailability."User Item Type" := Item."MICA User Item Type";
        MICAInventoryAvailability."Item Class" := Item."MICA Item Class";
        MICAInventoryAvailability.Brand := Item."MICA Brand";
        MICAInventoryAvailability."Calculation Type" := CalcType;
        MICAInventoryAvailability.Quantity := 0;
        MICAInventoryAvailability."Unit Cost" := Item."Unit Cost";
        MICAInventoryAvailability.Insert();
        EntryNo += 1;
    end;

    local procedure InsertAllocationDetailsTransferOrder(LocationCode: Code[20]; ItemNo: Code[20])
    var
        AllocDetailsTransferOrder: Query "Alloc. Details Transfer Order";
    begin
        AllocDetailsTransferOrder.SetFilter(Item_No_, ItemNo);
        AllocDetailsTransferOrder.SetFilter(Transfer_to_Code, LocationCode);
        AllocDetailsTransferOrder.Open();
        if AllocDetailsTransferOrder.Read() then
            InsertAllocationDetailsTransferOrder(AllocDetailsTransferOrder)
        else
            InsertInventoryAvailability(LocationCode, ItemNo, 5);
    end;

    local procedure InsertAllocationDetailsTransferOrder(AllocDetailsTransferOrder: Query "Alloc. Details Transfer Order")
    var
        MICAInventoryAvailability: Record "MICA Inventory Availability";
    begin
        MICAInventoryAvailability.Init();
        MICAInventoryAvailability."Entry No." := EntryNo;
        MICAInventoryAvailability."Item No." := AllocDetailsTransferOrder.Item_No_;
        MICAInventoryAvailability."Location Code" := AllocDetailsTransferOrder.Transfer_to_Code;
        MICAInventoryAvailability.Description := AllocDetailsTransferOrder.Description;
        MICAInventoryAvailability.CAI := AllocDetailsTransferOrder.No__2;
        MICAInventoryAvailability."Product Line" := AllocDetailsTransferOrder.Item_Category_Code;
        MICAInventoryAvailability."Business Line" := AllocDetailsTransferOrder.MICA_Business_Line;
        MICAInventoryAvailability."Market Code" := AllocDetailsTransferOrder.MICA_Market_Code;
        MICAInventoryAvailability."User Item Type" := AllocDetailsTransferOrder.MICA_User_Item_Type;
        MICAInventoryAvailability."Item Class" := AllocDetailsTransferOrder.MICA_Item_Class;
        MICAInventoryAvailability.Brand := AllocDetailsTransferOrder.MICA_Brand;
        MICAInventoryAvailability."Calculation Type" := MICAInventoryAvailability."Calculation Type"::"In-Transit";
        MICAInventoryAvailability.Quantity := AllocDetailsTransferOrder.Quantity;
        MICAInventoryAvailability."Unit Cost" := AllocDetailsTransferOrder.Unit_Cost;
        MICAInventoryAvailability.Insert();
        EntryNo += 1;
    end;
}