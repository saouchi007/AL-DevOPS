page 80862 "MICA Flow List"
{

    PageType = List;
    SourceTable = "MICA Flow";
    Caption = 'Interface Flows';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "MICA Flow Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
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
                field("Send Codeunit ID"; Rec."Send Codeunit ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Send Codeunit Name"; Rec."Send Codeunit Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Data Exch. Def. Code"; Rec."Data Exch. Def. Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Extract Codeunit ID"; Rec."Extract Codeunit ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Extract Codeunit Name"; Rec."Extract Codeunit Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Process Codeunit ID"; Rec."Process Codeunit ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Process Codeunit Name"; Rec."Process Codeunit Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Post Process Codeunit ID"; Rec."Post Process Codeunit ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Post Process Codeunit Name"; Rec."Post Process Codeunit Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Flow Buffer Page ID"; Rec."Flow Buffer Page ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Flow Buffer Page Name"; Rec."Flow Buffer Page Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("EndPoint Type"; Rec."EndPoint Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Count of Entry"; Rec."Count of Entry")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Last Executed Date Time"; Rec."Last Executed Date Time")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
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
        }
    }
}

