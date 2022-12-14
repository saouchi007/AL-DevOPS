/// <summary>
/// Codeunit ISA_API (ID 50307).
/// </summary>
codeunit 50307 ISA_API
{
    /// <summary>
    /// ISA_Ping.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure ISA_Ping(): Text
    begin
        exit('Pong Mate !');
    end;
    /// <summary>
    /// ISA_GetRecord.
    /// </summary>
    /// <param name="jsonText">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ISA_GetRecord(jsonText: Text): Text
    var
        ISA_Customer: Record Customer;
        ISA_Item: Record Item;
        ISA_JsonMgmt: Codeunit "JSON Management V2";
        RecRef: RecordRef;
        ISA_jsonObject: JsonObject;
        ISA_TokenName: JsonToken;
        ISA_RecordName: Text;
        ISA_ErroMsg: Label 'Oh dear , there was an error reading name record...';
        ISA_jsonArray: JsonArray;
        ISA_output: Text;
    begin
        ISA_jsonObject.ReadFrom(jsonText);

        if (not ISA_jsonObject.Get('Name', ISA_TokenName)) then begin
            Error(ISA_ErroMsg);
        end;

        ISA_RecordName := ISA_TokenName.AsValue().AsText();

        case ISA_RecordName of
            'Item':
                begin
                    ISA_Item.FindSet();
                    repeat begin
                        ISA_jsonArray.Add(ISA_JsonMgmt.RecordToJson(ISA_Item));
                    end until ISA_Item.Next() = 0;
                end;
            'Customer':
                begin
                    ISA_Customer.FindSet();
                    repeat begin
                        ISA_jsonArray.Add(ISA_JsonMgmt.RecordToJson(ISA_Customer));
                    end until ISA_Customer.Next() = 0;
                end;
        end;
        ISA_jsonArray.WriteTo(ISA_output)
    end;
}