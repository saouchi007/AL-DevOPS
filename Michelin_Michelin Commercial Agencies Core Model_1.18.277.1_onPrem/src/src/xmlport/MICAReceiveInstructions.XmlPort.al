xmlport 80980 "MICA Receive Instructions"
{
    //INT-3PL-002
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(ProcessReceiveDelivery)
        {
            XmlName = 'ProcessReceiveDeliveryVN';
            textattribute(Release_ProcessReceiveDelivery)
            {
                XmlName = 'releaseID';
                trigger OnBeforePassVariable()
                begin
                    Release_ProcessReceiveDelivery := '9';
                end;
            }
            textelement(ApplicationArea)
            {
                XmlName = 'ApplicationArea';
                textelement(Sender)
                {
                    textelement(LogicalID)
                    {
                    }
                    textelement(ComponentID)
                    {
                    }
                    textelement(TaskID)
                    {
                    }
                    textelement(ReferenceID)
                    {
                    }
                    trigger OnBeforePassVariable()
                    var
                        DataTypeManagement: CodeUnit "Data Type Management";
                        RecRef: RecordRef;
                        tempCode: Code[20];
                        ReferenceIDLbl: Label '%1_%2', Comment = '%1%2', Locked = true;
                    begin
                        LogicalID := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'LOGICALID');
                        ComponentID := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'COMPONENTID');

                        UpdateGlobalInformation(WarehouseReceiptLine);

                        case WarehouseReceiptLine."Source Document" of
                            WarehouseReceiptLine."Source Document"::"Sales Return Order":
                                tempCode := 'DOMESTIC RETURN';
                            WarehouseReceiptLine."Source Document"::"Inbound Transfer":
                                If HasAsnNo then
                                    tempCode := 'IMPORT'
                                else
                                    tempCode := 'INTERNAL_TRANSFER';
                        end;
                        TaskID := tempCode;

                        DataTypeManagement.GetRecordRef(WarehouseReceiptHeader, RecRef);
                        ReferenceID := StrSubstNo(ReferenceIDLbl, WarehouseReceiptHeader."No.", Format(ExportCurrentDateTime, 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
                    end;
                }
                textelement(CreationDateTime)
                {
                    trigger OnBeforePassVariable()
                    var
                        MICAFlowEntry: Record "MICA Flow Entry";
                    begin
                        CreationDateTime := MICAFlowEntry.GetCurrentDateTimeWithTimeZoneOffset();
                    end;
                }
                textelement(UserArea)
                {
                    textelement(MichEnvironment)
                    {
                    }
                    textelement(MichSender)
                    {
                    }
                    textelement(MichReceiver)
                    {
                    }
                    textelement(MichReceiverType)
                    {
                    }
                    textelement(MichReferencekey)
                    {
                    }
                    textelement(MichMessageType)
                    {
                    }
                    textelement(MichSenderApplicationCode)
                    {
                    }

                    trigger OnBeforePassVariable()
                    var
                        tempCode: Code[30];
                    begin
                        MichEnvironment := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'ENVIRONMENT');
                        MichSender := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'SENDER');
                        MichReceiver := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'RECEIVER');
                        MichReceiverType := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'RECEIVERTYPE');
                        MichReferencekey := LogicalID + ';' + TaskID + ';' + ReferenceID + ';' + MichReceiver;

                        case WarehouseReceiptLine."Source Document" of
                            WarehouseReceiptLine."Source Document"::"Sales Return Order":
                                tempCode := 'PROCESS_RMA';
                            WarehouseReceiptLine."Source Document"::"Inbound Transfer":
                                If HasAsnNo then
                                    tempCode := 'PROCESS_IMPORTORDER'
                                else
                                    tempCode := 'PROCESS_TRANSFERORDER'
                        end;
                        MichMessageType := tempCode;
                        MichSenderApplicationCode := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'SENDERAPPLICATION');
                        MICAFlowEntry.UpdateTechnicalData(LogicalID, ComponentID, TaskID, ReferenceID, ExportCurrentDateTime, MichSender, MichReceiver, MichReceiverType, MichReferencekey, MichMessageType, MichSenderApplicationCode);
                    end;
                }
            }
            textelement(DataArea)
            {
                textelement(Acknowledge)
                {
                }
                textelement(Shipment)
                {
                    XmlName = 'Shipment';
                    textattribute(nounVersionID)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            nounVersionID := '1';
                        end;
                    }
                    textelement(ShipmentHeader)
                    {
                        XmlName = 'ShipmentHeader';
                        textelement(DocumentID)
                        {
                            XmlName = 'DocumentID';
                            textelement(WhseRcptHeaderNo)
                            {
                                XmlName = 'ID';
                                trigger OnBeforePassVariable()
                                begin
                                    WhseRcptHeaderNo := WarehouseReceiptHeader."No.";
                                end;
                            }
                        }
                        textelement(AlternateDocumentID)
                        {
                            XmlName = 'AlternateDocumentID';
                            textelement(WhseRcptHeaderNoAlternate)
                            {
                                XmlName = 'ID';
                                trigger OnBeforePassVariable()
                                begin
                                    WhseRcptHeaderNoAlternate := WarehouseReceiptHeader."No.";
                                end;
                            }

                        }
                        textelement(DocRef_ApplicationOwner)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(type_ApplicationOwner)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_ApplicationOwner := 'ApplicationOwner';
                                end;
                            }
                            textelement(documentid_ApplicationOwner)
                            {
                                XmlName = 'DocumentID';
                                textelement(id_ApplicationOwner)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        id_ApplicationOwner := MichSenderApplicationCode;
                                    end;
                                }
                                textelement(linenumber__ApplicationOwner)
                                {
                                    XmlName = 'LineNumber';
                                }
                            }
                            textelement(DocumentDatetime)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DocumentDateTime';
                                trigger OnBeforePassVariable()
                                begin
                                    DocumentDatetime := CreationDateTime;
                                end;

                            }
                        }

                        textelement(DocRef_OrderType)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(type_OrderType)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_OrderType := 'OrderType';
                                end;
                            }
                            textelement(documentid_OrderType)
                            {
                                XmlName = 'DocumentID';
                                textelement(id_OrderType)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsSalesReturnOrder then
                                            id_OrderType := 'RMA'
                                        else
                                            if IsTransferOrder then
                                                if HasAsnNo then
                                                    id_OrderType := 'PO'
                                                else
                                                    id_OrderType := 'TO';
                                    end;
                                }
                            }
                        }
                        textelement(CarrierRouteReference)
                        {
                            XmlName = 'CarrierRouteReference';
                            textelement(DocumentID_CarrierRouteReference)
                            {
                                XmlName = 'DocumentID';
                                textelement(MicaContainerNo)
                                {
                                    MinOccurs = Zero;
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        MicaContainerNo := WarehouseReceiptHeader."MICA Container ID";
                                    end;
                                }
                            }
                            textelement(MicaSealNo)
                            {
                                MinOccurs = Zero;
                                XmlName = 'SealID';
                                trigger OnBeforePassVariable()
                                begin
                                    MicaSealNo := WarehouseReceiptHeader."MICA Seal No.";
                                end;
                            }
                            textelement(LicensePlate)
                            {
                                XmlName = 'LicensePlate';
                            }
                            textelement(TransportNature)
                            {
                                XmlName = 'TransportNature';
                            }
                            textelement(AlternativeTransportNature)
                            {
                                XmlName = 'AlternativeTransportNature';
                            }
                        }
                        textelement(ActualShipDateTime)
                        {
                        }
                        textelement(ScheduledDeliveryDateTime)
                        {
                        }
                        textelement(GrossWeightMeasure)
                        {
                            textattribute(unitcodegross)
                            {
                                XmlName = 'unitCode';
                                trigger OnBeforePassVariable()
                                begin
                                    unitcodegross := '';
                                end;


                            }
                            trigger OnBeforePassVariable()
                            begin
                                GrossWeightMeasure := FillZero(FORMAT(GetWeightAndCubbage(true)), 8);
                            end;

                        }
                        textelement(TotalVolumeMeasure)
                        {
                            textattribute(unitcodeTotalVolume)
                            {
                                XmlName = 'unitCode';
                                trigger OnBeforePassVariable()
                                begin
                                    unitcodeTotalVolume := '';
                                end;

                            }
                            trigger OnBeforePassVariable()
                            begin
                                TotalVolumeMeasure := FillZero(FORMAT(GetWeightAndCubbage(false)), 8);
                            end;

                        }
                        textelement(ShipFromParty)
                        {
                            textelement(PartyIDs)
                            {
                                textelement(partyidisid)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                partyidisid := PurchaseHeader."Buy-from Vendor No."
                                            else
                                                partyidisid := FromLocation."MICA 3PL Location Name";
                                        if IsSalesReturnOrder then
                                            partyidisid := SalesHeader."Sell-to Customer No.";
                                    end;
                                }
                            }
                            textelement(LocationType)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    if IsTransferOrder then
                                        if HasAsnNo then
                                            LocationType := 'IMPORT'
                                        else
                                            LocationType := 'TRANSFERORDER'
                                    else
                                        if IsSalesReturnOrder then
                                            LocationType := 'RMA';
                                end;
                            }
                            textelement(Address1)
                            {
                                XmlName = 'Address';
                                textelement(id_shipfrompartyaddress)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()

                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                id_shipfrompartyaddress := PurchaseHeader."Buy-from Vendor No."
                                            else
                                                id_shipfrompartyaddress := FromLocation."MICA 3PL Location Name"
                                        else
                                            id_shipfrompartyaddress := SalesHeader."Sell-to Customer No.";
                                    end;
                                }
                                textelement(name_shipfrompartyaddress)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                name_shipfrompartyaddress := PurchaseHeader."Buy-from Vendor Name"
                                            else
                                                name_shipfrompartyaddress := FromLocation."MICA 3PL Location Code"
                                        else
                                            name_shipfrompartyaddress := SalesHeader."Sell-to Customer Name";
                                    end;
                                }
                            }
                            textelement(Address2)
                            {
                                XmlName = 'Address';
                                textelement(lineone)
                                {
                                    XmlName = 'LineOne';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                lineone := PurchaseHeader."Buy-from Address"
                                            else
                                                lineone := FromLocation.Address
                                        else
                                            lineone := SalesHeader."Sell-to Address";
                                    end;
                                }
                                textelement(linetwo)
                                {
                                    XmlName = 'LineTwo';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                lineone := PurchaseHeader."Buy-from Address 2"
                                            else
                                                lineone := FromLocation."Address 2"
                                        else
                                            lineone := SalesHeader."Sell-to address";
                                    end;
                                }
                                textelement(linethree)
                                {
                                    XmlName = 'LineThree';
                                }
                                textelement(cityname)
                                {
                                    XmlName = 'CityName';
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                cityname := PurchaseHeader."Buy-from City"
                                            else
                                                cityname := FromLocation.City
                                        else
                                            cityname := SalesHeader."Sell-to City";
                                    end;
                                }
                                textelement(CountrySubDivisionCode1)
                                {
                                    XmlName = 'CountrySubDivisionCode';
                                    textattribute(listversionid_csdc)
                                    {
                                        Occurrence = Optional;
                                        XmlName = 'listVersionID';
                                        trigger OnBeforePassVariable()
                                        begin
                                            listversionid_csdc := 'STATE';
                                        end;
                                    }
                                }
                                textelement(CountrySubDivisionCode2)
                                {
                                    XmlName = 'CountrySubDivisionCode';
                                    textattribute(name_csdc)
                                    {
                                        Occurrence = Optional;
                                        XmlName = 'name';
                                        trigger OnBeforePassVariable()
                                        begin
                                            name_csdc := 'REGION';
                                        end;
                                    }
                                }

                                textelement(CountryCode)
                                {
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                CountryCode := PurchaseHeader."Buy-from Country/Region Code"
                                            else
                                                CountryCode := FromLocation."Country/Region Code"
                                        else
                                            CountryCode := SalesHeader."Sell-to Country/Region Code";
                                    end;
                                }
                                textelement(PostalCode)
                                {
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder then
                                            if HasAsnNo then
                                                PostalCode := PurchaseHeader."Buy-from Post Code"
                                            else
                                                PostalCode := FromLocation."Post Code"
                                        else
                                            PostalCode := SalesHeader."Sell-to Post Code";
                                    end;
                                }
                            }
                            textelement(Contact)
                            {
                                XmlName = 'Contact';
                            }
                        }
                        textelement(CarrierParty)
                        {
                            textattribute(category)
                            {
                                XmlName = 'category';
                                trigger OnBeforePassVariable()
                                begin
                                    category := 'Forwarder';
                                end;
                            }
                            textelement("partyids1")
                            {
                                XmlName = 'PartyIDs';
                                textelement(id_CarrierParty)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        id_CarrierParty := '*';
                                    end;
                                }
                            }
                            textelement(name_CarrierParty)
                            {
                                XmlName = 'Name';
                                trigger OnBeforePassVariable()
                                begin
                                    name_CarrierParty := '*';
                                end;
                            }
                        }
                        textelement(ShipToParty)
                        {
                            XmlName = 'ShipToParty';
                            textelement("<partyids2>")
                            {
                                XmlName = 'PartyIDs';
                                textelement(ID_ShipToParty)
                                {
                                    XmlName = 'ID';

                                    trigger OnBeforePassVariable()
                                    begin
                                        ID_ShipToParty := MICAFinancialReportingSetup."Company Code";
                                    end;
                                }
                            }
                            textelement(Name_ShipToParty)
                            {
                                XmlName = 'Name';
                                trigger OnBeforePassVariable()
                                begin
                                    Name_ShipToParty := MICAFinancialReportingSetup."Company Code";
                                end;
                            }
                            textelement(Location1)
                            {
                                XmlName = 'Location';
                                textattribute(type_Location1)
                                {
                                    XmlName = 'type';
                                    trigger OnBeforePassVariable()
                                    begin
                                        type_Location1 := 'DeliveryLocation';
                                    end;

                                }
                                textelement(ID_Location1)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        ID_Location1 := Location."MICA 3PL Location Name";
                                    end;
                                }
                                textelement(Name_Location1)
                                {
                                    XmlName = 'Name';
                                    trigger OnBeforePassVariable()
                                    begin
                                        Name_Location1 := Location."MICA 3PL Location Code";
                                    end;
                                }
                                textelement(Address_Location1)
                                {
                                    XmlName = 'Address';
                                    textelement(CountryCode_Location1)
                                    {
                                        XmlName = 'CountryCode';
                                        trigger OnBeforePassVariable()
                                        begin
                                            CountryCode_Location1 := Location."Country/Region Code";
                                        end;
                                    }
                                }
                            }
                        }
                        textelement(TransportationTerm)
                        {
                            textelement(IncotermsCode)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    if IsSalesReturnOrder then
                                        IncotermsCode := SalesHeader."Shipment Method Code";
                                end;
                            }
                            textelement(PlaceOfOwnershipTransferLocation)
                            {
                                XmlName = 'PlaceOfOwnershipTransferLocation';
                                textattribute(typepootl)
                                {
                                    XmlName = 'type';
                                    trigger OnBeforePassVariable()
                                    begin
                                        typepootl := 'Generic';
                                    end;
                                }
                                textelement(pootl)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        pootl := 'KEELUNG';
                                    end;
                                }
                            }
                            textelement(PlaceOfOwnershipTransferLocation2)
                            {
                                XmlName = 'PlaceOfOwnershipTransferLocation';
                                textattribute(typepootl2)
                                {
                                    XmlName = 'type';
                                    trigger OnBeforePassVariable()
                                    begin
                                        typepootl2 := 'ArrivalPort';
                                    end;
                                }
                                textelement(pootl2)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        pootl2 := WarehouseReceiptHeader."MICA Port of Arrival";
                                    end;
                                }
                            }
                        }
                        textelement(userarea2)
                        {
                            XmlName = 'UserArea';
                            textelement(BordereauTransportNumber)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    BordereauTransportNumber := WarehouseReceiptHeader."MICA Carrier Doc. No.";
                                end;
                            }
                        }
                        textelement(userarea3)
                        {
                            XmlName = 'UserArea';
                            textattribute(name_userarea3)
                            {
                                Occurrence = Optional;
                                XmlName = 'name';
                                trigger OnBeforePassVariable()
                                begin
                                    name_userarea3 := 'ReturnOrderWithCollect';
                                end;
                            }
                            trigger OnBeforePassVariable()
                            begin
                                userarea3 := 'N';
                                if IsSalesReturnOrder then
                                    if SalesHeader."MICA Return Order With Collect" then
                                        userarea3 := 'Y';
                            end;
                        }
                        textelement(userarea4)
                        {
                            XmlName = 'UserArea';
                            textattribute(name_userarea4)
                            {
                                Occurrence = Optional;
                                XmlName = 'name';
                                trigger OnBeforePassVariable()
                                begin
                                    name_userarea4 := 'ExpectedArrivalDateTimeAtPort';
                                end;
                            }
                            trigger OnBeforePassVariable()
                            var
                                MICAFlowEntry: Record "MICA Flow Entry";
                            begin
                                userarea4 := MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime(WarehouseReceiptHeader."MICA ETA", 0T));
                            end;
                        }
                        textelement(userarea5)
                        {
                            XmlName = 'UserArea';
                            textattribute(name_userarea5)
                            {
                                Occurrence = Optional;
                                XmlName = 'name';
                                trigger OnBeforePassVariable()
                                begin
                                    name_userarea5 := 'DCScheduledReceiptDateTime';
                                end;
                            }
                            trigger OnBeforePassVariable()
                            var
                                MICAFlowEntry: Record "MICA Flow Entry";
                            begin
                                userarea5 := MICAFlowEntry.FormatDateTimeWithTimeZoneOffset(CreateDateTime(WarehouseReceiptHeader."MICA SRD", 0T));
                            end;
                        }

                    }
                    tableelement(ShipmentItem; Integer)
                    {
                        XmlName = 'ShipmentItem';
                        textelement(ItemID)
                        {
                            textelement(Item_CAD)
                            {
                                XmlName = 'ID';
                                trigger OnBeforePassVariable()
                                begin
                                    Item_CAD := Item."No.";
                                end;
                            }
                            textelement(no2_item)
                            {
                                XmlName = 'VariationID';
                                textattribute(schemeName)
                                {
                                    trigger OnBeforePassVariable()
                                    begin
                                        schemeName := 'CST';
                                    end;
                                }
                                trigger OnBeforePassVariable()
                                begin
                                    no2_item := '';
                                end;
                            }
                        }
                        textelement(CustomerItemID)
                        {
                            textelement(id_customeritemid)
                            {
                                XmlName = 'ID';
                                trigger OnBeforePassVariable()
                                var
                                    ItemCrossRef: record "Item Cross Reference";
                                begin
                                    if IsSalesReturnOrder then begin
                                        ItemCrossRef.SetRange("Cross-Reference Type", ItemCrossREf."Cross-Reference Type"::Customer);
                                        ItemCrossRef.SetRange("Item No.", WarehouseReceiptLine."Item No.");
                                        ItemCrossRef.SetRange("Cross-Reference Type No.", Customer."No.");
                                        if ItemCrossRef.FindFirst() then
                                            id_customeritemid := ItemCrossRef."Cross-Reference No.";
                                    end else
                                        id_customeritemid := Item."No.";
                                end;
                            }
                        }
                        textelement(SupplierItemID)
                        {
                            textelement("id12")
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(Description_WhseRcptLine)
                        {
                            XmlName = 'Description';

                            trigger OnBeforePassVariable()

                            begin
                                Description_WhseRcptLine := WarehouseReceiptLine.Description;
                            end;
                        }
                        textelement(classification)
                        {
                            XmlName = 'Classification';
                            textattribute(type_classification)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_classification := 'Market';
                                end;
                            }
                            textelement(codes_classification)
                            {
                                XmlName = 'Codes';
                                textelement(code_classification)
                                {
                                    XmlName = 'Code';
                                    textattribute(sequence)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            sequence := '1';
                                        end;
                                    }
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsSalesReturnOrder then
                                            code_classification := Customer."MICA Market Code";
                                    end;
                                }
                            }
                        }
                        textelement(classification2)
                        {
                            XmlName = 'Classification';
                            textattribute(type_classification2)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_classification2 := 'CST';
                                end;
                            }
                            textelement(codes_classification2)
                            {
                                XmlName = 'Code';
                                textelement(code_classification2)
                                {
                                    XmlName = 'Code';
                                    textattribute(sequence2)
                                    {
                                        XmlName = 'sequence';
                                        trigger OnBeforePassVariable()
                                        begin
                                            sequence2 := '1';
                                        end;
                                    }
                                    trigger OnBeforePassVariable()
                                    begin
                                        code_classification2 := '';
                                    end;
                                }
                            }
                        }
                        textelement(classification3)
                        {
                            XmlName = 'Classification';
                            textattribute(type_classification3)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_classification3 := 'NCMClassification';
                                end;
                            }
                            textelement(codes_classification3)
                            {
                                XmlName = 'Codes';
                                textelement(code_classification3)
                                {
                                    XmlName = 'Code';
                                    textattribute(sequence3)
                                    {
                                        XmlName = 'sequence';
                                        trigger OnBeforePassVariable()
                                        begin
                                            sequence3 := '1';
                                        end;
                                    }
                                    trigger OnBeforePassVariable()
                                    begin
                                        code_classification3 := Item."MICA User Item Type";
                                    end;
                                }
                            }
                        }
                        textelement(Specification)
                        {
                            textelement(Property)
                            {
                                textelement(namevalue_specification)
                                {
                                    XmlName = 'NameValue';
                                    textattribute(name_specification)
                                    {
                                        XmlName = 'name';
                                        trigger OnBeforePassVariable()
                                        begin

                                            name_specification := 'ZPCode';
                                        end;
                                    }
                                    trigger OnBeforePassVariable()
                                    begin

                                        namevalue_specification := 'H1';
                                    end;
                                }

                            }
                        }
                        textelement(SerialNumber)
                        {
                        }
                        textelement(RequisitionReference)
                        {
                            textelement("<documentid3>")
                            {
                                XmlName = 'DocumentID';
                                textelement("<id13>")
                                {
                                    MinOccurs = Zero;
                                    XmlName = 'ID';
                                }
                            }
                            textelement("<linenumber1>")
                            {
                                XmlName = 'LineNumber';
                            }
                        }
                        textelement(PurchaseOrderReference)
                        {
                            textelement(DocumentID_PurchaseOrderReference)
                            {
                                XmlName = 'DocumentID';
                                textelement(ID_PurchaseOrderReference)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        ID_PurchaseOrderReference := WarehouseReceiptLine."No.";
                                    end;
                                }
                            }
                            textelement(LineNumber_PurchaseOrderReference)
                            {
                                XmlName = 'LineNumber';
                                trigger OnBeforePassVariable()
                                begin
                                    LineNumber_PurchaseOrderReference := FORMAT(WarehouseReceiptLine."Line No.");
                                end;
                            }
                            textelement(UserArea_PurchaseOrderReference)
                            {
                                XmlName = 'UserArea';
                                textelement(PaymentTermID)
                                {
                                    trigger OnBeforePassVariable()
                                    begin
                                        if IsTransferOrder and HasAsnNo then
                                            PaymentTermID := PurchaseHeader."Payment Terms Code";
                                    end;
                                }
                            }
                        }
                        textelement(SalesOrderReference)
                        {
                            textelement("documentid5")
                            {
                                XmlName = 'DocumentID';
                                textelement("id15")
                                {
                                    MinOccurs = Zero;
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(documentreference)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(type_documentreference)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_documentreference := 'BSCOrderReference';
                                end;
                            }
                            textelement(documentid_documentreference)
                            {
                                XmlName = 'DocumentID';
                                textelement(id_documentreference)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        id_documentreference := WarehouseReceiptLine."Source No.";
                                        if IsTransferOrder and HasAsnNo then
                                            id_documentreference := PurchaseHeader."No.";
                                    end;
                                }
                                textelement(linenumber_documentreference)
                                {
                                    XmlName = 'LineNumber';
                                    trigger OnBeforePassVariable()
                                    begin
                                        linenumber_documentreference := FORMAT(WarehouseReceiptLine."Source Line No.");
                                        if IsTransferOrder and HasAsnNo then
                                            linenumber_documentreference := FORMAT(PurchaseLine."Line No.");
                                    end;
                                }
                            }
                        }
                        textelement(documentreference2)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(type_documentreference2)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_documentreference2 := 'LogisticsDeliveryOrderCode';
                                end;
                            }
                            textelement(documentid_documentreference2)
                            {
                                XmlName = 'DocumentID';
                                textelement(id_documentreference2)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        id_documentreference2 := '';
                                        if HasAsnNo then
                                            id_documentreference2 := WarehouseReceiptLine."MICA ASN No.";
                                    end;
                                }
                                textelement(linenumber_documentreference2)
                                {
                                    XmlName = 'LineNumber';
                                }
                            }

                        }
                        textelement(documentreference3)
                        {
                            XmlName = 'DocumentReference';
                            textattribute(type_documentreference3)
                            {
                                XmlName = 'type';
                                trigger OnBeforePassVariable()
                                begin
                                    type_documentreference3 := 'CONTAINERNUM';
                                end;
                            }
                            textelement(documentid_documentreference3)
                            {
                                XmlName = 'DocumentID';
                                textelement(id_documentreference3)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        id_documentreference3 := WarehouseReceiptHeader."MICA Container ID";
                                    end;
                                }
                                textelement(linenumber_documentreference3)
                                {
                                    XmlName = 'LineNumber';
                                }
                            }

                        }
                        textelement(DeliveredQuantity)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                DeliveredQuantity := Format(WarehouseReceiptLine.Quantity, 0, '<Precision,0:2><Integer><Decimals><Comma,.>');
                            end;
                        }
                        textelement(AssemblyID)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                AssemblyID := '00';
                            end;
                        }
                        textelement(ImportLicense)
                        {
                            XmlName = 'ImportLicense';
                        }
                        textelement(ExportLicense)
                        {
                            XmlName = 'ExportLicense';
                        }
                        textelement(AvailableDateTime)
                        {
                        }
                        textelement(UserArea_ShipmentItem)
                        {
                            XmlName = 'UserArea';
                            textelement(CodeISOPaysOrigineFabrication)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    CodeISOPaysOrigineFabrication := WarehouseReceiptLine."MICA Country of Origin";
                                end;
                            }
                            textelement(LibellePaysOrigineFabrication)
                            {
                                XmlName = 'LibellePaysOrigineFabrication';
                                trigger OnBeforePassVariable()
                                var
                                    CountryRegion: Record "Country/Region";
                                begin
                                    if CountryRegion.get(WarehouseReceiptLine."MICA Country of Origin") then
                                        TransportNature2 := CountryRegion.Name;
                                end;
                            }
                            textelement(TransportNature2)
                            {
                                XmlName = 'TransportNature';
                                trigger OnBeforePassVariable()
                                begin
                                    TransportNature2 := 'R';
                                end;
                            }
                        }
                        trigger OnPreXmlItem()
                        begin
                            ShipmentItem.SetRange(Number, 1, WarehouseReceiptLine.Count());
                        end;

                        trigger OnAfterGetRecord()
                        var
                            NoLineErrorLbl: Label 'No Warehouse Receipt Line %1';
                        begin
                            if FirstLine then
                                FirstLine := false
                            else
                                WarehouseReceiptLine.Next();

                            UpdateGlobalInformation(WarehouseReceiptLine);

                            if WarehouseReceiptLine."No." = '' then begin
                                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, WarehouseReceiptLine.RecordId(), StrSubstNo(NoLineErrorLbl, WarehouseReceiptLine.FieldCaption("No.")), Format(WarehouseReceiptHeader.RecordId()));
                                currXMLport.Skip();
                            end;
                        end;
                    }
                }
            }
        }
    }

    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowInformation: Record "MICA Flow Information";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase line";
        SalesHeader: Record "Sales Header";
        Location: Record Location;
        FromLocation: Record Location;
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        Item: record Item;
        Customer: record Customer;
        ExportCurrentDateTime: DateTime;
        FirstLine: Boolean;
        HasAsnNo: Boolean;
        IsTransferOrder: Boolean;
        IsSalesReturnOrder: Boolean;
        ExportedRecordCount: Integer;

    trigger OnPreXmlPort()
    var
        NoHeaderErrorLbl: Label 'No Warehouse Receipt %1';
    begin
        ExportCurrentDateTime := CurrentDateTime();
        if WarehouseReceiptHeader."No." = '' then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, WarehouseReceiptHeader.RecordId(), StrSubstNo(NoHeaderErrorLbl, WarehouseReceiptHeader.FieldCaption("No.")), Format(WarehouseReceiptHeader.RecordId()));
            currXMLport.Skip();
        end else begin
            MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", WarehouseReceiptHeader.RecordId(), MICAFlowEntry."Send Status"::Prepared); // Update last send status on business data
            ExportedRecordCount += 1;
        end;
    end;

    local procedure WhseRcptDocHasAsnNo(WarehouseReceiptHeader: record "Warehouse Receipt Header")
    var
        FoundWarehouseReceiptLine: record "Warehouse Receipt Line";
    begin
        FoundWarehouseReceiptLine.SetRange("No.", WarehouseReceiptHeader."No.");
        if not FoundWarehouseReceiptLine.FindFirst() then
            HasAsnNo := false
        else
            HasAsnNo := FoundWarehouseReceiptLine."MICA ASN No." <> '';
    end;

    local procedure UpdateGlobalInformation(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        TransferHeader: record "Transfer Header";
    begin

        WhseRcptDocHasAsnNo(WarehouseReceiptHeader);

        if WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Sales Return Order" then begin
            IsSalesReturnOrder := true;
            if SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WarehouseReceiptLine."Source No.") then;
            if customer.get(SalesHeader."Sell-to Customer No.") then;
        end;

        if WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Inbound Transfer" then begin
            IsTransferOrder := true;
            TransferHeader.Get(WarehouseReceiptLine."Source No.");
            FromLocation.get(TransferHeader."Transfer-from Code");
            if HasAsnNo then begin
                PurchaseLine.reset();
                PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                PurchaseLine.SetRange(PurchaseLine."MICA ASN No.", WarehouseReceiptLine."MICA ASN No.");
                PurchaseLine.SetRange(PurchaseLine."MICA ASN Line No.", WarehouseReceiptLine."MICA ASN Line No.");
                if PurchaseLine.FindSet() then
                    PurchaseHeader.get(PurchaseHeader."Document Type"::Order, PurchaseLine."Document No.");
            end;
        end;

        Item.Get(WarehouseReceiptLine."Item No.");
    end;

    procedure SetFlowEntry(FlowEntryNo: Integer)
    var
    begin
        MICAFlowEntry.get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    procedure SetReceiptHeader(var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        WarehouseReceiptHeader := WarehouseReceiptHeader;
        WarehouseReceiptLine.SetRange("No.", WarehouseReceiptHeader."No.");
        WarehouseReceiptLine.FindSet();
        UpdateGlobalInformation(WarehouseReceiptLine);
        FirstLine := true;
        Location.Get(WarehouseReceiptHeader."Location Code");
        MICAFinancialReportingSetup.Get();
    end;

    procedure GetFileName(): Text[100]
    var
        tempName: text[100];
    begin
        tempName := StrSubstNo(MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", 'FILENAMING'),
                        WarehouseReceiptHeader."No.",
                        Format(ExportCurrentDateTime, 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));

        Exit(tempName);

    end;

    local procedure GetWeightAndCubbage(IfWeight: Boolean): Decimal
    var
        FoundWarehouseReceiptLine: Record "Warehouse Receipt Line";
        Weight: Decimal;
        Cubage: Decimal;
    begin
        FoundWarehouseReceiptLine.SetRange("No.", WarehouseReceiptHeader."No.");
        if WarehouseReceiptLine.Findset() then
            repeat
                Weight += FoundWarehouseReceiptLine.Weight;
                Cubage += FoundWarehouseReceiptLine.Cubage;

            until FoundWarehouseReceiptLine.Next() = 0;

        if IfWeight then
            exit(Weight)
        else
            exit(Cubage);
    end;

    local procedure FillZero(textvar: Text; Spacing: Integer): Text
    begin
        exit(Padstr('', Spacing - StrLen(textvar), '0') + textvar);
    end;
}

