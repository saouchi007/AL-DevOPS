page 80868 "MICA Flow Information List"
{

    PageType = List;
    SourceTable = "MICA Flow Information";
    Caption = 'Interface Flow Informations';
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                    Editable = false;
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Flow Buffer Entry No."; Rec."Flow Buffer Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Info Type"; Rec."Info Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    StyleExpr = StyleTxt;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Additional Text"; Rec."Additional Text")
                {
                    ApplicationArea = All;
                }
                field("Modified UserID"; Rec."Modified UserID")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Modified Date Time"; Rec."Modified Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date Time"; Rec."End Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Information Duration"; Rec."Information Duration")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }


    actions
    {
        // Adds the action called "My Actions" to the Action menu 
        area(Processing)
        {
            action(ShowMessage)
            {
                ApplicationArea = All;
                Image = GetActionMessages;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Show message';
                ToolTip = 'Show the information message.';

                trigger OnAction()
                begin
                    Rec.ShowMessage();
                end;
            }
            action(UpdateStatusToOpen)
            {
                ApplicationArea = All;
                Image = Open;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Set Status Open';

                trigger OnAction()
                var
                    Selected: Record "MICA Flow Information";
                begin
                    Selected.Copy(rec);
                    CurrPage.SetSelectionFilter(selected);
                    Rec.UpdateStatus(Selected, Rec.Status::Open);
                end;
            }
            action(UpdateStatusToInProgress)
            {
                ApplicationArea = All;
                Image = ChangeStatus;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Set Status In Progress';

                trigger OnAction()
                var
                    Selected: Record "MICA Flow Information";
                begin
                    Selected.Copy(rec);
                    CurrPage.SetSelectionFilter(selected);
                    Rec.UpdateStatus(Selected, Rec.Status::InProgress);
                end;
            }
            action(UpdateStatusToClosed)
            {
                ApplicationArea = All;
                Image = Closed;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Set Status Closed';

                trigger OnAction()
                var
                    Selected: Record "MICA Flow Information";
                begin
                    Selected.Copy(rec);
                    CurrPage.SetSelectionFilter(selected);
                    Rec.UpdateStatus(Selected, Rec.Status::Closed);
                end;
            }
        }
    }

    var
        StyleTxt: text;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;

}
