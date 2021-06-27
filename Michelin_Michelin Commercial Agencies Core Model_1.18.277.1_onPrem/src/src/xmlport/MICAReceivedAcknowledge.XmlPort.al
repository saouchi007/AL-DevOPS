xmlport 81960 "MICA Received Acknowledge"
{
    //INT – DOO-005 RECEIVED
    DefaultNamespace = 'http://www.openapplications.org/oagis/9';
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;
    Namespaces = gic = 'http://www.gic.michelin.com/oagis/9/michelin/1', gicleg = 'http://www.gic.michelin.com/oagis/9/michelin/legacy/1'; //, oagis = 'http://www.openapplications.org/oagis/9';
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(AcknowledgeReceiveDelivery)
        {
            textattribute(releaseID)
            {

                trigger OnBeforePassVariable()
                begin
                    releaseID := '9';
                end;
            }
            textelement(ApplicationArea)
            {
                NamespacePrefix = 'gic';
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
                }
                textelement(CreationDateTime)
                {
                }
            }
            textelement(DataArea)
            {
                textelement(Acknowledge)
                {
                }
                textelement(ReceiveDelivery)
                {
                    NamespacePrefix = 'gic';
                    textattribute(nounVersionID)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            nounVersionID := '1';
                        end;
                    }
                    tableelement(ReceiveDeliveryHeader; integer)
                    {
                        AutoSave = false;
                        XmlName = 'ReceiveDeliveryHeader';
                        NamespacePrefix = 'gic';
                        textelement(DocumentID)
                        {
                            NamespacePrefix = 'gic';
                            textelement(rdhdocid)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(LastModificationDateTime)
                        {
                        }
                        textelement(DocumentDateTime)
                        {
                        }
                        textelement(Note)
                        {
                            textattribute(author)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    author := 'Approver';
                                end;
                            }
                        }
                        textelement(documentreferencersc)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typedrrsc)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeDRRSC := 'RECEIPT_SOURCE_CODE';
                                end;
                            }
                            textelement(documentiddrrsc)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(iddrrsc)
                                {
                                    XmlName = 'ID';

                                    trigger OnBeforePassVariable()
                                    var
                                        IDDRRSCLbl: Label 'RECEIPT %1', Comment = '%1', Locked = true;
                                    begin
                                        IDDRRSC := StrSubstNo(IDDRRSCLbl, MICAReceivedAckGetASNLines.No_);
                                    end;
                                }
                            }
                        }
                        textelement(documentreferencesc)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typedrsc)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeDRSC := 'ShipmentCode';
                                end;
                            }
                            textelement(documentiddrsc)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(iddrsc)
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(documentreferencert)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typedrrt)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typedrrt := 'ReceiptType';
                                end;
                            }
                            textelement(documentiddrrt)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(iddrrt)
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(documentreferencesp)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typedrsp)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typedrsp := 'BRShipmentProcessNbr';
                                end;
                            }
                            textelement(documentiddrsp)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(iddrsp)
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(CarrierRouteReference)
                        {
                            NamespacePrefix = 'gic';
                            textelement(documentidcrr)
                            {
                                XmlName = 'DocumentID';
                                textelement(idcrr)
                                {
                                    XmlName = 'ID';
                                    textattribute(schemenamecrr)
                                    {
                                        XmlName = 'schemeName';

                                        trigger OnBeforePassVariable()
                                        begin
                                            schemeNameCRR := 'WayBillNumber';
                                        end;
                                    }
                                }
                            }
                            textelement(userareacrr)
                            {
                                XmlName = 'UserArea';
                                textelement(Equipment_Method)
                                {
                                }
                                textelement(Equipment_Number)
                                {
                                }
                            }
                        }
                        textelement(ActualShipDateTime)
                        {
                        }
                        textelement(TransportationMethodCode)
                        {
                        }
                        textelement(SpecialHandlingNote)
                        {
                        }
                        textelement(shipfrompartysup)
                        {
                            XmlName = 'ShipFromParty';
                            textattribute(categorysup)
                            {
                                XmlName = 'category';

                                trigger OnBeforePassVariable()
                                begin
                                    categorySup := 'Supplier';
                                end;
                            }
                            textelement(partyidssup)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idsup)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(dunsidsup)
                                {
                                    XmlName = 'DUNSID';
                                }
                            }
                            textelement(Name)
                            {
                            }
                            textelement(locationsupc)
                            {
                                XmlName = 'Location';
                                textattribute(typesupc)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeSupC := 'SupplierSite';
                                    end;
                                }
                                textelement(idsupc)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(namesupc)
                                {
                                    XmlName = 'Name';
                                }
                                textelement(addresssupc)
                                {
                                    XmlName = 'Address';
                                    textelement(countrycodesupc)
                                    {
                                        XmlName = 'CountryCode';
                                    }
                                }
                            }
                            textelement(locationinvloc)
                            {
                                XmlName = 'Location';
                                textattribute(typeinvloc)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeInvLoc := 'InventoryLocation';
                                    end;
                                }
                                textelement(idinvloc)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(UserArea)
                            {
                                textelement(mich_company_codesup)
                                {
                                    XmlName = 'Mich_Company_code';
                                }
                                textelement(supplier_typesup)
                                {
                                    XmlName = 'Supplier_Type';
                                }
                                textelement(trading_partner_typesup)
                                {
                                    XmlName = 'Trading_Partner_Type';
                                }
                            }
                        }
                        textelement(carrierpartyhdr)
                        {
                            XmlName = 'CarrierParty';
                            textelement(partyidshdr)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idhdr)
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(partybill)
                        {
                            XmlName = 'Party';
                            textattribute(categorybill)
                            {
                                XmlName = 'category';

                                trigger OnBeforePassVariable()
                                begin
                                    categoryBill := 'BillTo';
                                end;
                            }
                            textelement(partyidsbill)
                            {
                                XmlName = 'PartyIDs';
                                textelement(idbill)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(locationpartybill)
                            {
                                XmlName = 'Location';
                                textattribute(typepartybill)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typePartyBill := 'BillTo';
                                    end;
                                }
                                textelement(idpartybill)
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(ReceivedDateTime)
                        {
                        }
                        textelement(BillOfLadingID)
                        {
                        }
                        textelement(containerhdr)
                        {
                            XmlName = 'Container';
                            textelement(containeridhdr)
                            {
                                XmlName = 'ContainerID';

                                trigger OnBeforePassVariable()
                                begin
                                    containeridhdr := MICAReceivedAckGetASNLines.MICA_Container_ID;
                                end;
                            }
                            textelement(userareacont)
                            {
                                XmlName = 'UserArea';
                                textelement(num_of_containerscont)
                                {
                                    XmlName = 'NUM_OF_CONTAINERS';
                                }
                            }
                        }
                        textelement(delivertoparty)
                        {
                            XmlName = 'DeliverToParty';
                            textelement(partyidsdtp)
                            {
                                XmlName = 'PartyIDs';
                                textelement(iddtp)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(dunsiddtp)
                                {
                                    XmlName = 'DUNSID';
                                }
                            }
                            textelement(locationdelto)
                            {
                                XmlName = 'Location';
                                textattribute(typedelto)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeDelTo := 'DeliveryLocation';
                                    end;
                                }
                            }
                            textelement(userareadelto)
                            {
                                XmlName = 'UserArea';
                                textelement(TradingPartner_LocationID)
                                {
                                }
                                textelement(BSM_Admin)
                                {
                                }
                            }
                        }
                        textelement(ASNReference)
                        {
                            textelement(documentidasn)
                            {
                                XmlName = 'DocumentID';
                                textelement(idasn)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    begin
                                        idasn := CopyStr(MICAReceivedAckGetASNLines.MICA_AL_No_, 1, 2) + '_' + StrSubstNo(PrVal_ASNReferenceID, MICAReceivedAckGetASNLines.MICA_ASN_No_, Format(MICAReceivedAckGetASNLines.Posting_Date, 2, '<Year>'));

                                    end;
                                }
                            }
                        }

                        trigger OnPreXmlItem()
                        begin
                            if not MICAReceivedAckGetASNLines.Read() then
                                currXMLport.Break();

                            ReceiveDeliveryHeader.SetRange(Number, 1, 1);
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            // LastModificationDateTime := CreationDateTime;
                            // DocumentDateTime := CreationDateTime;
                            // ActualShipDateTime := CreationDateTime;
                            // ReceivedDateTime := CreationDateTime;
                        end;
                    }
                    tableelement(ReceiveDeliveryItem; Integer)
                    {
                        AutoSave = false;
                        LinkTable = ReceiveDeliveryHeader;
                        NamespacePrefix = 'gic';
                        textelement(itemid)
                        {
                            XmlName = 'ItemID';
                            textelement(iditem)
                            {
                                XmlName = 'ID';
                                trigger OnBeforePassVariable()
                                begin
                                    iditem := MICAReceivedAckGetASNLines.Item_No_;
                                end;
                            }
                            textelement(variationiditem)
                            {
                                XmlName = 'VariationID';
                                trigger OnBeforePassVariable()
                                begin
                                    variationiditem := PrVal_VariationID;
                                end;
                            }
                        }
                        textelement(CustomerItemID)
                        {
                            textelement(idcusti)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(SupplierItemID)
                        {
                            textelement(idsupi)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(descriptionitem)
                        {
                            XmlName = 'Description';
                            trigger OnBeforePassVariable()
                            begin
                                descriptionitem := MICAReceivedAckGetASNLines.Description;
                            end;
                        }
                        textelement(noteappr)
                        {
                            XmlName = 'Note';
                            textattribute(authorappr)
                            {
                                XmlName = 'author';

                                trigger OnBeforePassVariable()
                                begin
                                    authorappr := 'Approver';
                                end;
                            }
                        }
                        textelement(classificationcateg)
                        {
                            XmlName = 'Classification';
                            textattribute(typecateg)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeCateg := 'ItemCategory';
                                end;
                            }
                            textelement(codescateg)
                            {
                                XmlName = 'Codes';
                                textelement(codecateg)
                                {
                                    XmlName = 'Code';
                                    textattribute(sequencecateg)
                                    {
                                        XmlName = 'sequence';

                                        trigger OnBeforePassVariable()
                                        begin
                                            sequenceCateg := '1';
                                        end;
                                    }
                                }
                            }
                        }
                        textelement(packagingslip)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'Packaging';
                            textattribute(typeslip)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeSlip := 'Packing_Slip';
                                end;
                            }
                            textelement(idslip)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(packagingcode)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'Packaging';
                            textattribute(typecode)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeCode := 'Packing_Code';
                                end;
                            }
                            textelement(idcode)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(LotSerial)
                        {
                            textelement(lotidsserial)
                            {
                                XmlName = 'LotIDs';
                            }
                            textelement(idvendln)
                            {
                                XmlName = 'ID';
                                textattribute(schemenamevendln)
                                {
                                    XmlName = 'schemeName';

                                    trigger OnBeforePassVariable()
                                    begin
                                        schemeNameVendLN := 'VendorLotNumber';
                                    end;
                                }
                            }
                            textelement(idln)
                            {
                                XmlName = 'ID';
                                textattribute(schemenameln)
                                {
                                    XmlName = 'schemeName';

                                    trigger OnBeforePassVariable()
                                    begin
                                        schemeNameLN := 'LotNumber';
                                    end;
                                }
                            }
                        }
                        textelement(ShippedQuantity)
                        {
                        }
                        textelement(RequisitionReference)
                        {
                            textelement(documentidreqrf)
                            {
                                XmlName = 'DocumentID';
                                textelement(idreqrf)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(linenumberreqrf)
                            {
                                XmlName = 'LineNumber';
                            }
                        }
                        textelement(PurchaseOrderReference)
                        {
                            textelement(documentidpurchr)
                            {
                                XmlName = 'DocumentID';
                                textelement(idpurchr)
                                {
                                    XmlName = 'ID';
                                    trigger OnBeforePassVariable()
                                    var
                                        FlowBufferASN: Record "MICA Flow Buffer ASN";
                                    begin
                                        FlowBufferASN.SetRange("AL No.", MICAReceivedAckGetASNLines.MICA_AL_No_);
                                        FlowBufferASN.SetRange("AL Line No.", MICAReceivedAckGetASNLines.MICA_AL_Line_No_);
                                        FlowBufferASN.SetRange("Doc. ID", MICAReceivedAckGetASNLines.MICA_ASN_No_);
                                        FlowBufferASN.SetRange("ASN Line Number", MICAReceivedAckGetASNLines.MICA_ASN_Line_No_);
                                        if FlowBufferASN.FindFirst() then
                                            idpurchr := FlowBufferASN."AL No. Raw"
                                        else
                                            idpurchr := MICAReceivedAckGetASNLines.MICA_AL_No_;
                                    end;
                                }
                            }
                            textelement(linenumberpurchr)
                            {
                                XmlName = 'LineNumber';
                                trigger OnBeforePassVariable()
                                begin
                                    linenumberpurchr := MICAReceivedAckGetASNLines.MICA_AL_Line_No_;
                                end;
                            }
                            textelement(userareapurchr)
                            {
                                XmlName = 'UserArea';
                                textelement(currencycodepurchr)
                                {
                                    XmlName = 'CurrencyCode';
                                }
                            }
                        }
                        textelement(SalesOrderReference)
                        {
                            textelement(documentidsaler)
                            {
                                XmlName = 'DocumentID';
                                textelement(idsaler)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(linenumbersaler)
                            {
                                XmlName = 'LineNumber';
                            }
                        }
                        textelement(documentreferenceshipcd)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typeshipcd)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeShipCd := 'ShipmentCode';
                                end;
                            }
                            textelement(documentidshipcd)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(idshipcd)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(linenumbershipcd)
                                {
                                    XmlName = 'LineNumber';
                                    trigger OnBeforePassVariable()
                                    begin
                                        linenumbershipcd := Format(MICAReceivedAckGetASNLines.MICA_ASN_Line_No_, 0, 9);
                                    end;
                                }
                            }
                            textelement(statuscodeshipcd)
                            {
                                XmlName = 'StatusCode';
                            }
                        }
                        textelement(documentreferencercvdt)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typercvdt)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeRcvDT := 'ReceivedDateTime';
                                end;
                            }
                            textelement(documentdatetimercvdt)
                            {
                                XmlName = 'DocumentDateTime';

                                trigger OnBeforePassVariable()
                                begin
                                    documentdatetimercvdt := GetCurrentDateTimeWithTimeZoneOffset(CreateDateTime(MICAReceivedAckGetASNLines.Posting_Date, 0T));
                                end;
                            }
                        }
                        textelement(documentreferencescref)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typescref)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeSCRef := 'SC_REF';
                                end;
                            }
                            textelement(documentidscref)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(idscref)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(linenumberscref)
                                {
                                    XmlName = 'LineNumber';
                                }
                            }
                        }
                        textelement(documentreferencenfnbr)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typenfnbr)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeNFNbr := 'NFNbr';
                                end;
                            }
                            textelement(documentdinfnbr)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(idnfnbr)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(userareanfnbr)
                            {
                                XmlName = 'UserArea';
                                textelement(nfseriesnfnbr)
                                {
                                    XmlName = 'NFSeries';
                                }
                                textelement(nftypenfnbr)
                                {
                                    XmlName = 'NFType';
                                }
                                textelement(nfissuedatenfnbr)
                                {
                                    XmlName = 'NFIssueDate';
                                }
                                textelement(nftotamtnfnbr)
                                {
                                    XmlName = 'NFTotAmt';
                                }
                            }
                        }
                        textelement(documentreferencedinbr)
                        {
                            NamespacePrefix = 'gic';
                            XmlName = 'DocumentReference';
                            textattribute(typedinbr)
                            {
                                XmlName = 'type';

                                trigger OnBeforePassVariable()
                                begin
                                    typeDINbr := 'DINbr';
                                end;
                            }
                            textelement(documentiddinbr)
                            {
                                NamespacePrefix = 'gic';
                                XmlName = 'DocumentID';
                                textelement(iddinbr)
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(UserID)
                        {
                            NamespacePrefix = 'gic';
                        }
                        textelement(Status)
                        {
                            textelement(Code)
                            {
                            }
                        }
                        textelement(ReceivedQuantity)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                ReceivedQuantity := Format(MICAReceivedAckGetASNLines.Quantity, 0, 9);
                            end;
                        }
                        textelement(ReceiptRoutingCode)
                        {
                        }
                        textelement(delivertopartyitem)
                        {
                            XmlName = 'DeliverToParty';
                            textelement(partyidsdelto)
                            {
                                XmlName = 'PartyIDs';
                                textelement(iddelto)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(dinsiddelto)
                                {
                                    XmlName = 'DINSID';
                                }
                            }
                            textelement(locationinvorg)
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
                                textelement(idinvorg)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(userareainvorg)
                                {
                                    XmlName = 'UserArea';
                                    textelement(subinventoryinvorg)
                                    {
                                        XmlName = 'SubInventory';
                                    }
                                    textelement(invorgreceiptroutingindicator)
                                    {
                                        XmlName = 'InvOrgReceiptRoutingIndicator';
                                        trigger OnBeforePassVariable()
                                        begin
                                            invorgreceiptroutingindicator := PrVal_RoutingIndicatorID;
                                        end;
                                    }
                                    textelement(invorgtype)
                                    {
                                        XmlName = 'InvOrgType';
                                        trigger OnBeforePassVariable()
                                        begin
                                            invorgtype := PrVal_InvOrgTypeID;
                                        end;
                                    }
                                }
                            }
                            textelement(locationdelloc)
                            {
                                XmlName = 'Location';
                                textattribute(typedelloc)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeDelLoc := 'DeliveryLocation';
                                    end;
                                }
                                textelement(iddelloc)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(userareadelloc)
                                {
                                    XmlName = 'UserArea';
                                    textelement(tradingpartner_locationiddloc)
                                    {
                                        XmlName = 'TradingPartner_LocationID';
                                    }
                                }
                            }
                            textelement(Contact)
                            {
                                textattribute(typecont)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeCont := 'Requestor';
                                    end;
                                }
                                textelement(namecont)
                                {
                                    XmlName = 'Name';
                                }
                            }
                        }
                        textelement(userareaitem)
                        {
                            XmlName = 'UserArea';
                            textelement(Creation_Date)
                            {
                            }
                            textelement(Last_Update_Date)
                            {
                            }
                            textelement(Source_Document_Code)
                            {
                            }
                            textelement(TradingPartner_ReceivedQuantity_UOM)
                            {
                            }
                            textelement(MtlTransType)
                            {
                            }
                            textelement(MtlTransRef)
                            {
                            }
                        }
                        textelement(TotalQuantity)
                        {
                        }
                        textelement(ShipFromParty)
                        {
                            textelement(locationsf)
                            {
                                XmlName = 'Location';
                                textattribute(typesf)
                                {
                                    XmlName = 'type';

                                    trigger OnBeforePassVariable()
                                    begin
                                        typeSF := 'InventoryOrganization';
                                    end;
                                }
                                textelement(ID)
                                {
                                }
                                textelement(userareasf)
                                {
                                    XmlName = 'UserArea';
                                    textelement(invorgtypesf)
                                    {
                                        XmlName = 'InvOrgType';
                                        trigger OnBeforePassVariable()
                                        begin
                                            invorgtypesf := PrVal_InvOrgTypeID;
                                        end;
                                    }
                                    textelement(invorgreceiptroutingindsf)
                                    {
                                        XmlName = 'InvOrgReceiptRoutingIndicator';
                                        trigger OnBeforePassVariable()
                                        begin
                                            invorgreceiptroutingindsf := PrVal_RoutingIndicatorID;
                                        end;
                                    }
                                }
                            }
                        }
                        trigger OnPreXmlItem()
                        begin
                            if MICAReceivedAckGetASNLines.No_ = '' then  //Querry is empty
                                currXMLport.Break();
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if ReceiveDeliveryItem.Number > -1000000000 then
                                if not MICAReceivedAckGetASNLines.Read() then
                                    currXMLport.Break();

                            ExportedRecordCount += 1;

                            Creation_Date := CreationDateTime;
                            Last_Update_Date := CreationDateTime;
                        end;
                    }
                }
            }
        }
    }

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        //TempReceiptLine: Record "Posted Whse. Receipt Line" temporary;
        MICAReceivedAckGetASNLines: Query "MICA ReceivedAck GetASNLines";
        ExportedRecordCount: Integer;
        HeaderNo: Code[20];
        ASNNo: Code[35];
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        Param_LogicalIDTok: Label 'LogicalID', Locked = true;
        Param_ComponentIDTok: Label 'ComponentID', Locked = true;
        Param_TaskIDTok: Label 'TaskID', Locked = true;
        Param_ReferenceIDTok: Label 'ReferenceID', Locked = true;
        Param_VariationIDTok: Label 'VariationID', Locked = true;
        Param_RoutingIndicatorIDTok: Label 'RoutingIndicatorID', Locked = true;
        Param_InvOrgTypeIDTok: Label 'InvOrgType', Locked = true;
        Param_ASNRefIDTok: Label 'ASNRefID', Locked = true;

        PrVal_LogicalID: Text;
        PrVal_ComponentID: Text;
        PrVal_TaskID: Text;
        PrVal_ReferenceID: Text;
        PrVal_VariationID: Text;
        PrVal_RoutingIndicatorID: Text;
        PrVal_InvOrgTypeID: Text;
        PrVal_ASNReferenceID: Text;

    trigger OnPreXmlPort()
    begin
        MICAReceivedAckGetASNLines.SetRange(Filter_No_, HeaderNo);
        MICAReceivedAckGetASNLines.SetRange(MICAReceivedAckGetASNLines.Filter_MICA_ASN_No_, ASNNo);
        MICAReceivedAckGetASNLines.Open();

        LogicalID := PrVal_LogicalID;
        ComponentID := PrVal_ComponentID;
        TaskID := PrVal_TaskID;
        ReferenceID := StrSubstNo(PrVal_ReferenceID, ASNNo);
        CreationDateTime := MICAFlowEntry.GetCurrentDateTimeWithTimeZoneOffset();
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_LogicalIDTok, PrVal_LogicalID);
        CheckPrerequisitesAndRetrieveParameters(Param_ComponentIDTok, PrVal_ComponentID);
        CheckPrerequisitesAndRetrieveParameters(Param_TaskIDTok, PrVal_TaskID);
        CheckPrerequisitesAndRetrieveParameters(Param_ReferenceIDTok, PrVal_ReferenceID);
        CheckPrerequisitesAndRetrieveParameters(Param_VariationIDTok, PrVal_VariationID);
        CheckPrerequisitesAndRetrieveParameters(Param_RoutingIndicatorIDTok, PrVal_RoutingIndicatorID);
        CheckPrerequisitesAndRetrieveParameters(Param_InvOrgTypeIDTok, PrVal_InvOrgTypeID);
        CheckPrerequisitesAndRetrieveParameters(Param_ASNRefIDTok, PrVal_ASNReferenceID);
    end;

    local procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text)
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if ParamValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    procedure SetParam(var InMICAFlowEntry: Record "MICA Flow Entry"; inHeaderNo: Code[20]; inASNNo: Code[35])
    begin
        MICAFlowEntry := InMICAFlowEntry;
        HeaderNo := inHeaderNo;
        ASNNo := inASNNo;
    end;

    local procedure GetCurrentDateTimeWithTimeZoneOffset(inDT: DateTime) Res_TimeZoneOffset: Text[30]
    var
        TimeZone: record "Time Zone";
        UserPersonalization: record "User Personalization";
    begin
        Res_TimeZoneOffset := FORMAT(inDT, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>') + '+00:00';
        UserPersonalization.SETRANGE("User ID", UserId());
        If UserPersonalization.FindFirst() Then begin
            TimeZone.SETRANGE(ID, UserPersonalization."Time Zone");
            IF TimeZone.FindFirst() THEN
                Res_TimeZoneOffset := FORMAT(inDT, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>') + COPYSTR(TimeZone."Display Name", 5, 6);
        End;
    end;
}