page 80864 "MICA Flow Entry List"
{
    PageType = List;
    SourceTable = "MICA Flow Entry";
    SourceTableView = SORTING("Entry No.") ORDER(Descending);
    Caption = 'Interface Flow Entries';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    CardPageId = "MICA Flow Entry Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Skip this Entry"; Rec."Skip this Entry")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Direction; Rec."Direction")
                {
                    ApplicationArea = All;
                }
                field(Uploaded; Rec."Uploaded")
                {
                    ApplicationArea = All;
                }
                field("Send Status"; Rec."Send Status")
                {
                    ApplicationArea = All;
                }
                field("Receive Status"; Rec."Receive Status")
                {
                    ApplicationArea = All;
                }
                field("Blob Length"; Rec."Blob Length")
                {
                    ApplicationArea = All;
                }
                field("Initial Blob Length"; Rec."Initial Blob Length")
                {
                    ApplicationArea = All;
                }
                field("Data Exch. Entry No."; Rec."Data Exch. Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
                field("EndPoint Type"; Rec."EndPoint Type")
                {
                    ApplicationArea = All;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Open Error Count"; Rec."Open Error Count")
                {
                    Style = Unfavorable;
                    ApplicationArea = All;
                }
                field("In Progress Error Count"; Rec."In Progress Error Count")
                {
                    Style = Attention;
                    ApplicationArea = All;
                }
                field("Closed Error Count"; Rec."Closed Error Count")
                {
                    ApplicationArea = All;
                }
                field("Buffer Count"; Rec."Buffer Count")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        Rec.OpenBuffer();
                    end;
                }
                field("Record Count"; Rec."Record Count")
                {
                    ApplicationArea = All;
                }
                field("Copied from Entry No."; Rec."Copied from Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Use Encryption"; Rec."Use Encryption")
                {
                    ApplicationArea = All;
                }
                field("Source Entry No."; Rec."Source Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Download)
            {
                Caption = 'Download';
                ApplicationArea = All;
                Image = ExportFile;
                trigger OnAction()
                begin
                    Rec.DowloadData();
                end;
            }
            action(DownloadInitialBlob)
            {
                Caption = 'Download Initial Blob';
                ApplicationArea = All;
                Image = ExportFile;
                trigger OnAction()
                begin
                    Rec.DowloadInitialData();
                end;
            }
            action("Open Buffer")
            {
                ApplicationArea = All;
                Caption = 'Open Buffer';
                Image = SendTo;
                trigger OnAction()
                begin
                    Rec.OpenBuffer();
                end;
            }
            action(Extract)
            {
                ApplicationArea = All;
                Caption = 'Extract';
                Image = Export;
                trigger OnAction()
                begin
                    Rec.Extract();
                end;
            }
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process';
                Image = Interaction;
                trigger OnAction()
                begin
                    Rec.Process(true);
                end;
            }
            action(PostProcess)
            {
                ApplicationArea = All;
                Caption = 'PostProcess';
                Image = PostponedInteractions;
                trigger OnAction()
                begin
                    Rec.PostProcess();
                end;
            }
            action(ManuallySetToPrepared)
            {
                ApplicationArea = All;
                Caption = 'Set Status to Prepared';
                Image = ImportDatabase;
                trigger OnAction()
                begin
                    Rec.ManuallyPrepareToSend();
                end;
            }
            action(SetSkipEntry)
            {
                ApplicationArea = All;
                Caption = 'Set Skip Entry';
                Image = Delegate;
                trigger OnAction()
                var
                    SelectFlowEntry: Record "MICA Flow Entry";
                begin
                    CurrPage.SetSelectionFilter(SelectFlowEntry);
                    Rec.SetSkipEntry(SelectFlowEntry);
                end;
            }
            action(EncryptEntry)
            {
                ApplicationArea = All;
                Caption = 'Encrypt Entry';
                Image = EncryptionKeys;
                trigger OnAction()
                var
                    FlowEntry: Record "MICA Flow Entry";
                    EncryptionMgt: Codeunit "MICA Encryption Mgt";
                    ProcessedEntriesCount: Integer;
                    EncryptionDoneLbl: Label '%1 entry(ies) has(ve) been encrypted.', Comment = '%1 = Processed Entry Count (result of function)';
                begin
                    CurrPage.SetSelectionFilter(FlowEntry);
                    ProcessedEntriesCount := EncryptionMgt.EncryptBlob(FlowEntry, true);
                    Message(EncryptionDoneLbl, ProcessedEntriesCount);
                end;
            }
            action(SaasEncryptEntry)
            {
                ApplicationArea = All;
                Caption = 'Saas Encrypt Entry';
                Image = EncryptionKeys;
                trigger OnAction()
                var
                    MICAFlowEntry: Record "MICA Flow Entry";
                    SaasEncryptionMgt: Codeunit "MICA Saas Encryption Mgt";
                    ProcessedEntriesCount: Integer;
                    ConfirmLbl: Label 'Do you want to encrypt the %1 selected record(s) ?', Comment = '%1 = Record count';
                    EncryptionDoneLbl: Label '%1 entry(ies) has(ve) been encrypted.', Comment = '%1 = Processed Entry Count (result of function)';
                begin
                    CurrPage.SetSelectionFilter(MICAFlowEntry);
                    if MICAFlowEntry.Findset() then
                        if Confirm(StrSubstNo(ConfirmLbl, MICAFlowEntry.Count())) then
                            ProcessedEntriesCount := SaasEncryptionMgt.SaasEncryptBlob(MICAFlowEntry)
                        else
                            exit;
                    Message(EncryptionDoneLbl, ProcessedEntriesCount);
                end;
            }
        }
    }
}