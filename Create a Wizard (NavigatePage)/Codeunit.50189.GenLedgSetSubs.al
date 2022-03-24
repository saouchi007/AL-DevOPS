/// <summary>
/// Codeunit ISA_Gen. Ledg Setup Subsribers (ID 50189).
/// </summary>
codeunit 50189 "ISA_Gen. Ledg Setup Subsribers"
{


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddGeneralLedgerSetupWizard()
    var
        AssistedSetup: Codeunit "Guided Experience";
        Language: Codeunit Language;
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage;
        AssistedSetup.InsertAssistedSetup(SetupTxt, SetupTxt, SetupTxt, 1000, ObjectType::Page, Page::ISA_GenLedgerSetupWizard,
                        "Assisted Setup Group"::GettingStarted, 'https://www.youtube.com/embed/hRLjl2u4I0w',
                        "Video Category"::Uncategorized,
                        'https://docs.microsoft.com/en-us/dynamics365/business-central/ui-get-ready-business');

        GlobalLanguage(Language.GetDefaultApplicationLanguageId());
        AssistedSetup.AddTranslationForSetupObjectDescription(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::ISA_GenLedgerSetupWizard,
        Language.GetDefaultApplicationLanguageId(), SetupTxt);
        GlobalLanguage(CurrentGlobalLanguage);
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;

    var
        Info: ModuleInfo;
        SetupTxt: Label 'Set up General Ledger Setup';
}