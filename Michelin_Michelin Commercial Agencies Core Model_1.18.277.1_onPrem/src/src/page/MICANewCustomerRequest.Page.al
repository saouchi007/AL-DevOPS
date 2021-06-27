page 80100 "MICA New Customer Request"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    UsageCategory = None;
    SourceTable = "Interaction Log Entry";
    Caption = 'Customer Request';

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = not (StatusIsClosedCustomer or StatusIsClosedMichelin);
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Interaction Template Code"; Rec."Interaction Template Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Interaction Creation Date"; Rec."MICA Interaction Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Request Status"; Rec."MICA Request Status")
                {
                    ApplicationArea = All;
                    Editable = ((Rec."MICA Request Status" = 0) or (Rec."MICA Request Status" = 1));
                    trigger OnValidate()
                    begin
                        if not (((xRec."MICA Request Status" = xRec."MICA Request Status"::"In progress") and (Rec."MICA Request Status" = Rec."MICA Request Status"::"Close the Loop")) or ((xRec."MICA Request Status" = xRec."MICA Request Status"::"Close the Loop") and (Rec."MICA Request Status" = Rec."MICA Request Status"::"In progress"))) then
                            Error('');
                    end;
                }
                field("MICA Responsible User"; "ResponsibleUserID")
                {
                    Caption = 'Responsible User';
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        User: Record User;
                        Users: Page Users;
                    begin
                        if User.Get(Rec."MICA Responsible User") then
                            Users.SetRecord(User);

                        Users.LookupMode := true;
                        if Users.RunModal() = ACTION::LookupOK then begin
                            Users.GetRecord(User);
                            Rec."MICA Responsible User" := User."User Security ID";
                            CurrPage.Update(true);
                        end;
                    end;
                }
                field("Responsible User Name"; Rec."MICA Responsible User Name")
                {
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."MICA Assigned User Name")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("MICA Doc. Type"; Rec."MICA Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("MICA Doc. No."; Rec."MICA Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Request"; Rec."MICA Linked Request")
                {
                    ApplicationArea = All;
                }
                field("MICA Level"; Rec."MICA Level")
                {
                    ApplicationArea = All;
                }
                group("Request Description")
                {
                    field(RequestDescription; RequestDescriptionTxt)
                    {
                        ApplicationArea = All;
                        Editable = PageEditable;
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetRequestDescription(RequestDescriptionTxt);
                        end;
                    }
                }
            }
            part(Activities; 80101)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Interaction No." = FIELD("Entry No.");
            }
            group(Resolution)
            {
                Editable = not (StatusIsClosedCustomer);
                field("MICA Close the Loop Date"; Rec."MICA Close the Loop Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Close the Loop User"; Rec."MICA Close the Loop User Name")
                {
                    ApplicationArea = All;
                }
                group(G1)
                {
                    Caption = '';
                    Editable = not (StatusIsClosedCustomer or StatusIsClosedMichelin);
                    field("MICA Close the Case Date"; Rec."MICA Close the Case Date")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA Close the Case User Name"; Rec."MICA Close the Case User Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Result Document Type"; Rec."MICA Result Document Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Result Document No."; Rec."MICA Result Document No.")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Public Conclusion Text")
                {
                    field(PublicClosingDesc; PublicClosingDescTxt)
                    {
                        ApplicationArea = All;
                        Editable = PageEditable and not (StatusIsClosedMichelin);
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetPublicClosing(PublicClosingDescTxt);
                        end;
                    }
                }
                group("Internal Conclusion Text")
                {
                    field(InternalClosingDesc; InternalClosingDescTxt)
                    {
                        ApplicationArea = All;
                        Editable = PageEditable and not (StatusIsClosedMichelin);
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetInternalClosingDesc(InternalClosingDescTxt);
                        end;
                    }
                }
                group(G2)
                {
                    Caption = '';
                    field("CES Evaluation"; Rec."MICA CES Evaluation")
                    {
                        ApplicationArea = All;
                        Editable = StatusIsClosedMichelin;
                        BlankNumbers = BlankNeg;

                        trigger OnValidate()
                        begin
                            CurrPage.UPDATE()
                        end;
                    }
                    field("MICA Close the Case - CES Date"; Rec."MICA Close the Case - CES Date")
                    {
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.UPDATE()
                        end;
                    }
                }
                group("CES Comment")
                {
                    field(CESComment; CESCommentTxt)
                    {
                        ApplicationArea = All;
                        Editable = StatusIsClosedMichelin;
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetCESComment(CESCommentTxt);
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
                Visible = (Rec."MICA Request Status" = 0) or (Rec."MICA Request Status" = 1);
                trigger OnAction()
                var
                    AssignTo: Page "MICA Assign To";
                begin
                    IF (Rec."MICA Request Status" = Rec."MICA Request Status"::"In progress") or (Rec."MICA Request Status" = Rec."MICA Request Status"::"Close the Loop") THEN BEGIN
                        AssignTo.RUNMODAL();
                        MICACustomerRequest.AssignToUser(Rec, AssignTo.GetDescription(), AssignTo.GetAssignedUser(), AssignTo.GetEstimatedEndingDate());
                    END;
                end;
            }
            action("Close Loop")
            {
                Image = UnLinkAccount;
                Caption = 'Close Loop';
                ApplicationArea = All;
                //Visible = "MICA Request Status" = 0;
                Visible = false;
                trigger OnAction()
                begin
                    IF Rec."MICA Request Status" = Rec."MICA Request Status"::"In progress" THEN
                        MICACustomerRequest.CloseTheLoop(Rec);
                end;
            }
            action("Reopen Loop")
            {
                Image = LinkAccount;
                Caption = 'Reopen Loop';
                ApplicationArea = All;
                //Visible = "MICA Request Status" = 1;
                Visible = false;
                trigger OnAction()
                begin
                    IF Rec."MICA Request Status" = Rec."MICA Request Status"::"Close the Loop" THEN
                        MICACustomerRequest.ReopenTheLoop(Rec);
                end;
            }
            action("Close the Case")
            {
                Image = Close;
                Caption = 'Close the Case';
                ApplicationArea = All;
                Visible = Rec."MICA Request Status" = 1;
                trigger OnAction()
                begin
                    IF Rec."MICA Request Status" = Rec."MICA Request Status"::"Close the Loop" THEN
                        MICACustomerRequest.CloseTheCase(Rec);
                end;
            }
            action(Convert)
            {
                Image = UpdateDescription;
                Caption = 'Convert Descriptions';
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.ConvertRequestDescription();
                end;
            }
            /*            action("Analyze Evaluation")
                        {
                            Image = UnLinkAccount;
                            Caption = 'Analyze Evaluation';
                            Visible = ("MICA CES Evaluation" <> 0) and ("MICA CES Evaluation" < 7) and ("MICA Request Status" = 2);
                            trigger OnAction()
                            begin
                                CustomerRequest.AnalyzeEvaluation(Rec);
                            end;
                        }
            */
        }
    }

    trigger OnAfterGetRecord()
    begin
        RequestDescriptionTxt := Rec.GetRequestDescription();
        PublicClosingDescTxt := Rec.GetPublicClosingDesc();
        InternalClosingDescTxt := Rec.GetInternalClosingDesc();
        CESCommentTxt := Rec.GetCESComment();

        StatusIsClosedCustomer := Rec."MICA Request Status" = Rec."MICA Request Status"::"Close the Case - CES";
        StatusIsClosedMichelin := Rec."MICA Request Status" = Rec."MICA Request Status"::"Close the Case";

        PageEditable := CurrPage.EDITABLE();
    end;

    var
        MICACustomerRequest: Codeunit "MICA Customer Request";
        ResponsibleUserID: Code[50];
        RequestDescriptionTxt: Text;
        PublicClosingDescTxt: Text;
        InternalClosingDescTxt: Text;
        CESCommentTxt: Text;
        StatusIsClosedCustomer: Boolean;
        StatusIsClosedMichelin: Boolean;
        PageEditable: Boolean;

}

