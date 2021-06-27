table 82867 "MICA S2S P.Header Ext. Event"
{
    Caption = 'S2S P.Header Ext. Event';
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
            Caption = 'Source Event Type';
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
        field(6; Resource; Text[250])
        {
            Caption = 'Resource';
            DataClassification = CustomerContent;
        }
        field(7; "Last Modified Date Time"; DateTime)
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
        key(Key1; "Last Modified Date Time")
        {

        }
    }

    trigger OnInsert()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

    procedure RefreshFromIntervalEvent()
    var
        MICAS2SEventSetup: Record "MICA S2S Event Setup";
        MICAS2SPHeaderExtEvent: Record "MICA S2S P.Header Ext. Event";
        MICAS2SPHeaderIntEvent: Record "MICA S2S P.Header Int. Event";
        Company: Record Company;
        LastEntryNo: Integer;
        NumberOfEntryRefresh: Integer;
        URLTxt: Label '/api/v1.0/companies(%1)/statusPurchaseOrders(%2)';
    begin
        Company.Get(CompanyName);
        if not MICAS2SEventSetup.Get() then
            MICAS2SEventSetup.Init();
        if MICAS2SPHeaderExtEvent.FindLast() then
            LastEntryNo := MICAS2SPHeaderExtEvent."Entry No.";
        Clear(MICAS2SPHeaderExtEvent);

        MICAS2SPHeaderIntEvent.SetFilter("Entry No.", '>%1', LastEntryNo);
        if MICAS2SPHeaderIntEvent.FindSet(true) then
            repeat
                MICAS2SPHeaderExtEvent.TransferFields(MICAS2SPHeaderIntEvent);
                MICAS2SPHeaderExtEvent.Validate(Resource, StrSubstNo(URLTxt, CopyStr(Company.Id, 2, 36), CopyStr(MICAS2SPHeaderExtEvent."Source Record ID", 2, 36)));
                MICAS2SPHeaderExtEvent.Insert(true);

                MICAS2SPHeaderIntEvent.Validate("Last Modified Date Time", MICAS2SPHeaderExtEvent."Last Modified Date Time");
                MICAS2SPHeaderIntEvent.Modify(true);

                NumberOfEntryRefresh += 1;
            until (MICAS2SPHeaderIntEvent.Next() = 0) or (NumberOfEntryRefresh >= MICAS2SEventSetup."Event Count On Refresh");
    end;

}
