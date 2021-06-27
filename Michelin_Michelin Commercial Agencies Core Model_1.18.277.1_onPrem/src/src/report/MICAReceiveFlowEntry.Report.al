report 80861 "MICA Receive Flow Entry"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Receive Flow Entry';

    dataset
    {
        dataitem("MICA Flow"; "MICA Flow")
        {
            DataItemTableView = sorting (Code) order(ascending) where (Status = const (Released), Direction = const (Receive));
            RequestFilterFields = Code, "Partner Code";

            trigger OnAfterGetRecord()
            var
                FlowEntry: Record "MICA Flow Entry";
                FlowEntry2: Record "MICA Flow Entry";
            begin

                SelectLatestVersion();
                ReceiveData();
                Commit();

                SelectLatestVersion();
                ExtractAll();
                Commit();

                SelectLatestVersion();
                FlowEntry.Reset();
                FlowEntry.SetCurrentKey("Flow Code", "Receive Status", "Skip this Entry");
                FlowEntry.SetFilter("Receive Status", '%1|%2', FlowEntry."Receive Status"::Processed, FlowEntry."Receive Status"::Loaded);
                FlowEntry.SetRange("Flow Code", Code);
                FlowEntry.SetRange("Skip this Entry", false);
                if FlowEntry.FindSet(true, true) then
                    repeat
                        WITH FlowEntry2 do begin
                            FlowEntry2.GET(FlowEntry."Entry No.");
                            if ("Receive Status" = "Receive Status"::Loaded) then begin
                                process(false);
                                Commit();
                            end;

                            FlowEntry2.GET(FlowEntry."Entry No.");
                            if ("Receive Status" = "Receive Status"::Processed) then begin
                                PostProcess();
                                commit();
                            end;
                        end;
                    until FlowEntry.Next() = 0;


            end;

        }
    }
}
