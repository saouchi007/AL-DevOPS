xmlport 80874 "MICA Sample Data Import"
{
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    schema
    {
        textelement(SampleDatas)
        {
            tableelement(SampleData; "MICA Flow Buffer Sample Data")
            {
                fieldelement(BufferNo; SampleData."No.") { }
                fieldelement(Description; SampleData.Description) { }
                fieldelement(InventoryPostingGroup; SampleData."Inventory Posting Group") { }
                fieldelement(CostingMethod; SampleData."Costing Method Raw") { }
                fieldelement(UnitCost; SampleData."Unit Cost Raw") { }
                fieldelement(CostIsAdjusted; SampleData."Cost Is Adjusted Raw") { }
                fieldelement(LeadTimeCalculation; SampleData."Lead Time Calculation Raw") { }
                fieldelement(LastDateTimeModified; SampleData."Last Date Time Modified Raw") { }
                fieldelement(LastDateModified; SampleData."Last Date Modified Raw") { }
                fieldelement(LastTimeModified; SampleData."Last Time Modified Raw") { }

                trigger OnBeforeInsertRecord()
                begin
                    ImportedRecordCount += 1;
                    Sampledata."Flow Code" := MyMICAFlowEntry."Flow Code";
                    Sampledata."Flow Entry No." := MyMICAFlowEntry."Entry No.";
                    Sampledata."Entry No." := ImportedRecordCount;

                    // del
                    /*
                    Sampledata."No." := copystr(BufferNo, 1, maxstrlen(Sampledata."No."));
                    Sampledata.Description := Description;
                    Sampledata."Inventory Posting Group" := InventoryPostingGroup;
                    Sampledata."Costing Method Raw" := CostingMethod;
                    Sampledata."Unit Cost Raw" := UnitCost;
                    Sampledata."Cost Is Adjusted Raw" := CostIsAdjusted;
                    Sampledata."Lead Time Calculation Raw" := LeadTimeCalculation;
                    Sampledata."Last Date Time Modified Raw" := LastDateTimeModified;
                    Sampledata."Last Date Modified Raw" := LastDateModified;
                    Sampledata."Last Time Modified Raw" := LastTimeModified;
                    */
                end;
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
}