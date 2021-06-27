pageextension 80104 "MICA Customer List" extends "Customer List" //MyTargetPageId
{
    layout
    {
        addafter("Balance Due (LCY)")
        {
            field("MICA Balance Due (Buffer)"; Rec."MICA Balance Due (Buffer)")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.OpenCustomerLedgerEntriesDueBuffer();
                end;
            }
        }
        addafter(Name)
        {
            field("MICA Search Name"; Rec."Search Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Last Date Modified")
        {
            field("MICA Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
            }

        }
        addlast(Control1)
        {
            field("MICA Type"; Rec."MICA Type")
            {
                ApplicationArea = All;
            }
            field("MICA Status"; Rec."MICA Status")
            {
                ApplicationArea = All;
            }
            field("MICA Market Code"; Rec."MICA Market Code")
            {
                ApplicationArea = All;
            }
            field("MICA English Name"; Rec."MICA English Name")
            {
                ApplicationArea = All;
            }
            field("MICA Party Ownership"; Rec."MICA Party Ownership")
            {
                ApplicationArea = All;
            }
            field("MICA Express Order"; Rec."MICA Express Order")
            {
                ApplicationArea = All;
            }
            field("MICA Credit Classification"; Rec."MICA Credit Classification")
            {
                ApplicationArea = All;
            }
            field("MICA Channel"; Rec."MICA Channel")
            {
                ApplicationArea = All;
            }
            field("MICA Business Orientation"; Rec."MICA Business Orientation")
            {
                ApplicationArea = All;
            }
            field("MICA Partnership"; Rec."MICA Partnership")
            {
                ApplicationArea = All;
            }
            field("MICA Base Cal. Code Exp. Order"; Rec."MICA Base Cal. Code Exp. Order")
            {
                ApplicationArea = All;
            }
            field("MICA Shipping Agent Exp. Order"; Rec."MICA Shipping Agent Exp. Order")
            {
                ApplicationArea = All;
            }
            field("MICA Ship Agent Serv Exp Order"; Rec."MICA Ship Agent Serv Exp Order")
            {
                ApplicationArea = All;
            }
            field("MICA Deliverability Code"; Rec."MICA Deliverability Code")
            {
                ApplicationArea = All;
            }
            field("MICA MDM ID LE"; Rec."MICA MDM ID LE")
            {
                ApplicationArea = All;
            }
            field("MICA MDM Bill-to Site Use ID"; Rec."MICA MDM Bill-to Site Use ID")
            {
                ApplicationArea = All;
            }
            field("MICA Time Zone"; Rec."MICA Time Zone")
            {
                ApplicationArea = All;
            }
            field("MICA Time Zone Name"; Rec."MICA Time Zone Name")
            {
                ApplicationArea = All;
            }
            field("MICA MDM ID BT"; Rec."MICA MDM ID BT")
            {
                ApplicationArea = All;
            }
            field("MICA % Of Prepayment"; Rec."MICA % Of Prepayment")
            {
                ApplicationArea = All;
            }
            field("MICA Dont send balance aged"; Rec."MICA Dont send balance aged")
            {
                ApplicationArea = All;
            }
            field("MICA Last Balance Aged Sent"; Rec."MICA Last Balance Aged Sent")
            {
                ApplicationArea = All;
            }
            field("MICA Accr. Customer Grp."; Rec."MICA Accr. Customer Grp.")
            {
                ApplicationArea = All;
            }
            field("MICA Shipment Post Option"; Rec."MICA Shipment Post Option")
            {
                ApplicationArea = All;
            }
            field("MICA Factoring"; Rec."MICA Factoring")
            {
                ApplicationArea = All;
            }
            field("MICA id"; Rec."id")
            {
                Caption = 'id';
                ApplicationArea = All;
                Visible = false;
            }

        }

    }

    actions
    {
        modify(Statement)
        {
            Visible = false;
            Enabled = false;
        }
        addafter(Statement)
        {
            action("MICA Customer Statement")
            {
                Caption = 'Statement';
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
                ApplicationArea = all;
                Image = Report;
                RunObject = Codeunit "Customer Layout - Statement";
            }
        }
        addafter(PaymentRegistration)
        {
            action("MICA CreateCustomerRequest")
            {
                Caption = 'Create Customer Request';
                Image = CreateInteraction;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Cont: Record Contact;
                    InteractionLogEntry: Record "Interaction Log Entry";
                    ContBusRel: Record "Contact Business Relation";
                    MICACustRqst: Codeunit "MICA Customer Request";
                    NewCustomerRequest: Page "MICA New Customer Request";
                begin
                    ContBusRel.SetRange("No.", Rec."No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                    if ContBusRel.FindFirst() then
                        if Cont.Get(ContBusRel."Contact No.") then begin
                            MICACustRqst.CreateInteractionLogEntry(Cont, InteractionLogEntry);
                            InteractionLogEntry.SETRANGE("Entry No.", InteractionLogEntry."Entry No.");
                            NewCustomerRequest.SETTABLEVIEW(InteractionLogEntry);
                            NewCustomerRequest.Run();
                        end;
                end;
            }
        }
        addlast(Documents)
        {
            action("MICA CustomerRequestList")
            {
                ApplicationArea = All;
                Caption = 'Customer Request';
                Image = CustomerRating;
                trigger OnAction()
                var
                    InteractLogEntry: Record "Interaction Log Entry";
                    ContBusRel: Record "Contact Business Relation";
                    Cont: Record Contact;
                    Cont2: Record Contact;
                begin
                    ContBusRel.SetRange("No.", Rec."No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                    if ContBusRel.FindFirst() then
                        if Cont2.Get(ContBusRel."Contact No.") then
                            with Cont2 do begin
                                if "Type" = "Type"::Person then
                                    InteractLogEntry.SetRange("Contact No.", "No.")
                                else
                                    if "Type" = "Type"::Company then begin
                                        Cont.SetRange("Company No.", "No.");
                                        if Cont.FindSet() then
                                            repeat
                                                InteractLogEntry.SetRange("Contact No.", Cont."No.");
                                                if InteractLogEntry.FindSet() then
                                                    repeat
                                                        InteractLogEntry.Mark(true);
                                                    until InteractLogEntry.Next() = 0;
                                            until Cont.Next() = 0;
                                        InteractLogEntry.SetRange("Contact No.");
                                        InteractLogEntry.MarkedOnly(true);

                                    end;
                                Page.RunModal(Page::"MICA Customer Request List", InteractLogEntry);
                            end;
                end;
            }
        }
    }
}