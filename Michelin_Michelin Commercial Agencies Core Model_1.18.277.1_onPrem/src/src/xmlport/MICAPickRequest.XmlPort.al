xmlport 80960 "MICA Pick Request"
{
    //INT-3PL-001: Pick request (out)

    DefaultNamespace = '';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            XmlName = 'ProcessSalesOrderVN';
            textelement(ApplicationArea)
            {
                textelement(Sender)
                {
                    textelement(LogicalID)
                    { }
                    textelement(ComponentID)
                    { }
                    textelement(TaskID)
                    { }
                    textelement(ReferenceID)
                    { }
                }
                textelement(CreationDateTime)
                { }
                textelement(UserArea)
                {
                    textelement(MichEnvironment)
                    { }
                    textelement(MichSender)
                    { }
                    textelement(MichReceiver)
                    { }
                    textelement(MichReceiverType)
                    { }
                    textelement(MichReferencekey)
                    { }
                    textelement(MichMessageType)
                    { }
                    textelement(MichSenderApplicationCode)
                    { }
                }
            }
            textelement(DataArea)
            {
                textelement(Process)
                { }
                textelement(SalesOrder)
                {
                    tableelement("Warehouse Shipment Header"; "Warehouse Shipment Header")
                    {
                        AutoSave = false;
                        XmlName = 'SalesOrderHeader';

                        textelement(DocumentID)
                        {
                            textelement(IDHdr)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(DocumentReference)
                        {
                            textattribute(type)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    type := 'REASON_CODE';
                                end;
                            }
                            textelement(documentid2)
                            {
                                XmlName = 'DocumentID';
                                textelement(ID)
                                {

                                    trigger OnBeforePassVariable()
                                    begin
                                        ID := 'PICK_REQUEST';
                                    end;
                                }
                            }
                        }
                        textelement(SupplierParty)
                        {
                            textelement(PartyIDs)
                            {
                                textelement(idSupplParty)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idSupplParty := MICAFinancialReportingSetup."Company Code";
                                    end;

                                }
                            }
                            textelement(Name)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    Name := MICAFinancialReportingSetup."Company Code" + '_OU';
                                end;
                            }
                            textelement(locationorg)
                            {
                                XmlName = 'Location';
                                textattribute(typeinvorg)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeInvOrg := 'InventoryOrganization';
                                    end;
                                }
                                textelement(id3)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        id3 := Location."MICA 3PL Location Name";
                                    end;
                                }
                                textelement(name2)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        name2 := Location."MICA 3PL Location Code";
                                    end;

                                }
                                textelement(userarea2)
                                {
                                    XmlName = 'UserArea';
                                    textelement(InvOrgType)
                                    {
                                    }
                                    textelement(WAREHOUSE_SHIPMENT_HEADER_NUM)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            WAREHOUSE_SHIPMENT_HEADER_NUM := "Warehouse Shipment Header"."No.";
                                        end;
                                    }
                                }
                            }
                            textelement(locationinv)
                            {
                                XmlName = 'Location';
                                textattribute(typeinvloc)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeinvloc := 'InventoryLocation';
                                    end;
                                }
                                textelement(idinvloc)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idinvloc := Location."MICA 3PL Location Name";
                                    end;
                                }
                                textelement(nameinvloc)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        nameinvloc := Location."MICA 3PL Location Code";
                                    end;
                                }
                                textelement(Address)
                                {
                                    textelement(LineOne)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            LineOne := Location.Address;
                                        end;
                                    }
                                    textelement(LineTwo)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            LineTwo := Location."Address 2";
                                        end;

                                    }
                                    textelement(LineThree)
                                    {
                                    }
                                    textelement(CityName)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            CityName := Location.City;
                                        end;

                                    }
                                    textelement(countrysubdivisioncodestate)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(namestate)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameState := 'STATE';
                                            end;
                                        }
                                    }
                                    textelement(countrysubdivisioncoderegion)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(nameregion)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameRegion := 'REGION';
                                            end;
                                        }
                                    }
                                    textelement(CountryCode)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            CountryCode := Location."Country/Region Code";
                                        end;

                                    }
                                    textelement(PostalCode)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            PostalCode := Location."Post Code";
                                        end;

                                    }
                                }
                            }
                            textelement(locationlogsite)
                            {
                                XmlName = 'Location';
                                textattribute(typelogsite)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeLogSite := 'LogisticsSite';
                                    end;
                                }
                                textelement(idlogsite)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idlogsite := Location."MICA 3PL Location Name";
                                    end;

                                }
                                textelement(namelogsite)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        namelogsite := Location."MICA 3PL Location Code";
                                    end;

                                }
                                textelement(addresslogsite)
                                {
                                    XmlName = 'Address';
                                    textelement(deliverypointcodelogsite)
                                    {
                                        XmlName = 'DeliveryPointCode';
                                    }
                                }
                            }
                            textelement(Contact)
                            {
                                textattribute(typecontlog)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeContLog := 'LOGISTICS';
                                    end;
                                }
                            }
                        }
                        textelement(CarrierParty)
                        {
                            textelement(partyidscarrier)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idcarrier)
                                {
                                    XmlName = 'ID';

                                    trigger OnBeforePassVariable()
                                    begin
                                        IDCarrier := 'GENERIC Carrier';
                                    end;
                                }
                            }
                        }
                        textelement(PromisedShipDateTime)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                PromisedShipDateTime := CopyStr(MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime("Warehouse Shipment Header"."Shipment Date", 0T)), 1, 19);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Clear(SalesHeader);
                            if WarehouseShipmentLine."Source Type" = Database::"Sales Line" then begin
                                SalesHeader.Get(WarehouseShipmentLine."Source Subtype", WarehouseShipmentLine."Source No.");
                                IDHdr := SalesHeader."No.";
                            end;
                            Clear(TransferHeader);
                            Clear(TransferToLocation);
                            if WarehouseShipmentLine."Source Type" = Database::"Transfer Line" then begin
                                TransferHeader.Get(WarehouseShipmentLine."Source No.");
                                TransferToLocation.Get(TransferHeader."Transfer-to Code");
                                IDHdr := TransferHeader."No.";
                            end;
                            Location.Get(WarehouseShipmentLine."Location Code");
                        end;
                    }
                    tableelement("Warehouse Shipment Line"; "Warehouse Shipment Line")
                    {
                        AutoSave = false;
                        LinkFields = "No." = FIELD("No.");
                        LinkTable = "Warehouse Shipment Header";
                        XmlName = 'SalesOrderLine';
                        fieldelement(ID; "Warehouse Shipment Line"."No.")
                        { }
                        fieldelement(LineNumber; "Warehouse Shipment Line"."Line No.")
                        { }
                        textelement(documentreferencesrchdrno)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(typesrchdrno)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeSrcHdrNo := 'SOURCE_HEADER_NUMBER';
                                end;
                            }
                            textelement(documentidsrchdrno)
                            {
                                XmlName = 'DocumentID';
                                fieldelement(ID; "Warehouse Shipment Line"."Source No.")
                                { }
                            }
                        }
                        textelement(documentreferencesrclineno)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(typesrclineno)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeSrcLineNo := 'SOURCE_LINE_NUMBER';
                                end;
                            }
                            textelement(documentidsrclineno)
                            {
                                XmlName = 'DocumentID';
                                textelement(idsrclineno)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idsrclineno := Format("Warehouse Shipment Line"."Source Line No.", 0, 9);
                                    end;
                                }
                            }
                        }
                        textelement(documentreferencesrvlevelname)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(typesrvlevelname)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeSrvLevelName := 'SERVICE_LEVEL_NAME';
                                end;
                            }
                            textelement(documentidsrvlevelname)
                            {
                                XmlName = 'DocumentID';
                                textelement(idsrvlevelname)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if SalesHeader."MICA Order Type" = 0 then
                                            idsrvlevelname := 'Standard'
                                        else
                                            idsrvlevelname := 'Express';
                                    end;

                                }
                            }
                        }
                        textelement(documentreferencetrmode)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(typetrmode)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeTrMode := 'TRANSPORT_MODE';
                                end;
                            }
                            textelement(documentidtrmode)
                            {
                                XmlName = 'DocumentID';
                                textelement(idtrmode)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if TransferHeader."No." = '' then
                                            idtrmode := SalesHeader."Shipment Method Code"
                                        else
                                            idtrmode := TransferHeader."Shipment Method Code";
                                    end;
                                }
                            }
                        }
                        textelement(Status)
                        {
                            textelement(codestatus)
                            {
                                XmlName = 'Code';
                                trigger OnBeforePassVariable()
                                begin
                                    codestatus := 'RELEASED TO WAREHOUSE';
                                end;
                            }
                        }
                        textelement(Item)
                        {
                            textelement(ItemID)
                            {
                                textelement(IDItem)
                                {
                                    XmlName = 'ID';
                                    textattribute(schemename)
                                    {
                                        XmlName = 'schemeName';

                                        trigger OnBeforePassVariable()
                                        begin
                                            schemeName := 'CAD';
                                        end;
                                    }

                                    trigger OnBeforePassVariable()
                                    var
                                        Item: Record Item;
                                    begin
                                        if Item.Get("Warehouse Shipment Line"."Item No.") then
                                            IDItem := Item."No."
                                        else begin
                                            FoundMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error,
                                                    "Warehouse Shipment Line".RecordId(),
                                                    StrSubstNo(MissingValueLbl, "Warehouse Shipment Line".FieldCaption("Item No.")),
                                                    Format("Warehouse Shipment Line".RecordId()));
                                            currXMLport.Skip();
                                        end;
                                    end;
                                }
                            }
                            textelement(CustomerItemID)
                            {
                                textelement(idcustitem)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    var
                                        CrossRef: Record "Item Cross Reference";
                                    begin
                                        CrossRef.SetRange("Cross-Reference Type", CrossRef."Cross-Reference Type"::Customer);
                                        CrossRef.SetRange("Item No.", "Warehouse Shipment Line"."Item No.");
                                        CrossRef.SetRange("Cross-Reference Type No.", "Warehouse Shipment Line"."Destination No.");
                                        if CrossRef.FindFirst() then
                                            idcustitem := CrossRef."Cross-Reference No."
                                        else
                                            idcustitem := '';
                                    end;
                                }
                            }
                            textelement(Description)
                            {
                                XmlName = 'Description';
                                trigger OnBeforePassVariable()
                                begin
                                    Description := CopyStr("Warehouse Shipment Line".Description + ' ' + "Warehouse Shipment Line"."Description 2", 1, 60);
                                end;
                            }
                            textelement(Classification)
                            {
                                textattribute(typeclasif)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeClasif := 'ProductLine';
                                    end;
                                }
                                textelement(codesclasif)
                                {
                                    XmlName = 'Codes';
                                    textelement(codeclasif)
                                    {
                                        XmlName = 'Code';
                                        textattribute(sequenceclasif)
                                        {
                                            XmlName = 'sequence';

                                            trigger OnBeforePassVariable()
                                            var
                                                Item: Record Item;
                                            begin
                                                Item.Get("Warehouse Shipment Line"."Item No.");
                                                sequenceClasif := Item."Item Category Code";
                                            end;
                                        }

                                        trigger OnBeforePassVariable()
                                        begin
                                            CodeClasif := 'TC';
                                        end;
                                    }
                                }
                            }
                        }
                        // fieldelement(Quantity; "Warehouse Shipment Line".Quantity)
                        // {
                        //     fieldattribute(unitCode; "Warehouse Shipment Line"."Unit of Measure Code")
                        //     { }
                        // }

                        textelement(Quantity)
                        {
                            XmlName = 'Quantity';
                            fieldattribute(unitCode; "Warehouse Shipment Line"."Unit of Measure Code")
                            {

                            }
                            trigger OnBeforePassVariable()
                            begin
                                Quantity := Format("Warehouse Shipment Line".Quantity, 0, '<Precision,0:2><Integer><Decimals><Comma,.>');
                            end;
                        }
                        textelement(ShipToParty)
                        {
                            textelement(partyidsshipto)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idshipto)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idshipto := "Warehouse Shipment Line"."Destination No.";
                                    end;
                                }
                            }
                            textelement(nameshipto)
                            {
                                XmlName = 'Name';
                            }
                            textelement(locationdelivery)
                            {
                                XmlName = 'Location';
                                textattribute(typedelivery)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeDelivery := 'DeliveryLocation';
                                    end;
                                }
                                textelement(iddelivery)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if TransferToLocation.Code <> '' then
                                            iddelivery := TransferToLocation."MICA 3PL Location Code"
                                        else
                                            iddelivery := SalesHeader."Ship-to Code";
                                    end;
                                }
                                textelement(namedelivery)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if TransferHeader."No." <> '' then
                                            namedelivery := TransferToLocation."MICA 3PL Location Name"
                                        else
                                            namedelivery := SalesHeader."Ship-to Name" + SalesHeader."Ship-to Name 2";
                                    end;
                                }
                                textelement(addressdelivery)
                                {
                                    XmlName = 'Address';
                                    textelement(lineonedelivery)
                                    {
                                        XmlName = 'LineOne';
                                        trigger OnBeforePassVariable()
                                        begin
                                            if TransferHeader."No." <> '' then
                                                lineonedelivery := TransferToLocation.Address
                                            else
                                                lineonedelivery := SalesHeader."Ship-to Address";
                                        end;
                                    }
                                    textelement(linetwodelivery)
                                    {
                                        XmlName = 'LineTwo';
                                        trigger OnBeforePassVariable()
                                        begin
                                            if TransferHeader."No." <> '' then
                                                linetwodelivery := TransferToLocation."Address 2"
                                            else
                                                linetwodelivery := SalesHeader."Ship-to Address 2";
                                        end;

                                    }
                                    textelement(linethreedelivery)
                                    {
                                        XmlName = 'LineThree';
                                    }
                                    textelement(citynamedelivery)
                                    {
                                        XmlName = 'CityName';
                                        trigger OnBeforePassVariable()
                                        begin
                                            if TransferHeader."No." <> '' then
                                                citynamedelivery := TransferToLocation.City
                                            else
                                                citynamedelivery := SalesHeader."Ship-to City";
                                        end;
                                    }
                                    textelement(countrysubdivisioncodedlvstate)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(listversioniddelivery)
                                        {
                                            XmlName = 'listVersionID';

                                            trigger OnBeforePassVariable()
                                            begin
                                                listVersionIDDelivery := 'STATE';
                                            end;
                                        }
                                    }
                                    textelement(countrysubdivisioncodedlvname)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(namedlvregion)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameDlvRegion := 'REGION';
                                            end;
                                        }
                                    }
                                    textelement(countrycodedelivery)
                                    {
                                        XmlName = 'CountryCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            if TransferHeader."No." <> '' then
                                                countrycodedelivery := TransferToLocation."Country/Region Code"
                                            else
                                                countrycodedelivery := SalesHeader."Ship-to Country/Region Code";
                                        end;

                                    }
                                    textelement(postalcodedelivery)
                                    {
                                        XmlName = 'PostalCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            if TransferHeader."No." <> '' then
                                                postalcodedelivery := TransferToLocation."Post Code"
                                            else
                                                postalcodedelivery := SalesHeader."Ship-to Post Code";
                                        end;
                                    }
                                }
                            }
                            textelement(userareashipto)
                            {
                                XmlName = 'UserArea';
                                textelement(remarkshipto)
                                {
                                    XmlName = 'REMARK';
                                    trigger OnBeforePassVariable()
                                    begin
                                        remarkshipto := "Warehouse Shipment Line"."MICA 3PL Whse Shpt. Comment";
                                    end;
                                }
                                textelement(customer_pickupshipto)
                                {
                                    XmlName = 'CUSTOMER_PICKUP';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if SalesHeader."MICA Customer Transport" then
                                            customer_pickupshipto := 'Y'
                                        else
                                            customer_pickupshipto := 'N';
                                    end;
                                }
                                textelement(onetimedeliveryshipto)
                                {
                                    XmlName = 'ONETIMEDELIVERY';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if SalesHeader."Shipping Advice" = SalesHeader."Shipping Advice"::Complete then
                                            onetimedeliveryshipto := 'Y'
                                        else
                                            onetimedeliveryshipto := 'N';
                                    end;
                                }
                                fieldelement(WAREHOUSE_SHIPMENT_LINE_NUM; "Warehouse Shipment Line"."Line No.")
                                { }
                            }
                        }
                        textelement(PurchaseOrderReference)
                        {
                            textelement(documentidporef)
                            {
                                XmlName = 'DocumentID';
                                textelement(idporef)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(linenumberporef)
                            {
                                XmlName = 'LineNumber';
                            }
                        }
                        textelement(DistributionCenterCode)
                        {
                        }
                        textelement(SalesOrderSchedule)
                        {
                            textelement(ShipmentQuantityTolerence)
                            {
                                textelement(UnderQuantity)
                                {

                                    trigger OnBeforePassVariable()
                                    begin
                                        UnderQuantity := '0';
                                    end;
                                }
                                textelement(OverQuantity)
                                {
                                    trigger OnBeforePassVariable()
                                    begin
                                        OverQuantity := '0';
                                    end;
                                }
                            }
                        }
                        textelement(TransportationMethodCode)
                        {
                            trigger OnBeforePassVariable()
                            var
                                ShipmentMethod: Record "Shipment Method";
                            begin
                                if ShipmentMethod.Get(SalesHeader."Shipment Method Code") then
                                    TransportationMethodCode := ShipmentMethod.Description
                                else
                                    TransportationMethodCode := '';
                            end;
                        }
                        textelement(Instructions)
                        {
                            textelement(InstructionCode)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    InstructionCode := 'REXLOG';
                                end;
                            }
                            textelement(InstructionString)
                            {
                            }
                        }
                        textelement(RequestedShipDateTime)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                RequestedShipDateTime := CopyStr(MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime(SalesLine."Requested Delivery Date", 0T)), 1, 19);
                            end;
                        }
                        textelement(ShipmentDateTime)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                ShipmentDateTime := CopyStr(MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime(SalesLine."Shipment Date", 0T)), 1, 19);
                            end;
                        }
                        textelement(ScheduledShipDateTime)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                ScheduledShipDateTime := CopyStr(MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime(SalesLine."Planned Shipment Date", 0T)), 1, 19);
                            end;
                        }
                        textelement(userareagrossw)
                        {
                            XmlName = 'UserArea';
                            textattribute(namegrossw)
                            {
                                XmlName = 'name';

                                trigger OnBeforePassVariable()
                                begin
                                    nameGrossW := 'GrossWeight';
                                end;
                            }
                            trigger OnBeforePassVariable()
                            begin
                                userareagrossw := Format(SalesLine."Gross Weight" * SalesLine."Quantity (Base)", 0, 9);
                            end;
                        }
                        textelement(userareaweightuom)
                        {
                            XmlName = 'UserArea';
                            textattribute(nameweightuom)
                            {
                                XmlName = 'name';

                                trigger OnBeforePassVariable()
                                begin
                                    nameWeightUOM := 'WeightUOM';
                                end;
                            }
                            trigger OnBeforePassVariable()
                            begin
                                userareaweightuom := 'KG';
                            end;
                        }
                        textelement(userareaitemorig)
                        {
                            XmlName = 'UserArea';
                            textattribute(nameitemorig)
                            {
                                XmlName = 'name';

                                trigger OnBeforePassVariable()
                                begin
                                    nameItemOrig := 'ItemOrigin';
                                end;
                            }
                        }
                        textelement(promisedshipdatetimesl)
                        {
                            XmlName = 'PromisedShipDateTime';
                            trigger OnBeforePassVariable()
                            begin
                                promisedshipdatetimesl := CopyStr(MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime(SalesLine."Planned Delivery Date", 0T)), 1, 19);
                            end;
                        }
                        textelement(supplierpartysl)
                        {
                            XmlName = 'SupplierParty';
                            textelement(partyidssuplparty)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idsuplparty)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idsuplparty := MICAFinancialReportingSetup."Company Code";
                                    end;
                                }
                            }
                            textelement(namesuplparty)
                            {
                                XmlName = 'Name';
                                trigger OnBeforePassVariable()
                                begin
                                    namesuplparty := MICAFinancialReportingSetup."Company Code" + '_OU';
                                end;
                            }
                            textelement(locationspinvorg)
                            {
                                XmlName = 'Location';
                                textattribute(typespinvorg)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeSPInvOrg := 'InventoryOrganization';
                                    end;
                                }
                                textelement(idspinvorg)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idspinvorg := Location."MICA 3PL Location Name";
                                    end;
                                }
                                textelement(namespinvorg)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        namespinvorg := Location."MICA 3PL Location Code";
                                    end;
                                }
                                textelement(userareaspinvorg)
                                {
                                    XmlName = 'UserArea';
                                    textelement(invorgtypespinvorg)
                                    {
                                        XmlName = 'InvOrgType';
                                    }
                                    textelement(subinventoryspinvorg)
                                    {
                                        XmlName = 'SubInventory';

                                        trigger OnBeforePassVariable()
                                        begin
                                            subinventoryspinvorg := Location.Code;
                                        end;
                                    }
                                }
                            }
                            textelement(locationspinvloc)
                            {
                                XmlName = 'Location';
                                textattribute(typespinvloc)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeSPInvLoc := 'InventoryLocation';
                                    end;
                                }
                                textelement(idspinvloc)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idspinvloc := Location."MICA 3PL Location Name";
                                    end;
                                }
                                textelement(namespinvloc)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        namespinvloc := Location."MICA 3PL Location Code";
                                    end;
                                }
                                textelement(addressspinvloc)
                                {
                                    XmlName = 'Address';
                                    textelement(lineonespinvloc)
                                    {
                                        XmlName = 'LineOne';
                                        trigger OnBeforePassVariable()
                                        begin
                                            lineonespinvloc := Location.Address;
                                        end;
                                    }
                                    textelement(linetwospinvloc)
                                    {
                                        XmlName = 'LineTwo';
                                        trigger OnBeforePassVariable()
                                        begin
                                            linetwospinvloc := Location."Address 2";
                                        end;
                                    }
                                    textelement(linethreespinvloc)
                                    {
                                        XmlName = 'LineThree';
                                    }
                                    textelement(citynamespinvloc)
                                    {
                                        XmlName = 'CityName';
                                        trigger OnBeforePassVariable()
                                        begin
                                            citynamespinvloc := Location.City;
                                        end;

                                    }
                                    textelement(countrysubdivcodestatespinvloc)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(namestatespinvloc)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameStateSPInvLoc := 'STATE';
                                            end;
                                        }
                                    }
                                    textelement(countrysubdivcoderegspinvloc)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(nameregionspinvloc)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameRegionSPInvLoc := 'REGION';
                                            end;
                                        }
                                    }
                                    textelement(countrycodespinvloc)
                                    {
                                        XmlName = 'CountryCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            countrycodespinvloc := Location."Country/Region Code";
                                        end;
                                    }
                                    textelement(postalcodespinvloc)
                                    {
                                        XmlName = 'PostalCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            postalcodespinvloc := Location."Post Code";
                                        end;
                                    }
                                }
                            }
                            textelement(locationsplogsite)
                            {
                                XmlName = 'Location';
                                textattribute(typesplogsite)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeSPLogSite := 'LogisticSite';
                                    end;
                                }
                                textelement(idsplogsite)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idsplogsite := Location."MICA 3PL Location Name";
                                    end;
                                }
                                textelement(namesplogsite)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        namesplogsite := Location."MICA 3PL Location Code";
                                    end;
                                }
                                textelement(addresssplogsite)
                                {
                                    XmlName = 'Address';
                                    textelement(deliverypointcodesplogsite)
                                    {
                                        XmlName = 'DeliveryPointCode';
                                    }
                                }
                            }
                        }
                        textelement(carrierpartysl)
                        {
                            XmlName = 'CarrierParty';
                            textelement(partyidsslcarrier)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idslcarrier)
                                {
                                    XmlName = 'ID';

                                    trigger OnBeforePassVariable()
                                    begin
                                        IDSLCarrier := '';
                                    end;
                                }
                            }
                            textelement(nameslcarrier)
                            {
                                XmlName = 'Name';
                            }
                        }
                        textelement(BillToParty)
                        {
                            textelement(partyidsslbill)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idslbill)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idslbill := SalesHeader."Bill-to Customer No.";
                                    end;
                                }
                            }
                            textelement(nameslbill)
                            {
                                XmlName = 'Name';
                                trigger OnBeforePassVariable()
                                begin
                                    nameslbill := SalesHeader."Bill-to Name" + SalesHeader."Bill-to Name 2";
                                end;
                            }
                            textelement(locationslbill)
                            {
                                XmlName = 'Location';
                                textattribute(typeslbillloc)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeSLBillLoc := 'BillToLocation';
                                    end;
                                }
                                textelement(idslbillloc)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idslbillloc := SalesHeader."Bill-to Customer No.";
                                    end;

                                }
                                textelement(nameslbillloc)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        nameslbillloc := SalesHeader."Bill-to Name" + SalesHeader."Bill-to Name 2";
                                    end;

                                }
                                textelement(addressslbillloc)
                                {
                                    XmlName = 'Address';
                                    textelement(lineoneslbillloc)
                                    {
                                        XmlName = 'LineOne';
                                        trigger OnBeforePassVariable()
                                        begin
                                            lineoneslbillloc := SalesHeader."Bill-to Address";
                                        end;

                                    }
                                    textelement(linetwoslbillloc)
                                    {
                                        XmlName = 'LineTwo';
                                        trigger OnBeforePassVariable()
                                        begin
                                            linetwoslbillloc := SalesHeader."Bill-to Address 2";
                                        end;

                                    }
                                    textelement(linethreeslbillloc)
                                    {
                                        XmlName = 'LineThree';
                                    }
                                    textelement(citynameslbillloc)
                                    {
                                        XmlName = 'CityName';
                                        trigger OnBeforePassVariable()
                                        begin
                                            citynameslbillloc := SalesHeader."Bill-to City";
                                        end;
                                    }
                                    textelement(countrysubdivcdstateslbillloc)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(namestateslbillloc)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameStateSLBillLoc := 'STATE';
                                            end;
                                        }
                                    }
                                    textelement(countrysubdivcoderegslbillloc)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(nameregionslbillloc)
                                        {
                                            XmlName = 'name';

                                            trigger OnBeforePassVariable()
                                            begin
                                                nameRegionSLBillLoc := 'REGION';
                                            end;
                                        }
                                    }
                                    textelement(countrycodeslbillloc)
                                    {
                                        XmlName = 'CountryCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            countrycodeslbillloc := SalesHeader."Bill-to Country/Region Code";
                                        end;

                                    }
                                    textelement(postalcodeslbillloc)
                                    {
                                        XmlName = 'PostalCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            postalcodeslbillloc := SalesHeader."Bill-to Post Code";
                                        end;

                                    }
                                }
                            }
                        }
                        textelement(customerpartysl)
                        {
                            XmlName = 'CustomerParty';
                            textelement(partyidsslcustomer)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idslcustomer)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idslcustomer := SalesHeader."Sell-to Customer No.";
                                    end;

                                }
                            }
                            textelement(nameslcustomer)
                            {
                                XmlName = 'Name';
                                trigger OnBeforePassVariable()
                                begin
                                    nameslcustomer := SalesHeader."Sell-to Customer Name" + SalesHeader."Sell-to Customer Name 2";
                                end;

                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Clear(SalesLine);
                            Clear(TransferLine);
                            if "Warehouse Shipment Line"."Source Type" = Database::"Sales Line" then
                                SalesLine.GET("Warehouse Shipment Line"."Source Subtype", "Warehouse Shipment Line"."Source No.", "Warehouse Shipment Line"."Source Line No.");
                            if "Warehouse Shipment Line"."Source Type" = Database::"Transfer Line" then
                                TransferLine.GET("Warehouse Shipment Line"."Source No.", "Warehouse Shipment Line"."Source Line No.");
                            TotalExported += 1;
                        end;
                    }
                }
            }
        }
    }
    var
        MICAFlowSetup: Record "MICA Flow Setup";
        FoundMICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Location: Record Location;
        TransferToLocation: Record Location;
        MICAFlowEntry: Record "MICA Flow Entry";
        CompanyInformation: record "Company Information";
        TotalExported: Integer;
        MissingValueLbl: Label 'Empty Field : %1';
        FirstRootName: Text;

    trigger OnPreXmlPort()
    var
        WarehouseShipmentHeader: record "Warehouse Shipment Header";
        MichReferencekeyLbl: Label '%1;%2;%3;%4', Comment = '%1%2%3%4', Locked = true;
    begin
        if not WarehouseShipmentLine.FindFirst() then
            currXMLport.Break();

        MICAFinancialReportingSetup.Get();

        CompanyInformation.get();
        CompanyInformation.TestField("Country/Region Code");

        FirstRootName := 'ProcessSalesOrder' + CompanyInformation."Country/Region Code";

        LogicalID := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'LogicalID');
        ComponentID := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'ComponentID');
        if WarehouseShipmentLine."Source Type" = Database::"Sales Line" then begin
            TaskID := StrSubstNo(MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'TaskID'), 'DOMESTIC_DELIVERY');
            MichMessageType := StrSubstNo(MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'TaskID'), 'PROCESS_SALESORDER');
        end;
        if WarehouseShipmentLine."Source Type" = Database::"Transfer Line" then begin
            TaskID := StrSubstNo(MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'TaskID'), 'INTERNAL_TRANSFER');
            MichMessageType := StrSubstNo(MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'TaskID'), 'PROCESS_TRANSFERORDER');
        end;

        WarehouseShipmentHeader.GET(WarehouseShipmentLine."No.");
        CreationDateTime := CopyStr(MICAFlowEntry.GetCurrentDateTimeWithTimeZoneOffset(), 1, 19);
        ReferenceID := WarehouseShipmentHeader."No." + '_' + CreationDateTime;
        MichEnvironment := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'Environment');
        MichSender := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'Sender');
        MichReceiver := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'Receiver');
        MichReceiverType := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'ReceiverType');
        MichReferencekey := StrSubstNo(MichReferencekeyLbl, LogicalID, TaskID, ReferenceID, MichReceiver);
        MichSenderApplicationCode := MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'SenderApplication');
    end;

    procedure SetParam(var InMICAFlowEntry: Record "MICA Flow Entry"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        FoundMICAFlowEntry := InMICAFlowEntry;
        "Warehouse Shipment Header".CopyFilters(WarehouseShipmentHeader);
        "Warehouse Shipment Header".SetRange("No.", WarehouseShipmentHeader."No.");

        WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
    end;

    procedure GetParam(var TotalExportedOut: Integer; var FileName: Text[100])
    begin
        TotalExportedOut := TotalExported;
        FileName := StrSubstNo(MICAFlowSetup.GetFlowTextParam(FoundMICAFlowEntry."Flow Code", 'FILENAMING'),
                                "Warehouse Shipment Header"."No.",
                                Format(CurrentDateTime(), 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
    end;
}