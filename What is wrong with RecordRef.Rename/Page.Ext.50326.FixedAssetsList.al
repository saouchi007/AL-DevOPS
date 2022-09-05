/// <summary>
/// PageExtension ISA_FixedAssetList_Ext (ID 50326) extends Record MyTargetPage.
/// </summary>
pageextension 50326 ISA_FixedAssetList_Ext extends "Sales Order List"
{

    trigger OnOpenPage()
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(Database::Customer);
        Message('%',ISA_GetRecRefPKFieldNosInOrder(RecRef));
    end;



    local procedure ISA_GetRecRefPKFieldNosInOrder(RecRef: RecordRef) ListOfPKFieldNo: List of [Integer]
    var
        FieldRefVar: FieldRef;
        KeyRefVar: KeyRef;
        KeyCount: Integer;
    begin
        //Usually Primary Key is first key of table, so we just get key №1 and assign it to KeyRef variable
        KeyRefVar := RecRef.KeyIndex(1);

        //Read each field index from key in loop ​
        for KeyCount := 1 to KeyRefVar.FieldCount() do begin

            //Get each field to FieldRef variable by field index
            FieldRefVar := KeyRefVar.FieldIndex(KeyCount);

            //Add each field number to list
            //We can't use values just because values can have different data types
            //List doesn't support variant data type, so we just store numbers for now
            ListOfPKFieldNo.Add(FieldRefVar.Number());

        end;
        exit(ListOfPKFieldNo);
    end;
}