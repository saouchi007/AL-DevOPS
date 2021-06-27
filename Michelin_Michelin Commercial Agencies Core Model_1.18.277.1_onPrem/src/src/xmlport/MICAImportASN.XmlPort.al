xmlport 81720 "MICA Import ASN"
{
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    schema
    {
        textelement(AcknowledgeShipment)
        {
            XmlName = 'AcknowledgeShipment';
            textattribute(releaseID) { }
            textelement(ApplicationArea)
            {
                textelement(Sender)
                {
                    textelement(LogicalID)
                    {
                        trigger OnAfterAssignVariable()
                        begin
                            MICAFlowBufferASN."Tech. Logical ID" := CopyStr(LogicalID, 1, MaxStrLen(MICAFlowBufferASN."Tech. Logical ID"));
                        end;
                    }
                    textelement(ComponentID)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            MICAFlowBufferASN."Tech. Component ID" := CopyStr(ComponentID, 1, MaxStrLen(MICAFlowBufferASN."Tech. Component ID"));
                        end;
                    }
                    textelement(TaskID)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            MICAFlowBufferASN."Tech. Task ID" := CopyStr(TaskID, 1, MaxStrLen(MICAFlowBufferASN."Tech. Task ID"));
                        end;
                    }
                    textelement(ReferenceID)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            MICAFlowBufferASN."Tech. Reference ID" := CopyStr(ReferenceID, 1, MaxStrLen(MICAFlowBufferASN."Tech. Reference ID"));
                        end;
                    }
                }
                textelement(CreationDateTime)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        MICAFlowBufferASN."Tech. Creation DateTime Raw" := CreationDateTime;
                    end;
                }
            }
            textelement(DataArea)
            {
                textelement(Acknowledge) { }
                textelement(Shipment)
                {
                    textattribute(nounVersionID) { }
                    textelement(ShipmentHeader)
                    {
                        textelement(DocumentID)
                        {

                            textelement(ID)
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    MICAFlowBufferASN."Doc. ID" := ID;
                                end;
                            }
                        }

                        textelement(AlternateDocumentID)
                        {

                            textelement(aID)
                            {
                                xmlname = 'ID';
                                trigger OnAfterAssignVariable()
                                begin
                                    MICAFlowBufferASN."Alt. Doc. ID" := aID;
                                end;
                            }
                        }
                        textelement(DocumentDateTime) { }
                        textelement(DocumentReference)
                        {

                            textattribute(type) { }
                            textelement(drDocumentID)
                            {
                                XmlName = 'DocumentID';
                                textelement(drID)
                                {
                                    XmlName = 'ID';

                                    trigger OnAfterAssignVariable()
                                    begin
                                        case type of
                                            'REASON_CODE':
                                                MICAFlowBufferASN."Doc. Type" := drID;
                                            'ETA':
                                                MICAFlowBufferASN."ETA Raw" := DocumentDateTime;
                                        end;
                                    end;
                                }
                            }
                        }
                        textelement(CarrierRouteReference)
                        {
                            textelement(crrDocumentID)
                            {
                                XmlName = 'DocumentID';
                                textelement(crrID)
                                {

                                    XmlName = 'ID';
                                    trigger OnAfterAssignVariable()
                                    begin
                                        MICAFlowBufferASN."Container ID" := crrID;
                                    end;
                                }
                            }
                            textelement(SealID)
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    MICAFlowBufferASN."Seal Number" := SealID;
                                End;
                            }
                            textelement(LicensePlate)
                            {
                                textattribute(ltype)
                                {
                                    XmlName = 'type';
                                }
                            }
                            textelement(TransportNature) { }
                            textelement(AlternativeTransportNature) { }

                        }
                        textelement(ActualShipDateTime)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBufferASN."Actual Ship DateTime Raw" := ActualShipDateTime;
                            End;
                        }
                        textelement(ScheduledDeliveryDateTime)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBufferASN."SRD Raw" := ScheduledDeliveryDateTime;
                            end;
                        }
                        textelement(GrossWeightMeasure)
                        {
                            textattribute(unitCode) { }
                        }
                        textelement(TotalVolumeMeasure)
                        {
                            textattribute(tunitCode)
                            {
                                XmlName = 'unitCode';
                            }
                        }
                        textelement(DistributionCenterCode) { }
                        textelement(ShipFromParty)
                        {
                            textelement(PartyIDs)
                            {
                                textelement(pID)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(Name) { }
                            textelement(sLocation)
                            {
                                XmlName = 'Location';
                                textattribute(stype)
                                {
                                    XmlName = 'type';
                                }
                                textelement(sID)
                                {
                                    XmlName = 'ID';
                                    trigger OnAfterAssignVariable()
                                    begin
                                        if stype = 'InventoryOrganization' then
                                            MICAFlowBufferASN."Ship. From" := sID;
                                    end;
                                }
                                textelement(sName)
                                {
                                    XmlName = 'Name';
                                }
                                textelement(Address)
                                {
                                    MinOccurs = Zero;
                                    textelement(LineOne) { }
                                    textelement(LineTwo) { }
                                    textelement(LineThree) { }
                                    textelement(LineFour) { }
                                    textelement(CityName) { }
                                    textelement(CountrySubDivisionCode)
                                    {
                                        textattribute(cname)
                                        {
                                            XmlName = 'name';
                                            Occurrence = Optional;
                                        }
                                    }
                                    textelement(CountryCode) { }
                                    textelement(PostalCode) { }
                                }
                                textelement(slUserArea)
                                {
                                    XmlName = 'UserArea';
                                    MinOccurs = Zero;
                                    textelement(InvOrgType) { }
                                    textelement(GSS_Site) { }
                                    textelement(SubInventory) { }
                                }
                            }
                            textelement(Contact)
                            {
                                textattribute(sctype)
                                {
                                    XmlName = 'type';
                                }
                                textelement(scID)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(scName)
                                {
                                    XmlName = 'Name';
                                }
                            }
                        }
                        textelement(CarrierParty)
                        {
                            textattribute(category) { }
                            textelement(scpPartyIDs)
                            {
                                XmlName = 'PartyIDs';
                                textelement(scpID)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(scpName)
                            {
                                XmlName = 'Name';
                            }
                        }
                        textelement(Instructions)
                        {
                            textelement(InstructionCode) { }
                            textelement(InstructionString) { }
                        }

                        textelement(ShipToParty)
                        {
                            textelement(stpPartyIDs)
                            {
                                XmlName = 'PartyIDs';
                                textelement(stpID)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(Location)
                            {
                                textattribute(stpltype)
                                {
                                    XmlName = 'type';
                                }
                                textelement(stplID)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(stplName)
                                {
                                    XmlName = 'Name';
                                }
                                textelement(stplAddress)
                                {
                                    XmlName = 'Address';
                                    MinOccurs = Zero;
                                    textelement(stplaID)
                                    {
                                        XmlName = 'ID';
                                    }
                                    textelement(stplaCountrySubDivisionCode)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(stplaname)
                                        {
                                            XmlName = 'name';
                                            Occurrence = Optional;
                                        }
                                    }
                                    textelement(stplaCountryCode)
                                    {
                                        XmlName = 'CountryCode';
                                    }
                                }
                                textelement(stplUserArea)
                                {
                                    Xmlname = 'UserArea';
                                    MinOccurs = Zero;
                                    textelement(stplInvOrgType)
                                    {
                                        XmlName = 'InvOrgType';
                                    }
                                }
                            }
                            textelement(stpContact)
                            {
                                XmlName = 'Contact';
                            }
                            textelement(Account)
                            {
                                textattribute(stpatype)
                                {
                                    XmlName = 'type';
                                }
                                textelement(AccountIDs)
                                {
                                    textelement(stpaID)
                                    {
                                        XmlName = 'ID';
                                    }
                                }
                                textelement(stpaLocation)
                                {
                                    XmlName = 'Location';
                                    MinOccurs = Zero;
                                    textelement(stpalAddress)
                                    {
                                        XmlName = 'Address';
                                        MinOccurs = Zero;
                                    }
                                }
                            }
                        }
                        textelement(TransportationTerm)
                        {
                            textelement(IncotermsCode) { }
                            textelement(PlaceOfOwnershipTransferLocation)
                            {
                                textattribute(tptype)
                                {
                                    XmlName = 'type';
                                }
                                textelement(tpID)
                                {
                                    XmlName = 'ID';
                                    trigger OnAfterAssignVariable()
                                    begin
                                        case tptype of
                                            'ArrivalPort':
                                                MICAFlowBufferASN."Arrival Port" := tpID;
                                        end;
                                    end;
                                }
                            }
                        }
                        textelement(ClearanceCustomsOffice) { }
                        textelement(CustomsOffice) { }
                        textelement(MaritimeAirCompany) { }
                        textelement(MaritimeAirNumber) { }
                        textelement(MaritimeAirCompanyName) { }
                        textelement(MaritimeAirCompanyCountryCode) { }
                        textelement(MaritimeAirDepartureDateTime) { }
                        textelement(shUserArea)
                        {
                            XmlName = 'UserArea';
                            MinOccurs = Zero;
                            textattribute(shname)
                            {
                                XmlName = 'name';
                                Occurrence = Optional;
                            }
                            textelement(CodePaysISOGalia) { MinOccurs = Zero; }
                            textelement(CodeAdresseVendeuse) { MinOccurs = Zero; }
                            textelement(CodeOD) { MinOccurs = Zero; }
                            textelement(CodeOR) { MinOccurs = Zero; }
                            textelement(EmitterMailboxCode) { MinOccurs = Zero; }
                            textelement(DestinationMailboxCode) { MinOccurs = Zero; }
                            textelement(VendorNumber) { MinOccurs = Zero; }
                            textelement(ConsignmentNoteNumber) { MinOccurs = Zero; }
                        }
                    } // shipment header

                    textelement(ShipmentItem)
                    {
                        textelement(ItemID)
                        {
                            textelement(siiID)
                            {
                                xmlname = 'ID';
                            }
                            textelement(VariationID)
                            {
                                textattribute(schemeName)
                                {
                                }
                                trigger OnAfterAssignVariable()
                                begin
                                    case schemeName of
                                        'ITEMTYPE':
                                            MICAFlowBufferASN.CAI := siiID;
                                        'CCI':
                                            MICAFlowBufferASN.CCI := VariationID;
                                        'CST':
                                            MICAFlowBufferASN.CST := VariationID;
                                    end;
                                end;
                            }
                        }
                        textelement(CustomerItemID)
                        {
                            textelement(sicID)
                            {
                                XmlName = 'ID';
                                trigger OnAfterAssignVariable()
                                Begin
                                    MICAFlowBufferASN.ccid := sicID;
                                End;
                            }
                        }

                        textelement(SupplierItemID)
                        {
                            textelement(sisID)
                            {
                                XmlName = 'ID';

                            }
                        }
                        textelement(Description) { }
                        textelement(Classification)
                        {
                            textattribute(sictype)
                            {
                                XmlName = 'type';
                            }
                            textelement(Codes)
                            {
                                textelement(cCode)
                                {
                                    xmlName = 'Code';
                                    textattribute(sequence)
                                    {

                                    }
                                    trigger OnAfterAssignVariable()
                                    Begin
                                        if (sequence = '1') and (sictype = 'Market') then
                                            MICAFlowBufferASN."Market Code" := cCode;
                                    End;
                                }
                            }
                        }
                        textelement(Specification)
                        {
                            textelement(Property)
                            {
                                textelement(NameValue)
                                {
                                    textattribute(sispname)
                                    {
                                        XmlName = 'name';
                                        Occurrence = Optional;
                                    }
                                }

                            }
                        }
                        textelement(Packaging) { }
                        textelement(ShippedQuantity)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBufferASN."Quantity Raw" := ShippedQuantity;
                            End;
                        }

                        textelement(EstimatedWeightMeasure)
                        {
                            textattribute(sieunitCode)
                            {
                                XmlName = 'unitCode';
                            }
                        }

                        textelement(RequisitionReference)
                        {
                            textelement(sirDocumentID)
                            {
                                XmlName = 'DocumentID';
                                textelement(sirID)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(LineNumber) { }
                        }

                        textelement(PurchaseOrderReference)
                        {
                            textelement(sipoDocumentID)
                            {
                                XmlName = 'DocumentID';
                                textelement(sipoID)
                                {
                                    XmlName = 'ID';
                                    trigger OnAfterAssignVariable()
                                    begin
                                        MICAFlowBufferASN."AL No. Raw" := sipoID;
                                    End;
                                }
                            }
                            textelement(sipoLineNumber)
                            {
                                XmlName = 'LineNumber';
                                trigger OnAfterAssignVariable()
                                begin
                                    MICAFlowBufferASN."AL Line No." := sipoLineNumber;
                                End;

                            }
                        }

                        textelement(SalesOrderReference)
                        {
                            MinOccurs = Zero;
                            textelement(sisoDocumentID)
                            {
                                XmlName = 'DocumentID';
                                textelement(sisoID)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(sisoLineNumber)
                            {
                                XmlName = 'LineNumber';
                                MinOccurs = Zero;
                            }
                        }

                        textelement(sidrDocumentReference)
                        {

                            XmlName = 'DocumentReference';
                            textattribute(sidrtype)
                            {
                                XmlName = 'type';
                            }

                            textelement(sidrDocumentID)
                            {
                                XmlName = 'DocumentID';
                                textelement(sidrID)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(sidrLineNumber)
                                {
                                    XmlName = 'LineNumber';
                                    MinOccurs = Zero;
                                }
                            }
                            textelement(StatusCode) { MinOccurs = Zero; }

                        }
                        textelement(siLineNumber)
                        {
                            XmlName = 'LineNumber';
                            MinOccurs = Zero;
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBufferASN."ASN Line Number Raw" := siLineNumber;
                            End;

                        }
                        textelement(DeliveredQuantity) { }
                        textelement(AssemblyID) { MinOccurs = Zero; }
                        textelement(siGrossWeightMeasure)
                        {
                            XmlName = 'GrossWeightMeasure';
                            MinOccurs = Zero;
                            textattribute(sigwunitCode)
                            {
                                Xmlname = 'unitCode';
                            }
                        }
                        textelement(NetWeightMeasure)
                        {
                            MinOccurs = Zero;
                            textattribute(sinwunitCode)
                            {
                                Xmlname = 'unitCode';
                            }
                        }
                        textelement(ReasonCode)
                        {
                            MinOccurs = Zero;
                            textattribute(sirname)
                            {
                                XmlName = 'name';
                                Occurrence = Optional;
                            }
                        }
                        textelement(ImportLicense) { MinOccurs = Zero; }
                        textelement(AvailableDateTime) { MinOccurs = Zero; }
                        textelement(DispensationNumber) { MinOccurs = Zero; }
                        textelement(siShipToParty)
                        {
                            XmlName = 'ShipToParty';
                            textelement(siPartyIDs)
                            {
                                XmlName = 'PartyIDs';
                                textelement(sipID)
                                {
                                    XmlName = 'ID';
                                }
                            }
                            textelement(siLocation)
                            {
                                XmlName = 'Location';

                                textattribute(sitype)
                                {
                                    xmlname = 'type';
                                }

                                textelement(silID)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(silName)
                                {
                                    XmlName = 'Name';
                                }
                                textelement(silAddress)
                                {
                                    XmlName = 'Address';
                                    MinOccurs = Zero;
                                    textelement(silaCountrySubDivisionCode)
                                    {
                                        XmlName = 'CountrySubDivisionCode';
                                        textattribute(silaname)
                                        {
                                            XmlName = 'name';
                                            Occurrence = Optional;
                                        }
                                    }
                                    textelement(silaCountryCode)
                                    {
                                        XmlName = 'CountryCode';
                                        trigger OnAfterAssignVariable()
                                        begin
                                            MICAFlowBufferASN."Country Code" := silaCountryCode;
                                        End;
                                    }
                                }
                                textelement(silaUserArea)
                                {
                                    xmlname = 'UserArea';
                                    MinOccurs = Zero;
                                    textelement(silaInvOrgType)
                                    {
                                        XmlName = 'InvOrgType';
                                    }

                                    textelement(silaSubInventory)
                                    {
                                        XmlName = 'SubInventory';
                                    }

                                }
                            }
                            textelement(sipContact)
                            {
                                XmlName = 'Contact';
                            }
                        }

                        textelement(siUserArea)
                        {
                            XmlName = 'UserArea';
                            MinOccurs = Zero;
                            textattribute(siname)
                            {
                                XmlName = 'name';
                                Occurrence = Optional;
                            }
                            textelement(CodeISOPaysOrigineFabrication) { MinOccurs = Zero; }
                            textelement(LibellePaysOrigineFabrication) { MinOccurs = Zero; }
                            textelement(siTransportNature) { XmlName = 'TransportNature'; MinOccurs = Zero; }

                            trigger OnAfterAssignVariable()
                            begin
                                if siname = 'BordereauTransportNumber' then
                                    MICAFlowBufferASN."Carrier Doc. No." := siUserArea
                                else
                                    siUserArea := '';
                            End;
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            ImportedRecordCount += 1;
                            MICAFlowBufferASN."Tech. Native ID" := CopyStr(MICAFlowBufferASN."Doc. ID" + 'ODOR' +
                              format(MICAFlowBufferASN."Date Time Creation"), 1, MaxStrLen(MICAFlowBufferASN."Tech. Native ID"));
                            MICAFlowBufferASN.Validate("Flow Entry No.", MyMICAFlowEntry."Entry No.");
                            MICAFlowBufferASN."Entry No." := ImportedRecordCount;

                            MICAFlowBufferASN.Insert();
                        end;

                    } // shipment item
                }
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        MICAFlowBufferASN.Init();
    end;

    trigger OnPostXmlPort()
    begin
    end;

    procedure SetFlowEntry(var MICAFlowEntry: Record "MICA Flow Entry")
    var
    begin
        MyMICAFlowEntry := MICAFlowEntry;
    end;

    procedure GetBuffer(var OutMICAFlowBufferASN: Record "MICA Flow Buffer ASN")
    begin
        OutMICAFlowBufferASN := MICAFlowBufferASN;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

    var
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        MyMICAFlowEntry: Record "MICA Flow Entry";
        ImportedRecordCount: Integer;
}