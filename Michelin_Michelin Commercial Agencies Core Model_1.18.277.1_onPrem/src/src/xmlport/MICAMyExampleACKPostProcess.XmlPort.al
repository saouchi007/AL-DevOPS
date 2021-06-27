xmlport 80878 "MICA MyExample ACK PostProcess"
{
    DefaultNamespace = 'http://www.w3.org/2001/XMLSchema';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(SampleData; "MICA Flow Buffer Sample Data")
            {
                fieldelement(No; SampleData."No.")
                {
                    textelement("Errors")
                    {
                        tableelement(Error; "MICA Flow Information")
                        {
                            LinkTable = SampleData;
                            LinkFields = "Flow Buffer Entry No." = field("Entry No."),
                                "Flow Entry No." = field("Flow Entry No."),
                                "Info Type" = filter('Error|Warning');
                            fieldelement(Description; Error.Description)
                            {

                            }
                        }
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    ExportedRecordCount += 1;

                end;
            }
        }
    }
    procedure SetFlowEntry(FlowEntryNo: Integer)
    var
    begin
        ACKMICAFlowEntry.Get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    var
        ACKMICAFlowEntry: Record "MICA Flow Entry";
        ExportedRecordCount: Integer;

}
