page 80865 "MICA Flow Entry Card"
{

    PageType = Card;
    SourceTable = "MICA Flow Entry";
    Caption = 'Interface Flow Entry Card';
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
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
                }
                field(Direction; Rec."Direction")
                {
                    ApplicationArea = All;
                }
                field(Uploaded; Rec."Uploaded")
                {
                    ApplicationArea = All;
                }
                field("Receive Status"; Rec."Receive Status")
                {
                    ApplicationArea = All;
                }
                field("Send Status"; Rec."Send Status")
                {
                    ApplicationArea = All;
                }
                field("Blob Length"; Rec."Blob Length")
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
                field("Partner Name"; Rec."Partner Name")
                {
                    ApplicationArea = All;
                }
                field("EndPoint Type"; Rec."EndPoint Type")
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
            }
            group(EndPoint)
            {
                Caption = 'EndPoint';
                field("EndPoint Code"; Rec."EndPoint Code")
                {
                    ApplicationArea = All;
                }
                field("Blob Container"; Rec."Blob Container")
                {
                    ApplicationArea = All;
                }
                field("MQ URL"; Rec."MQ URL")
                {
                    ApplicationArea = All;
                }
                field("MQ Sub URL"; Rec."MQ Sub URL")
                {
                    ApplicationArea = All;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
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
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Received Date Time"; Rec."Received Date Time")
                {
                    ApplicationArea = All;
                }
                field("Loaded Date Time"; Rec."Loaded Date Time")
                {
                    ApplicationArea = All;
                }
                field("Processed Date Time"; Rec."Processed Date Time")
                {
                    ApplicationArea = All;
                }
                field("PostProcessed Date Time"; Rec."PostProcessed Date Time")
                {
                    ApplicationArea = All;
                }
                field("Prepared Date Time"; Rec."Prepared Date Time")
                {
                    ApplicationArea = All;
                }
                field("Sent Date Time"; Rec."Sent Date Time")
                {
                    ApplicationArea = All;
                }
            }
            group("Technical Data")
            {
                Caption = 'Technical Data';
                field("Logical ID"; Rec."Logical ID")
                {
                    ApplicationArea = All;
                }
                field("Component ID"; Rec."Component ID")
                {
                    ApplicationArea = All;
                }
                field("Task ID"; Rec."Task ID")
                {
                    ApplicationArea = All;
                }
                field("Reference ID"; Rec."Reference ID")
                {
                    ApplicationArea = All;
                }
                field("Creation Date Time"; Rec."Creation Date Time")
                {
                    ApplicationArea = All;
                }
                field(Sender; Rec."Sender")
                {
                    ApplicationArea = All;
                }
                field(Receiver; Rec."Receiver")
                {
                    ApplicationArea = All;
                }
                field("Receiver Type"; Rec."Receiver Type")
                {
                    ApplicationArea = All;
                }
                field("Reference Key"; Rec."Reference Key")
                {
                    ApplicationArea = All;
                }
                field("Message Type"; Rec."Message Type")
                {
                    ApplicationArea = All;
                }
                field("Sender Application Code"; Rec."Sender Application Code")
                {
                    ApplicationArea = All;
                }
                field("ACK from Flow Entry ID"; Rec."ACK from Flow Entry ID")
                {
                    ApplicationArea = All;
                }
                field("ACK Flow Entry Count"; Rec."ACK Flow Entry Count")
                {
                    ApplicationArea = All;
                }
            }
            group(Encryption)
            {
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
                    ProcessedEntriesCount := EncryptionMgt.EncryptBlob(FlowEntry, false);
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
                    EncryptionDoneLbl: Label '%1 entry(ies) has(ve) been encrypted.', Comment = '%1 = Processed Entry Count (result of function)';
                begin
                    CurrPage.SetSelectionFilter(MICAFlowEntry);
                    ProcessedEntriesCount := SaasEncryptionMgt.SaasEncryptBlob(MICAFlowEntry);
                    Message(EncryptionDoneLbl, ProcessedEntriesCount);
                end;
            }
        }
    }
}