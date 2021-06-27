xmlport 81190 "MICA Shipped Confirmation"
{
    //INT-3PL-005: Shipped confirmation (in)

    Caption = 'Shipped Confirmation';
    DefaultFieldsValidation = false;
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(ConfirmationShipment)
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
                    textelement(MichReferencekey)
                    {
                    }
                    textelement(MichMessageType)
                    {
                    }
                }
            }
            textelement(DataArea)
            {
                textelement(Acknowledge)
                {
                }
                textelement(Shipment)
                {
                    textattribute(nounVersionID)
                    {
                    }
                    textelement(ShipmentHeader)
                    {
                        textelement(DocumentID)
                        {
                            textelement(ID)
                            {
                            }
                        }
                        tableelement(DocumentReference; Integer)
                        {
                            AutoSave = false;
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
                            textelement(DocumentDateTime)
                            {
                                MinOccurs = Zero;
                            }

                        }

                        textelement("userareaSH")
                        {
                            XmlName = 'UserArea';
                            textelement(DriverInfo)
                            {
                            }
                            textelement(LicensePlate)
                            {
                                textattribute(typelicenseplate)
                                {
                                    XmlName = 'type';
                                }
                            }
                        }
                        textelement(ActualShipDateTime)
                        {
                        }
                        textelement(ShipFromParty)
                        {
                            textelement(Location)
                            {
                                textattribute("typeLogSite")
                                {
                                    XmlName = 'type';
                                }
                                textelement("idLogSite")
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(MovementCode)
                        {
                        }
                    }
                    tableelement("MICA FlowBuff Shipped Confirm2"; "MICA FlowBuff Shipped Confirm2")
                    {
                        AutoSave = false;
                        XmlName = 'ShipmentItem';
                        textelement(ItemID)
                        {
                            textelement("<id3>")
                            {
                                XmlName = 'ID';
                                textattribute(schemeName)
                                {
                                }
                            }
                            trigger OnAfterAssignVariable()
                            begin
                                UserAreaCountryOfOriginValue := '';
                                UserAreaFactoryStockOwner := '';
                                UserAreaDOTValue := '';
                            end;
                        }
                        textelement(CustomerItemID)
                        {
                            textelement("<id4>")
                            {
                                XmlName = 'ID';
                                textattribute("<schemename1>")
                                {
                                    XmlName = 'schemeName';
                                }
                            }
                        }
                        textelement(Description)
                        {
                        }
                        fieldelement(ShippedQuantity; "MICA FlowBuff Shipped Confirm2"."RAW Shipped Quantity")
                        { }

                        tableelement("documentreferenceLine"; Integer)
                        {
                            XmlName = 'DocumentReference';
                            AutoSave = false;
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
                                    MinOccurs = Zero;

                                    trigger OnAfterAssignVariable()
                                    begin
                                        if typeLine = 'DeliveryNumber' then begin
                                            "MICA FlowBuff Shipped Confirm2"."Document ID" := IDLine;
                                            "MICA FlowBuff Shipped Confirm2"."RAW Document Line Number" := LineNumberLine;
                                        end;
                                    end;

                                }
                            }
                        }
                        textelement("<linenumber1>")
                        {
                            XmlName = 'LineNumber';
                        }
                        textelement(Instructions)
                        {
                            textelement(InstructionCode)
                            {
                            }
                            textelement(InstructionString)
                            {
                            }
                        }
                        fieldelement(PlannedShipQuantity; "MICA FlowBuff Shipped Confirm2"."RAW Planned Ship Quantity")
                        { }
                        textelement(ShipToParty)
                        {
                            textelement("<location1>")
                            {
                                XmlName = 'Location';
                                textattribute("<type4>")
                                {
                                    XmlName = 'type'; //LogisticsSite
                                }
                                textelement("<id6>")
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement("<shipfromparty1>")
                        {
                            XmlName = 'ShipFromParty';
                            textelement("<location2>")
                            {
                                XmlName = 'Location';
                                textattribute("<type5>")
                                {
                                    XmlName = 'type'; //LogisticsSite
                                }
                                textelement("<id7>")
                                {
                                    XmlName = 'ID';
                                }
                            }
                        }
                        textelement(UserAreaLine)
                        {
                            XmlName = 'UserArea';
                            MaxOccurs = Unbounded;
                            textattribute(nameUALine)
                            {
                                XmlName = 'name';
                            }
                            textattribute("typeUALine")
                            {
                                XmlName = 'type';
                                trigger OnAfterAssignVariable()
                                begin
                                    UserAreaLine := '';
                                end;
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                CASE nameUALine of
                                    'COUNTRYOFORIGINISOCODE':
                                        UserAreaCountryOfOriginValue := UserAreaLine;
                                    'DOT_Value':
                                        UserAreaDOTValue := UserAreaLine;
                                end;
                            end;
                        }
                        // textelement(UserAreaElement)
                        // {
                        //     XmlName = 'UserArea';
                        //     // MinOccurs = Zero;
                        //     // MaxOccurs = Unbounded;
                        //     textattribute(UserAreaName)
                        //     {
                        //         XmlName = 'name';
                        //     }
                        //     textattribute("typeUALine")
                        //     {
                        //         XmlName = 'type';
                        //     }
                        //     trigger OnAfterAssignVariable()
                        //     begin
                        //         case UserAreaName of
                        //             'FACTORY_STOCK_OWNER':
                        //                 UserAreaFactoryStockOwner := UserAreaElement;
                        //             'COUNTRYOFORIGINISOCODE':
                        //                 UserAreaCountryOfOriginValue := CopyStr(UserAreaElement, 1, 2);
                        //             'DOT_Value':
                        //                 UserAreaDOTValue := CopyStr(UserAreaElement, 1, 4);
                        //         end;
                        //     end;
                        // }

                        trigger OnBeforeInsertRecord()
                        begin
                            ImportedRecordCount += 1;
                            "MICA FlowBuff Shipped Confirm2"."Driver Info" := CopyStr(DriverInfo, 1, 30);
                            "MICA FlowBuff Shipped Confirm2"."License Plate" := CopyStr(LicensePlate, 1, 15);
                            "MICA FlowBuff Shipped Confirm2"."License Plate Type" := CopyStr(typelicenseplate, 1, 30);
                            "MICA FlowBuff Shipped Confirm2"."RAW Actual Ship DateTime" := ActualShipDateTime;
                            "MICA FlowBuff Shipped Confirm2"."RAW DOT Value" := UserAreaDOTValue;
                            "MICA FlowBuff Shipped Confirm2"."RAW Country Of Origin" := UserAreaCountryOfOriginValue;
                            "MICA FlowBuff Shipped Confirm2".Validate("Flow Entry No.", MICAFlowEntry."Entry No.");
                            "MICA FlowBuff Shipped Confirm2".Insert(true);
                        end;
                    }
                }
            }
        }
    }

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        ImportedRecordCount: Integer;
        UserAreaCountryOfOriginValue: text[2];
        UserAreaFactoryStockOwner: text[10];
        UserAreaDOTValue: text[10];

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

    procedure GetBuffer(var OutMICAFlowBuffShippedConfirm2: Record "MICA FlowBuff Shipped Confirm2")
    begin
        OutMICAFlowBuffShippedConfirm2 := "MICA FlowBuff Shipped Confirm2";
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

}