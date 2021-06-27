pageextension 80020 "MICA Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("MICA Search Name"; Rec."Search Name")
            {
                ApplicationArea = All;
            }
        }
        modify("Payment Terms Code")
        {
            Enabled = false;
        }
        modify("Payment Method Code")
        {
            Enabled = false;
        }

        addfirst(Payments)
        {
            field("MICA % Of Prepayment"; Rec."MICA % Of Prepayment")
            {
                ApplicationArea = All;
            }
        }
        addlast(Invoicing)
        {
            field("MICA Print Sell-to Address"; Rec."MICA Print Sell-to Address")
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Type"; Rec."MICA Type")
                {
                    ApplicationArea = All;
                }
                field("MICA Segmentation Code"; Rec."MICA Segmentation Code")
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

                field("MICA Credit classification"; Rec."MICA Credit classification")
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

                field("MICA Deliverability Code"; Rec."MICA Deliverability Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Rebate Pool"; Rec."MICA Rebate Pool")
                {
                    ApplicationArea = All;
                }

                field("MICA MDM ID LE"; Rec."MICA MDM ID LE")
                {
                    ApplicationArea = All;
                }

                field("MICA Time Zone Name"; Rec."MICA Time Zone Name")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        TimeZone: Record "Time Zone";
                    begin
                        TimeZone.Reset();
                        TimeZone.SetCurrentKey("No.");
                        TimeZone."No." := Rec."MICA Time Zone";
                        if TimeZone.FIND('=><') then;
                        if PAGE.RUNMODAL(PAGE::"MICA Time Zone List", TimeZone) = ACTION::LookupOK then
                            Rec.Validate("MICA Time Zone", TimeZone."No.");
                    end;
                }

                field("MICA MDM ID BT"; Rec."MICA MDM ID BT")
                {
                    ApplicationArea = All;
                }
                field("MICA MDM Bill-to Site Use ID"; Rec."MICA MDM Bill-to Site Use ID")
                {
                    ApplicationArea = all;
                }

                field("MICA Base Calendar Code Express Order"; Rec."MICA Base Cal. Code Exp. Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Shipping Agent Express Order"; Rec."MICA Shipping Agent Exp. Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Shipping Agent Service Express Order"; Rec."MICA Ship Agent Serv Exp Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Accr. Customer Grp."; Rec."MICA Accr. Customer Grp.")
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
                    trigger OnDrillDown()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileMgt: Codeunit "File Management";
                    begin
                        Rec.CalcFields("MICA Last Balance Aged Blob");
                        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Last Balance Aged Blob"));
                        // TempBlob.Blob := "MICA Last Balance Aged Blob";
                        FileMgt.BLOBExport(TempBlob, Rec.FieldCaption("MICA Last Balance Aged Sent") + '.pdf', true)
                    end;
                }
                field("MICA Shipment Post Option"; Rec."MICA Shipment Post Option")
                {
                    ApplicationArea = All;
                }
                field("MICA Factoring"; Rec."MICA Factoring")
                {
                    ApplicationArea = All;
                }
                field("MICA S2S External Ref."; Rec."MICA S2S External Ref.")
                {
                    ApplicationArea = All;
                }
                field("MICA S2S Exact Qty."; Rec."MICA S2S Exact Qty.")
                {
                    ApplicationArea = All;
                }
            }
        }
        addlast(content)
        {
            group("MICA Flow Integration")
            {
                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter(Blocked)
        {
            field("MICA RPL Status"; Rec."MICA RPL Status")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if Rec."MICA RPL Status" <> xRec."MICA RPL Status" then
                        CurrPage.Update(); //Update the RPL Status Description flowfield
                end;
            }
            field("MICA RPL Status Description"; Rec."MICA RPL Status Description")
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
        addafter("Balance Due (LCY)")
        {
            field("MICA Rebate Pool Rem. Amount"; Rec."MICA Rebate Pool Rem. Amount")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

        modify("Report Statement")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Report Statement")
        {
            action("MICA Customer Statement")
            {
                Caption = 'Statement';
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
                ApplicationArea = all;
                Image = Report;
                RunObject = Codeunit "Customer Layout - Statement";
            }

            action("MICA Customer Catalog")
            {
                Caption = 'Customer Catalog List';
                ToolTip = 'View a list of items in the customer catalog based on customer assortment definition.';
                ApplicationArea = All;
                Image = Report;
                // RunObject = Report "MICA Customer Catalog List";
                trigger OnAction()
                var
                    sc: Record "SC - Cust. Assortment";
                begin
                    sc.SetFilter("Sales Code", Rec."No.");
                    Report.RunModal(Report::"MICA Customer Catalog List", true, false, sc);
                End;

            }
        }

        addafter("Line Discounts")
        {
            action("MICA Accrual Rates")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category9;
                Image = Price;
                Caption = 'Deferred Rebates Rates';
                RunObject = page 80767;
                RunPageLink = "Customer No." = FIELD("No.");
            }
        }

        addafter("Ledger E&ntries")
        {

            action("MICA Accrual Ledger Entries")
            {
                ApplicationArea = All;
                //Promoted = true;
                //PromotedCategory = Process;
                Image = CustomerLedger;
                Caption = 'Deferred Rebates Ledger Entries';
                RunObject = page 80766;
                RunPageLink = "Customer No." = FIELD("No.");
            }

            action("MICA Accrual Dtld. Ledger Entries")
            {
                ApplicationArea = All;
                //Promoted = true;
                //PromotedCategory = Process;
                Image = CustomerLedger;
                Caption = 'Def. Reb. Dtld. Ledger Entries';
                RunObject = page 80765;
                RunPageLink = "Customer No." = FIELD("No.");
            }
        }

        addlast("&Customer")
        {
            action("MICA Forecast")
            {
                ApplicationArea = All;
                Caption = 'Forecast Code';
                Image = Forecast;

                trigger OnAction()
                var
                    MICAForecastCustCode: Record "MICA Forecast Customer Code";
                begin
                    MICAForecastCustCode.SetRange("Customer Code", Rec."No.");
                    Page.RunModal(Page::"MICA Forecaste Cust Code List", MICAForecastCustCode);
                end;
            }

            action("MICA Sales Agreement")
            {
                ApplicationArea = All;
                Caption = 'Sales Agreement';
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category9;
                trigger OnAction()
                var
                    SalesAgreementList: Page "MICA Sales Agreement List";
                begin
                    SalesAgreementList.SetCustomer(Rec."No.");
                    SalesAgreementList.RunModal();
                    //MICASalesAgreement.SetRange("Customer No.", "No.");
                    //Page.RunModal(Page::"MICA Sales Agreement List", MICASalesAgreement);
                end;
            }
            action("MICA Rebate Pool Entries")
            {
                ApplicationArea = All;
                Caption = 'Rebate Pool';
                Image = RefreshDiscount;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category9;
                RunObject = Page "MICA Rebate Pool Entries";
                RunPageLink = "Customer No." = field("No."), Open = const(true);
            }
        }
        addlast("F&unctions")
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
        addafter(BackgroundStatement)
        {
            action("MICA Rebate Pool Statement")
            {
                Caption = 'Rebate Pool Statement';
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
                begin
                    MICARebatePoolEntry.SetRange("Customer No.", Rec."No.");
                    Report.Run(Report::"MICA Rebate Pool Statement", true, false, MICARebatePoolEntry);
                end;
            }
        }
    }
}