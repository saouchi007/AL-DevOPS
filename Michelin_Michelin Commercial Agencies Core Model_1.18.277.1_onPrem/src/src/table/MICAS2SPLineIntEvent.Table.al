table 82868 "MICA S2S P.Line Int. Event"
{
    Caption = 'S2S P.Line Int. Event';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Event Date Time"; DateTime)
        {
            Caption = 'Event Date Time';
            DataClassification = CustomerContent;
        }
        field(3; "Source Event Type"; Option)
        {
            Caption = 'Source Event Type ';
            DataClassification = CustomerContent;
            OptionMembers = Created,Updated,Deleted;
            OptionCaption = 'Created,Updated,Deleted';
        }
        field(4; "Source Record ID"; Guid)
        {
            Caption = 'Source Record ID';
            DataClassification = CustomerContent;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(8; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure RefreshFromIntervalEvent()
    var
        MICAS2SEventSetup: Record "MICA S2S Event Setup";
        MICAS2SPLineExtEvent: Record "MICA S2S P.Line Ext. Event";
        MICAS2SPLineIntEvent: Record "MICA S2S P.Line Int. Event";
        LastEntryNo: Integer;
        NumberOfEntryRefresh: Integer;
    begin
        LastEntryNo := -1;
        if not MICAS2SEventSetup.FindFirst() then
            MICAS2SEventSetup.Init();
        if MICAS2SPLineExtEvent.FindLast() then
            LastEntryNo := MICAS2SPLineExtEvent."Entry No.";
        Clear(MICAS2SPLineExtEvent);

        MICAS2SPLineIntEvent.SetFilter("Entry No.", '>%1', LastEntryNo);
        if MICAS2SPLineIntEvent.FindSet() then
            repeat
                MICAS2SPLineExtEvent.TransferFields(MICAS2SPLineIntEvent);
                MICAS2SPLineExtEvent.Insert(true);

                NumberOfEntryRefresh += 1;
            until (MICAS2SPLineIntEvent.Next() = 0) or (NumberOfEntryRefresh >= MICAS2SEventSetup."Event Count On Refresh");


    end;

}
