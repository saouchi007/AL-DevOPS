page 80863 "MICA Flow Card"
{

    PageType = Card;
    SourceTable = "MICA Flow";
    Caption = 'Interface Flow Card';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec.Status = 0;
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                }
                field(Direction; Rec."Direction")
                {
                    ApplicationArea = All;
                }
                field("Allow Upload by User"; Rec."Allow Upload by User")
                {
                    ApplicationArea = All;
                    //Editable = Direction = 1;
                    Importance = Additional;
                }
                field("Allow Download by User"; Rec."Allow Download by User")
                {
                    ApplicationArea = All;
                    //Editable = Direction = 2;
                    Importance = Additional;
                }
                field("Archive Data After"; Rec."Archive Data After")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Delete Archived Data After"; Rec."Delete Archived Data After")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }

                field("Disable Calc. Descripton"; Rec."Disable Calc. Descripton")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'If checked then the flow entry description will not be updated.';
                }

                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Last Modified User ID"; Rec."Last Modified User ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
            }
            group(EndPoint)
            {
                Caption = 'EndPoint';
                Editable = (Rec.Status = 0);
                field("EndPoint Type"; Rec."EndPoint Type")
                {
                    ApplicationArea = All;
                }
                field("EndPoint Code"; Rec."EndPoint Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" < 3;
                }
                field("EndPoint Recipients"; Rec."EndPoint Recipients")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 3;
                }
                field("Blob Container"; Rec."Blob Container")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 1;
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    var
                        FlowEndPoint: Record "MICA Flow EndPoint";
                    begin
                        FlowEndPoint.get(Rec."EndPoint Code");
                        message(SubstituteMsgLbl,
                            Rec.FieldCaption("Blob Container"),
                            flowendpoint.SubstituteParameters(Rec."Blob Container"))
                    end;
                }
                field("Blob Prefix"; Rec."Blob Prefix")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 1;
                }
                field("MQ Sub URL"; Rec."MQ Sub URL")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 2;
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    var
                        FlowEndPoint: Record "MICA Flow EndPoint";
                    begin
                        FlowEndPoint.get(Rec."EndPoint Code");
                        message(SubstituteMsgLbl,
                            Rec.FieldCaption("MQ Sub URL"),
                            flowendpoint.SubstituteParameters(Rec."MQ Sub URL"))
                    end;
                }
            }
            group(Receive)
            {
                Caption = 'Receive';
                Editable = (Rec.Status = 0) and (Rec.Direction = 2);
                field("Allow Partial Processing"; Rec."Allow Partial Processing")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Allow Reprocessing"; Rec."Allow Reprocessing")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Allow Skip Line"; Rec."Allow Skip Line")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Delete After Receive"; Rec."Delete After Receive")
                {
                    ApplicationArea = All;
                }
                field("Data Exch. Def. Code"; Rec."Data Exch. Def. Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Extract Codeunit ID" = 0;
                }
                field("Extract Codeunit ID"; Rec."Extract Codeunit ID")
                {
                    ApplicationArea = All;
                    Editable = Rec."Data Exch. Def. Code" = '';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Extract Codeunit Name"; Rec."Extract Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field("Process Codeunit ID"; Rec."Process Codeunit ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Process Codeunit Name"; Rec."Process Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field("Post Process Codeunit ID"; Rec."Post Process Codeunit ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Post Process Codeunit Name"; Rec."Post Process Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field("Flow Buffer Page ID"; Rec."Flow Buffer Page ID")
                {
                    ApplicationArea = All;
                }
                field("Flow Buffer Page Name"; Rec."Flow Buffer Page Name")
                {
                    ApplicationArea = All;
                }
                field("Remove XML NameSpaces"; Rec."Remove XML NameSpaces")
                {
                    ApplicationArea = All;
                }
                field("ACK Flow Code"; Rec."ACK Flow Code")
                {
                    ApplicationArea = All;
                }

            }
            group(Send)
            {
                Caption = 'Send';
                Editable = (Rec.Status = 0) and (Rec.Direction = 1);
                field("Send Codeunit ID"; Rec."Send Codeunit ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Send Codeunit Name"; Rec."Send Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field("Set Prepared manually"; Rec."Set Prepared manually")
                {
                    ApplicationArea = All;
                }
                field("Is ACK"; Rec."Is ACK")
                {
                    ApplicationArea = All;
                }

            }
            group(Encryption)
            {
                field("Use Encryption"; Rec."Use Encryption")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Direction = Rec.Direction::Send) and (Rec.status = 0);
                }
                field("Public Key Filepath"; Rec."Public Key Filepath")
                {
                    ApplicationArea = All;
                    Editable = Rec."Use Encryption" and (not Rec."Use SaaS Encryption") and (Rec.status = 0);
                }
                field("Use SaaS Encryption"; Rec."Use SaaS Encryption")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Direction = Rec.Direction::Send) and (Rec.status = 0);
                }
                field("Public Key File Name"; Rec."Public Key File Name")
                {
                    ApplicationArea = All;
                    Editable = Rec."Use SaaS Encryption" and (not Rec."Use Encryption") and (Rec.status = 0);
                }
            }
            group(Statistics)
            {
                Editable = Rec.Status = 0;
                Caption = 'Statistic';
                field("Count of Entry"; Rec."Count of Entry")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Count of Archived File"; Rec."Count of Archived Entry")
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
                field("Last Executed Date Time"; Rec."Last Executed Date Time")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Last Executed Duration"; Rec."Last Executed Duration")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                trigger OnAction()
                begin
                    Rec.Release();
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                trigger OnAction()
                begin
                    Rec.Open();
                end;
            }
            action(UploadData)
            {
                ApplicationArea = All;
                Caption = 'Upload';
                Image = ExportFile;
                trigger OnAction()
                begin
                    Rec.UploadData();
                end;
            }
            action(ReceiveData)
            {
                ApplicationArea = All;
                Caption = 'Receive';
                Image = ExportDatabase;

                trigger OnAction()
                begin
                    Rec.ReceiveData();
                end;
            }
            action(ExecuteSendCodeunit)
            {
                ApplicationArea = All;
                Caption = 'Execute Send Codeunit';
                Image = ExecuteBatch;
                trigger OnAction()
                begin
                    Rec.ExecuteSendCodeunit();
                end;
            }
            action(SendData)
            {
                ApplicationArea = All;
                Caption = 'Send';
                Image = ImportDatabase;

                trigger OnAction()
                begin
                    Rec.SendData();
                end;
            }
            action(Parameters)
            {
                ApplicationArea = All;
                Caption = 'Parameters';
                Image = Tools;

                trigger OnAction()
                var
                    MICAFlowSetup: Record "MICA Flow Setup";
                    MICAFlowParameters: Page "MICA Flow Parameters";
                begin
                    MICAFlowSetup.SetRange(Flow, Rec.Code);
                    MICAFlowParameters.SetTableView(MICAFlowSetup);
                    MICAFlowParameters.RunModal();
                end;
            }
            action(UploadPublicKey)
            {
                ApplicationArea = All;
                Caption = 'Upload Public Key';
                Image = ExportFile;
                Enabled = UploadEnabled;

                trigger OnAction()
                begin
                    Rec.UploadPublicKey();
                end;
            }
            action(ClearPublicKey)
            {
                ApplicationArea = All;
                Caption = 'Clear Public Key';
                Image = Delete;
                Enabled = not UploadEnabled;

                trigger OnAction()
                begin
                    Rec.ClearPublicKey();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        Rec.CalcFields("Public Key Blob");
        UploadEnabled := Rec."Public Key Blob".Length() = 0;
    end;

    var
        SubstituteMsgLbl: Label '%1 with substitute parameters is :\%2';
        UploadEnabled: Boolean;
}
