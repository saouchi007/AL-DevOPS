xmlport 80873 "MICA MyExampleTable XmlPort"
{
    DefaultNamespace = 'http://www.w3.org/2001/XMLSchema';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(SampleData; "MICA Sample Data")
            {
                fieldelement(No; SampleData."No.")
                {
                }
                fieldelement(Description; SampleData.Description)
                {
                }
                fieldelement(InventoryPostingGroup; SampleData."Inventory Posting Group")
                {
                }
                fieldelement(CostingMethod; SampleData."Costing Method")
                {
                }
                fieldelement(UnitCost; SampleData."Unit Cost")
                {
                }
                fieldelement(CostIsAdjusted; SampleData."Cost Is Adjusted")
                {
                }
                fieldelement(LeadTimeCalculation; SampleData."Lead Time Calculation")
                {
                }
                fieldelement(LastDateTimeModified; SampleData."Last Date Time Modified")
                {
                }
                fieldelement(LastDateModified; SampleData."Last Date Modified")
                {
                }
                fieldelement(LastTimeModified; SampleData."Last Time Modified")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    if SampleData.Description = '' then begin// simulate error on business data (not exported)
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, SampleData.RecordId(), StrSubstNo(MissingValueLbl, SampleData.FieldCaption(Description)), Format(SampleData.RecordId()));
                        currXMLport.Skip();
                    end else begin
                        MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", SampleData.RecordId(), MICAFlowEntry."Send Status"::Prepared); // Update last send status on business data
                        ExportedRecordCount += 1;
                    end;

                end;
            }
        }
    }
    procedure SetFlowEntry(FlowEntryNo: Integer)
    var
    begin
        MICAFlowEntry.get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowInformation: Record "MICA Flow Information";
        MissingValueLbl: Label 'Empty Field : %1';
        ExportedRecordCount: Integer;

}
