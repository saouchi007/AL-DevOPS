/// <summary>
/// Codeunit ISA_DownloadJson (ID 50306).
/// </summary>
codeunit 50305 ISA_DownloadJson
{
    /// <summary>
    /// ISA_DownloadJson.
    /// </summary>
    /// <param name="variant">Variant.</param>
    procedure ISA_DownloadJson(variant: Variant)
    var
        ISA_RecRef: RecordRef;
        ISA_FileName, ISA_JsonText : Text;
        ISA_Confirmed: Boolean;
        ISA_DownloadLbl: Label 'Do you want to downlaod the file';
        ISA_JsonArray: JsonArray;
        ISA_JSonMgmt: Codeunit "JSON Management V2";
        ISA_TempBlob: Codeunit "Temp Blob";
        ISA_InStream: InStream;
        ISA_OutStream: OutStream;
    begin
        ISA_RecRef.GetTable(variant);
        ISA_FileName := ISA_RecRef.Name + '.json';

        ISA_Confirmed := Dialog.Confirm(ISA_DownloadLbl + ' ' + ISA_FileName + ' ?');
        if (not ISA_Confirmed) then
            exit;

        if ISA_RecRef.FindSet() then
            repeat begin
                ISA_JsonArray.Add(ISA_JSonMgmt.RecordToJson(variant));
            end until ISA_RecRef.Next() = 0;

        ISA_JsonArray.WriteTo(ISA_JsonText);

        ISA_TempBlob.CreateOutStream(ISA_OutStream, TextEncoding::UTF8);
        ISA_OutStream.WriteText(ISA_JsonText);
        ISA_TempBlob.CreateInStream(ISA_InStream);

        DownloadFromStream(ISA_InStream, 'Export', '', 'All Files (*.*)|*.*', ISA_FileName);
    end;
}