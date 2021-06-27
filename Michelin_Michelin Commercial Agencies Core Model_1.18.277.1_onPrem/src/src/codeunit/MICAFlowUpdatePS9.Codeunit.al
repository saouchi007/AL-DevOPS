codeunit 82081 "MICA Flow Update PS9"
{
    TableNo = "MICA Flow Buffer PS9";

    trigger OnRun()
    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        InventorySetup.Get();

        if Item.get(Rec."No.") then begin
            Item.Validate(Description, Rec.Description);
            ValidateFields(Rec, false);
            Item.modify(true);
        end else begin
            Clear(Item);
            Item.Validate("No.", Rec."No.");
            Item.Validate(Description, Rec.Description);
            Item.Insert(true);
            ValidateFields(Rec, true);
            Item.modify(true);
        end;

        MICAFlowRecord.UpdateReceiveRecord(Rec."Flow Entry No.", Item.RecordId(), MICAFlowEntry."Receive Status"::Processed);

    end;

    local procedure ValidateFields(MICAFlowBufferPS9: Record "MICA Flow Buffer PS9"; NoneUpdateFromPS9: Boolean)
    begin
        if (MICAFlowBufferPS9."No. 2" <> '') or ((MICAFlowBufferPS9."No. 2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item."No. 2" := MICAFlowBufferPS9."No. 2";
        if (MICAFlowBufferPS9."Base Unit of Measure" <> '') or ((MICAFlowBufferPS9."Base Unit of Measure" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("Base Unit of Measure", MICAFlowBufferPS9."Base Unit of Measure");
        if (MICAFlowBufferPS9."Item Category Code" <> '') or ((MICAFlowBufferPS9."Item Category Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("Item Category Code", MICAFlowBufferPS9."Item Category Code");
        if (MICAFlowBufferPS9."MICA Market Code" <> '') or ((MICAFlowBufferPS9."MICA Market Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Market Code", MICAFlowBufferPS9."MICA Market Code");
        if (MICAFlowBufferPS9."MICA Sensitive Product") or ((not MICAFlowBufferPS9."MICA Sensitive Product") and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Sensitive Product", MICAFlowBufferPS9."MICA Sensitive Product");
        if (MICAFlowBufferPS9."MICA Item Status") or ((not MICAFlowBufferPS9."MICA Item Status") and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Item Status", MICAFlowBufferPS9."MICA Item Status");
        if (MICAFlowBufferPS9."MICA Item Master Type Code" <> '') or ((MICAFlowBufferPS9."MICA Item Master Type Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Item Master Type Code", MICAFlowBufferPS9."MICA Item Master Type Code");
        if (MICAFlowBufferPS9."MICA Brand" <> '') or ((MICAFlowBufferPS9."MICA Brand" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Brand", MICAFlowBufferPS9."MICA Brand");
        if (MICAFlowBufferPS9."MICA Product Segment" <> '') or ((MICAFlowBufferPS9."MICA Product Segment" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Product Segment", MICAFlowBufferPS9."MICA Product Segment");
        if (MICAFlowBufferPS9."MICA Item Class" <> '') or ((MICAFlowBufferPS9."MICA Item Class" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Item Class", MICAFlowBufferPS9."MICA Item Class");
        if (MICAFlowBufferPS9."MICA Long Description" <> '') or ((MICAFlowBufferPS9."MICA Long Description" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Long Description", MICAFlowBufferPS9."MICA Long Description");
        if (MICAFlowBufferPS9."MICA Short Description" <> '') or ((MICAFlowBufferPS9."MICA Short Description" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Short Description", MICAFlowBufferPS9."MICA Short Description");
        if (MICAFlowBufferPS9."MICA Primary Unit Of Measure" <> '') or ((MICAFlowBufferPS9."MICA Primary Unit Of Measure" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Primary Unit Of Measure", MICAFlowBufferPS9."MICA Primary Unit Of Measure");
        if (MICAFlowBufferPS9."MICA LP Family Code" <> '') or ((MICAFlowBufferPS9."MICA LP Family Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA LP Family Code", MICAFlowBufferPS9."MICA LP Family Code");
        if (MICAFlowBufferPS9."MICA LPR Category" <> '') or ((MICAFlowBufferPS9."MICA LPR Category" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA LPR Category", MICAFlowBufferPS9."MICA LPR Category");
        if (MICAFlowBufferPS9."MICA LPR Sub Family" <> '') or ((MICAFlowBufferPS9."MICA LPR Sub Family" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA LPR Sub Family", MICAFlowBufferPS9."MICA LPR Sub Family");
        if (MICAFlowBufferPS9."MICA Product Nature" <> '') or ((MICAFlowBufferPS9."MICA Product Nature" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Product Nature", MICAFlowBufferPS9."MICA Product Nature");
        if (MICAFlowBufferPS9."MICA Usage Category" <> '') or ((MICAFlowBufferPS9."MICA Usage Category" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Usage Category", MICAFlowBufferPS9."MICA Usage Category");
        if (MICAFlowBufferPS9."MICA Prevision Indicator" <> '') or ((MICAFlowBufferPS9."MICA Prevision Indicator" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Prevision Indicator", MICAFlowBufferPS9."MICA Prevision Indicator");
        if (MICAFlowBufferPS9."MICA Manufacturer Part Number" <> '') or ((MICAFlowBufferPS9."MICA Manufacturer Part Number" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Manufacturer Part Number", MICAFlowBufferPS9."MICA Manufacturer Part Number");
        if (MICAFlowBufferPS9."MICA Commercial Label" <> '') or ((MICAFlowBufferPS9."MICA Commercial Label" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Commercial Label", MICAFlowBufferPS9."MICA Commercial Label");
        if (MICAFlowBufferPS9."MICA Product Weight" <> 0) or ((MICAFlowBufferPS9."MICA Product Weight" = 0) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Product Weight", MICAFlowBufferPS9."MICA Product Weight");
        if (MICAFlowBufferPS9."MICA Product Weight UOM" <> '') or ((MICAFlowBufferPS9."MICA Product Weight UOM" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Product Weight UOM", MICAFlowBufferPS9."MICA Product Weight UOM");
        if (MICAFlowBufferPS9."MICA Product Volume UoM" <> '') or ((MICAFlowBufferPS9."MICA Product Volume UoM" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Product Volume UoM", MICAFlowBufferPS9."MICA Product Volume UoM");
        if (MICAFlowBufferPS9."MICA Product Volume" <> 0) or ((MICAFlowBufferPS9."MICA Product Volume" = 0) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Product Volume", MICAFlowBufferPS9."MICA Product Volume");
        if (MICAFlowBufferPS9."MICA Section Width" <> 0) or ((MICAFlowBufferPS9."MICA Section Width" = 0) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Section Width", MICAFlowBufferPS9."MICA Section Width");
        if (MICAFlowBufferPS9."MICA Aspect Ratio" <> '') or ((MICAFlowBufferPS9."MICA Aspect Ratio" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Aspect Ratio", MICAFlowBufferPS9."MICA Aspect Ratio");
        if (MICAFlowBufferPS9."MICA Load Index 1" <> 0) or ((MICAFlowBufferPS9."MICA Load Index 1" = 0) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Load Index 1", MICAFlowBufferPS9."MICA Load Index 1");
        if (MICAFlowBufferPS9."MICA Speed Index 1" <> '') or ((MICAFlowBufferPS9."MICA Speed Index 1" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Speed Index 1", MICAFlowBufferPS9."MICA Speed Index 1");
        if (MICAFlowBufferPS9."MICA Tire Type" <> '') or ((MICAFlowBufferPS9."MICA Tire Type" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Tire Type", MICAFlowBufferPS9."MICA Tire Type");
        if (MICAFlowBufferPS9."MICA Star Rating" <> '') or ((MICAFlowBufferPS9."MICA Star Rating" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Star Rating", MICAFlowBufferPS9."MICA Star Rating");
        if (MICAFlowBufferPS9."MICA Grading Type" <> '') or ((MICAFlowBufferPS9."MICA Grading Type" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Grading Type", MICAFlowBufferPS9."MICA Grading Type");
        if (MICAFlowBufferPS9."MICA Rolling Resistance2" <> '') or ((MICAFlowBufferPS9."MICA Rolling Resistance2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Rolling Resistance2", MICAFlowBufferPS9."MICA Rolling Resistance2");
        if (MICAFlowBufferPS9."MICA Wet Grip2" <> '') or ((MICAFlowBufferPS9."MICA Wet Grip2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Wet Grip2", MICAFlowBufferPS9."MICA Wet Grip2");
        if (MICAFlowBufferPS9."MICA Noise Performance2" <> '') or ((MICAFlowBufferPS9."MICA Noise Performance2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Noise Performance2", MICAFlowBufferPS9."MICA Noise Performance2");
        if (MICAFlowBufferPS9."MICA Noise Wave2" <> '') or ((MICAFlowBufferPS9."MICA Noise Wave2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Noise Wave2", MICAFlowBufferPS9."MICA Noise Wave2");
        if (MICAFlowBufferPS9."MICA Noise Class2" <> '') or ((MICAFlowBufferPS9."MICA Noise Class2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Noise Class2", MICAFlowBufferPS9."MICA Noise Class2");
        if (MICAFlowBufferPS9."MICA Aspect Quality2" <> '') or ((MICAFlowBufferPS9."MICA Aspect Quality2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Aspect Quality2", MICAFlowBufferPS9."MICA Aspect Quality2");
        if (MICAFlowBufferPS9."MICA Marketing Manager Name2" <> '') or ((MICAFlowBufferPS9."MICA Marketing Manager Name2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Marketing Manager Name2", MICAFlowBufferPS9."MICA Marketing Manager Name2");
        if (MICAFlowBufferPS9."MICA Commercial. Start Date" <> 0D) or ((MICAFlowBufferPS9."MICA Commercial. Start Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Commercial. Start Date", MICAFlowBufferPS9."MICA Commercial. Start Date");
        if (MICAFlowBufferPS9."MICA Commercial. End Date" <> 0D) or ((MICAFlowBufferPS9."MICA Commercial. End Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Commercial. End Date", MICAFlowBufferPS9."MICA Commercial. End Date");
        Item.Validate("MICA None Update from PS9", NoneUpdateFromPS9);
        if (MICAFlowBufferPS9."MICA CCID Code" <> '') or ((MICAFlowBufferPS9."MICA CCID Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA CCID Code", MICAFlowBufferPS9."MICA CCID Code");
        if (MICAFlowBufferPS9."MICA User Item Type" <> '') or ((MICAFlowBufferPS9."MICA User Item Type" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA User Item Type", MICAFlowBufferPS9."MICA User Item Type");
        if (MICAFlowBufferPS9."MICA Vignette") or ((not MICAFlowBufferPS9."MICA Vignette") and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Vignette", MICAFlowBufferPS9."MICA Vignette");
        if (MICAFlowBufferPS9."MICA Business Line" <> '') or ((MICAFlowBufferPS9."MICA Business Line" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Business Line", MICAFlowBufferPS9."MICA Business Line");
        if (MICAFlowBufferPS9."MICA Business Line OE" <> '') or ((MICAFlowBufferPS9."MICA Business Line OE" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Business Line OE", MICAFlowBufferPS9."MICA Business Line OE");
        if (MICAFlowBufferPS9."MICA Business Line RT" <> '') or ((MICAFlowBufferPS9."MICA Business Line RT" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Business Line RT", MICAFlowBufferPS9."MICA Business Line RT");
        if (MICAFlowBufferPS9."MICA LB-OE" <> '') or ((MICAFlowBufferPS9."MICA LB-OE" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA LB-OE", MICAFlowBufferPS9."MICA LB-OE");
        if (MICAFlowBufferPS9."MICA LB-RT" <> '') or ((MICAFlowBufferPS9."MICA LB-RT" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA LB-RT", MICAFlowBufferPS9."MICA LB-RT");
        if (MICAFlowBufferPS9."MICA Administrative Status" <> '') or ((MICAFlowBufferPS9."MICA Administrative Status" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Administrative Status", MICAFlowBufferPS9."MICA Administrative Status");
        if (MICAFlowBufferPS9."MICA Load Range" <> '') or ((MICAFlowBufferPS9."MICA Load Range" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Load Range", MICAFlowBufferPS9."MICA Load Range");
        if (MICAFlowBufferPS9."MICA Airtightness" <> '') or ((MICAFlowBufferPS9."MICA Airtightness" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Airtightness", MICAFlowBufferPS9."MICA Airtightness");
        if (MICAFlowBufferPS9."MICA Tire Size" <> '') or ((MICAFlowBufferPS9."MICA Tire Size" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Tire Size", MICAFlowBufferPS9."MICA Tire Size");
        if (MICAFlowBufferPS9."MICA Pattern Code" <> '') or ((MICAFlowBufferPS9."MICA Pattern Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Pattern Code", MICAFlowBufferPS9."MICA Pattern Code");
        if (MICAFlowBufferPS9."MICA Homologator Code" <> '') or ((MICAFlowBufferPS9."MICA Homologator Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologator Code", MICAFlowBufferPS9."MICA Homologator Code");
        if (MICAFlowBufferPS9."MICA Homologator Label" <> '') or ((MICAFlowBufferPS9."MICA Homologator Label" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologator Label", MICAFlowBufferPS9."MICA Homologator Label");
        if (MICAFlowBufferPS9."MICA Homologation Market Code" <> '') or ((MICAFlowBufferPS9."MICA Homologation Market Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologation Market Code", MICAFlowBufferPS9."MICA Homologation Market Code");
        if (MICAFlowBufferPS9."MICA Homologation Vehicle Code" <> '') or ((MICAFlowBufferPS9."MICA Homologation Vehicle Code" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologation Vehicle Code", MICAFlowBufferPS9."MICA Homologation Vehicle Code");
        if (MICAFlowBufferPS9."MICA Homologation Type2" <> '') or ((MICAFlowBufferPS9."MICA Homologation Type2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologation Type2", MICAFlowBufferPS9."MICA Homologation Type2");
        if (MICAFlowBufferPS9."MICA Homologation Start Date" <> 0D) or ((MICAFlowBufferPS9."MICA Homologation Start Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologation Start Date", MICAFlowBufferPS9."MICA Homologation Start Date");
        if (MICAFlowBufferPS9."MICA Homologation End Date" <> 0D) or ((MICAFlowBufferPS9."MICA Homologation End Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologation End Date", MICAFlowBufferPS9."MICA Homologation End Date");
        if (MICAFlowBufferPS9."MICA Homologa. Deliver Profil" <> '') or ((MICAFlowBufferPS9."MICA Homologa. Deliver Profil" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologa. Deliver Profil", MICAFlowBufferPS9."MICA Homologa. Deliver Profil");
        if (MICAFlowBufferPS9."MICA Homologation Country" <> '') or ((MICAFlowBufferPS9."MICA Homologation Country" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Homologation Country", MICAFlowBufferPS9."MICA Homologation Country");
        if (MICAFlowBufferPS9."MICA Derogation Number" <> '') or ((MICAFlowBufferPS9."MICA Derogation Number" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Derogation Number", MICAFlowBufferPS9."MICA Derogation Number");
        if (MICAFlowBufferPS9."MICA Derogation Quantity" <> 0) or ((MICAFlowBufferPS9."MICA Derogation Quantity" = 0) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Derogation Quantity", MICAFlowBufferPS9."MICA Derogation Quantity");
        if (MICAFlowBufferPS9."MICA Certificate Country" <> '') or ((MICAFlowBufferPS9."MICA Certificate Country" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Certificate Country", MICAFlowBufferPS9."MICA Certificate Country");
        if (MICAFlowBufferPS9."MICA Certif. Effective Date" <> 0D) or ((MICAFlowBufferPS9."MICA Certif. Effective Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Certif. Effective Date", MICAFlowBufferPS9."MICA Certif. Effective Date");
        if (MICAFlowBufferPS9."MICA Certif. Expiration Date" <> 0D) or ((MICAFlowBufferPS9."MICA Certif. Expiration Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Certif. Expiration Date", MICAFlowBufferPS9."MICA Certif. Expiration Date");
        if (MICAFlowBufferPS9."MICA Certificate Number" <> '') or ((MICAFlowBufferPS9."MICA Certificate Number" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Certificate Number", MICAFlowBufferPS9."MICA Certificate Number");
        if (MICAFlowBufferPS9."MICA Regional. Active Country" <> '') or ((MICAFlowBufferPS9."MICA Regional. Active Country" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Regional. Active Country", MICAFlowBufferPS9."MICA Regional. Active Country");
        if (MICAFlowBufferPS9."MICA Regional. Act. Str. Date" <> 0D) or ((MICAFlowBufferPS9."MICA Regional. Act. Str. Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Regional. Act. Str. Date", MICAFlowBufferPS9."MICA Regional. Act. Str. Date");
        if (MICAFlowBufferPS9."MICA Regional. Act. End Date" <> 0D) or ((MICAFlowBufferPS9."MICA Regional. Act. End Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Regional. Act. End Date", MICAFlowBufferPS9."MICA Regional. Act. End Date");
        if (MICAFlowBufferPS9."MICA Custom Export Country" <> '') or ((MICAFlowBufferPS9."MICA Custom Export Country" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Custom Export Country", MICAFlowBufferPS9."MICA Custom Export Country");
        if (MICAFlowBufferPS9."MICA Custom Start Date2" <> 0D) or ((MICAFlowBufferPS9."MICA Custom Start Date2" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Custom Start Date2", MICAFlowBufferPS9."MICA Custom Start Date2");
        if (MICAFlowBufferPS9."MICA Custom End Date2" <> 0D) or ((MICAFlowBufferPS9."MICA Custom End Date2" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Custom End Date2", MICAFlowBufferPS9."MICA Custom End Date2");
        if (MICAFlowBufferPS9."MICA Military ECCN Code2" <> '') or ((MICAFlowBufferPS9."MICA Military ECCN Code2" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Military ECCN Code2", MICAFlowBufferPS9."MICA Military ECCN Code2");
        if (MICAFlowBufferPS9."MICA Military ECCN Label" <> '') or ((MICAFlowBufferPS9."MICA Military ECCN Label" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Military ECCN Label", MICAFlowBufferPS9."MICA Military ECCN Label");
        if (MICAFlowBufferPS9."MICA Military Export Country" <> '') or ((MICAFlowBufferPS9."MICA Military Export Country" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Military Export Country", MICAFlowBufferPS9."MICA Military Export Country");
        if (MICAFlowBufferPS9."MICA Military Start Date" <> 0D) or ((MICAFlowBufferPS9."MICA Military Start Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Military Start Date", MICAFlowBufferPS9."MICA Military Start Date");
        if (MICAFlowBufferPS9."MICA Military End Date" <> 0D) or ((MICAFlowBufferPS9."MICA Military End Date" = 0D) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Military End Date", MICAFlowBufferPS9."MICA Military End Date");
        if (MICAFlowBufferPS9."MICA EAN Item ID" <> '') or ((MICAFlowBufferPS9."MICA EAN Item ID" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item."MICA EAN Item ID" := MICAFlowBufferPS9."MICA EAN Item ID";
        Item."MICA Record ID" := Item.RecordId();
        if (MICAFlowBufferPS9."MICA Last DateTime Modified" <> 0DT) or ((MICAFlowBufferPS9."MICA Last DateTime Modified" = 0DT) and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("Last DateTime Modified", MICAFlowBufferPS9."MICA Last DateTime Modified");
        if (MICAFlowBufferPS9."MICA Blocked") or ((not MICAFlowBufferPS9."MICA Blocked") and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate(Blocked, MICAFlowBufferPS9."MICA Blocked");
        if (MICAFlowBufferPS9."MICA Rim Diameter" <> '') or ((MICAFlowBufferPS9."MICA Rim Diameter" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Rim Diameter", MICAFlowBufferPS9."MICA Rim Diameter");
        if (MICAFlowBufferPS9."MICA Rim Diameter UOM" <> '') or ((MICAFlowBufferPS9."MICA Rim Diameter UOM" = '') and not InventorySetup."MICA Keep Value in Item Card") then
            Item.Validate("MICA Rim Diameter UOM", MICAFlowBufferPS9."MICA Rim Diameter UOM");
    end;

    var
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
}