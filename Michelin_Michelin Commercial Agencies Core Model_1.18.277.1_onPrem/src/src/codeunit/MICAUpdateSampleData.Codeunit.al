codeunit 80875 "MICA Update Sample Data"
{
    TableNo = "MICA Flow Buffer Sample Data";

    trigger OnRun()
    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        if MyExpTableMICASampleData.get(Rec."No.") then begin
            ValidateFields(Rec);
            MyExpTableMICASampleData.modify(true);
        end else begin
            //Create some data
            clear(MyExpTableMICASampleData);
            MyExpTableMICASampleData.Validate("No.", Rec."No.");
            MyExpTableMICASampleData.Insert(true);
            ValidateFields(Rec);
            MyExpTableMICASampleData.modify(true);
        end;

        //Update status on Business Data
        MICAFlowRecord.UpdateReceiveRecord(Rec."Flow Entry No.", MyExpTableMICASampleData.RecordId(), MICAFlowEntry."Receive Status"::Processed);
    end;

    local procedure ValidateFields(MICAFlowBufferSampleData: Record "MICA Flow Buffer Sample Data")
    begin
        MyExpTableMICASampleData.Validate(Description, MICAFlowBufferSampleData.Description);
        MyExpTableMICASampleData.Validate("Inventory Posting Group", MICAFlowBufferSampleData."Inventory Posting Group");
        MyExpTableMICASampleData.Validate("Costing Method", MICAFlowBufferSampleData."Costing Method");
        MyExpTableMICASampleData.Validate("Unit Cost", MICAFlowBufferSampleData."Unit Cost");
        MyExpTableMICASampleData.Validate("Cost Is Adjusted", MICAFlowBufferSampleData."Cost Is Adjusted");
        MyExpTableMICASampleData.Validate("Lead Time Calculation", MICAFlowBufferSampleData."Lead Time Calculation");
        MyExpTableMICASampleData.Validate("Last Date Time Modified", MICAFlowBufferSampleData."Last Date Time Modified");
        MyExpTableMICASampleData.Validate("Last Date Modified", MICAFlowBufferSampleData."Last Date Modified");
        MyExpTableMICASampleData.Validate("Last Time Modified", MICAFlowBufferSampleData."Last Time Modified");
        MyExpTableMICASampleData."MICA Record ID" := MyExpTableMICASampleData.RecordId(); // Mandatory to be used with flow integrations (Fields in Id range 80860-80879)
    end;

    var
        MyExpTableMICASampleData: Record "MICA Sample Data";
}