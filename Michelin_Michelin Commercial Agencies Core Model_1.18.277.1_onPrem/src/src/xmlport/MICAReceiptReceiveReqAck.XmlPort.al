xmlport 81240 "MICA Receipt Receive Req.Ack."
{   //INT-3PL-008
    Caption = 'Receive acknowledgement';
    DefaultFieldsValidation = false;
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(Acknowledgement)
        {
            textelement(CONTROLAREA)
            {
                textelement(LOGICALID)
                {
                }
                textelement(COMPONENT)
                {
                }
                textelement(TASK)
                {
                }
                textelement(REFERENCEID)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        MICAFlowBuffReceiveReqAck2."RAW REFERENCEID" := CopyStr(REFERENCEID, 1, 41);
                    end;

                }
                textelement(LANGUAGE)
                {
                }
                textelement(CODEPAGE)
                {
                }
                textelement(CREATION_DATE_TIME)
                {
                }
            }
            textelement(USERAREA)
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
            textelement(DATAAREA)
            {
                textelement(CONFIRM_BOD)
                {
                    textelement(CONFIRM)
                    {
                        textelement(STATUSLVL)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBuffReceiveReqAck2.STATUSLVL := CopyStr(STATUSLVL, 1, 10);
                            end;
                        }
                        textelement(DESCRIPTN)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBuffReceiveReqAck2.DESCRIPTN := CopyStr(DESCRIPTN, 1, 100);
                            end;
                        }
                        textelement(ORIGREF)
                        {
                            trigger OnAfterAssignVariable()
                            begin
                                MICAFlowBuffReceiveReqAck2.ORIGREF := CopyStr(ORIGREF, 1, 100);
                            end;
                        }
                    }
                }
            }
        }
    }

    var
        MICAFlowBuffReceiveReqAck2: Record "MICA FlowBuff Receive Req.Ack2";
        MICAFlowEntry: Record "MICA Flow Entry";

    trigger OnPreXmlPort()
    begin
        MICAFlowBuffReceiveReqAck2.Init();
    end;

    trigger OnPostXmlPort()
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
        CreationDT: DateTime;
    begin
        CreationDT := 0DT;
        DTVariant := CreationDT;
        TypeHelper.Evaluate(DTVariant, CREATION_DATE_TIME, '', '');
        MICAFlowEntry.UpdateTechnicalData(LOGICALID, COMPONENT, TASK, REFERENCEID, CreationDT, MichSender, MichReceiver, '', MichReferencekey, MichMessageType, '');
    end;

    procedure SetFlowEntry(var inMICAFlowEntry: Record "MICA Flow Entry")
    begin
        MICAFlowEntry := inMICAFlowEntry;
    end;

    procedure GetBuffer(var OutMICAFlowBuffReceiveReqAck2: Record "MICA FlowBuff Receive Req.Ack2")
    begin
        OutMICAFlowBuffReceiveReqAck2 := MICAFlowBuffReceiveReqAck2;
    end;
}