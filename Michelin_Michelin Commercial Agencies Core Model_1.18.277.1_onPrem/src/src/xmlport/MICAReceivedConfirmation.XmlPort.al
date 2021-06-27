xmlport 81210 "MICA Received Confirmation"
{
    //INT-3PL-006: Received confirmation (in)
    Caption = 'Received Confirmation';
    DefaultFieldsValidation = false;
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(ConfirmationReception)
        {
            textelement(ApplicationArea)
            {
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
                }
            }
            textelement(DataArea)
            {
                textelement(Process)
                {
                }
                textelement(ReceiveDelivery)
                {
                    textattribute(nounVersionID)
                    {
                    }
                    textelement(ReceiveDeliveryHeader)
                    {
                        textelement(DocumentID)
                        {
                            textelement(IDDocRDH)
                            {
                                XmlName = 'ID';
                            }
                        }
                        textelement(AlternateDocumentID)
                        {
                            textelement(ID)
                            {
                            }
                        }
                        textelement(DocumentDateTime)
                        {
                        }

                        textelement(DocumentReference)
                        {
                            textattribute(type)
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    type := type;
                                end;
                            }
                            textelement("documentid1")
                            {
                                XmlName = 'DocumentID';
                                textelement("id1")
                                {
                                    XmlName = 'ID';
                                }
                            }

                        }
                        textelement(ActualDeliveryDateTime)
                        {
                        }
                        textelement(ShipFromParty)
                        {
                            textelement(Location)
                            {
                                textelement("Address")
                                {
                                    textelement(CountryCode)
                                    { }
                                }
                            }
                        }
                        textelement(DeliverToParty)
                        {
                            textelement(LocationDlv)
                            {
                                XmlName = 'Location';
                                textelement(IDDlv)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(AddressDlv)
                                {
                                    XmlName = 'Address';
                                    textelement(CountryCodeDlv)
                                    {
                                        XmlName = 'CountryCode';
                                    }
                                }
                            }
                        }
                    }
                    tableelement("MICA FlowBuff ReceivedConfirm2"; "MICA FlowBuff ReceivedConfirm2")
                    {
                        AutoSave = false;
                        XmlName = 'ReceiveDeliveryItem';
                        textelement(ItemID)
                        {
                            textelement("idItem")
                            {
                                XmlName = 'ID';
                            }
                        }
                        fieldelement(ExpectedQuantity; "MICA FlowBuff ReceivedConfirm2"."RAW Expected Quantity")
                        { }
                        textelement(OwnershipCode)
                        { }
                        textelement(PurchaseOrderReference)
                        {
                            textelement(DocumentIDPOR)
                            {
                                XmlName = 'DocumentID';
                                textelement(IDPOR)
                                {
                                    XmlName = 'ID';
                                }

                            }
                            textelement(LineNumber)
                            { }
                        }

                        textelement("documentreferenceLine")
                        {
                            XmlName = 'DocumentReference';
                            textattribute("typeLine")
                            {
                                XmlName = 'type';
                            }
                            textelement("documentidLine")
                            {
                                XmlName = 'DocumentID';
                                textelement(IDLine)
                                {
                                    XmlName = 'ID';
                                }
                                textelement(LineNumberLine)
                                {
                                    XmlName = 'LineNumber';

                                    trigger OnAfterAssignVariable()
                                    begin
                                        "MICA FlowBuff ReceivedConfirm2"."Document ID" := IDLine;
                                        "MICA FlowBuff ReceivedConfirm2"."RAW Document Line Number" := LineNumberLine;
                                    end;
                                }
                            }
                        }
                        textelement(linenumberItem)
                        {
                            XmlName = 'LineNumber';
                        }
                        fieldelement(ReceivedQuantity; "MICA FlowBuff ReceivedConfirm2"."RAW Received Quantity")
                        { }
                        textelement(ReturnedQuantity)
                        { }
                        textelement(ReceiptRoutingCode)
                        { }
                        textelement(DeliverToPartyLine)
                        {
                            XmlName = 'DeliverToParty';
                            textelement(locationDTP)
                            {
                                XmlName = 'Location';
                                textelement(AddressDTP)
                                {
                                    XmlName = 'Address';
                                    textelement(StatusDTP)
                                    {
                                        XmlName = 'Status';
                                        textelement(ReasonCodeDTP)
                                        {
                                            XmlName = 'ReasonCode';
                                        }
                                    }
                                }
                            }
                        }

                        trigger OnBeforeInsertRecord()
                        begin
                            "MICA FlowBuff ReceivedConfirm2"."RAW Actual Delivery DateTime" := ActualDeliveryDateTime;
                            "MICA FlowBuff ReceivedConfirm2".Validate("Flow Entry No.", MICAFlowEntry."Entry No.");
                            "MICA FlowBuff ReceivedConfirm2".Insert(true);
                            ImportedRecordCount += 1;
                        end;
                    }
                }
            }
        }
    }

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        ImportedRecordCount: Integer;

    trigger OnPostXmlPort()
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
        CreationDT: DateTime;
    begin
        CreationDT := 0DT;
        DTVariant := CreationDT;
        TypeHelper.Evaluate(DTVariant, CreationDateTime, '', '');
        Evaluate(CreationDT, format(DTVariant));
        MICAFlowEntry.UpdateTechnicalData(LOGICALID, ComponentID, TaskID, REFERENCEID, CreationDT, MichSender, MichReceiver, '', MichReferencekey, MichMessageType, '');
    end;

    procedure SetFlowEntry(var inMICAFlowEntry: Record "MICA Flow Entry")
    begin
        MICAFlowEntry := inMICAFlowEntry;
    end;

    procedure GetBuffer(var OutMICAFlowBuffReceivedConfirm2: Record "MICA FlowBuff ReceivedConfirm2")
    begin
        OutMICAFlowBuffReceivedConfirm2 := "MICA FlowBuff ReceivedConfirm2";
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

}