/// <summary>
/// Table ISA_NYT_API_Setup (ID 50305).
/// </summary>
table 50310 ISA_NYT_API_Setup
{
    DataClassification = ToBeClassified;
    Caption = 'ISA New York Times API Setup';

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Primary Key';

        }
        field(2; BaseURL; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Base URL';
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    procedure ISA_SetAPIKey(NewAPIKey: Text)
    var
        EncryptionManagement: Codeunit "Cryptography Management";
    begin
        if IsolatedStorage.Contains(ISA_GetStorageKey(), DataScope::Module) then
            IsolatedStorage.Delete(ISA_GetStorageKey(), DataScope::Module);
        if EncryptionManagement.IsEncryptionEnabled() and EncryptionManagement.IsEncryptionPossible() then
            NewAPIKey := EncryptionManagement.Encrypt(NewAPIKey);

        IsolatedStorage.set(ISA_GetStorageKey(), NewAPIKey, DataScope::Module);
    end;

    procedure ISA_GetAPIKey(): Text
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        APIKey: Text;
    begin
        if IsolatedStorage.Contains(ISA_GetStorageKey(), DataScope::Module) then begin
            IsolatedStorage.Get(ISA_GetStorageKey(), DataScope::Module, APIKey);
            if EncryptionManagement.IsEncryptionEnabled() and EncryptionManagement.IsEncryptionPossible() then
                APIKey := EncryptionManagement.Decrypt(APIKey);
            exit(APIKey);
        end;
    end;

    local procedure ISA_GetStorageKey(): Text
    begin
        exit(SystemId);
    end;


}