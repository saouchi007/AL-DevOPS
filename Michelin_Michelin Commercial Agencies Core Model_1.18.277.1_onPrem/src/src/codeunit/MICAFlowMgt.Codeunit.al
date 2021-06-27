codeunit 82600 "MICA Flow Mgt"
{

    procedure GetFlowEntry(FlowEntryNo: Integer; var MICAFlowEntry: Record "MICA Flow Entry"): Boolean
    begin
        IF Not MICAFlowEntry.get(FlowEntryNo) then begin
            Clear(MICAFlowEntry);
            Exit;
        end;

        Exit(true);
    end;

    procedure CountFlowInformation(InfoType: Option Information,Warning,Error; FlowEntryNo: Integer; LinkedRecordID: RecordID; var MICAFlowInformation: Record "MICA Flow Information"): Integer
    begin

        MICAFlowInformation.reset();
        MICAFlowInformation.setrange("Info Type", InfoType);
        MICAFlowInformation.setrange("Flow Entry No.", FlowEntryNo);
        MICAFlowInformation.setrange("Linked Record ID", LinkedRecordID);

        exit(MICAFlowInformation.count());
    end;

    procedure CountFlowInformation(InfoType: Option Information,Warning,Error; FlowEntryNo: Integer; LinkedRecordID: RecordID): Integer
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin

        MICAFlowInformation.reset();
        MICAFlowInformation.setrange("Info Type", InfoType);
        MICAFlowInformation.setrange("Flow Entry No.", FlowEntryNo);
        MICAFlowInformation.setrange("Linked Record ID", LinkedRecordID);

        exit(MICAFlowInformation.count());
    end;

}