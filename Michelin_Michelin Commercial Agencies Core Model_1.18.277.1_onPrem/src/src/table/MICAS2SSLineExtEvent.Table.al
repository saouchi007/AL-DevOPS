table 82865 "MICA S2S S.Line Ext. Event"
{
    Caption = 'S2S S.Line Ext. Event';
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
        MICAS2SSLineExtEvent: Record "MICA S2S S.Line Ext. Event";
        MICAS2SSLineIntEvent: Record "MICA S2S S.Line Int. Event";
        Company: Record Company;
        LastEntryNo: Integer;
        NumberOfEntryRefresh: Integer;
        URLTxt: Label '/api/v1.0/companies(%1)/statusSalesOrderLines(%2)';
    begin
        Company.Get(CompanyName);
        if not MICAS2SEventSetup.FindFirst() then
            MICAS2SEventSetup.Init();
        if MICAS2SSLineExtEvent.FindLast() then
            LastEntryNo := MICAS2SSLineExtEvent."Entry No.";
        Clear(MICAS2SSLineExtEvent);

        MICAS2SSLineIntEvent.SetFilter("Entry No.", '>%1', LastEntryNo);
        if MICAS2SSLineIntEvent.FindSet(true) then
            repeat
                MICAS2SSLineExtEvent.TransferFields(MICAS2SSLineIntEvent);
                MICAS2SSLineExtEvent.Validate(Resource, StrSubstNo(URLTxt, CopyStr(Company.Id, 2, 36), CopyStr(MICAS2SSLineExtEvent."Source Record ID", 2, 36)));
                MICAS2SSLineExtEvent.Insert(true);

                MICAS2SSLineIntEvent.Validate("Last Modified Date Time", MICAS2SSLineExtEvent."Last Modified Date Time");
                MICAS2SSLineIntEvent.Modify(true);

                NumberOfEntryRefresh += 1;
            until (MICAS2SSLineIntEvent.Next() = 0) or (NumberOfEntryRefresh >= MICAS2SEventSetup."Event Count On Refresh");


    end;

}
