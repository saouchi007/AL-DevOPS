page 82680 "MICA Archived Flow Entry List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Flow Entry Archive";
    Editable = false;
    Caption = 'Archived Flow Entries';

    layout
    {
        area(Content)
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
                }
                field("Record Count"; Rec."Record Count")
                {
                    ApplicationArea = All;
                }
                field("Copied from Entry No."; Rec."Copied from Entry No.")
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
            action(Download)
            {
                Caption = 'Download';
                ApplicationArea = All;
                Image = ExportFile;
                trigger OnAction()
                begin
                    Rec.DownloadData();
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

        }
    }
}