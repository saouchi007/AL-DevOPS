page 80102 "MICA Interaction Activity"
{
    // version REQUEST

    //ApplicationArea = Basic,Suite,Service;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "MICA Interaction Activities";
    UsageCategory = None;
    Caption = 'Interaction Activity';

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Not (StatusIsClosedCustomer) and Not (IsFinished);
                field("Interaction No."; Rec."Interaction No.")
                {
                    ApplicationArea = All;
                }
                field("Contact Name"; InteractionLogEntry."Contact Name")
                {
                    Caption = 'Contact Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Interaction Template Code"; InteractionLogEntry."Interaction Template Code")
                {
                    Caption = 'Interaction Template Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Interaction Description"; InteractionLogEntry.Description)
                {
                    Caption = 'Interaction Description';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Activity Status"; Rec."Activity Status")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation User ID"; Rec."Creation User Name")
                {
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User Name")
                {
                    ApplicationArea = All;
                }
                field("Estimated Ending Date"; Rec."Estimated Ending Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Level"; Rec."Level")
                {
                    ApplicationArea = All;
                }

            }
            group(Resolution)
            {
                Editable = Not (StatusIsClosedCustomer);
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Activity Closer ID"; Rec."Activity Closer Name")
                {
                    ApplicationArea = All;
                }
                group("Public Comment")
                {
                    field(PublicComment; PublicCommentTxt)
                    {
                        ApplicationArea = All;
                        Editable = PageEditable;
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetPublicComment(PublicCommentTxt);
                        end;
                    }
                }
                group("Internal Comment")
                {
                    field(InternalComment; InternalCommentTxt)
                    {
                        ApplicationArea = All;
                        Editable = PageEditable;
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetInternalComment(InternalCommentTxt);
                        end;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Assign to another user")
            {
                Image = CoupledUsers;
                Caption = 'Assign to another user';
                ApplicationArea = All;

                trigger OnAction()
                var
                    AssignTo: Page "MICA Assign To";
                begin
                    IF InteractionLogEntry."MICA Request Status" = InteractionLogEntry."MICA Request Status"::"In progress" THEN BEGIN
                        AssignTo.RUNMODAL();
                        MICACustomerRequest.AssignToUser(InteractionLogEntry, AssignTo.GetDescription(), AssignTo.GetAssignedUser(), AssignTo.GetEstimatedEndingDate());
                    END;
                end;
            }
            action("Close Loop")
            {
                Image = UnLinkAccount;
                Caption = 'Close Loop';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF InteractionLogEntry."MICA Request Status" = InteractionLogEntry."MICA Request Status"::"In progress" THEN
                        MICACustomerRequest.CloseTheLoop(InteractionLogEntry);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        InteractionLogEntry.GET(Rec."Interaction No.");
        InteractionLogEntry.CALCFIELDS("Contact Name");

        InternalCommentTxt := Rec.GetInternalComment();
        PublicCommentTxt := Rec.GetPublicComment();

        StatusIsClosedCustomer := InteractionLogEntry."MICA Request Status" = InteractionLogEntry."MICA Request Status"::"Close the Case - CES";

        IsFinished := Rec."Activity Status" = Rec."Activity Status"::Closed;

        PageEditable := CurrPage.EDITABLE();
    end;

    var
        InteractionLogEntry: Record "Interaction Log Entry";
        MICACustomerRequest: Codeunit "MICA Customer Request";
        PublicCommentTxt: Text;
        InternalCommentTxt: Text;
        StatusIsClosedCustomer: Boolean;
        IsFinished: Boolean;
        PageEditable: Boolean;
}

