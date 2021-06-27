xmlport 80875 "MICA Sample Data Sub Import"
{
    Direction = Import;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(SampleDatas)
        {
            textelement(SampleData)
            {
                textelement(BufferNo) { }
                textelement(Description) { }
                textelement(InventoryPostingGroup) { }
                textelement(CostingMethod) { }
                textelement(UnitCost) { }
                textelement(CostIsAdjusted) { }
                textelement(LeadTimeCalculation) { }
                textelement(LastDateTimeModified) { }
                textelement(LastDateModified) { }
                textelement(LastTimeModified) { }

                // Complex XML Fields
                textelement(SubLines) // TODO : try tabledata here
                {
                    tableelement(SubLine; "MICA Flow Buffer Sample Data")
                    {
                        fieldelement(LogicalID; SubLine."Logical Id") { }
                        textelement(Location)
                        {
                            textattribute(type) { }
                            fieldelement(ID; SubLine."Location Id") { }
                        }
                        textelement(Item)
                        {
                            textelement(ItemID)
                            {
                                fieldelement(ID; SubLine."Item Id")
                                {
                                    textattribute(schemeName) { }
                                }
                            }
                        }
                        textelement(AttributeField)
                        {
                            textattribute(name) { }
                            fieldattribute(value; SubLine."Attribute Id") { }
                        }
                        trigger OnBeforeInsertRecord()
                        begin
                            ImportedRecordCount += 1;
                            SubLine."Flow Code" := MyMICAFlowEntry."Flow Code";
                            SubLine."Flow Entry No." := MyMICAFlowEntry."Entry No.";
                            SubLine."Entry No." := ImportedRecordCount;

                            SubLine."No." := copystr(BufferNo, 1, maxstrlen(SubLine."No."));
                            SubLine.Description := Description;
                            SubLine."Inventory Posting Group" := InventoryPostingGroup;
                            SubLine."Costing Method Raw" := CostingMethod;
                            SubLine."Unit Cost Raw" := UnitCost;
                            SubLine."Cost Is Adjusted Raw" := CostIsAdjusted;
                            SubLine."Lead Time Calculation Raw" := LeadTimeCalculation;
                            SubLine."Last Date Time Modified Raw" := LastDateTimeModified;
                            SubLine."Last Date Modified Raw" := LastDateModified;
                            SubLine."Last Time Modified Raw" := LastTimeModified;
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


}
