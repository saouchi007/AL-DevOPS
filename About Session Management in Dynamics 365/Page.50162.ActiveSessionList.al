/// <summary>
/// Page ActiveSessionList (ID 50162).
/// </summary>
page 50162 ActiveSessionList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Active Session";
    Caption = 'Active Session List';
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;

                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = All;

                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;

                }
                field("Server Instance Name"; Rec."Server Instance Name")
                {
                    ApplicationArea = All;

                }
                field("Server Computer Name"; Rec."Server Computer Name")
                {
                    ApplicationArea = All;

                }
                field("Client Type"; Rec."Client Type")
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
            action(CancelSession)
            {
                Caption = 'Cancel Session';
                Image = CancelAllLines;
                ApplicationArea = All;

                trigger OnAction()
                var
                    userPermission: Codeunit "User Permissions";
                    CanceledLBL: Label 'Selected session has been canedled !';
                    NoPermission: Label 'You do not have "SUPER" permission...';

                begin
                    if userPermission.CanManageUsersOnTenant(UserSecurityId()) then begin
                        if StopSession("Session ID") then begin
                            Message(CanceledLBL);
                        end;
                    end else begin
                        Message(NoPermission);
                    end;
                end;
            }
        }
    }
}