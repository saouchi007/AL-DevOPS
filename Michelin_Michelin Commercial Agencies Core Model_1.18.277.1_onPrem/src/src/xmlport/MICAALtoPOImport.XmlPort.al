xmlport 81261 "MICA AL to PO Import"
{
    //Namespaces = imp1 = 'http://www.openapplications.org/oagis/10';
    //DefaultNamespace = 'http://www.openapplications.org/oagis/10';
    //UseDefaultNamespace = false;
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(ProcessPurchaseOrder)
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
                textelement(Extension1)
                {
                    XmlName = 'Extension';

                    textelement(Name)
                    {

                        textattribute(typeCode1)
                        {
                            XmlName = 'typeCode';

                        }
                    }
                }
            }
            textelement(DataArea)
            {

                textelement(PurchaseOrder)
                {

                    textattribute(typeCode2)
                    {

                        XmlName = 'typeCode';
                    }
                    textelement(PurchaseOrderHeader)
                    {

                        textelement(DocumentIDSet)
                        {


                            textelement(ID3)
                            {

                                XmlName = 'ID';
                                textattribute(typeCode4)
                                {

                                    XmlName = 'typeCode';
                                }

                            }
                        }
                        textelement(DocumentReference)
                        {

                            textelement(ID1)
                            {

                                XmlName = 'ID';
                            }
                            textelement(DocumentDateTime)
                            {

                            }
                        }
                        textelement(ShipToParty)
                        {


                            textelement(ID4)
                            {


                                XmlName = 'ID';
                            }
                        }
                        textelement(RequestedShipDateTime)
                        {

                        }
                        textelement(ShippingInstructions)
                        {

                        }
                        textelement(OrderDateTime)
                        {

                        }
                        textelement(BuyerParty)
                        {

                            textelement(ID2)
                            {

                                XmlName = 'ID';
                                textattribute(typeCode3)
                                {

                                    XmlName = 'typeCode';
                                }

                            }
                        }

                        textelement(ShipFromParty)
                        {

                            textelement(ID)
                            {

                                textattribute(typeCode) { }
                            }
                        }


                        textelement(Extension2)
                        {


                            XmlName = 'Extension';
                            textelement(ID5)
                            {

                                XmlName = 'ID';
                                textattribute(typeCode5)
                                {
                                    XmlName = 'typeCode';
                                }
                                trigger OnAfterAssignVariable()
                                begin
                                    case typeCode5 of
                                        'PayTo':
                                            PayTo := ID5;
                                        'PhysicalDownstreamDCCode':
                                            DC14 := ID5;
                                    end;
                                    ID5 := '';
                                end;
                            }
                        }

                    }
                    tableelement(PurchaseOrderLine; "MICA Flow Buffer AL to PO")
                    {

                        fieldelement(LineNumberID; PurchaseOrderLine."AL Line Number")
                        {

                        }
                        textelement(Item)
                        {

                            fieldelement(ID; PurchaseOrderLine.CAD)
                            {

                            }
                        }
                        fieldelement(Quantity; PurchaseOrderLine."Quantity Raw")
                        {

                        }

                        trigger OnBeforeInsertRecord()
                        begin
                            // Flow Buffer Fields
                            ImportedRecordCount += 1;
                            PurchaseOrderLine."Flow Code" := copystr(MyMICAFlowEntry."Flow Code", 1, MaxStrLen(PurchaseOrderLine."Flow Code"));
                            PurchaseOrderLine."Flow Entry No." := MyMICAFlowEntry."Entry No.";
                            PurchaseOrderLine."Entry No." := ImportedRecordCount;
                            // Technical Header fields
                            PurchaseOrderLine."Logical Id" := copystr(LogicalID, 1, MaxStrLen(PurchaseOrderLine."Logical Id"));
                            PurchaseOrderLine."Component Id" := copystr(ComponentID, 1, MaxStrLen(PurchaseOrderLine."Component Id"));
                            PurchaseOrderLine."Task Id" := copystr(TaskID, 1, MaxStrLen(PurchaseOrderLine."Task Id"));
                            PurchaseOrderLine."Reference Id" := copystr(ReferenceID, 1, MaxStrLen(PurchaseOrderLine."Reference Id"));
                            PurchaseOrderLine."Creation Date Time Raw" := copystr(CreationDateTime, 1, MaxStrLen(PurchaseOrderLine."Creation Date Time Raw"));
                            PurchaseOrderLine."Native Id" := copystr(Name, 1, MaxStrLen(PurchaseOrderLine."Native Id"));
                            // Purchase Header fields
                            PurchaseOrderLine."Document Reference" := copystr(ID1, 1, MaxStrLen(PurchaseOrderLine."Document Reference"));
                            PurchaseOrderLine."Document Date Time Raw" := copystr(DocumentDateTime, 1, MaxStrLen(PurchaseOrderLine."Document Date Time Raw"));
                            PurchaseOrderLine."Buy-From Vendor" := copystr(ID2, 1, MaxStrLen(PurchaseOrderLine."Buy-From Vendor"));
                            PurchaseOrderLine."Ship From Vendor" := CopyStr(ID, 1, MaxStrLen(PurchaseOrderLine."Ship From Vendor"));
                            PurchaseOrderLine."Order Date Time Raw" := copystr(OrderDateTime, 1, MaxStrLen(PurchaseOrderLine."Order Date Time Raw"));
                            PurchaseOrderLine."Vendor Order Number" := copystr(ID3, 1, MaxStrLen(PurchaseOrderLine."Vendor Order Number"));
                            PurchaseOrderLine."Shipment Method Code" := copystr(ShippingInstructions, 1, 3);
                            PurchaseOrderLine."Shipment Instructions" := copystr(ShippingInstructions, 4, 20);
                            PurchaseOrderLine.Location := copystr(ID4, 1, MaxStrLen(PurchaseOrderLine.Location));
                            PurchaseOrderLine."Pay-To" := copystr(PayTo, 1, MaxStrLen(PurchaseOrderLine."Pay-To"));
                            PurchaseOrderLine."MICA DC14" := copystr(DC14, 1, MaxStrLen(PurchaseOrderLine."MICA DC14"));
                            PurchaseOrderLine."Requested Receipt Date Raw" := copystr(RequestedShipDateTime, 1, MaxStrLen(PurchaseOrderLine."Requested Receipt Date Raw"));
                        end;
                    }
                }
            }
        }
    }
    procedure SetFlowEntry(var MICAFlowEntry: Record "MICA Flow Entry")
    var
    begin
        MyMICAFlowEntry := MICAFlowEntry;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

    var
        MyMICAFlowEntry: Record "MICA Flow Entry";
        ImportedRecordCount: Integer;
        PayTo: Code[20];
        DC14: Code[20];
}