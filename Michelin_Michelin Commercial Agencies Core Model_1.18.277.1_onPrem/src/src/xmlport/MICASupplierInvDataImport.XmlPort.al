xmlport 82020 "MICA Supplier Inv. Data Import"
{
    //INTGIS001 – Supplier Invoice Integration
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    Format = Xml;
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
        textelement(PROCESS_INVOICE_002)
        {
            MinOccurs = Zero;
            textelement(CNTROLAREA)
            {
                MinOccurs = Zero;
                textelement(BSR)
                {
                    MinOccurs = Zero;
                    textelement(VERB)
                    {
                        MinOccurs = Zero;
                        textattribute(bsrvalue)
                        {
                            XmlName = 'value';
                        }
                    }
                    textelement(NOUN)
                    {
                        MinOccurs = Zero;
                        textattribute(nounvalue)
                        {
                            XmlName = 'value';
                        }
                    }
                    textelement(REVISION)
                    {
                        MinOccurs = Zero;
                        textattribute(revisionvalue)
                        {
                            XmlName = 'value';
                        }
                    }
                }
                textelement(SENDER)
                {
                    MinOccurs = Zero;
                    textelement(LOGICALID)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(COMPONENT)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(TASK)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(REFERENCEID)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(CONFIRMATION)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(LANGUAGE)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(CODEPAGE)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(AUTHID)
                    {
                        MinOccurs = Zero;
                    }
                }
                textelement(DATETIME)
                {
                    MinOccurs = Zero;
                    textattribute(qualifier)
                    {
                    }
                    textelement(YEAR)
                    {
                    }
                    textelement(MONTH)
                    {
                    }
                    textelement(DAY)
                    {
                    }
                    textelement(HOUR)
                    {
                    }
                    textelement(MINUTE)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(SECOND)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(SUBSECOND)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(TIMEZONE)
                    {
                        MinOccurs = Zero;
                    }
                }
            }
            textelement(DATAAREA)
            {
                textelement(PROCESS_INVOICE)
                {
                    textelement(INVHEADER1)
                    {
                        XmlName = 'INVHEADER';
                        textelement(TotalAMOUNT)
                        {
                            MinOccurs = Zero;
                            XmlName = 'AMOUNT';
                            textattribute(index)
                            {
                            }
                            textattribute(totalamountqualifier)
                            {
                                XmlName = 'qualifier';
                            }
                            textattribute(type)
                            {
                            }
                            textelement(VALUE)
                            {
                            }
                            textelement(NUMOFDEC)
                            {
                            }
                            textelement(SIGN)
                            {
                            }
                            textelement(CURRENCY)
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.CURRENCY := CURRENCY;
                                End;
                            }
                            textelement(DRCR)
                            {
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                HdrMICAFlowBufferSupplierInv."Total Amount RAW" := VALUE;
                                BuildDecimal(HdrMICAFlowBufferSupplierInv."Total Amount RAW", NUMOFDEC, SIGN, DRCR);
                            end;
                        }
                        textelement(datetimeDocument)
                        {
                            MinOccurs = Zero;
                            XmlName = 'DATETIME';
                            textattribute(datetimequalifier)
                            {
                                XmlName = 'qualifier';
                            }
                            textelement(docYEAR)
                            {
                                XmlName = 'YEAR';
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.YEAR := docYEAR;
                                End;
                            }
                            textelement(docMonth)
                            {
                                XmlName = 'MONTH';
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.MONTH := docMonth;
                                End;
                            }

                            textelement(docDay)
                            {
                                XmlName = 'DAY';
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.DAY := docDay;
                                End;
                            }
                            textelement(docHour)
                            {
                                XmlName = 'HOUR';
                            }
                            textelement(docMinute)
                            {
                                XmlName = 'MINUTE';
                            }
                            textelement(docSecond)
                            {
                                XmlName = 'SECOND';
                            }
                            textelement(docSubsecond)
                            {
                                XmlName = 'SUBSECOND';
                            }
                            textelement(docTimezone)
                            {
                                XmlName = 'TIMEZONE';
                            }
                        }
                        textelement(DOCUMENTID)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                HdrMICAFlowBufferSupplierInv."Vendor Invoice No." := DOCUMENTID;
                            End;
                        }
                        textelement(DESCRIPTN)
                        {
                            MinOccurs = Zero;
                        }
                        textelement(DOCTYPE)
                        {
                            MinOccurs = Zero;
                            trigger OnAfterAssignVariable()
                            begin
                                HdrMICAFlowBufferSupplierInv.DOCTYPE := DOCTYPE;
                            End;
                        }
                        textelement(PAYMETHOD)
                        {
                            MinOccurs = Zero;
                        }
                        textelement(REASONCODE)
                        {
                            MinOccurs = Zero;
                        }
                        textelement(USERAREA)
                        {
                            MinOccurs = Zero;
                            trigger OnAfterAssignVariable()
                            begin
                                HdrMICAFlowBufferSupplierInv.ATTRIBUTE1 := USERAREA;
                            End;
                        }
                        textelement(PARTNER)
                        {
                            MinOccurs = Zero;
                            textelement(NAME)
                            {
                                textattribute(partnerIndex)
                                {
                                    XmlName = 'index';
                                }
                            }
                            textelement(ONETIME)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(PARTNRID)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(PARTNRTYPE)
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    case PARTNRTYPE of
                                        'Supplier':
                                            begin
                                                HdrMICAFlowBufferSupplierInv."Supplier PARTNERID" := PARTNRID;
                                                HdrMICAFlowBufferSupplierInv."Supplier NAME" := NAME;
                                            end;
                                        'BillTo':
                                            begin
                                                HdrMICAFlowBufferSupplierInv."BillTo PARTNERID" := PARTNRID;
                                                HdrMICAFlowBufferSupplierInv."BillTo NAME" := NAME;
                                            end;
                                        'ShipTo':
                                            begin
                                                HdrMICAFlowBufferSupplierInv."ShipTo PARTNERID" := PARTNRID;
                                                HdrMICAFlowBufferSupplierInv."ShipTo NAME" := NAME;
                                            end;
                                    end;
                                end;
                            }
                            textelement(ACTIVE)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(partnerPaymethod)
                            {
                                MinOccurs = Zero;
                                XmlName = 'PAYMETHOD';
                            }
                            textelement(TAXID)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(TERMID)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(partnerUserarea)
                            {
                                MinOccurs = Zero;
                                XmlName = 'USERAREA';
                            }
                            textelement(ADDRESS)
                            {
                                MinOccurs = Zero;
                                textelement(ADDRLINE)
                                {
                                    textattribute(addrlineIndex)
                                    {
                                        XmlName = 'index';
                                    }
                                }
                                textelement(ADDRTYPE)
                                {
                                    MinOccurs = Zero;
                                }
                                textelement(CITY)
                                {
                                    MinOccurs = Zero;
                                }
                                textelement(COUNTRY)
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        case PARTNRTYPE of
                                            'Supplier':
                                                HdrMICAFlowBufferSupplierInv."Supplier COUNTRY" := COUNTRY;
                                            'BillTo':
                                                HdrMICAFlowBufferSupplierInv."BillTo COUNTRY" := COUNTRY;
                                            'ShipTo':
                                                HdrMICAFlowBufferSupplierInv."ShipTo COUNTRY" := COUNTRY;
                                        end;
                                    end;
                                }
                                textelement(addrDescriptn)
                                {
                                    XmlName = 'DESCRIPTN';
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        case PARTNRTYPE of
                                            'Supplier':
                                                HdrMICAFlowBufferSupplierInv."Supplier Descriptn" := addrDescriptn;
                                            'BillTo':
                                                HdrMICAFlowBufferSupplierInv."BillTo Descriptn" := addrDescriptn;
                                            'ShipTo':
                                                HdrMICAFlowBufferSupplierInv."ShipTo Descriptn" := addrDescriptn;
                                        end;
                                    end;
                                }
                                textelement(POSTALCODE)
                                {
                                    MinOccurs = Zero;
                                }
                                textelement(userareaPartner)
                                {
                                    MinOccurs = Zero;
                                    XmlName = 'USERAREA';
                                }

                            }

                            trigger OnAfterAssignVariable()
                            begin
                                clear(COUNTRY);
                                clear(PARTNRID);
                                clear(NAME);
                                clear(addrDescriptn);
                            end;

                        }
                        textelement(DOCUMNTREF)
                        {
                            textelement(refdoctype)
                            {
                                XmlName = 'DOCTYPE';
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv."DocRef Document Type" := refdoctype;
                                end;
                            }
                            textelement(refdocumentid)
                            {
                                XmlName = 'DOCUMENTID';
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.DOCUMENTID := refdocumentid;
                                end;
                            }
                            textelement(refpartnrid)
                            {
                                MinOccurs = Zero;
                                XmlName = 'PARTNRID';
                            }
                            textelement(refpartnrtype)
                            {
                                MinOccurs = Zero;
                                XmlName = 'PARTNRTYPE';
                            }
                            textelement(refdescriptn)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DESCRIPTN';
                            }
                            textelement(DOCUMENTRV)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(LINENUM)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(NOTES)
                            {
                                textattribute(notesindex)
                                {
                                    XmlName = 'index';
                                }
                            }
                            textelement(SCHLINENUM)
                            {
                                MinOccurs = Zero;
                            }
                            textelement(refuserarea)
                            {
                                MinOccurs = Zero;
                                XmlName = 'USERAREA';
                            }
                        }
                        textelement(PYMTTERM)
                        {
                            textelement(pymttermamount)
                            {
                                MinOccurs = Zero;
                                XmlName = 'AMOUNT';
                                textattribute(pymttermindex)
                                {
                                    XmlName = 'index';
                                }
                                textattribute(pymttermqualifier)
                                {
                                    XmlName = 'qualifier';
                                }
                                textattribute(pymttermtype)
                                {
                                    XmlName = 'type';
                                }
                                textelement(amountvalue)
                                {
                                    XmlName = 'VALUE';
                                }
                                textelement(pymttermnumofdec)
                                {
                                    XmlName = 'NUMOFDEC';
                                }
                                textelement(pymttermsign)
                                {
                                    XmlName = 'SIGN';
                                }
                                textelement(pymttermcurrency)
                                {
                                    XmlName = 'CURRENCY';
                                }
                                textelement(pymttermdrcr)
                                {
                                    XmlName = 'DRCR';
                                }
                            }
                            textelement(pymttermdatetime)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DATETIME';
                                textattribute(pymttermdatequalifier)
                                {
                                    XmlName = 'qualifier';
                                }
                                textelement(pymttermear)
                                {
                                    XmlName = 'YEAR';
                                }
                                textelement(pymttermmonth)
                                {
                                    XmlName = 'MONTH';
                                }
                                textelement(pymttermday)
                                {
                                    XmlName = 'DAY';
                                }
                                textelement(pymttermhour)
                                {
                                    XmlName = 'HOUR';
                                }
                                textelement(pymttermminute)
                                {
                                    XmlName = 'MINUTE';
                                }
                                textelement(pymttermsecond)
                                {
                                    XmlName = 'SECOND';
                                }
                                textelement(pymttermsubsecond)
                                {
                                    XmlName = 'SUBSECOND';
                                }
                                textelement(pymttermtimezone)
                                {
                                    XmlName = 'TIMEZONE';
                                }
                            }
                            textelement(pymttermdescriptn)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DESCRIPTN';
                            }
                            textelement(pymttermTermID)
                            {
                                MinOccurs = Zero;
                                XmlName = 'TERMID';
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.TERMID := pymttermTermID;
                                end;
                            }
                            textelement(pymttermuserarea)
                            {
                                MinOccurs = Zero;
                                XmlName = 'USERAREA';
                            }
                        }
                        textelement("MICH.ARInvoice.ARHEADER.USERAREA")
                        {
                            textelement("MICH.RELFACTCODE")
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.RELFACTCODE := "MICH.RELFACTCODE";
                                end;
                            }
                            textelement("MICH.REASON")
                            {
                                MinOccurs = Zero;
                            }
                            textelement("MICH.SHIPNUMBER")
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv.SHIPNUMBER := "MICH.SHIPNUMBER";
                                end;
                            }
                            textelement("MICH.ORIGINVNUM")
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv."MICH.ORIGINVNUM" := "MICH.ORIGINVNUM";
                                end;
                            }
                            textelement("MICH.ORIGINVDATE")
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv."MICH.ORIGINVDATE" := "MICH.ORIGINVDATE";
                                end;
                            }
                            textelement("MICH.DCNNUM")
                            {
                                MinOccurs = Zero;
                            }
                            textelement("MICH.ATTRIBUTE1")
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    HdrMICAFlowBufferSupplierInv."MICH.ATTRIBUTE1" := "MICH.ATTRIBUTE1";
                                end;
                            }
                            textelement("MICH.ATTRIBUTE4")
                            {
                                MinOccurs = Zero;
                            }
                            textelement("MICH.SHIPTOADDRESSCODE")
                            {
                                MinOccurs = Zero;
                            }
                            textelement("MICH.OR")
                            {
                                MinOccurs = Zero;
                            }
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            LineMICAFlowBufferSupplierInv.Copy(HdrMICAFlowBufferSupplierInv);
                            ChargeMICAFlowBufferSupplierInv.Copy(HdrMICAFlowBufferSupplierInv);
                        end;
                    }
                    textelement(FlowBufferSupplierInvLine1)
                    {
                        XmlName = 'INVLINE';
                        textelement(AMOUNT)
                        {
                            MinOccurs = Zero;
                            XmlName = 'AMOUNT';
                            textattribute(FlowBufferSupplierInvLineindex)
                            {
                                XmlName = 'index';
                            }
                            textattribute(FlowBufferSupplierInvLinequalifier)
                            {
                                XmlName = 'qualifier';
                            }
                            textattribute(FlowBufferSupplierInvLinetype)
                            {
                                XmlName = 'type';
                            }
                            textelement(valueLineamount)
                            {
                                XmlName = 'VALUE';
                                trigger OnAfterAssignVariable()
                                begin
                                    LineMICAFlowBufferSupplierInv."Line Amount Raw" := valueLineamount;
                                end;

                            }
                            textelement(valueLinenumofdec)
                            {
                                XmlName = 'NUMOFDEC';
                            }
                            textelement(valueLinesign)
                            {
                                XmlName = 'SIGN';
                            }
                            textelement(valueLinecurrency)
                            {
                                XmlName = 'CURRENCY';
                            }
                            textelement(valueLinedrcr)
                            {
                                XmlName = 'DRCR';
                            }
                            trigger OnAfterAssignVariable()
                            begin
                                BuildDecimal(LineMICAFlowBufferSupplierInv."Line Amount Raw", valueLinenumofdec, valueLinesign, valueLinedrcr);
                            end;
                        }
                        textelement(OPERAMT)
                        {
                            textattribute(operamtqualifier)
                            {
                                XmlName = 'qualifier';
                            }
                            textattribute(operamttype)
                            {
                                XmlName = 'type';
                            }
                            textelement(operamtvalue)
                            {
                                XmlName = 'VALUE';
                                trigger OnAfterAssignVariable()
                                begin
                                    LineMICAFlowBufferSupplierInv."Line OPERAMT Raw" := operamtvalue;
                                end;
                            }
                            textelement(operamtnumofdec)
                            {
                                XmlName = 'NUMOFDEC';
                            }
                            textelement(operamtsign)
                            {
                                XmlName = 'SIGN';
                            }
                            textelement(operamtcurrency)
                            {
                                XmlName = 'CURRENCY';
                            }
                            textelement(UOMVALUE)
                            {
                            }
                            textelement(UOMNUMDEC)
                            {
                            }
                            textelement(UOM)
                            {
                            }
                            trigger OnAfterAssignVariable()
                            begin
                                BuildDecimal(LineMICAFlowBufferSupplierInv."Line OPERAMT Raw", operamtnumofdec, operamtsign, '');
                            end;
                        }
                        textelement(QUANTITY)
                        {
                            textattribute(quantityqualifier)
                            {
                                XmlName = 'qualifier';
                            }
                            textelement(quantityvalue)
                            {
                                XmlName = 'VALUE';
                                trigger OnAfterAssignVariable()
                                begin
                                    LineMICAFlowBufferSupplierInv."Line Quantity Raw" := quantityvalue;
                                end;
                            }
                            textelement(quantitynumofdec)
                            {
                                XmlName = 'NUMOFDEC';
                            }
                            textelement(quantitysign)
                            {
                                XmlName = 'SIGN';
                            }
                            textelement(quantityuom)
                            {
                                XmlName = 'UOM';
                            }
                            trigger OnAfterAssignVariable()
                            begin
                                BuildDecimal(LineMICAFlowBufferSupplierInv."Line Quantity Raw", quantitynumofdec, quantitysign, '');
                            end;

                        }
                        textelement(FlowBufferSupplierInvLinelinenum)
                        {
                            MinOccurs = Zero;
                            XmlName = 'LINENUM';
                            trigger OnAfterAssignVariable()
                            begin
                                LineMICAFlowBufferSupplierInv."Line No." := FlowBufferSupplierInvLinelinenum;
                            end;
                        }
                        textelement(FlowBufferSupplierInvLinelinedescriptn)
                        {
                            MinOccurs = Zero;
                            XmlName = 'DESCRIPTN';
                            trigger OnAfterAssignVariable()
                            begin
                                LineMICAFlowBufferSupplierInv."Line DESCRIPTN" := FlowBufferSupplierInvLinelinedescriptn;
                            end;
                        }
                        textelement(ITEM)
                        {
                            MinOccurs = Zero;
                            trigger OnAfterAssignVariable()
                            begin
                                LineMICAFlowBufferSupplierInv."Line Item No." := ITEM;
                            end;
                        }
                        textelement(ITEMTYPE)
                        {
                            MinOccurs = Zero;
                        }
                        textelement(ITEMX)
                        {
                            MinOccurs = Zero;
                        }

                        textelement(UNIT)
                        {
                            MinOccurs = Zero;
                            trigger OnAfterAssignVariable()
                            begin
                                LineMICAFlowBufferSupplierInv."Line Unit of Measure" := UNIT;
                            end;
                        }
                        textelement(DOCUMNTREFLine)
                        {
                            MinOccurs = Zero;
                            XmlName = 'DOCUMNTREF';
                            textelement(reflinedoctype)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DOCTYPE';
                                trigger OnAfterAssignVariable()
                                begin
                                    case reflinedoctype of
                                        'LINE':
                                            LineMICAFlowBufferSupplierInv."Line DOCTYPE1" := reflinedoctype;
                                        'PurchaseOrder':
                                            LineMICAFlowBufferSupplierInv."Line DOCTYPE2" := reflinedoctype;
                                        'AL':
                                            LineMICAFlowBufferSupplierInv."Line DOCTYPE3" := reflinedoctype;
                                    end;

                                end;
                            }
                            textelement(reflinedocumentid)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DOCUMENTID';
                                trigger OnAfterAssignVariable()
                                begin
                                    case reflinedoctype of
                                        'LINE':
                                            LineMICAFlowBufferSupplierInv."Line DocumentID1" := reflinedocumentid;
                                        'AL':
                                            LineMICAFlowBufferSupplierInv."Line DocumentID2" := reflinedocumentid;
                                        'PurchaseOrder':
                                            LineMICAFlowBufferSupplierInv."Line DocumentID3" := reflinedocumentid;
                                    end;

                                end;
                            }
                            textelement(reflinepartnrid)
                            {
                                MinOccurs = Zero;
                                XmlName = 'PARTNRID';
                            }
                            textelement(reflinepartnrtype)
                            {
                                MinOccurs = Zero;
                                XmlName = 'PARTNRTYPE';
                            }
                            textelement(reflinedescriptn)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DESCRIPTN';
                            }
                            textelement(reflinedocumentrv)
                            {
                                MinOccurs = Zero;
                                XmlName = 'DOCUMENTRV';
                            }
                            textelement(reflinelinenum)
                            {
                                MinOccurs = Zero;
                                XmlName = 'LINENUM';
                                trigger OnAfterAssignVariable()
                                begin
                                    case reflinedoctype of
                                        'LINE':
                                            LineMICAFlowBufferSupplierInv."Line Linenum1" := reflinelinenum;
                                        'PurchaseOrder':
                                            LineMICAFlowBufferSupplierInv."Line Linenum2" := reflinelinenum;
                                        'AL':
                                            LineMICAFlowBufferSupplierInv."Line Linenum3" := reflinelinenum;
                                    end;

                                end;
                            }
                            textelement(reflinenotes)
                            {
                                MinOccurs = Zero;
                                XmlName = 'NOTES';
                                textattribute(reflineindex)
                                {
                                    XmlName = 'index';
                                }
                            }
                            textelement(reflineschlinenum)
                            {
                                MinOccurs = Zero;
                                XmlName = 'SCHLINENUM';
                                trigger OnAfterAssignVariable()
                                begin
                                    case reflinedoctype of
                                        'AL':
                                            LineMICAFlowBufferSupplierInv."Line SCHLINENUM" := reflineschlinenum;
                                    end;
                                end;
                            }
                            textelement(reflineuserarea)
                            {
                                MinOccurs = Zero;
                                XmlName = 'USERAREA';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                clear(reflinedoctype);
                                clear(reflinedocumentid);
                                clear(reflinelinenum);
                                clear(reflineschlinenum);
                            end;

                        }
                        textelement("MICH.ARInvoice.ARLINE.USERAREA")
                        {
                            MinOccurs = Zero;
                            textelement("MICH.ETA")
                            {
                                MinOccurs = Zero;
                            }
                            textelement("MICH.LINEATTRIBUTE3")
                            {
                                MinOccurs = Zero;
                                trigger OnAfterAssignVariable()
                                begin
                                    LineMICAFlowBufferSupplierInv."Line MICH.LINEATTRIBUTE3" := "MICH.LINEATTRIBUTE3";
                                end;

                            }
                            textelement("MICH.LINEATTRIBUTE4")
                            {
                                MinOccurs = Zero;
                            }
                            textelement("MICH.INTRASTAT")
                            {
                                MinOccurs = Zero;
                                textelement("MICH.DESTCOUNTRYCODE")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.DESTCOUNTRYCODE" := "MICH.DESTCOUNTRYCODE";
                                    end;

                                }
                                textelement("MICH.COUNTRYORIG")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.COUNTRYORIG" := "MICH.COUNTRYORIG";
                                    end;
                                }
                                textelement("MICH.DELIVERTERMS")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.DELIVERTERMS" := "MICH.DELIVERTERMS";
                                    end;
                                }
                                textelement("MICH.TRXCODENATURE")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.TRXCODENATURE" := "MICH.TRXCODENATURE";

                                    end;
                                }
                                textelement("MICH.COMMODITYCODE")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.COMMODITYCODE" := "MICH.COMMODITYCODE";
                                    end;
                                }
                                textelement("MICH.NETMASS")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.NETMASS Raw" := "MICH.NETMASS";
                                    end;
                                }
                                textelement("MICH.SUPPLEMENTUNITS")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.SUPPLEMENTUNITS" := "MICH.SUPPLEMENTUNITS";
                                    end;
                                }
                                textelement("MICH.TRANSPORTMODE")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.TRANSPORTMODE" := "MICH.TRANSPORTMODE";
                                    end;
                                }
                                textelement("MICH.LOADINGPORT")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.LOADINGPORT" := "MICH.LOADINGPORT";
                                    end;
                                }
                                textelement("MICH.STATISTICPROCED")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.STATISTICPROCED" := "MICH.STATISTICPROCED";
                                    end;
                                }
                                textelement("MICH.STATISTICVALUE")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.STATISTICVALUE" := "MICH.STATISTICVALUE";
                                    end;
                                }
                                textelement("MICH.DESTREGION")
                                {
                                    MinOccurs = Zero;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        LineMICAFlowBufferSupplierInv."Line MICH.DESTREGION" := "MICH.DESTREGION";
                                    end;
                                }
                                textelement("MICH.VALUE")
                                {
                                    MinOccurs = Zero;
                                }
                            }
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            ImportedRecordCount += 1;
                            LineMICAFlowBufferSupplierInv."Flow Code" := MyMICAFlowEntry."Flow Code";
                            LineMICAFlowBufferSupplierInv."Flow Entry No." := MyMICAFlowEntry."Entry No.";
                            LineMICAFlowBufferSupplierInv."Entry No." := ImportedRecordCount;
                            LineMICAFlowBufferSupplierInv.Validate("Flow Entry No.", MyMICAFlowEntry."Entry No.");
                            LineMICAFlowBufferSupplierInv.Insert(true);
                        end;
                    }
                    textelement(INVCHARGE1)
                    {
                        XmlName = 'INVCHARGE';
                        MinOccurs = Zero;
                        textelement(invchargeamount)
                        {
                            MinOccurs = Zero;
                            XmlName = 'AMOUNT';
                            textattribute(invchargeindex)
                            {
                                XmlName = 'index';
                            }
                            textattribute(invchargequalifier)
                            {
                                XmlName = 'qualifier';
                            }
                            textattribute(invchargetype)
                            {
                                XmlName = 'type';
                            }
                            textelement(invchargeamountvalue)
                            {
                                XmlName = 'VALUE';
                                trigger OnAfterAssignVariable()
                                begin
                                    ChargeMICAFlowBufferSupplierInv."Line Charge Amount Raw" := invchargeamountvalue;
                                end;
                            }
                            textelement(invchargenumofdec)
                            {
                                XmlName = 'NUMOFDEC';
                            }
                            textelement(invchargesign)
                            {
                                XmlName = 'SIGN';
                            }
                            textelement(invchargecurrency)
                            {
                                XmlName = 'CURRENCY';
                            }
                            textelement(invchargedrcr)
                            {
                                XmlName = 'DRCR';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                BuildDecimal(ChargeMICAFlowBufferSupplierInv."Line Charge Amount Raw", invchargenumofdec, invchargesign, invchargedrcr);
                            end;
                        }
                        textelement(CHARGETYPE)
                        {
                            MinOccurs = Zero;
                            trigger OnAfterAssignVariable()
                            begin
                                ChargeMICAFlowBufferSupplierInv."Line CHARGETYPE" := CHARGETYPE;
                            end;
                        }
                        textelement(invchargelinenum)
                        {
                            MinOccurs = Zero;
                            XmlName = 'LINENUM';
                            trigger OnAfterAssignVariable()
                            begin
                                ChargeMICAFlowBufferSupplierInv."Freight Line No." := invchargelinenum;
                            end;
                        }
                        textelement(invchargeuserarea)
                        {
                            MinOccurs = Zero;
                            XmlName = 'USERAREA';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            ImportedRecordCount += 1;
                            ChargeMICAFlowBufferSupplierInv."Flow Code" := MyMICAFlowEntry."Flow Code";
                            ChargeMICAFlowBufferSupplierInv."Flow Entry No." := MyMICAFlowEntry."Entry No.";
                            ChargeMICAFlowBufferSupplierInv."Entry No." := ImportedRecordCount;
                            ChargeMICAFlowBufferSupplierInv.Validate("Flow Entry No.", MyMICAFlowEntry."Entry No.");
                            ChargeMICAFlowBufferSupplierInv.Insert(true);
                        end;
                    }
                }
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        ChargeMICAFlowBufferSupplierInv.Init();
        LineMICAFlowBufferSupplierInv.Init();
    end;

    trigger OnPostXmlPort()
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
        CreationDT: DateTime;
        DocDateTime: Text;
        DocDateTimeLbl: Label '%1-%2-%3T%4:%5:%6%7%8', Comment = '%1%2%3%4%5%6%7%8', Locked = true;
        TechData1Lbl: Label 'LANGUAGE %1, CODEPAGE %2, AUTHID %3', Comment = '%1%2%3', Locked = true;
        TechData2Lbl: Label '%1 %2, %3', Comment = '%1%2%3', Locked = true;
    begin
        CreationDT := 0DT;
        DocDateTime := StrSubstNo(DocDateTimeLbl, YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, CopyStr(TIMEZONE, 1, 3), CopyStr(TIMEZONE, 4, 2));
        DTVariant := CreationDT;
        TypeHelper.Evaluate(DTVariant, DocDateTime, '', '');
        Evaluate(CreationDT, format(DTVariant));
        MyMICAFlowEntry.UpdateTechnicalData(LOGICALID, Component, Task, REFERENCEID, CreationDT,
            Strsubstno(TechData1Lbl, LANGUAGE, CODEPAGE, AUTHID), '', '',
            Strsubstno(TechData2Lbl, VALUE, nounvalue, revisionvalue), '', '');
    end;

    procedure SetFlowEntry(var MICAFlowEntry: Record "MICA Flow Entry")
    var
    begin
        MyMICAFlowEntry := MICAFlowEntry;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

    local procedure BuildDecimal(var RAWAmount: Text[30]; NumOfDec: Text[1]; Sign: Text[1]; DebitCredit: Text[1])
    var
        Decimals: Integer;
    begin
        RAWAmount := DelChr(RAWAmount, '<>');
        if NumOfDec <> '' then begin
            Evaluate(Decimals, NumOfDec);
            RAWAmount := CopyStr(RAWAmount, 1, StrLen(RAWAmount) - Decimals) + '.' +
                                            CopyStr(RAWAmount, StrLen(RAWAmount) - Decimals + 1);
        end;
        if Sign = '-' then
            RAWAmount := Sign + CopyStr(RAWAmount, 1, 29);
        if DebitCredit = '' then
            DebitCredit := ' ';
        RAWAmount := DebitCredit + CopyStr(RAWAmount, 1, 29);
        //[D|C| ][Sign]decimals.decimals
    end;

    var
        HdrMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        LineMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        ChargeMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        MyMICAFlowEntry: Record "MICA Flow Entry";
        ImportedRecordCount: Integer;
}