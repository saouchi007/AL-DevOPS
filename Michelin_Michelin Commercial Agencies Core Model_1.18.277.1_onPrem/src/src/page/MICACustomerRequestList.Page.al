page 80104 "MICA Customer Request List"
{
    // version REQUEST

    ApplicationArea = All;
    Caption = 'Customer Request List';
    CardPageID = "MICA New Customer Request";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Interaction Log Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Request Status"; Rec."MICA Request Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Interaction Creation Date"; Rec."MICA Interaction Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                }
                field("Interaction Template Code"; Rec."Interaction Template Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    ApplicationArea = All;
                }
                field("CES Evaluation"; Rec."MICA CES Evaluation")
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
                }
                field("Salesperson Name"; SalespersonPurchaser.Name)
                {
                    Caption = 'Salesperson Name';
                    ApplicationArea = All;
                }

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Responsible User ID"; Rec."MICA Responsible User Name")
                {
                    ApplicationArea = All;
                }
                field("MICA Level"; Rec."MICA Level")
                {
                    ApplicationArea = All;
                }
                field("MICA Close the Loop Date"; Rec."MICA Close the Loop Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Close the Loop User"; Rec."MICA Close the Loop User Name")
                {
                    ApplicationArea = All;
                }
                field("MICA Close the Case Date"; Rec."MICA Close the Case Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Close the Case User"; Rec."MICA Close the Case User Name")
                {
                    ApplicationArea = All;
                }
                field("MICA Customer No."; Rec."MICA Customer No.")
                {
                    ApplicationArea = All;
                }

                field(GetRequestDescription; Rec.GetRequestDescription())
                {
                    Caption = 'Request Description';
                    ApplicationArea = All;
                }
                field("MICA Close the Case - CES Date"; Rec."MICA Close the Case - CES Date")
                {
                    ApplicationArea = All;
                }
                field(GetPublicClosingDesc; Rec.GetPublicClosingDesc())
                {
                    Caption = 'Public Closing Desc.';
                    ApplicationArea = All;
                }
                field(GetCESComment; Rec.GetCESComment())
                {
                    Caption = 'CES Comment';
                    ApplicationArea = All;
                }
                field("MICA Result Document Type"; Rec."MICA Result Document Type")
                {
                    ApplicationArea = All;
                }
                field("MICA Result Document No."; Rec."MICA Result Document No.")
                {
                    ApplicationArea = All;
                }
            }
        }

        area(factboxes)
        {
            /*systempart(;Links)
            {
            }
            systempart(;Notes)
            {
            }*/
        }

    }


    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if not SalespersonPurchaser.Get(Rec."Salesperson Code") then
            SalespersonPurchaser.Init();
    end;

    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
}

