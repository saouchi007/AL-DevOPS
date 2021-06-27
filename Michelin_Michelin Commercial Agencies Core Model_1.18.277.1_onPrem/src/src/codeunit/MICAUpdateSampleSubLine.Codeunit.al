codeunit 80877 "MICA Update Sample Sub Line"
{
    TableNo = "MICA Flow Buffer Sample Data";

    trigger OnRun()
    begin
        if MyMICASampleSubLine.get(Rec."No.", Rec."Item Id") then begin
            ValidateFields(Rec);
            MyMICASampleSubLine.modify(true);
        end else begin
            clear(MyMICASampleSubLine);
            MyMICASampleSubLine.Validate("Line No.", Rec."No.");
            MyMICASampleSubLine.Validate("Item Id", Rec."Item Id");
            MyMICASampleSubLine.Insert(true);
            ValidateFields(Rec);
            MyMICASampleSubLine.modify(true);
        end;
    end;

    local procedure ValidateFields(MICAFlowBufferSampleData: Record "MICA Flow Buffer Sample Data")
    begin
        MyMICASampleSubLine.Validate("Logical Id", MICAFlowBufferSampleData."Logical Id");
        MyMICASampleSubLine.Validate("Location Id", MICAFlowBufferSampleData."Location Id");
        MyMICASampleSubLine.Validate("Attribute Id", MICAFlowBufferSampleData."Attribute Id");
    end;

    var
        MyMICASampleSubLine: Record "MICA Sample Sub Line";
}