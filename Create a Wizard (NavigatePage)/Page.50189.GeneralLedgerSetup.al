/// <summary>
/// Page ISA_GenLedgerSetupWizard (ID 50189).
/// </summary>
page 50189 ISA_GenLedgerSetupWizard
{
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "General Ledger Setup";
    SourceTableTemporary = true;
    Caption = 'General Ledger Setup Wizard';

    layout
    {
        area(Content)
        {
            group(Step1)
            {
                Visible = Step1Visibility;
                group("Welcome to General Ledger Setup Wizard")
                {
                    Visible = Step1Visibility;
                    group(Welcome)
                    {
                        ShowCaption = false;
                        InstructionalText = 'You can setup General Ledger Setup now';
                    }
                }
                group("Let's Go !")
                {
                    group(Group10)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Choose Next to start basic settings for General Ledger.';
                    }
                }
                group(StandardBanner)
                {
                    Caption = '';
                    Editable = false;
                    Visible = TopBannerVisible and not FinishActionEnabled;

                    field(MediaRessourcesStandard; MediaRessourcesStandard."Media Reference")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                    }
                }
                group(FinishedBanner)
                {
                    Caption = '';
                    Editable = false;
                    Visible = TopBannerVisible and FinishActionEnabled;

                    field(MediaRessourcesDone; MediaRessourcesDone."Media Reference")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                    }
                }
            }
            group(Step2)

            {
                Caption = 'General';
                Visible = Step2Visibility;
                InstructionalText = 'Step2 - Setup General';
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                    ApplicationArea = All;
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                    ApplicationArea = All;
                }
                field("Max. VAT Difference Allowed"; Rec."Max. VAT Difference Allowed")
                {
                    ApplicationArea = All;
                }
                field("LCY Code"; Rec."LCY Code")
                {
                    ApplicationArea = All;
                }

                //Visible = StepVisible = 1;

            }
            group(Step3)
            {
                Caption = 'Dimensions';
                InstructionalText = 'Step3 - Setup Dimensions';
                Visible = Step3Visibility;
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;

                }
            }
            group(Step4)
            {
                Visible = Step4Visibility;
                group(Group23)
                {
                    Caption = 'OK';
                    InstructionalText = 'Step4 - You have finished the setup';
                }
                group("That's it!")
                {
                    group(Group25)
                    {
                        ShowCaption = false;
                        InstructionalText = 'To save this setup, choose Finish';
                    }
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }

            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    FinishAction();
                end;
            }
        }
    }

    var
        Step1Visibility: Boolean;
        Step2Visibility: Boolean;
        Step3Visibility: Boolean;
        Step4Visibility: Boolean;
        StepVisible: Integer; //You can also create global Integer variable and set the Visible property with an expression, tried it with step 2 
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        Step: Option Start,Step2,Step3,Finish;
        TopBannerVisible: Boolean;
        MediaRepoDone: Record "Media Repository";
        MediaRepoStandard: Record "Media Repository";
        MediaRessourcesDone: Record "Media Resources";
        MediaRessourcesStandard: Record "Media Resources";

    local procedure EnableControls()
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
            Step::Step2:
                ShowStep2();
            Step::Step3:
                ShowStep3();
            Step::Finish:
                ShowStep4();
        end;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;
        EnableControls();
    end;

    local procedure FinishAction()
    begin
        StoreRecordVar();
        CurrPage.Close();
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visibility := false;
        Step2Visibility := false;
        Step3Visibility := false;
        Step4Visibility := false;
    end;

    local procedure ShowStep1()
    begin
        Step1Visibility := true;
        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowStep2()
    begin
        Step2Visibility := true;
    end;

    local procedure ShowStep3()
    begin
        Step3Visibility := true;

    end;

    local procedure ShowStep4()
    begin
        Step4Visibility := true;
        NextActionEnabled := false;
        FinishActionEnabled := true;
    end;

    local procedure StoreRecordVar()
    var
        GenLedgSetup: Record "General Ledger Setup";
    begin
        if not GenLedgSetup.Get() then begin
            GenLedgSetup.Init();
            GenLedgSetup.Insert();
        end;
        GenLedgSetup.TransferFields(Rec, false);
        GenLedgSetup.Modify(true);
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepoStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) AND
           MediaRepoDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType())) then
            if MediaRessourcesStandard.Get(MediaRepoStandard."Media Resources Ref") AND
               MediaRessourcesDone.GET(MediaRepoDone."Media Resources Ref")
            then
                TopBannerVisible := MediaRessourcesDone."Media Reference".HasValue();
    end;

    trigger OnOpenPage()
    var
        GenLedgSetup: Record "General Ledger Setup";
    begin
        Rec.Init();
        if GenLedgSetup.Get() then
            Rec.TransferFields(GenLedgSetup);
        Rec.Insert();
        Step := Step::Start;
        EnableControls();
    end;

    trigger OnInit()
    begin
        LoadTopBanners();
    end;
}