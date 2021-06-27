table 82869 "MICA S2S P.Line Ext. Event"
{
    Caption = 'S2S P.Line Ext. Event';
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
        field(6; "Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(7; Resource; Text[250])
        {
            Caption = 'Resource';
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
        MICAS2SPLineExtEvent: Record "MICA S2S P.Line Ext. Event";
        MICAS2SPLineIntEvent: Record "MICA S2S P.Line Int. Event";
        Company: Record Company;
        LastEntryNo: Integer;
        NumberOfEntryRefresh: Integer;
        URLTxt: Label '/api/v1.0/companies(%1)/statusPurchaseOrderLines(%2)';
    begin
        Company.Get(CompanyName);
        if not MICAS2SEventSetup.FindFirst() then
            MICAS2SEventSetup.Init();
        if MICAS2SPLineExtEvent.FindLast() then
            LastEntryNo := MICAS2SPLineExtEvent."Entry No.";
        Clear(MICAS2SPLineExtEvent);

        MICAS2SPLineIntEvent.SetFilter("Entry No.", '>%1', LastEntryNo);
        if MICAS2SPLineIntEvent.FindSet(true) then
            repeat
                MICAS2SPLineExtEvent.TransferFields(MICAS2SPLineIntEvent);
                MICAS2SPLineExtEvent.Validate(Resource, StrSubstNo(URLTxt, CopyStr(Company.Id, 2, 36), CopyStr(MICAS2SPLineExtEvent."Source Record ID", 2, 36)));
                MICAS2SPLineExtEvent.Insert(true);

                MICAS2SPLineIntEvent.Validate("Last Modified Date Time", MICAS2SPLineExtEvent."Last Modified Date Time");
                MICAS2SPLineIntEvent.Modify(true);

                NumberOfEntryRefresh += 1;
            until (MICAS2SPLineIntEvent.Next() = 0) or (NumberOfEntryRefresh >= MICAS2SEventSetup."Event Count On Refresh");


    end;

}
