tableextension 80101 "MICA User Task" extends "User Task"
{

    fields
    {
        field(80000; "MICA Process ID"; Option)
        {
            Caption = 'Process ID';
            DataClassification = CustomerContent;
            OptionMembers = "","Customer Request";
        }
        field(80001; "MICA URL"; Blob)
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
            Subtype = Memo;
        }
        field(80002; "MICA Record ID"; RecordID)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "MICA Record ID Label" := Format("MICA Record ID");
            end;
        }
        field(80003; "MICA Record ID Label"; Text[250])
        {
            Caption = 'Record ID Label';
            DataClassification = CustomerContent;
            Editable = false;
        }


    }

    procedure SetMICAURL(NewMICAURL: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        CLEAR("MICA URL");
        IF NewMICAURL = '' THEN
            EXIT;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA URL"));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::Windows);
        OutStream.Write(NewMICAURL);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "MICA URL".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;

    procedure GetMICAURL(): Text
    begin
        CALCFIELDS("MICA URL");
        EXIT(GetMICAURLCalculated());
    end;

    procedure GetMICAURLCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: Instream;
        Result: Text;
    begin
        IF NOT "MICA URL".HASVALUE() THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA URL"));
        TempBLob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(Result);
        Exit(Result);
    end;

}