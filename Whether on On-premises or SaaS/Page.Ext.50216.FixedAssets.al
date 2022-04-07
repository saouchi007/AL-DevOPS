/// <summary>
/// PageExtension ISA_FixedAssets_List (ID 50216) extends Record Fixed Asset List.
/// </summary>
pageextension 50216 ISA_FixedAssets_List extends "Fixed Asset List"
{
    trigger OnOpenPage()
    var
        EnvInfo: Codeunit "Environment Information";
        SAAS: Label 'This environment is SAAS';
        NotSAAS: Label 'This environment is not SAAS';
        Production: Label 'This is a Production Environment';
        SandBox: Label 'This is a SandBox Environment';
    begin
        if EnvInfo.IsSaaS() then
            Message(SAAS)
            else
            Message(NotSAAS);

            if EnvInfo.IsProduction() then
                Message(Production);

                if EnvInfo.IsSandbox() then
                    Message(SandBox);

                    Message(Format(EnvInfo.GetEnvironmentName()) + '\\App Family : ' + EnvInfo.GetApplicationFamily() +
                    '\\ Base App Version:' + Format(EnvInfo.VersionInstalled('437dbf0e-84ff-417a-965d-ed2bb9650972')));
    end;
}