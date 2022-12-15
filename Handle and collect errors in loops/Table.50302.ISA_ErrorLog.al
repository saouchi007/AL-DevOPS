/// <summary>
/// Table ISA_ErrorLog (ID 50302).
/// </summary>
table 50304 ISA_ErrorLog
{
    DataClassification = CustomerContent;
    Caption = 'ISA Error Log';

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Error Message"; Blob)
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(3; "Error Callstack"; Blob)
        {
            Caption = 'Error Callstack';
            DataClassification = CustomerContent;
        }
        field(4; "Error Text"; Text[2048])
        {
            Caption = 'Error Text';
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

    /// <summary>
    /// ISA_ShowErroMessage.
    /// </summary>
    procedure ISA_ShowErroMessage()
    var
        ISA_InStream: InStream;
        ISA_PlaceHolder: Text;
    begin
        if not Rec."Error Message".HasValue then
            exit;

        Rec.CalcFields("Error Message");
        Rec."Error Message".CreateInStream(ISA_InStream);
        ISA_InStream.ReadText(ISA_PlaceHolder);
        Message(ISA_PlaceHolder);
    end;

    /// <summary>
    /// ISA_ShowErroCallStack.
    /// </summary>
    procedure ISA_ShowErroCallStack()
    var
        ISA_InStream: InStream;
        ISA_PlaceHolder: Text;
    begin
        if not Rec."Error Callstack".HasValue then
            exit;

        Rec.CalcFields("Error Callstack");
        Rec."Error Callstack".CreateInStream(ISA_InStream);
        ISA_InStream.ReadText(ISA_PlaceHolder);
        Message(ISA_PlaceHolder);
    end;

}