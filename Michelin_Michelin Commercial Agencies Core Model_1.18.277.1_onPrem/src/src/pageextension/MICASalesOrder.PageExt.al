pageextension 80200 "MICA Sales Order" extends "Sales Order" //MyTargetPageId
{
    layout
    {
        modify("Payment Terms Code")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            visible = false;
        }

        modify("VAT Bus. Posting Group")
        {
            ApplicationArea = All;
            Visible = MICAMultiPosting;
        }

        addafter("VAT Bus. Posting Group")
        {
            field("MICA Customer Posting Group Alt."; Rec."MICA Cust. Posting Group Alt.")
            {
                ApplicationArea = All;
                Visible = MICAMultiPosting;
            }
        }

        addlast(General)
        {
            field("MICA Order Type"; Rec."MICA Order Type")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    If Rec."MICA Order Type" = Rec."MICA Order Type"::"Standard Order" then
                        MICACustTransEnabled := true
                    ELSE
                        MICACustTransEnabled := false;
                end;
            }

            field("MICA Customer Transport"; Rec."MICA Customer Transport")
            {
                ApplicationArea = ALL;
                Enabled = MICACustTransEnabled;
            }
            field("MICA Shipment"; Rec."MICA Shipment")
            {
                ApplicationArea = ALL;
                Enabled = MICACustTransEnabled;
                Importance = Additional;
            }

        }

        moveafter("Sell-to Customer Name"; "Order Date")
        moveafter("Order Date"; "Requested Delivery Date")
        modify("Posting Date")
        {
            Importance = Additional;
        }
        modify("Due Date")
        {
            Importance = Additional;
        }
        modify("External Document No.")
        {
            Importance = Additional;
        }
        modify(ShippingOptions)
        {
            Importance = Additional;
        }
        modify("Ship-to Address 2")
        {
            Importance = Additional;
        }
        modify("Ship-to Post Code")
        {
            Importance = Additional;
        }
        modify("Ship-to Contact")
        {
            Importance = Additional;
        }
        modify(BillToOptions)
        {
            Importance = Additional;
        }
        modify("Shipment Date")
        {
            Importance = Additional;
        }
        modify("Currency Code")
        {
            Editable = EnableEditSalesPriceAndCTC;
        }
        addlast(Content)
        {
            group("MICA Michelin")
            {
                field("MICA % Of Prepayment"; Rec."MICA % Of Prepayment")
                {
                    ApplicationArea = All;
                }
                field("MICA Prepayment Amount"; Rec."MICA Prepayment Amount")
                {
                    ApplicationArea = All;
                }
                field("MICA Prepaid Amount"; Rec."MICA Prepaid Amount")
                {
                    ApplicationArea = All;
                }
                field("MICA Shipment Post Option"; Rec."MICA Shipment Post Option")
                {
                    ApplicationArea = All;
                }
                field("MICA Automatic Release Date"; Rec."MICA Automatic Release Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Exempt from 3PL Ant. Chk."; Rec."MICA Exempt from 3PL Ant. Chk.")
                {
                    ApplicationArea = All;
                }
                field("MICA Created By"; Rec."MICA Created By")
                {
                    ApplicationArea = All;
                }
            }
        }


        moveafter(General; "Shipping and Billing")

        addlast(Factboxes)
        {
            part(MyFactBox; "MICA Add. Item Discounts Fact")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");
            }

        }
    }

    actions
    {
        // modify("Post")
        // {
        //     Visible = false;
        //     Enabled = false;
        // }
        // modify(PostAndNew)
        // {
        //     Visible = false;
        //     Enabled = false;
        // }
        // modify(PostAndSend)
        // {
        //     Visible = false;
        //     Enabled = false;
        // }

        // addfirst("P&osting")
        // {
        //     action("MICA Post")
        //     {
        //         Caption = 'P&ost';
        //         Promoted = true;
        //         PromotedCategory = Category6;
        //         image = PostOrder;
        //         ApplicationArea = Basic, Suite;
        //         trigger OnAction()
        //         var
        //             TOPMgt: Codeunit "MICA Terms Of Payment Mgt";
        //         begin
        //             TOPMgt.PostSalesOrder(Rec);
        //         end;
        //     }

        // }
        addlast("&Print")
        {
            action("MICA Print Prepayment")
            {
                Caption = 'Print Prepayment';
                Promoted = true;
                PromotedCategory = Process;
                image = Print;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"MICA Sales Prepayment", true, true, SalesHeader);
                end;
            }

        }
        addlast("F&unctions")
        {
            action("MICA Commit All Line")
            {
                Caption = 'Commit All Line';
                Promoted = true;
                PromotedCategory = Process;
                image = ShipmentLines;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CommitAll(false);
                end;
            }

            action("MICA Batch Job Execution Setup")
            {
                Caption = 'Batch Job Execution Setup';
                Promoted = true;
                PromotedCategory = Process;
                image = Calculate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    BatchSetup: Page "MICA Batch Job Exec Setup List";
                begin
                    BatchSetup.Run();
                end;
            }
        }

        modify("Create &Warehouse Shipment")
        {
            Visible = false;
        }
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("MICA Create Warehouse Shipment")
            {
                Caption = 'Create &Warehouse Shipment';
                ToolTip = 'Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.';
                AccessByPermission = TableData "Warehouse Shipment Header" = R;
                ApplicationArea = All;
                Image = NewShipment;
                trigger OnAction()
                var
                    GetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
                begin
                    GetSourceDocOutbound.CreateFromSalesOrder(Rec);
                end;
            }
        }
    }
    var
        MICACustTransEnabled: Boolean;
        MICAMultiPosting: Boolean;
        EnableEditSalesPriceAndCTC: Boolean;

    trigger OnAfterGetRecord()
    begin
        If Rec."MICA Order Type" = Rec."MICA Order Type"::"Standard Order" then
            MICACustTransEnabled := true
        else
            MICACustTransEnabled := false;
    end;

    trigger OnOpenPage()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        UserSetup: Record "User Setup";
    begin
        if MICAFinancialReportingSetup.Get() then
            MICAMultiPosting := MICAFinancialReportingSetup."Multi-Posting"
        else
            MICAMultiPosting := false;
        if not UserSetup.Get(UserId()) then
            exit
        else
            EnableEditSalesPriceAndCTC := UserSetup."MICA Allow SalePrice & CTC Upd";
    End;
}