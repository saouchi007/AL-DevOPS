xmlport 80877 "MICA MyExample ACK PostLoaded"
{
    DefaultNamespace = 'http://www.w3.org/2001/XMLSchema';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    schema
    {
        textelement(RootNodeName)
        {
            textelement(FileName)
            {
                textelement(Message)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Message := 'File Receive';
                    end;
                }
                trigger OnBeforePassVariable()
                begin
                    FileName := ACKMICAFlowEntry.Description;
                end;
            }
        }
    }
    procedure SetFlowEntry(FlowEntryNo: Integer)
    var
    begin
        ACKMICAFlowEntry.Get(FlowEntryNo);
    end;

    var
        ACKMICAFlowEntry: Record "MICA Flow Entry";
}