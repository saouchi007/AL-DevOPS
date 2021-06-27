xmlport 80876 "MICA MyExample ACK PostCreated"
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
                textelement(Error)
                {
                    textattribute(ID)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ID := '100';
                        end;
                    }
                    trigger OnBeforePassVariable()
                    begin
                        Error := 'Invalid file';
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